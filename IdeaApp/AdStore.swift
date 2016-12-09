//
//  ItemStore.swift
//  ItemStore
//
//  Created by HEERA ANIL on 11/20/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
class AdStore {
    
    static var myAds = [Ad]()
    static var userDetails = [UserReg]()
    static var bookItems = [Ad]()
    static var housingItems = [Ad]()
    static var valuableItems = [Ad]()
    static var householdItems = [Ad]()
    
    static var allItems = [String : Ad]()
    
    static var favorites = [String] ()
    static var favItem = [Ad]()
    static var userInfo = FIRAuth.auth()?.currentUser
    static let storage = FIRStorage.storage()
    static let storageReference = storage.reference(forURL: "gs://cuseexc.appspot.com")
    //function to create an item
    func createItem(_ ad: Ad) {
        if ad.category == "Books"
        {
            AdStore.bookItems.append(ad)
        }
        if ad.category == "Housing"
        {
            AdStore.housingItems.append(ad)
        }
        if ad.category == "Valuables"
        {
            AdStore.valuableItems.append(ad)
        }
        if ad.category == "Household Accessories"
        {
            AdStore.householdItems.append(ad)
        }
        if ad.userEmail == AdStore.userInfo?.email
        {
            AdStore.myAds.append(ad)
        }
        AdStore.allItems[ad.adKey] = ad
        
    }
    func clearAll(){
        AdStore.myAds.removeAll()
        AdStore.bookItems.removeAll()
        AdStore.housingItems.removeAll()
        AdStore.householdItems.removeAll()
        AdStore.valuableItems.removeAll()
    }
    func getItem()-> Ad{
        return AdStore.bookItems[AdStore.bookItems.count - 1 ]
    }
    func clearFavAll(){
        AdStore.favItem.removeAll()
        AdStore.favorites.removeAll()
    }
    
    func fillFavorites(key: String){
     //   let index = ItemStore.allItems.index(forKey: key)
       if AdStore.allItems[key] != nil{
            AdStore.favItem.append(AdStore.allItems[key]!)
        }
    }
    //function to remove specified item from the array
    func removeItem(_ ad: Ad) {
        
            if ad.category == "Books"
            {
                if let index = AdStore.bookItems.index(of: ad) {
                AdStore.bookItems.remove(at: index)
                }
            }
            if ad.category == "Housing"
            {
                if let index = AdStore.housingItems.index(of: ad) {
                AdStore.housingItems.remove(at: index)
                }
            }
            if ad.category == "Valuables"
            {
                if let index = AdStore.valuableItems.index(of: ad) {
                AdStore.valuableItems.remove(at: index)
                }
            }
            if ad.category == "Household Accessories"
            {
                if let index = AdStore.householdItems.index(of: ad) {
                AdStore.householdItems.remove(at: index)
                }
            }
            if let index = AdStore.myAds.index(of: ad) {
            AdStore.myAds.remove(at: index)
            }
    }
    
    func removeFromFavs(_ ad: Ad){
        if let index = AdStore.favItem.index(of: ad) {
            AdStore.favItem.remove(at: index)
            AdStore.favorites.remove(at: index)
        }
    }
    
    
    //function to reorder an item in the array
    func moveItem(_ fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = AdStore.myAds[fromIndex]
        
        AdStore.myAds.remove(at: fromIndex)
        
        AdStore.myAds.insert(movedItem, at: toIndex)
    }
    
    func moveIteminFavs(_ fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = AdStore.favItem[fromIndex]
        
        AdStore.favItem.remove(at: fromIndex)
        
        AdStore.favItem.insert(movedItem, at: toIndex)
    }


}
