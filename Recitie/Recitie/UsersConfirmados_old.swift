//
//  UsersConfirmados.swift
//  Recitie
//
//  Created by Natalia Souza on 11/10/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import Parse
import ParseUI

var users = [PFObject] ()


class UsersConfirmados : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var eventoObjeto : PFObject?
    
    var toPass : String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Wire up search bar delegate so that we can react to button selections
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        
        let cellWidth = ((UIScreen.mainScreen().bounds.width) ) / 3
        
        let cellLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        cellLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loadCollectionViewData()
    }
    
    
    
    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func loadCollectionViewData() {
        
        // Build a parse query object
        let query = PFQuery(className:"_User")
        // Fetch data from the parse platform
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            // The find succeeded now rocess the found objects into the countries array
            if error == nil {
                
                // Clear existing country data
                users.removeAll(keepCapacity: true)
                
                // Add country objects to our array
                if let objects = objects {
                    users = Array(objects.generate())
                }
                
                // reload our data into the collection view
                self.collectionView.reloadData()
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        // Display the country name
        if let value = users[indexPath.row]["username"] as? String {
            cell.cellTitle.text = value
        }
        
        // Display "initial" flag image
        let initialThumbnail = UIImage(named: "placeholder")
        
        cell.cellImage.image = initialThumbnail
        
        //Layout cellImage
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            
            cell.cellImage.layer.cornerRadius = 90
            cell.cellImage.layer.masksToBounds = true
            
        } else {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    
                    cell.cellImage.layer.cornerRadius = 48
                    cell.cellImage.layer.masksToBounds = true
                    
                    
                } else {
                    
                    cell.cellImage.layer.cornerRadius = 45
                    cell.cellImage.layer.masksToBounds = true
                    
                }
            } else {
                
                cell.cellImage.layer.cornerRadius = 38
                cell.cellImage.layer.masksToBounds = true
                
                
            }
        }
        
        // Fetch final flag image - if it exists
        if let value = users[indexPath.row]["profile_picture"] as? PFFile {
            let finalImage = users[indexPath.row]["profile_picture"] as? PFFile
            finalImage!.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.cellImage.image = UIImage(data:imageData)
                    }
                }
            }
        }
        return cell
    }
    
    
}


