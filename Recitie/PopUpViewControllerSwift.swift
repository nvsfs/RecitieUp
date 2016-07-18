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
import Parse
import ParseUI

@objc class PopUpViewControllerSwift : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    
    let picker = UIImagePickerController()
    var foto : PFFile!
    var placeObId : String?

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var fotoLugar: PFImageView!
    //@IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    var location : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        self.fotoLugar.layer.borderWidth = 1
        self.fotoLugar.layer.borderColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor
        
        self.nameField.layer.borderWidth = 1
        self.nameField.layer.borderColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor
        
        self.descriptionField.layer.borderWidth = 1
        self.descriptionField.layer.borderColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveLatitude:", name: "latitudePosted", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveLongitude:", name: "longitudePosted", object: nil)
       
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
            fotoLugar.contentMode = .ScaleAspectFill //3
            fotoLugar.layer.masksToBounds = true
            fotoLugar.image = chosenImage //4
            dismissViewControllerAnimated(true, completion: nil) //5
        
            //Upload to Parse
            //let usuario = PFUser.currentUser()?.username
            
            let imageData = UIImageJPEGRepresentation(chosenImage,0.5)
            let imageFile = PFFile(name:"foto.jpg", data:imageData!)
            //let userPhoto = newUser
            foto = imageFile!
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func escolherFotoGaleria(sender: UIButton) {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        //presentViewController(picker, animated: true, completion: nil)//4
        picker.modalPresentationStyle = .Popover
        presentViewController(picker,
            animated: true, completion: nil)//4
        //picker.popoverPresentationController?. = sender
        picker.popoverPresentationController?.sourceView = view
        picker.popoverPresentationController?.sourceRect = sender.frame
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
    
    func showInView(aView: UIView!, withImage image : UIImage!, withMessage message: String!, animated: Bool){
        aView.addSubview(self.view)
        if animated{
            self.showAnimate()
        }
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate(){
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
    
    @IBAction func savePlace(sender: AnyObject) {
        
        // Testando se todos os campos estao preenchidos.
        if(nameField.text!.isEmpty || descriptionField.text!.isEmpty){
            let alertController = UIAlertController(title: "Campos vazios!", message:
                "É necessário preencher todos os campos!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        //print(location.latitude)
        //let london = Places(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        
        //        let container = CKContainer.defaultContainer()
        //        let publicData = container.publicCloudDatabase
        
        let newPlace:Places = Places(objectId: "" ,title: nameField.text!, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), info: descriptionField.text!)
        
        let place = PFObject(className: "Place")
        
        place["name"] = nameField.text
        
        place["description"] = descriptionField.text
        place["longitude"] = location.longitude
        place["latitude"] = location.latitude
        if foto != nil{
            place["imagem_lugar"] = foto
        }else{
            let placeholder = UIImage(named: "placeholder.jpg")
            let imageData = UIImageJPEGRepresentation(placeholder!,0.5)
            let imageFile = PFFile(name:"foto.jpg", data:imageData!)
            place["imagem_lugar"] = imageFile
        }
        place.pinInBackground()
        place.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                NSUserDefaults.standardUserDefaults().setObject(place.objectId, forKey: "placeId")
                NSNotificationCenter.defaultCenter().postNotificationName("newPlacePosted", object: self, userInfo: ["newPlace": newPlace])
                self.removeAnimate()
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
           //     print("n foi")
            }
        }
        //print("place.objectId: \(place.objectId)")
//
//        NSNotificationCenter.defaultCenter().postNotificationName("newPlacePosted", object: self, userInfo: ["newPlace": newPlace])
//        self.removeAnimate()
//        dismissViewControllerAnimated(true, completion: nil)
    }
}
