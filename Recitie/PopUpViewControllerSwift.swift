//
//  PopUpViewControllerSwift.swift
//  NMPopUpView
//
//  Created by Nikos Maounis on 13/9/14.
//  Copyright (c) 2014 Nikos Maounis. All rights reserved.
//


import UIKit
import MapKit
import QuartzCore
import CoreLocation
import CloudKit


@objc class PopUpViewControllerSwift : UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    
    var location : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveLatitude:", name: "latitudePosted", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveLongitude:", name: "longitudePosted", object: nil)
        
    }
    
    
    
    func recieveLongitude (sender:NSNotification) {
        
        let info = sender.userInfo!
        let longitude = info["longitude"] as! Double
        
        location.longitude = longitude
    }
    
    
    
    
    
    func recieveLatitude (sender:NSNotification) {
        let info = sender.userInfo!
        let latitude = info["latitude"] as! Double
        
        location.latitude = latitude
        
    }
    func showInView(aView: UIView!, withImage image : UIImage!, withMessage message: String!, animated: Bool)
    {
        aView.addSubview(self.view)
        logoImg!.image = image
        messageLabel!.text = message
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    @IBAction func closePopup(sender: AnyObject) {
        self.removeAnimate()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBOutlet weak var descriptionField: UITextField!
    
    
    
    
    @IBAction func savePlace(sender: AnyObject) {
        
        print(location.latitude)
        //let london = Places(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        
        let newPlace:Places = Places(title: nameField.text!, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), info: descriptionField.text!)
        
        
        let record = CKRecord(recordType: "Place")
        record.setValue(newPlace.title, forKey: "name")
        record.setValue(newPlace.description, forKey: "description")
        record.setValue(newPlace.coordinate.latitude, forKey: "latitude")
        record.setValue(newPlace.coordinate.longitude, forKey: "longitude")
        publicData.saveRecord(record, completionHandler: { record, error in
            if error != nil {
                print(error)
            }
        })
        
        //
        NSNotificationCenter.defaultCenter().postNotificationName("newPlacePosted", object: self, userInfo: ["newPlace": newPlace])
        
        self.removeAnimate()
        dismissViewControllerAnimated(true, completion: nil)
        
        
        
        
        
    }
    
    
    
}
