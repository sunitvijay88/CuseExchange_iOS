//
//  FavoritesViewController.swift
//  Favorites
//
//  Created by HEERA ANIL on 12/4/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//


import UIKit
import FirebaseDatabase
import FirebaseStorage
class FavoritesViewController: UITableViewController {
    //reference to AdStore
    var adStore = AdStore()
    var ref: FIRDatabaseReference!
    //reference to ImageStore
    var imageStore: ImageStore!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        navigationController?.navigationBar.tintColor = UIColor.orange
        tableView.estimatedRowHeight = 65
        
        ref = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //reloadData() reloads the cells of the tableView
        tableView.reloadData()
    }
    
    
    //function that commits the editing style of a specified row.
    //function that commits the editing style of a specified row.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //print("Trying to delete Section: \(indexPath.section) Row: \(indexPath.row)")
            let ad = AdStore.favItem[indexPath.row]
            
            let title = "Delete \(ad.name)?"
            
            let message = "Are you sure?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .destructive,
                                             handler: {_ in
                                                let email = AdStore.userInfo?.email
                                                let newEmail = email!.replacingOccurrences(of: ".", with: ",")
                                            self.ref.child("users").child(newEmail).child("favorites").child(ad.adKey).removeValue()
                                                self.adStore.removeFromFavs(ad)
                                                
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
        }
    }
    
    //function that returns a new index path to retarget a proposed move of a row.
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath
    }
    
    //function that enables row reordering
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        adStore.moveIteminFavs(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    //function to get the number of sections in the table view.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //function to get the number of rows in a given section of a table view. This is a REQUIRED function
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return AdStore.favItem.count
    }
    
    //function to get a cell for inserting in a particular location of the table view. This is a REQUIRED function
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("Getting cell for Section: \(indexPath.section) Row: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        cell.updateLabels()
        
        let ad = AdStore.favItem[indexPath.row]
        
        cell.nameLabel.text = ad.name
        cell.serialNumberLabel.text = ad.desc!
        cell.valueLabel.text = "$\(ad.valueInDollars)"
        cell.imageTest?.image = ImageStore.cache.object(forKey: ad.adKey as AnyObject ) as?UIImage
        return cell
    }
    
    
    @IBAction func toggleEditMode(_ sender: UIButton) {
        
        if isEditing {
            setEditing(false, animated: true)
            sender.setTitle("Edit", for: UIControlState())
            
        }
        else {
            setEditing(true, animated: true)
            sender.setTitle("Done", for: UIControlState())
        }
    }
    
    
    
    
}
