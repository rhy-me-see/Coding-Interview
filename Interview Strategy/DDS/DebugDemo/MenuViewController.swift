//
//  ViewController.swift
//  DebugDemo
//
//  Created by Ruohua Yin on 4/13/25.
//

import UIKit

struct MenuItem {
    let id: String
    let name: String
    let imageURL: URL
}

class MenuViewController: UIViewController, UICollectionViewDataSource {

    private var collectionView: UICollectionView!
    private var items: [MenuItem] = []
    private var imageLoader: ImageLoaderProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupDI()
        fetchItems()
    }
    
    private func fetchItems() {
        let baseURL = URL(string: "https://picsum.photos/200/300")!
        items = (1...10).map {
            MenuItem(id: "\($0)", name: "Item \($0)", imageURL: baseURL)
        }
        collectionView.reloadData()
    }
    
    // MARK: - DI Container
    
    private func setupDI() {
        let container = DIContainer()
        container.register(ImageLoaderProtocol.self) { ImageLoader() }
        self.imageLoader = container.resolve(ImageLoaderProtocol.self)
    }
    
    // MARK: - View Controller
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 140)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

class MenuCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MenuCell"
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
