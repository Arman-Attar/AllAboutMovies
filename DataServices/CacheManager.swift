//
//  CacheManager.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-11-18.
//

import Foundation
import UIKit


// WORK IN PROGRESS
class CacheManager{
    static let shared = CacheManager()
    private init () {
        
    }
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        return cache
    }()
    
    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
        print("Added to cache")
    }
    
    func remove(name: String){
        imageCache.removeObject(forKey: name as NSString)
        print("removed")
    }
    
    func get(name: String) -> UIImage?{
        return imageCache.object(forKey: name as NSString)
    }
    
}
