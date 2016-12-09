//
//  BooksViewController.swift
//  Books
//
//  Created by HEERA ANIL on 12/4/16.
//  Copyright © 2016 HEERA ANIL. All rights reserved.
//

import UIKit
import FirebaseDatabase
class BooksViewController: UITableViewController {
    //reference to ItemStore
    var adStore = AdStore()
    //reference to ImageStore
    var imageStore = ImageStore()
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 65
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //reloadData() reloads the cells of the tableView
        tableView.reloadData()
    }
    
    //function to get the number of sections in the table view.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //function to get the number of rows in a given section of a table view. This is a REQUIRED function
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return AdStore.bookItems.count
    }
    
    //function to get a cell for inserting in a particular location of the table view. This is a REQUIRED function
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("Getting cell for Section: \(indexPath.section) Row: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        cell.updateLabels()
        
        let ad = AdStore.bookItems[indexPath.row]
        //var image : UIImage = UIImage ()
        cell.nameLabel.text = ad.name
        cell.serialNumberLabel.text = ad.desc
        cell.valueLabel.text = "$\(ad.valueInDollars)"
        cell.imageTest?.image = ImageStore.cache.object(forKey: ad.adKey as AnyObject ) as?UIImage
        return cell
    }
    
    //Whenever a segue is triggered, the prepareForSegue(_:sender:) method is called on the view controller initiating the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = AdStore.bookItems [row]
                
                let detailController = segue.destination as! BooksDetailViewController
                
                //passes a reference of the item to display to the DetailViewController
                detailController.ad = item
                
                //passes a reference to the imageStore to the DetailViewController
                detailController.imageStore = imageStore
            }
        }
    }
}
