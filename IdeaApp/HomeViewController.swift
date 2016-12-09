//
//  HomeViewController.swift
//  IdeaApp
//
//  Created by HEERA ANIL on 11/17/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
class HomeViewController: UIViewController {

    @IBOutlet var AdTitle: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var AdImage: UIImageView!
    
    @IBOutlet var AdOwner: UILabel!
    @IBOutlet var AdDate: UILabel!
    @IBOutlet var AdDesc: UILabel!
    @IBOutlet var profileImage: UIImageView!
   
    @IBOutlet var valuableButton: UIButton!
    @IBOutlet var householdButton: UIButton!
    @IBOutlet var housingButton: UIButton!
    @IBOutlet var booksButton: UIButton!
    var ref: FIRDatabaseReference!
    var adStore = AdStore()
    var imageStore = ImageStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
       navigationController?.navigationBar.tintColor = UIColor.orange
        loadAllAds()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        booksButton.setImage(UIImage(named: "books.jpg"), for: UIControlState.normal)
        valuableButton.setImage(UIImage(named: "valuables.jpg"), for: UIControlState.normal)
        householdButton.setImage(UIImage(named: "household.jpg"), for: UIControlState.normal)
        housingButton.setImage(UIImage(named: "housing.jpg"), for: UIControlState.normal)
        //loadAllAds()
        fetchUserInfo()
        fetchRecentAds()
    }
    
    func loadAllAds() {
        ref = FIRDatabase.database().reference()
        adStore.clearAll()
        ref.child("ads").observe(.childAdded, with: { (snapshot) -> Void in
            if !snapshot.exists() { return }
            let category = snapshot.childSnapshot(forPath: "category").value
            let title = snapshot.childSnapshot(forPath: "title").value
            let description = snapshot.childSnapshot(forPath: "description").value
            let price = snapshot.childSnapshot(forPath: "price").value
            let keyItem = snapshot.key
            let email = snapshot.childSnapshot(forPath: "email").value
            _ = (email as! String).replacingOccurrences(of: ".", with: ",")
            let adImagePath = ("\(email!)/\(keyItem)/img1.jpg")
            print ("\(adImagePath)")
            if adImagePath != ""{
                AdStore.storageReference.child(adImagePath).data(withMaxSize: 10*1024*1024, completion: {(data,error) in
                    let image = UIImage(data: data!)
                    self.imageStore.setImage(image!, forKey: keyItem)
                })
            }
            var conv_desc: String!
            if let result_desc = description as? NSString
            {
                conv_desc = "\(result_desc)"
            }
            let ad = Ad(name: title as! String, valueInDollars: price as! Int, desc: conv_desc, category: category as! String, adKey: keyItem ,userEmail : email as! String )
            self.adStore.createItem(ad)
        })
    }
    
    func fetchRecentAds(){
        if AdStore.bookItems.count != 0
        {
            let ad = adStore.getItem()
            
            let commaEmail = ad.userEmail.replacingOccurrences(of: ".", with: ",")
            let ref1 = FIRDatabase.database().reference().child("users").child(commaEmail)
            ref1.observeSingleEvent(of: .value, with: { snapshot in
                
                if !snapshot.exists() { return }
                let name = snapshot.childSnapshot(forPath: "name").value
                self.AdOwner.text! = ("Posted By: \(name!)")
            })
            
            AdTitle.text! = ("Title: \(ad.name)")
            AdImage.image = self.imageStore.imageForKey(ad.adKey)
            let time = ad.dateCreated
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let formatteddate = formatter.string(from: time)
            AdDate.text! = ("Posted On: \(formatteddate)")
            AdDesc.text! = ("Description: \(ad.desc!)")
        }
    }
    
    func fetchUserInfo(){
        
        adStore.clearFavAll()
        //let fetchUser = FIRAuth.auth()?.currentUser
        let email = AdStore.userInfo?.email
        let newEmail = email!.replacingOccurrences(of: ".", with: ",")
        ref = FIRDatabase.database().reference().child("users").child(newEmail)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let name = snapshot.childSnapshot(forPath: "name").value
            self.userName.text = ("Hi \(name!)")
            let userProfilePic = snapshot.childSnapshot(forPath: "profile_pic").value
            let userProfilePath = userProfilePic as! String
            
            if snapshot.hasChild("favorites")
            {
                let fav = snapshot.childSnapshot(forPath: "favorites").value as? [String:[String:String]]
                for (key,_) in fav!{
                    AdStore.favorites.append(key)
                    self.adStore.fillFavorites(key: key)
                }
            }
            if userProfilePath != ""{
                let filePath = "\(email!)/profile.jpg"
                AdStore.storageReference.child(filePath).data(withMaxSize: 10*1024*1024, completion: {(data,error) in
                    let userPhoto = UIImage(data: data!)
                    self.profileImage.image = userPhoto
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

