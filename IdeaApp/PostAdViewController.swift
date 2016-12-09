//
//  PostAdViewController.swift
//  PostAd
//
//  Created by HEERA ANIL on 11/26/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
class PostAdViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var catButton: UIButton!
    @IBOutlet weak var textBox: UITextField!
    //reference to ItemStore
    var adStore = AdStore()
    var imageStore = ImageStore()
    @IBOutlet var addDescription: UITextView!
    @IBOutlet var price: UITextField!
    @IBOutlet var addTitle: UITextField!
    //@IBOutlet var selectSubCat: UITextField!
    @IBOutlet var selectCat: UITextField!
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var submitButton: UIButton!
    var ref: FIRDatabaseReference!
    
    @IBOutlet var catPicker: UIPickerView!

    var image: UIImage?
    var list = ["Categories","Books", "Housing","Household Accessories","Valuables"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
              // Do any additional setup after loading the view, typically from a nib.
        catPicker.delegate = self
        catPicker.dataSource = self
        price.delegate = self
        addDescription.delegate = self
        addDescription.text = "Add Description"
        addDescription.layer.borderWidth = 0.5;
        addDescription.layer.borderColor = UIColor.lightGray.cgColor
        addDescription.layer.cornerRadius = 5.0
        addDescription.textColor = UIColor.lightGray
        ref = FIRDatabase.database().reference()
        catButton.layer.cornerRadius = 5
        catButton.layer.borderWidth = 1
        catButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectCategory(_ sender: UIButton) {
        catPicker.isHidden = false
        price.isHidden = true
        addTitle.isHidden = true
        addDescription.isHidden = true
        submitButton.isHidden = true
    }
    
    //IBAction for the button on the Toolbar that lets the user select an image
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        print("IBAction: takePicture() called.")
        
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
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //display the selected image on the imageView (by setting its image property)
        imageview.image = image
        //store the selected image in the imageStore (which has a cache to store images)
        //imageStore.setImage(image!, forKey: item.itemKey)
        
        //dismiss the view of imagePicker (that was earlier presented modally)
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2{
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            print ("\(price.text!)")
            return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return true
       
    }
    
    @IBAction func postAd(_ sender: UIButton) {
        let userInfo = FIRAuth.auth()?.currentUser
        let userEmail = userInfo?.email
        let updatedUserEmail = userEmail?.replacingOccurrences(of: ".", with: ",")
        if Validate(){
        let adKey = UUID().uuidString
        let dateCreated = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formatteddate = formatter.string(from: dateCreated)
        var address = self.addDescription.text!
        if address == "Add Description"{
            address = ""
        }
        let filePth = ("\(userEmail!)/\(adKey)/img1.jpg")
        let stRef = AdStore.storageReference.child(filePth)
        var data = NSData()
        data = UIImageJPEGRepresentation(imageview.image!, 0.7)! as NSData
        stRef.put(data as Data, metadata: FIRStorageMetadata()){(metadata,error) in
        if error != nil{
        }else{
            let downloadURL = metadata!.downloadURL()!.absoluteString
        self.ref.child("ads").child(adKey).setValue(["category": self.catButton.currentTitle!, "date": formatteddate, "description": address, "email": userEmail , "price": Int(self.price.text!)! , "title": self.addTitle.text! , "url_img": "img1.jpg"])
        }
    }
        self.ref.child("users").child(updatedUserEmail!).child("myads").child(adKey).setValue([""])
        let ac = UIAlertController(title: "Post Ad",
                                       message: "Ad Posted Successfully!",
                                       preferredStyle: .alert)
            
        let dismiss = UIAlertAction(title: "Dismiss",
                                    style: .default ,
                                      handler: { (action) -> Void in
                                        self.performSegue(withIdentifier: "showHomeScreen", sender: nil)
            })
            ac.addAction(dismiss)
           present(ac, animated: true, completion: nil)
        }
    }

    
    func Validate() -> Bool{
        var valid:Bool = true
        if addTitle.text!.isEmpty {
            //Change the placeholder color to red for textfield email if
            addTitle.attributedPlaceholder = NSAttributedString(string: "Please enter Title", attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        
        if catButton.currentTitle == "Select Category" || catButton.currentTitle == "Please select Category" ||  catButton.currentTitle == "Categories" {
            //Change the placeholder color to red for textfield email if
            catButton.setTitle("Please select Category", for: UIControlState.normal)
            catButton.setTitleColor(UIColor.red,for: UIControlState.normal)

            valid = false
        }
        if price.text!.isEmpty {
            //Change the placeholder color to red for textfield email if
            price.attributedPlaceholder = NSAttributedString(string: "Please enter Price", attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        if image == nil{
            //setup the validation message
            valid = false
        }
        return valid
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    
    @IBAction func userTappedBackground(_ gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        view.resignFirstResponder()
    }
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list [row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributeString = NSAttributedString(string: list [row], attributes: [NSForegroundColorAttributeName: UIColor.white] )
        return attributeString
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // textBox.text = list [row]
        
        catButton.setTitleColor(UIColor.black,for: UIControlState.normal)
        
        catButton.setTitle(list [row], for: UIControlState.normal)
        pickerView.isHidden = true
        price.isHidden = false
        addTitle.isHidden = false
        addDescription.isHidden = false
        submitButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.catButton.setTitle("Select Category", for: UIControlState.normal)
    }
    func textFieldDidChange()
    {
        if addTitle.text == "" || price.text == "" || selectCat.text == ""
        {
            submitButton.isEnabled = false
        }
        else{
            submitButton.isEnabled = true
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if addDescription.text! == "Add Description"
        {
            addDescription.text = ""
            addDescription.textColor = UIColor.black
        }
    }
}

