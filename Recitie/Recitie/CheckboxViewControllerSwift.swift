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


@objc class CheckboxViewControllerSwift : UIViewController {
    var interest: [String] = []
    
    
    @IBOutlet weak var popUpView: UIView!
    
    var esportesBoxChecked:Bool = false
    var musicaBoxChecked:Bool = false
    var showsBoxChecked:Bool = false
    var comidaBoxChecked:Bool = false
    var lazerBoxChecked:Bool = false
    var encontrosBoxChecked:Bool = false
    var feirasBoxChecked:Bool = false
    var socialBoxChecked:Bool = false
    var exposiçãoBoxChecked:Bool = false
    var culturaBoxChecked:Bool = false
    var festasBoxChecked:Bool = false
    var outrosBoxChecked:Bool = false
    
    
    @IBOutlet var esportesCheck: CheckBox!
    @IBOutlet var musicaCheck: CheckBox!
    @IBOutlet var showsCheck: CheckBox!
    @IBOutlet var comidaCheck: CheckBox!
    @IBOutlet var lazerCheck: CheckBox!
    @IBOutlet var encontrosCheck: CheckBox!
    @IBOutlet var feirasCheck: CheckBox!
    @IBOutlet var socialCheck: CheckBox!
    @IBOutlet var exposicaoCheck: CheckBox!
    @IBOutlet var culturaCheck: CheckBox!
    @IBOutlet var festasCheck: CheckBox!
    @IBOutlet var outrosCheck: CheckBox!
    //sabendo se no final de tudo, a box está selecionada ou nao
    @IBAction func esportesBox(sender: CheckBox) {
        if (esportesBoxChecked == false){
            esportesBoxChecked = true
        }else{
            esportesBoxChecked = false
        }
    }
    
    @IBAction func musicaBox(sender: CheckBox) {
        if( musicaBoxChecked == false){
            musicaBoxChecked = true
        }else{
            musicaBoxChecked = false
        }
    }
    
    @IBAction func showsBox(sender: CheckBox) {
        if( showsBoxChecked == false){
            showsBoxChecked = true
        }else{
            showsBoxChecked = false
        }
    }
    
    @IBAction func comidaBox(sender: CheckBox) {
        if( comidaBoxChecked == false){
            comidaBoxChecked = true
        }else{
            comidaBoxChecked = false
        }
    }
    
    @IBAction func lazerBox(sender: CheckBox) {
        if( lazerBoxChecked == false){
            lazerBoxChecked = true
        }else{
            lazerBoxChecked = false
        }
    }
    
    @IBAction func encontrosBox(sender: CheckBox) {
        if( encontrosBoxChecked == false){
            encontrosBoxChecked = true
        }else{
            encontrosBoxChecked = false
        }
    }
    
    @IBAction func feirasBox(sender: CheckBox) {
        if( feirasBoxChecked == false){
            feirasBoxChecked = true
        }else{
            feirasBoxChecked = false
        }
    }
    
    @IBAction func socialBox(sender: CheckBox) {
        if( socialBoxChecked == false){
            socialBoxChecked = true
        }else{
            socialBoxChecked = false
        }
    }
    
    @IBAction func exposiçãoBox(sender: CheckBox) {
        if( exposiçãoBoxChecked == false){
            exposiçãoBoxChecked = true
        }else{
            exposiçãoBoxChecked = false
        }
    }
    
    @IBAction func culturaBox(sender: CheckBox) {
        if( culturaBoxChecked == false){
            culturaBoxChecked = true
        }else{
            culturaBoxChecked = false
        }
    }
    
    @IBAction func festasBox(sender: CheckBox) {
        if( festasBoxChecked == false){
            festasBoxChecked = true
        }else{
            festasBoxChecked = false
        }
    }
    
    @IBAction func outrosBox(sender: CheckBox) {
        if( outrosBoxChecked == false){
            outrosBoxChecked = true
        }else{
            outrosBoxChecked = false
        }
    }
    
