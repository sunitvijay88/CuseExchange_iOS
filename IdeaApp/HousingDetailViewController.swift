//
//  HousingDetailViewController.swift
//  HousingDetail
//
//  Created by HEERA ANIL on 11/30/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HousingDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var nameField: UILabel!
    @IBOutlet var serialNumberField: UILabel!
    @IBOutlet var valueField: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var postedBy: UILabel!
    //IBOutlet for the UIImageView
    @IBOutlet var imageView: UIImageView!
    
     @IBOutlet var favButton: UIButton!
    
    var ref: FIRDatabaseReference!
    var ref2: FIRDatabaseReference!
    var ref3: FIRDatabaseReference!
    var key :String = ""
    var isFav :Bool = false
    
    //reference to the item to display
    var ad: Ad! {
        didSet {
            //sets the title property of navigationItem to show the name of the item on the navigation bar of the DetaiLViewController
            navigationItem.title = ad.name
        }
    }
    
    //reference to the imageStore
    var imageStore: ImageStore!
    
    //number formatter
    let numberFomatter: NumberFormatter = {_ in
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    //date formatter
    let dateFormatter: DateFormatter = {_ in
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        ref2 = FIRDatabase.database().reference()
        ref3 = FIRDatabase.database().reference()
    }
    
    //viewWillAppear() is called right before the view of DetailViewController comes onscreen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("DetailViewController's view will appear")
        
        let commaEmail = ad.userEmail.replacingOccurrences(of: ".", with: ",")
        ref = ref.child("users").child(commaEmail)
        
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let name = snapshot.childSnapshot(forPath: "name").value
            self.postedBy.text = ("\(name!)")
            
        })

        
        //nameField.text = item.name
        serialNumberField.text = ad.desc
        valueField.text = ("$\(numberFomatter.string(from: ad.valueInDollars as NSNumber)!)")
        dateLabel.text = dateFormatter.string(from: ad.dateCreated as Date)
        imageView.image = self.imageStore.imageForKey(ad.adKey)
        
        key = ad.adKey
        
        if AdStore.favorites.contains(key)
        {
            favButton.setImage(UIImage(named: "filled_star.jpg"), for: UIControlState.normal)
            isFav = true
            
        }
        else
        {
            favButton.setImage(UIImage(named: "outline_star.jpg"), for: UIControlState.normal)
            isFav = false
        }
       // postedBy.text = item.postedBy
        //displays the image associated with the item on imageView
        //imageView.image = imageStore.imageForKey(item.itemKey)
        
        //navigationItem.title = item.name
    }
    @IBAction func contactSeller() {
//        let title = "Game Over"
//        var message = String()
//        
//        if let ID = playerID {
//            message = "Player \(ID) wins"
//        }
//        else {
//            message = "No Winner"
//        }
        var phNum: String!
        
        let commaEmail = ad.userEmail.replacingOccurrences(of: ".", with: ",")
        print ("Comma Email - \(commaEmail)")
        ref2 = ref2.child("users").child(commaEmail)
        
        
        ref2.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let num = snapshot.childSnapshot(forPath: "mobile").value
            phNum = num as! String
            print ("Phone number is \(phNum!)")
            let ac = UIAlertController(title: "Contact Seller",
                                       message: self.postedBy.text!,
                                       preferredStyle: .actionSheet)
            
            let messageSeller = UIAlertAction(title: "Message Seller",
                                              style: .default ,
                                              handler: { (action) -> Void in
                                                //self.startNewGame()
            })
            
            ac.addAction(messageSeller)
            let callSeller = UIAlertAction(title: "Call Seller",
                                           style: .default ,
                                           handler: { (action) -> Void in
                                            //self.startNewGame()
            })
            
            ac.addAction(callSeller)
            let emailSeller = UIAlertAction(title: "Email Seller",
                                            style: .default ,
                                            handler: { (action) -> Void in
                                                //self.startNewGame()
            })
            
            ac.addAction(emailSeller)
            let cancelSeller = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            ac.addAction(cancelSeller)
            
            self.present(ac, animated: true, completion: nil)
            
        })

    }
    
    //viewWillDisappear is called right before the view of DetailViewController disappears
    //The function in our case is used to save the values of the three textFields
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("DetailViewController's view will disappear")
//                if let text = nameField.text {
//                    item.name = text
//                }
//                else {
//                    item.name = ""
//                }
//        
//        item.name = nameField.text ?? ""
//        
//        item.serialNumber = serialNumberField.text
        
//        if let text = valueField.text, let value = numberFomatter.number(from: text) {
//            item.valueInDollars = value.intValue
//        }
//        else {
//            item.valueInDollars = 0
//        }
    }
    
    //textFieldShouldReturn is called when the user taps the keyboard’s return button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //IBAction for tap gesture recognizer
    @IBAction func userTappedBackground(_ gestureRecognizer: UITapGestureRecognizer) {
        //        if nameField.isFirstResponder() {
        //            nameField.resignFirstResponder()
        //        }
        //        else if serialNumberField.isFirstResponder() {
        //            serialNumberField.resignFirstResponder()
        //        }
        //        else if valueField.isFirstResponder() {
        //            valueField.resignFirstResponder()
        //        }
        //        else {
        //            print("No textfield is firstResponder.")
        //        }
        view.endEditing(true)
    }
    
    @IBAction func onSelectFavorite(_ sender: UIButton) {
        
        let email = AdStore.userInfo?.email
        let newEmail = email!.replacingOccurrences(of: ".", with: ",")
        if isFav == true
        {
            isFav = false
            favButton.setImage(UIImage(named: "outline_star.jpg"), for: UIControlState.normal)
            let index = AdStore.favorites.index(of: key)
            AdStore.favorites.remove(at: index!)
            ref3.child("users").child(newEmail).child("favorites").child(key).removeValue()
        }
        else
        {
            isFav = true
            favButton.setImage(UIImage(named: "filled_star.jpg"), for: UIControlState.normal)
            AdStore.favorites.append(key)
            ref3.child("users").child(newEmail).child("favorites").child(key).setValue(["key": "value"])
            
        }
    }
    
    }
