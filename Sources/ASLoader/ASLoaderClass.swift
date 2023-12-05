//
//  ASLoaderClass.swift
//  ASLoader
//
//  Created by Anton Babko on 05.12.2023.
//

import UIKit
/// A utility class for asynchronous loading of images and data.
public class ASLoaderClass {
    
    /// Shared utility class for asynchronous loading of images and data.
    public static let shared = ASLoaderClass()
    
    public init() {}
    
    /// NSCache for global image caching.
    public let globalImagesCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 20
        return cache
    }()
    
    /// NSCache for primary image caching.
    public let primaryImagesCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 20
        return cache
    }()
    
    /// NSCache for main image caching.
    public let mainImagesCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 20
        return cache
    }()
    
    /// Clears the image cache for the specified cache type.
    ///
    /// - Parameters:
    ///   - type: The cache type to be cleared.
    public func clearImagesCache(_ type: ASCacheType = .global) {
        switch type {
        case .global:
            globalImagesCache.removeAllObjects()
        case .primary:
            primaryImagesCache.removeAllObjects()
        case .main:
            mainImagesCache.removeAllObjects()
        }
    }
    
    /// Sets the count limit for the image cache for the specified cache type.
    ///
    /// - Parameters:
    ///   - limit: The new count limit for the cache.
    ///   - cacheType: The cache type to be modified.
    public func setCacheLimit(_ limit: Int, cacheType: ASCacheType = .global) {
        if limit >= 0 {
            switch cacheType {
            case .global:
                globalImagesCache.countLimit = limit
            case .primary:
                primaryImagesCache.countLimit = limit
            case .main:
                mainImagesCache.countLimit = limit
            }
        } else {
            print("ASLoader.setCacheLimit: Limit must be greater or equal to 0!")
        }
    }
    
    /// Increases cache count limit.
    ///
    /// - Parameters:
    ///   - count: value by which to increase the limit.
    ///   - cacheType: The cache type to be used for caching the loaded image.
    public func increaseCacheLimit(_ count: Int = 1, cacheType: ASCacheType = .global) {
        switch cacheType {
        case .global:
            globalImagesCache.countLimit += count
        case .primary:
            primaryImagesCache.countLimit += count
        case .main:
            mainImagesCache.countLimit += count
        }
    }
    
    /// Decreases cache count limit.
    ///
    /// - Parameters:
    ///   - count: value by which to reduce the limit.
    ///   - cacheType: The cache type to be used for caching the loaded image.
    public func decreaseCacheLimit(_ count: Int = 1, cacheType: ASCacheType = .global) {
        switch cacheType {
        case .global:
            if globalImagesCache.countLimit - count >= 0 {
                globalImagesCache.countLimit -= count
            }
        case .primary:
            if primaryImagesCache.countLimit - count >= 0 {
                primaryImagesCache.countLimit -= count
            }
        case .main:
            if mainImagesCache.countLimit - count >= 0 {
                mainImagesCache.countLimit -= count
            }
        }
    }
    
    /// Asynchronously loads an image from a given URL.
    ///
    /// - Parameters:
    ///   - placeholderImage: The placeholder image to be displayed while the actual image is being loaded.
    ///   - imageURL: The URL of the image to be loaded.
    ///   - cacheType: The cache type to be used for caching the loaded image.
    ///   - completion: A closure that is called with the result of the image loading operation.
    public func loadImage(placeholderImage: UIImage, imageURL: String, cacheType: ASCacheType = .global, completion: @escaping (Result<UIImage, Error>) -> Void) {
        completion(.success(placeholderImage))
        var cache: NSCache<NSString, UIImage>!
        switch cacheType {
        case .global:
            cache = globalImagesCache
        case .primary:
            cache = primaryImagesCache
        case .main:
            cache = mainImagesCache
        }
        DispatchQueue.global().async {
            if let image = cache.object(forKey: imageURL as NSString) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                if let url = URL(string: imageURL),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    cache.setObject(image, forKey: imageURL as NSString)
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                } else {
                    print("ASLoader.loadImage: Data responding-converting error")
                }
            }
        }
    }
    
    /// Asynchronously loads data from a given URL.
    ///
    /// - Parameters:
    ///   - placeholder: A placeholder value to be used while the actual data is being loaded.
    ///   - dataURL: The URL from which data should be loaded.
    ///   - completion: A closure that is called with the loaded data or the placeholder in case of an error.
    public func loadData(placeholder: Any, dataURL: String, completion: @escaping (Any) -> Void) {
        completion(placeholder)
        DispatchQueue.global().async {
            if let url = URL(string: dataURL),
               let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(data as Any)
                }
            } else {
                print("ASLoader.loadData: Data responding error")
            }
        }
    }
}
