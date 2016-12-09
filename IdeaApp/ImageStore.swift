//
//  ImageStore.swift
//  ImageStore
//
//  Created by HEERA ANIL on 11/24/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit

class ImageStore {
    static var cache = NSCache<AnyObject, AnyObject>()
    
    //Add a key-and-image to the cache
    func setImage(_ image: UIImage, forKey key: String) {
        print("Adding image to cache")
        ImageStore.cache.setObject(image, forKey: key as AnyObject)
    }
    
    //Retrieve an image from the cache for a given key
    func imageForKey(_ key: String) -> UIImage? {
        print("Getting image for key")
       // print(ImageStore.cache.object(forKey: key as AnyObject) as? UIImage )
        return ImageStore.cache.object(forKey: key as AnyObject) as? UIImage
    }
    
    //Delete an image from the cache for a given key
    func deleteImageForKey(_ key: String) {
        print("Deleting image from cache")
        ImageStore.cache.removeObject(forKey: key as AnyObject)
    }
}
