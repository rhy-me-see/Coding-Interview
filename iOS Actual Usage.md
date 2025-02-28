


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
		print("response: \(response)")
		print("data: \(data)")
		return data
	})
	.decode(type: FileModel.self, decoder: JSONDecoder())
	.sink { (completion) in
		print("completion: \(completion)")
	} receiveValue: { (returnedFileModel) in
		let fm = returnedFileModel as FileModel
		self.posts = fm.content
		print("self.posts: \(self.posts)")
	}
	.store(in: &cancellables)
```


## SwiftUI Component

### Image

```swift
// render image using system default
// shift + command + L to check all available ones
Image(systemName: "globe").imageScale(.small).foregroundStyle(.tint)
// render image with assets
// need to inject image to app assets
Image("taco").resizable().aspectRatio(contentMode: .fill)
// render Image with URL
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


