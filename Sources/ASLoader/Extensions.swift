//
//  File.swift
//  
//
//  Created by Anton Babko on 05.12.2023.
//

import UIKit

/// UiImageView extension for ASLoader framework
public extension UIImageView {
    
    /// Asynchronous image loading for UIImageView image
    /// - Parameters:
    ///   - placeholder: Image displaying before actual image will be loaded
    ///   - imageURL: Image you need URL
    ///   - cacheType: ASLoader.shared cache where it will be cached
    func ASLoad(placeholder: UIImage, imageURL: String, cacheType: ASCacheType = .global) {
        let loader = ASLoaderClass.shared
        var cache: NSCache<NSString, UIImage>!
        switch cacheType {
        case .global:
            cache = loader.globalImagesCache
        case .primary:
            cache = loader.primaryImagesCache
        case .main:
            cache = loader.mainImagesCache
        }
        self.image = placeholder
        DispatchQueue.global().async {
            if let image = cache.object(forKey: imageURL as NSString) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                if let url = URL(string: imageURL),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    cache.setObject(image, forKey: imageURL as NSString)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    print("UIImageView.ASLoad: Data responding-converting error")
                }
            }
        }
    }
}
