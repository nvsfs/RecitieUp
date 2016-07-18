//
//  ViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/12/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import CloudKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var usuarios = [User]()
    
    let user:User = User()
    
    
    //  let container = CKContainer.defaultContainer()
    
    func handleIdentityChanged(notification: NSNotification){
        
        let fileManager = NSFileManager()
        
        if let token = fileManager.ubiquityIdentityToken{
            print("The new token is \(token)", terminator: "")
        } else {
            print("User has logged out of iCloud", terminator: "")
        }
    }
    
    /* Start listening for iCloud user change notifications */
    func applicationBecameActive(notification: NSNotification){
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "handleIdentityChanged:",
            name: NSUbiquityIdentityDidChangeNotification,
            object: nil)
    }
    
    /* Stop listening for those notifications when the app becomes inactive */
    func applicationBecameInactive(notification: NSNotification){
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: NSUbiquityIdentityDidChangeNotification,
            object: nil)
    }
    
    
    
    
    
    @IBAction func showHome(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Find out when the app is becoming active and inactive
        so that we can find out when the user's iCloud logging status changes.*/
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationBecameActive:",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationBecameInactive:",
            name: UIApplicationWillResignActiveNotification,
            object: nil)
        
        
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            print("Not logged in...")
        }
        else{
            returnUserData()
            
            print("Logged in...")
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnUserData()
    {
        print("returnUserData")
        
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me?fields=picture", parameters: ["fields":"id,email,name,first_name,last_name,gender,bio,age_range,about,context,currency,devices,education,favorite_athletes,favorite_teams,hometown,cover,picture"], HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                
                
                let idUsuario:String = result.valueForKey("id") as! String
                let imgURLString = "http://graph.facebook.com/" +  idUsuario + "/picture?type=large"
                
                self.user.name = result.valueForKey("name") as! String
                self.user.fotoUrl = imgURLString
                self.user.email = result.valueForKey("email") as! String
                self.user.id = result.valueForKey("id") as! String
                
                print("-------------")
                print(self.user.id)
                
                print("-------------")
                let container = CKContainer.defaultContainer()
                let publicData = container.publicCloudDatabase
                
                
                let query = CKQuery(recordType: "User", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
                
                publicData.performQuery(query, inZoneWithID: nil, completionHandler: { results, error in
                    
                    if error == nil {
                        
                        for comparacao in results! {
                            
                            
                            let name:String = comparacao["name"] as! String
                            let fotoURL:String = comparacao["photoURL"] as! String
                            let email:String = comparacao["email"] as! String
                            let id:String = comparacao["id"] as! String
                            
                            
                            let usuario:User = User()
                            
                            usuario.name = name
                            usuario.id = id
                            usuario.email = email
                            usuario.fotoUrl = fotoURL
                            
                            self.usuarios.append(usuario)
                            
                            print("-------------")
                            print(name)
                            print(email)
                            print(id)
                            print("-------------")
                            
                        }
                    }else {
                        
                    }
                    
                    let teste:Bool = self.verificarDisponibilidade()
                    
                    
                    if(teste == true){
                        
                        //print(result.valueForKey("id"))
                        let record = CKRecord(recordType: "User")
                        record.setValue(self.user.name, forKey: "name")
                        record.setValue(self.user.email, forKey: "email")
                        record.setValue(self.user.fotoUrl, forKey: "photoURL")
                        record.setObject(self.user.id, forKey: "id")
                        
                        publicData.saveRecord(record, completionHandler: { record, error in
                            if error != nil {
                                print(error)
                            }
                        })
                        
                    }
                    
                    
                    
                    
                })
                
                
                let defaultContainer: CKContainer = CKContainer.defaultContainer()
                
                //get the PublicDatabase inside the Container
                let publicDatabase: CKDatabase = defaultContainer.publicCloudDatabase
                
                //create the target record id you will use to fetch by
                let wellKnownID: CKRecordID = CKRecordID(recordName: "User")
                
                //fetch the target record using it's record id
                publicDatabase.fetchRecordWithID(wellKnownID, completionHandler: { (record, error) -> Void in
                    
                    if error != nil {
                        
                        print("Uh oh, there was an error fetching...")
                        print(error!.localizedDescription)
                    }
                    
                    if record != nil {
                        print("Fetched record by Id Successflly")
                        print(record!.objectForKey("title"))
                        print(record!.objectForKey("description"))
                        print(record!.objectForKey("address"))
                        print(record!.objectForKey("location"))
                    }
                })
                
                
                
                NSNotificationCenter.defaultCenter().postNotificationName("userInfoPosted", object: self, userInfo: ["userInfo" : self.user])
                
                
            }
            
            
            
        })
    }
    
    
    
    
    func verificarDisponibilidade() -> Bool{
        
        for var index:Int = 1 ; index < self.usuarios.count ;index++ {
            
            
            if(self.user.id == self.self.usuarios[index].id){
                return false
                
            }
            
            
        }
        
        return true
        
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil
        {
            print("Login complete.")
            self.performSegueWithIdentifier("mainScreen", sender: self)
        }
        else
        {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("User logged out...")
        
    }
    
    /* Just a little method to help us display alert dialogs to the user */
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
}