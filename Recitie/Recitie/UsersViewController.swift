//
//  UsersViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/16/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import CloudKit
import Parse
import ParseUI
import Bolts
import ParseFacebookUtilsV4

class UsersViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var channel = "Music"
    
    var popViewController : CheckboxViewControllerSwift = CheckboxViewControllerSwift(nibName: "PopUp_Checkbox", bundle: nil)


    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutAction: UIButton!
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var contato: UILabel!
    
    let picker = UIImagePickerController()
    
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profilePicture.contentMode = .ScaleAspectFill //3
        profilePicture.layer.masksToBounds = true
        profilePicture.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
        
        //Upload to Parse
        //let usuario = PFUser.currentUser()?.username
        let imageData = UIImageJPEGRepresentation(chosenImage,0.5)
        let imageFile = PFFile(name:"foto.jpg", data:imageData!)
        
        let userPhoto = PFUser.currentUser()
        userPhoto!["profile_picture"] = imageFile
        userPhoto!.saveInBackground()
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: Users
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        if let pUserName = PFUser.currentUser()?["first_name"] as? String {
            self.userNameLabel.text = pUserName
            
            let initialThumbnail = UIImage(named: "placeholder.png")
            profilePicture.image = initialThumbnail
            
            emailLabel.text = PFUser.currentUser()!["email"] as? String
            if let ddd = PFUser.currentUser()!["ddd"] as? String{
                //print("ddd: \(ddd)")
                if let telefone = PFUser.currentUser()!["telefone"] as? String{
                    //print("telefone: \(telefone)")
                    contato.text = ddd + " " + telefone
                }
            }
            
            
            // Replace question image if an image exists on the parse platform
            if let thumbnail = PFUser.currentUser()!["profile_picture"] as? PFFile {
                profilePicture.file = thumbnail
                profilePicture.loadInBackground()
            }
        }
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //profilePicture Style
        self.profilePicture.layer.borderWidth = 1
        self.profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.logOutAction.layer.cornerRadius = logOutAction.frame.size.width / 40
        self.logOutAction.layer.masksToBounds = true
        
        let currentInstallation = PFInstallation.currentInstallation()
       // currentInstallation.addUniqueObject(channel, forKey: "channels")
        currentInstallation.addUniqueObject("Esportes", forKey: "channels")
        currentInstallation.saveInBackground()
        
        //ProfilePicture different devices
        
    if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
    //self.profilePicture.frame.size = CGSize(width: 300, height: 300)
        self.profilePicture.layer.cornerRadius = 195
        self.profilePicture.layer.masksToBounds = true

    } else {
    if UIScreen.mainScreen().bounds.size.width > 320 {
    if UIScreen.mainScreen().scale == 3 {
    //self.profilePicture.frame.size = CGSizeMake(200, 200)
        self.profilePicture.layer.cornerRadius = 105
        self.profilePicture.layer.masksToBounds = true

    
    } else {
    //self.profilePicture.frame.size = CGSizeMake(150, 150)
        self.profilePicture.layer.cornerRadius = 95
        self.profilePicture.layer.masksToBounds = true

    }
    } else {
    
    //self.profilePicture.frame.size = CGSizeMake(150, 150)
        self.profilePicture.layer.cornerRadius = 80
        self.profilePicture.layer.masksToBounds = true
    }
    }
    
}




    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    //MARK: Facebook
    @IBAction func facebookConnect(sender: UIButton) {
        if let newUser = PFUser.currentUser(){
            if !PFFacebookUtils.isLinkedWithUser(newUser){
                PFFacebookUtils.linkUserInBackground(newUser, withReadPermissions: nil, block: {
                    (succeeded: Bool?, error: NSError?) -> Void in  
                    print("SUCCEEDED: \(succeeded)")
                    print("ERROR: \(error)")
                    if (succeeded == true && error == nil) {
                        let alert = UIAlertController(title: "Facebook", message:"Facebook conectado com sucesso.", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                        self.presentViewController(alert, animated: true){}
                    }
                    else if(error?.code == 208){
                        let alert = UIAlertController(title: "Facebook", message:"Existe outro usuário conectado com essa conta do Facebook.", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                        self.presentViewController(alert, animated: true){}
                    }
                    else if(succeeded == false){
                        let alert = UIAlertController(title: "Facebook", message:"Não foi possível logar com Facebook. Tente novamente.", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                        self.presentViewController(alert, animated: true){}
                    }
                    else{
                        let alert = UIAlertController(title: "Facebook", message:"Não foi possível logar com Facebook. Tente novamente.", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                        self.presentViewController(alert, animated: true){}
                    }
                })
            }
            else{
                let alert = UIAlertController(title: "Facebook", message:"Já existe uma conta associada a esse perfil.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}
            }
        }
        else{
            let alert = UIAlertController(title: "Facebook", message:"Não foi possível logar com Facebook. Tente novamente.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
    }

    @IBAction func logOutAction(sender: AnyObject){
        
        // Send a request to log out a user
        PFUser.logOut()
        print("LogOut->Login")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        
    }
    //MARK: Fotos
    @IBAction func tirarFoto(sender: UIButton) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC,
            animated: true,
            completion: nil)
    }
    
    @IBAction func addInterest(sender: AnyObject) {
        
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            self.popViewController = CheckboxViewControllerSwift(nibName: "PopUp_Checkbox", bundle: nil)
            self.popViewController.title = "This is a popup view"
            self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
            self.popViewController.view.frame.size = CGSizeMake(768, 1024)
        } else
        {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.popViewController = CheckboxViewControllerSwift(nibName: "PopUp_Checkbox", bundle: nil)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "iphone 6+", animated: true)
                    self.popViewController.view.frame.size = CGSizeMake(414, 736)
                } else {
                    self.popViewController = CheckboxViewControllerSwift(nibName: "PopUp_Checkbox", bundle: nil)
                    self.popViewController.title = " esse é o 6"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "esse é o 6", animated: true)
                    self.popViewController.view.frame.size = CGSizeMake(375, 667)
                }
            } else {
                self.popViewController = CheckboxViewControllerSwift(nibName: "PopUp_Checkbox", bundle: nil)
                self.popViewController.title = "iPhone 5"
                self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "iPhone 5", animated: true)
                self.popViewController.view.frame.size = CGSizeMake(320, 480)
                
            }
        }
        
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
    
}