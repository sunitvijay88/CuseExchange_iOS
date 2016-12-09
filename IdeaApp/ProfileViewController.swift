//
//  ProfileViewController.swift
//  Profile
//
//  Created by HEERA ANIL on 11/27/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {
    @IBOutlet var photoEdit: UIButton!
    @IBOutlet var editProfile: UIButton!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var name: UITextField!

    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var phNumber: UITextField!
    
    @IBOutlet var toggle: UISwitch!
    @IBOutlet var address: UITextView!
    @IBOutlet var email: UITextField!
    var ref: FIRDatabaseReference!
    var storage: FIRStorage!
//    var oldPhoto: UIImage
//    var oldName: String!
//    var oldphNumber: String!
//    var oldAddress: String!
//    var oldToggle: Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //To change image dimensions
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        //image.layer.borderColor = UIColor.black
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        photoEdit.isHidden = true
        name.isEnabled = false
        email.isEnabled = false
        phNumber.isEnabled = false
        address.isEditable = false
        toggle.isEnabled = false
        address.delegate = self

        if address.text! == ""
        {
            address.text = "Address"
            address.textColor = UIColor.lightGray
            
        }
        
        address.layer.borderWidth = 0.5;
        address.layer.borderColor = UIColor.lightGray.cgColor
        address.layer.cornerRadius = 5.0
        
        cancelButton.setTitle("", for: UIControlState.normal)
        ref = FIRDatabase.database().reference()
        storage = FIRStorage.storage()
        loadUserDetail()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if address.text! == "Address"
        {
            address.text = ""
            address.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if address.text! == ""
        {
            address.text = "Address"
            address.textColor = UIColor.lightGray
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        //let fetchUser = FIRAuth.auth()?.currentUser
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadUserDetail(){
        let email1 = AdStore.userInfo?.email
        let newEmail = email1!.replacingOccurrences(of: ".", with: ",")
        ref.child("users").child(newEmail).observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            let userAddress = snapshot.childSnapshot(forPath: "address").value
            let userName = snapshot.childSnapshot(forPath: "name").value
            let userMobile = snapshot.childSnapshot(forPath: "mobile").value
            let userProfilePic = snapshot.childSnapshot(forPath: "profile_pic").value
            print ("USer Or \(userProfilePic)")
            let userProfilePath = userProfilePic as! String
            if userProfilePath != ""{
                let filePath = "\(email1!)/profile.jpg"
                AdStore.storageReference.child(filePath).data(withMaxSize: 10*1024*1024, completion: {(data,error) in
                    let userPhoto = UIImage(data: data!)
                    self.profileImage.image = userPhoto
                })
            }
            let userEmail = email1!
            self.name.text! = userName as! String
            let address = self.address.text!
            if address != "" && address != "Address" {
                self.address.text! = userAddress as! String
            }
            self.phNumber.text! = userMobile as! String
            let notify = snapshot.childSnapshot(forPath: "notifications").value as! String
            if notify == "Y" {
                self.toggle.setOn(true, animated: true)
            }else{
                self.toggle.setOn(false, animated: true)
            }
            self.email.text! = userEmail as String
        })

    }

    @IBAction func onProfileEdit(_ sender: UIButton) {
        
        if editProfile.title(for: UIControlState.normal) == "Edit"
        {   editProfile.setTitle("Save" , for : UIControlState.normal)
            photoEdit.isHidden = false
            name.isEnabled = true
            phNumber.isEnabled = true
            address.isEditable = true
            toggle.isEnabled = true
             cancelButton.setTitle("Cancel" , for : UIControlState.normal)
        }
        else   //Save
        {
            editProfile.setTitle("Edit" , for : UIControlState.normal)
            photoEdit.isHidden = true
            name.isEnabled = false
            phNumber.isEnabled = false
            address.isEditable = false
            toggle.isEnabled = false
            cancelButton.setTitle("" , for : UIControlState.normal)
            let email = AdStore.userInfo?.email
            let newEmail = email!.replacingOccurrences(of: ".", with: ",")
            if address.text! != "" && address.text! != "Address"
            { self.ref.child("users").child(newEmail).child("address").setValue(address.text)
            }
            self.ref.child("users").child(newEmail).child("mobile").setValue(phNumber.text)
            self.ref.child("users").child(newEmail).child("name").setValue(name.text)
            if toggle.isOn{
            self.ref.child("users").child(newEmail).child("notifications").setValue("Y")
            }else{
                self.ref.child("users").child(newEmail).child("notifications").setValue("N")
            }
            if profileImage.image! != UIImage(named : "default.jpg"){
            let stRef = AdStore.storageReference.child("\(email!)/profile.jpg")
            var data = NSData()
            data = UIImageJPEGRepresentation(profileImage.image!, 0.7)! as NSData
            stRef.put(data as Data, metadata: FIRStorageMetadata()){(metadata,error) in
                if error != nil{
                }else{
            self.ref.child("users").child(newEmail).child("profile_pic").setValue("profile.jpg")
                }
            }
        }
    }
    }

    @IBAction func onCancel(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showHomeFromProfile", sender: nil)
        
    }

    @IBAction func changePicture(_ sender: UIButton) {
        
        //instantiates the UIImagePickerController
        let imagePicker = UIImagePickerController()
        
        //sets sourceType of imagePicker
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }
        
        //sets DetailViewController as the delegate for imagePicker
        imagePicker.delegate = self
        
        //presents imagePicker modally
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //info is a dictionary that contains information about the media (image) the user selected
        //subscript the dictionary with the appropriate key to get the image selected by the user
         let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //display the selected image on the imageView (by setting its image property)
        profileImage.image = image
        //store the selected image in the imageStore (which has a cache to store images)
        //imageStore.setImage(image!, forKey: item.itemKey)
        
        //newItem.image = image
        
        //dismiss the view of imagePicker (that was earlier presented modally)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func signOff(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AdStore.userInfo = nil
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "showLoginFromProfile", sender: nil)
    }
    
    
    @IBAction func onBackgroundTap(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
        view.resignFirstResponder()
    }
    
}

