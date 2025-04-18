
### Generate URL for local resource

```swift
// Generate URL for local resource
guard let url = Bundle.main.url(forResource: "Datasource", withExtension: "json") else {
	print("Failed to find Datasource.json")
	return
}

// Generate URL for a network request
guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
```

### Read from URL and publish the data 

```swift
URLSession.shared.dataTaskPublisher(for: url)
	.receive(on: DispatchQueue.main)
	.subscribe(on: DispatchQueue.global(qos: .background))
	.tryMap( { (data, response) -> Data in
        guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
		print("response: \(response), data: \(data)")
		return data
	})
	.decode(type: FileModel.self, decoder: JSONDecoder())
	.sink { (completion) in
		if case .failure(let error) = completion {
            print("Error: \(error)")
        }
	} receiveValue: { (returnedFileModel) in
		let fm = returnedFileModel as FileModel
		self.posts = fm.content
		print("self.posts: \(self.posts)")
	}
	.store(in: &cancellables)
```

#### Decode with Combine and special handling to keys

```swift
// Define 1)init and 2)CodingKeys to special handle the parsing
struct OrderItems: Codable, Identifiable {
    var id: UUID? = UUID()
    let name: String
    let displayPrice: String
    
    private enum CodingKeys : String, CodingKey {
        case name = "name"
        case displayPrice = "display_price"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.displayPrice = try container.decodeIfPresent(String.self, forKey: .displayPrice) ?? "Free"
    }
}
```


### DispatchQueue

```swift 
// sync queue by default
let queue = DispatchQueue(label: "image.queue")
queue.async{ ... } // seriel execution
// async queue 
let queue = DispatchQueue(label: "image.queue", attributes: .concurrent)
queue.async(flags: .barriers) { ... } // execute in order when barriers defined
```

## SwiftUI Component

### Image

```swift
// system default image:[shift + command + L] to check all 
Image(systemName: "globe").imageScale(.small).foregroundStyle(.tint)
// assets image: need to inject image to app assets
Image("taco").resizable().aspectRatio(contentMode: .fill)
// url image
AsyncImage(url: URL(string: "https://hws.dev/paul3.jpg")) { phase in
		switch phase {
		case .failure:
			Image(systemName: "photo")
				.font(.largeTitle)
		case .success(let image):
			image
				.resizable()
		default:
			ProgressView()
		}
	}
	.frame(width: 256, height: 256)
	.clipShape(.rect(cornerRadius: 25))
```


### NavigationPath

**Append new string to `NavigationPath()`, then navigate to new pages** 
Benefits for this approach, easier to programmatically manage navigation pages in larger project

```swift
@State private var path = NavigationPath()
var body: some View {
	NavigationStack(path: $path) {
		VStack {
			List { ... }
			Button(action: { ... }) { ... (view)}
			.onChange(of: checkoutService.orderSubmission) { orderSubmission 
				if orderSubmission == .received {
					path.append("OrderConfirmationPage")
				}
			}
		}
		.navigationDestination(for: String.self) { pageName in
			if pageName == "OrderConfirmationPage" {
				OrderConfirmationView()
			}
		}
	}
```


### Example of DI container

```swift
class DIContainer {
    private var registry: [String: Any] = [:]
    func register<Service>(_ type: Service.Type, service: @escaping () -> Service) {
        registry[String(describing: type)] = service
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        let key = String(describing: type)
        guard let serviceClosure = registry[key] as? () -> Service else {
            fatalError("No registration for type \(type)")
        }
        return serviceClosure()
    }
}

// call site(e.g: within view controller)
private func setupDI() {
	let container = DIContainer()
	container.register(ImageLoaderProtocol.self) { ImageLoader() }
	self.imageLoader = container.resolve(ImageLoaderProtocol.self)
}

```

## UIKit

### UICollectionView

```swift 
class MenuViewController: UIViewController, UICollectionViewDataSource {

    private var collectionView: UICollectionView!
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 140)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false        
        NSLayoutConstraint.activate([ ... ])
    }
    
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.reuseIdentifier, for: indexPath) as! MenuCell
        let item = items[indexPath.item]
        cell.titleLabel.text = item.name
        imageLoader.loadImage(from: item.imageURL) { image in
            cell.imageView.image = image
        }
        return cell
    }
}
```

### 图片加载使用 DispatchQueue

```swift

private let cacheQueue = DispatchQueue(label: "image.cache.queue", attributes: .concurrent)
private var cache: [URL: UIImage] = [:]

func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
	cacheQueue.async {
		if let image = self.cache[url] {
			DispatchQueue.main.async { completion(image) }
			return
		}
		// load image: url --> data --> UIImage
		let data = try? Data(contentsOf: url)
		let image = data.flatMap { data in
			UIImage(data: data)
		}
		self.cacheQueue.async(flags: .barrier) {
			self.cache[url] = image
		}
		DispatchQueue.main.async { completion(image) }
	}
	
}

```

### Network Request with URLSession

```swift
let url = URL(string: "https://api.example.com/menu")!
var request = URLRequest(url: url)
request.httpMethod = "GET"

URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {
        print("Error: \(error?.localizedDescription ?? "unknown error")")
        return
    }

    do {
        let result = try JSONDecoder().decode(MenuResponse.self, from: data)
        DispatchQueue.main.async {
            self.menuItems = result.items
        }
    } catch {
        print("Decoding error: \(error)")
    }
}.resume()
```
### Replace storyboard and set root view controller

**在 `Info.plist` 中删除这一行：**`<key>UIMainStoryboardFile</key> <string>Main</string>`

**替换 `SceneDelegate.swift` 的 `scene(_:willConnectTo:)` 方法：**
```swift 
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
	guard let windowScene = (scene as? UIWindowScene) else { return }
	
	let window = UIWindow(windowScene: windowScene)
	window.rootViewController = UINavigationController(rootViewController: MenuViewController())
	self.window = window
	window.makeKeyAndVisible()
}
```

