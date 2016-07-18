//
//  SingUpViewController.swift
//  ReCitie
//
//  Created by Rodrigo Bruno de Carvalho Cavalcanti on 21/10/15.
//  Copyright © 2015 Rodrigo Bruno de Carvalho Cavalcanti. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4
import Bolts


class SingUpViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var popViewController : CheckboxViewControllerSwift = CheckboxViewControllerSwift(nibName: "PopUp_Checkbox", bundle: nil)
    var userPhoto : PFFile!
    var interessesUser = ""
    
    @IBOutlet weak var emailField: UITextField!
    //@IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var sobrenome: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var contato : UITextField!
    
    @IBOutlet weak var fotoCadastro: PFImageView!
    
    @IBOutlet weak var addInterest: UIButton!
    @IBOutlet weak var signUpAction: UIButton!
    
    let picker = UIImagePickerController()
    
    
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        fotoCadastro.contentMode = .ScaleAspectFill //3
        fotoCadastro.layer.masksToBounds = true
        fotoCadastro.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
        
        //Upload to Parse
        //let usuario = PFUser.currentUser()?.username
        let imageData = UIImageJPEGRepresentation(chosenImage,0.5)
        let imageFile = PFFile(name:"foto.jpg", data:imageData!)
        
        
        //let userPhoto = newUser
        userPhoto = imageFile!
        //userPhoto.saveInBackground()
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        // Do any additional setup after loading the view.
        
        //buttons rounded corners
        
        self.addInterest.layer.cornerRadius = addInterest.frame.size.width / 40
        self.addInterest.layer.masksToBounds = true
        
        self.signUpAction.layer.cornerRadius = signUpAction.frame.size.width / 40
        self.signUpAction.layer.masksToBounds = true
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveInteresse:", name: "interesses", object: nil)
        
        //fotoCadastro different devices
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            self.fotoCadastro.layer.cornerRadius = 117
            self.fotoCadastro.layer.masksToBounds = true
            
        } else {
            if UIScreen.mainScreen().bounds.size.width > 320 {
                if UIScreen.mainScreen().scale == 3 {
                    self.fotoCadastro.layer.cornerRadius = 63
                    self.fotoCadastro.layer.masksToBounds = true
                    
                    
                } else {
                    self.fotoCadastro.layer.cornerRadius = 57
                    self.fotoCadastro.layer.masksToBounds = true
                    
                }
            } else {
                self.fotoCadastro.layer.cornerRadius = 50
                self.fotoCadastro.layer.masksToBounds = true
            }
        }

        
    }
    
    func recieveInteresse(sender: NSNotification) {
        
        let info = sender.userInfo!
        interessesUser = info["interesses"] as! String
        
        //print(interessesUser)
        
    }
    

    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func signUpAction(sender: AnyObject) {
        
        //let username = self.usernameField.text
        let username = self.nome.text
        let password = self.passwordField.text
        let email = self.emailField.text
        let contato = self.contato.text
        let nome = self.nome.text
        let sobrenome = self.sobrenome.text
        //print(interessesUser)
        
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Validate the text fields
        if  (username?.characters.count) < 5 {
            //            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
            let alert = UIAlertController(title: "Inválido.", message:"O usuário deve ter mais de 5 caracteres.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        } else if (password?.characters.count) < 8 {
            //            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            //            alert.show()
            let alert = UIAlertController(title: "Inválido.", message:"A senha deve ter mais de 8 caracteres.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        } else if (email?.characters.count) < 8 {
            //            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK"
            //            alert.show()
            let alert = UIAlertController(title: "Inválido.", message:"Por favor entre com um endereço de email válido.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
            
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            
            newUser.username = username
            newUser.password = password
            newUser.email = finalEmail
            newUser["first_name"] = nome
            newUser["last_name"] = sobrenome
            newUser["telefone"] = contato
            
            
            if userPhoto != nil{
                newUser["profile_picture"] = userPhoto
            }else{
                let placeholderImage = UIImage(named: "placeholder.png")
                let imageData = UIImageJPEGRepresentation(placeholderImage!,0.5)
                let imageFile = PFFile(name:"foto.jpg", data:imageData!)
                newUser["profile_picture"] = imageFile
            }
            newUser["interesses"] = interessesUser
            
            //            if !PFFacebookUtils.isLinkedWithUser(newUser) {
            //                PFFacebookUtils.linkUserInBackground(newUser, withReadPermissions: nil, block: {
            //                    (succeeded: Bool?, error: NSError?) -> Void in
            //                    if (succeeded != nil) {
            //                        print("Woohoo, the user is linked with Facebook!")
            //                    }
            //                })
            //            }
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    //                    let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    //                    alert.show()
                    let alert = UIAlertController(title: "Não foi possível efetuar o cadastro", message:"Verifique se você preencheu corretamente os campos ou se seu endereço de email já foi cadastrado.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
                    
                } else {
                    //                    let alert = UIAlertController(title: "Success", message:"Signed Up", preferredStyle: .Alert)
                    //                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    //                    self.presentViewController(alert, animated: true){}
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            })
        }
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
