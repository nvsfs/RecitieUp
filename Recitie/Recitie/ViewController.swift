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
    
 
    let user:User = User()
    @IBAction func showHome(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
             self.performSegueWithIdentifier("mainScreen", sender: self)
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func returnUserData()
    {
        
       
        
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
                
                let container = CKContainer.defaultContainer()
                let publicData = container.publicCloudDatabase
                
                
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

                
       
                
               
                NSNotificationCenter.defaultCenter().postNotificationName("userInfoPosted", object: self, userInfo: ["userInfo" : self.user])
                
              
                }
            

            
        })
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
    
    
    
}