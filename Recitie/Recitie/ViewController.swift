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


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
   
    
    @IBAction func showHome(sender: AnyObject) {
        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("Not logged in...")
        }
        else{
            print("Logged in...")
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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