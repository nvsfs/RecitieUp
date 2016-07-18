//
//  LoginViewController.swift
//  ReCitie
//
//  Created by Rodrigo Bruno de Carvalho Cavalcanti on 21/10/15.
//  Copyright © 2015 Rodrigo Bruno de Carvalho Cavalcanti. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var loginAction: UIButton!
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        self.loginAction.layer.cornerRadius = loginAction.frame.size.width / 40
        self.loginAction.layer.masksToBounds = true

    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookSignIn(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email"], block: { (user:PFUser?, error:NSError?) -> Void in
            if(error != nil){
                //Display an alert message
                let myAlert = UIAlertController(title:"Não foi possível logar com o Facebook. Tente novamente.", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated:true, completion:nil);
                return
            }
            //print(user)
            //print("Current user token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
            //print("Current user id \(FBSDKAccessToken.currentAccessToken().userID)")
            if(FBSDKAccessToken.currentAccessToken() != nil){
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                self.presentViewController(viewController, animated: true, completion: nil)
                let mapa = self.storyboard?.instantiateViewControllerWithIdentifier("ProtectedPageViewController") as! MapViewController
                let MapaNav = UINavigationController(rootViewController: mapa)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = MapaNav
            }
            else{
                let alert = UIAlertController(title: "Não foi possível logar com o Facebook. Tente novamente.", message:"\(error)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}
            }
        })
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        // Validate the text fields
        if (username?.characters.count) < 5 {
            //let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            //alert.show()
            let alert = UIAlertController(title: "Inválido.", message:"O usuário deve ter mais de 5 caracteres.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        } else if (password?.characters.count) < 8 {
            //            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
            let alert = UIAlertController(title: "Inválido.", message:"A senha deve ter mais de 8 caracteres.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            // Send a request to login
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                if ((user) != nil) {
                    //                    let alert = UIAlertController(title: "Success", message:"Logged In", preferredStyle: .Alert)
                    //                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    //                    self.presentViewController(alert, animated: true){}
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                    
                } else {
                    //                    let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    //                    alert.show()
                    let alert = UIAlertController(title: "Falha no login.", message:"Parâmetros de login inválidos.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
                }
            })
        }
    }
    
    
}