    @IBAction func confirmarBox(sender: UIButton) {
        if(esportesBoxChecked == true){
            interest.append("Esportes")
        }
        if(musicaBoxChecked == true){
            interest.append("Musica")
        }
        if(showsBoxChecked == true){
            interest.append("Shows")
        }
        if(comidaBoxChecked == true){
            interest.append("Comida")
        }
        if(lazerBoxChecked == true){
            interest.append("Lazer")
        }
        if(encontrosBoxChecked == true){
            interest.append("Encontros")
        }
        if(feirasBoxChecked == true){
            interest.append("Feiras")
        }
        if(socialBoxChecked == true){
            interest.append("Social")
        }
        if(exposiçãoBoxChecked == true){
            interest.append("Exposição")
        }
        if(culturaBoxChecked == true){
            interest.append("Cultura")
        }
        if(festasBoxChecked == true){
            interest.append("Festas")
        }
        if(outrosBoxChecked == true){
            interest.append("Outros")
        }
        
        if( interest.isEmpty ){
            let alertController = UIAlertController(title: "Você não selecionou nenhuma hashtag", message:
                "É necessário escolher ao menos uma!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        self.removeAnimate()
        dismissViewControllerAnimated(true, completion: nil)
        
        let interesses = interest.joinWithSeparator(" , ")
        
        NSNotificationCenter.defaultCenter().postNotificationName("interesses", object: self, userInfo: ["interesses": interesses])
        let user = PFUser.currentUser()
        user!["interesses"] = interesses
        user!.saveInBackground()
        
    }
    
    @IBOutlet weak var nameField: UITextField!
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
        
        //        self.descriptionField.layer.borderWidth = 0.5
        //        self.descriptionField.layer.borderColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor
        //        self.descriptionField.textColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveLatitude:", name: "latitudePosted", object: nil)
        //
        //
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveLongitude:", name: "longitudePosted", object: nil)
        
        super.viewDidLoad()
        
        if let userInteresses = PFUser.currentUser()?["interesses"] as? String {
            print(userInteresses)
            if userInteresses.rangeOfString("Esportes") != nil{
                esportesCheck.isChecked = true
                esportesBoxChecked = true
            }
            if userInteresses.rangeOfString("Musica") != nil{
                musicaCheck.isChecked = true
                musicaBoxChecked = true
            }
            if userInteresses.rangeOfString("Shows") != nil{
                showsCheck.isChecked = true
                showsBoxChecked = true
            }
            if userInteresses.rangeOfString("Comida") != nil{
                comidaCheck.isChecked = true
                comidaBoxChecked = true
            }
            if userInteresses.rangeOfString("Lazer") != nil{
                lazerCheck.isChecked = true
                lazerBoxChecked = true
            }
            if userInteresses.rangeOfString("Encontros") != nil{
                encontrosCheck.isChecked = true
                encontrosBoxChecked = true
            }
            if userInteresses.rangeOfString("Feiras") != nil{
                feirasCheck.isChecked = true
                feirasBoxChecked = true
            }
            if userInteresses.rangeOfString("Social") != nil{
                socialCheck.isChecked = true
                socialBoxChecked = true
            }
            if userInteresses.rangeOfString("Exposição") != nil{
                exposicaoCheck.isChecked = true
                exposiçãoBoxChecked = true
            }
            if userInteresses.rangeOfString("Cultura") != nil{
                culturaCheck.isChecked = true
                culturaBoxChecked = true
            }
            if userInteresses.rangeOfString("Festas") != nil{
                festasCheck.isChecked = true
                festasBoxChecked = true
            }
            if userInteresses.rangeOfString("Outros") != nil{
                outrosCheck.isChecked = true
                outrosBoxChecked = true
            }
        }
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        if animated
        {
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
                if (finished){
                    self.view.removeFromSuperview()
                }
        });
    }
    
    @IBAction func closePopup(sender: AnyObject) {
        self.removeAnimate()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
