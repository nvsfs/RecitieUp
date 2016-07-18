//
//  PlacesViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/18/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import CloudKit
import Parse
import ParseUI


class PlacesViewController : UIViewController {
    
    let lugarId = NSUserDefaults.standardUserDefaults().objectForKey("placeId") as! String

    @IBOutlet weak var foto_lugar: PFImageView!
    var foto : PFFile!

    let lugarId = NSUserDefaults.standardUserDefaults().objectForKey("placeId") as! String

    @IBOutlet weak var placesEvents: UITableView!
    
    @IBOutlet weak var tableplaces: UIView!
    
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var placeName: UILabel!
    
    let events = [PFObject]()
    
    var currentObject : PFObject?
    
    override func viewDidLoad() {
        
        let lugarIddcd = lugarId
        
        print("sbhdgshd" + lugarIddcd)
        
        let query = PFQuery(className: "Place")
        query.whereKey("objectId", equalTo: lugarId)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    
                    self.placeName.text = (object["name"] as! String)
                    self.descriptionField.text = (object["description"] as! String)
                    
                    let initialThumbnail = UIImage(named: "placeholder.png")
                    self.foto_lugar.image = initialThumbnail
                    
                    // Replace question image if an image exists on the parse platform
                    if let thumbnail = object["imagem_lugar"] as? PFFile {
                        self.foto_lugar.file = thumbnail
                        self.foto_lugar.loadInBackground()
                    }
                    self.foto_lugar = object["imagem_lugar"] as? PFImageView

                }
            }
        }
        
        tableplaces.hidden = false
        
        let vc = (storyboard?.instantiateViewControllerWithIdentifier("test"))! as UIViewController
        self.tableplaces.addSubview(vc.view)
        
        
        self.addChildViewController(vc)
        vc.view.frame = CGRectMake(0, 0, self.tableplaces.frame.size.width, self.tableplaces.frame.size.height);
        self.tableplaces.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
        self.tableplaces.reloadInputViews()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableplaces.hidden = false
        
        let vc = (storyboard?.instantiateViewControllerWithIdentifier("test"))! as UIViewController
        self.tableplaces.addSubview(vc.view)
        self.tableplaces.reloadInputViews()
        
        self.addChildViewController(vc)
        vc.view.frame = CGRectMake(0, 0, self.tableplaces.frame.size.width, self.tableplaces.frame.size.height);
        self.tableplaces.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
        
    }
    
    
    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}