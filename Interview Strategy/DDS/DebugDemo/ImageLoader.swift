//
//  ImageLoader.swift
//  DebugDemo
//
//  Created by Ruohua Yin on 4/13/25.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class ImageLoader: ImageLoaderProtocol {
    private let cacheQueue = DispatchQueue(label: "image.cache.queue", attributes: .concurrent)
    private var cache: [URL: UIImage] = [:]

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        cacheQueue.async {
            if let image = self.cache[url] {
                DispatchQueue.main.async { completion(image) }
                return
            }
            
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
}
