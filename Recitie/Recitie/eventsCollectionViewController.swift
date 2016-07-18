//
//  eventsCollectionViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 11/19/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import Parse

var interests = [PFObject]()

var interest :  String!

class eventsCollectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var currentObject = ""

    @IBOutlet weak var todoseventos: UIButton!
    
    // Connection to the collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize size of collection view items in grid so that we achieve 3 boxes across
        //let cellWidth = ((UIScreen.mainScreen().bounds.width) - 32 - 30 ) / 3
        let cellWidth = ((UIScreen.mainScreen().bounds.width) ) / 3

        let cellLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        cellLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
    }

    @IBAction func todos(sender: AnyObject) {
        
        let searchtext = ""
        performSegueWithIdentifier("EventosViewController", sender: searchtext)

        
    }

  
    func loadCollectionViewData() {
        
        // Build a parse query object
        let query = PFQuery(className:"Interests")
        
        // Check to see if there is a search term
        
        
        // Fetch data from the parse platform
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            // The find succeeded now rocess the found objects into the countries array
            if error == nil {
                
                // Clear existing country data
                interests.removeAll(keepCapacity: true)
                
                // Add country objects to our array
                if let objects = objects {
                    interests = Array(objects.generate())
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
        return interests.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! eventsCollectionViewCell
    
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 0.5
        
        
    // Display the country name
    if let value = interests[indexPath.row]["type"] as? String {
    cell.cellTitle.text = value
        }
    
    // Display "initial" flag image
//    let initialThumbnail = UIImage(named: "placeholder")
//    cell.cellImage.image = initialThumbnail
    
    // Fetch final flag image - if it exists
    if let value = interests[indexPath.row]["image"] as? PFFile {
    let finalImage = interests[indexPath.row]["image"] as? PFFile
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
    
    // Load data into the collectionView when the view appears
    override func viewDidAppear(animated: Bool) {
        loadCollectionViewData()
        
    }
    
    // Process collectionView cell selection
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let currentObject = interests[indexPath.row]
            interest = interests[indexPath.row]["type"] as! String
        let searchtext = interest
        performSegueWithIdentifier("EventosViewController", sender: searchtext)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let detailScene = segue.destinationViewController as! TableViewController
        if sender != nil{
            detailScene.currentObject = sender as? String

        }

    }
  
}
