//
//  Cadastro.swift
//  Recitie
//
//  Created by Natalia Souza on 10/13/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI


class NewEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var message = "bla bla bla"
    
    var foto : PFFile!
    
    var placeholder : PFFile!

    
    var hashtags : String?

    
    var popViewController : CheckboxViewControllerSwift = CheckboxViewControllerSwift(nibName: "PopUp_Checkbox", bundle: nil)
    
    @IBOutlet weak var fotoBackground: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var hourTextField: UITextField!
    
    @IBOutlet weak var addFotoBackground: PFImageView!
    
    @IBOutlet weak var hashtagsButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    let picker = UIImagePickerController()

    
    @IBAction func hourTextFieldEditing(sender: UITextField) {
        let hourPickerView:UIDatePicker = UIDatePicker()
        
        hourPickerView.datePickerMode = UIDatePickerMode.Time
        // hourPickerView.locale = NSLocale(localeIdentifier: "en_GB") // using Great Britain for this example
        
        sender.inputView = hourPickerView
        
        hourPickerView.addTarget(self, action: Selector("hourPickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func hourPickerValueChanged(sender:UIDatePicker) {
        
        let hourFormatter = NSDateFormatter()
        
        hourFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        hourTextField.text = hourFormatter.stringFromDate(sender.date)
    }
    
    var arrayEventos:[Event]?
    @IBOutlet weak var dateTextField: UITextField!
    
    
    
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        fotoBackground.contentMode = .ScaleAspectFit //3
        fotoBackground.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
        
        //Upload to Parse
        //let usuario = PFUser.currentUser()?.username
        let imageData = UIImageJPEGRepresentation(chosenImage,0.5)
        let imageFile = PFFile(name:"foto.jpg", data:imageData!)
        
        
        //let userPhoto = newUser
        foto = imageFile!
        //userPhoto.saveInBackground()
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        
        picker.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveInteresse:", name: "interesses", object: nil)


        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        //Layout Style
        self.addFotoBackground.layer.cornerRadius = 50
        self.addFotoBackground.layer.masksToBounds = true
        
        //Muita atencao nas seguintes linhas
        //Quando as escrevi, so eu e Deus entendiamos
        //Agora, so Deus
        self.descriptionField.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.descriptionField.layer.borderWidth = 0.5
        
        //inicializando field da hora com hora atual
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        hourTextField.text = dateFormatter.stringFromDate(NSDate())
        self.saveButton.layer.cornerRadius = saveButton.frame.size.width / 40
        self.saveButton.layer.masksToBounds = true
        
        self.hashtagsButton.layer.cornerRadius = hashtagsButton.frame.size.width / 40
        self.hashtagsButton.layer.masksToBounds = true
        //inicializando field da data com data atual
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateStyle = .ShortStyle
        dateFormatter2.timeStyle = .NoStyle
        
        dateFormatter2.dateFormat = "dd/MM/yyyy"
        
        dateTextField.text = dateFormatter2.stringFromDate(NSDate())
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func textFieldEditing(sender: UITextField) {
        // 6
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBOutlet weak var dddContact: UITextField!
    @IBOutlet weak var numContact: UITextField!
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    //validando numero de telefone
    func phoneNumberValidation(value: String) -> Bool {
        let charcter  = NSCharacterSet(charactersInString: "0123456789").invertedSet
        var filtered:NSString!
        let inputString:NSArray = value.componentsSeparatedByCharactersInSet(charcter)
        filtered = inputString.componentsJoinedByString("")
        return  value == filtered
    }
    
    func recieveInteresse(sender: NSNotification) {
        
        let info = sender.userInfo!
        hashtags = (info["interesses"] as! String)
        
        print(hashtags)
        
    }
    
    
    
    
    let lugarEvento = NSUserDefaults.standardUserDefaults().objectForKey("place") as! String
    @IBAction func saveButton(sender: AnyObject) {
        print(lugarEvento)
        let evento = PFObject(className: "Event")
        
        if(hourTextField.text!.isEmpty || nameField.text!.isEmpty || descriptionField.text!.isEmpty || dateTextField.text!.isEmpty || numContact.text!.isEmpty || dddContact.text!.isEmpty){
            
            // testando se todos os campos estao preenchidos
            let alertController = UIAlertController(title: "Campos vazios!", message:
                "É necessário preencher todos os campos!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        func checarTelefoneValido (testNum: String) -> Bool{
            //retorna boleano correspondente a validade do numero
            let phoneRegex: String = "[0-9]{4,5}-[0-9]{4}"
            let nuumTest = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
            return nuumTest.evaluateWithObject(testNum)
        }
        
        if(  !(dddContact.text!.characters.count == 2) ){
            //alerta caso o telefone nao seja no formato valido
            let alertController = UIAlertController(title: "Contato Inválido", message:
                "Digite um DDD válido", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        if(  !( checarTelefoneValido(numContact.text!) )  ){
            //alerta caso o telefone nao seja no formato valido
            let alertController = UIAlertController(title: "Contato Inválido", message:
                "Digite um numero para contato valido", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        var contactEvent: String = "(0"
        contactEvent += dddContact.text! as String
        contactEvent += ") "
        contactEvent += numContact.text! as String
        
        let initialThumbnail = UIImage(named: "placeholder.png")
      
        let file = PFFile(data: UIImageJPEGRepresentation(initialThumbnail!, 1.0)!)

        
        let descricao = (descriptionField.text! + hashtags!)
        
        evento["name"] = nameField.text!
        
        if foto != nil {
            evento["imagem"] = foto
        } else {
            evento["imagem"] = file
        
        }
        evento["description"] = descricao
        evento["user"] = PFUser.currentUser()
        evento["data"] = dateTextField.text!
        evento["hora"] = hourTextField.text!
        evento["contato"] = contactEvent
        evento["qtdParticipantes"] = 1
        let eventNSDate = (dateTextField.text! + " " + hourTextField.text!)
        evento["NSDate"] = eventNSDate
        let searchText = (nameField.text! + " " + descriptionField.text!).lowercaseString
        evento["searchText"] = searchText
        
        let query = PFQuery(className:"Place")
        query.whereKey("name", equalTo:lugarEvento)
        do {
            let place = try query.getFirstObject() as PFObject
            evento["place"] = place
        }
        catch{
            print("ERRO DO TRY")
        }
        evento.pinInBackground()
        
        evento.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
//                
//                let data = [
//                    "alert" : self.message,
//                    
//                ]
//                
//                let myPush = PFPush()
//                myPush.setChannel("Music")
//                
//                myPush.setData(data)
//                myPush.sendPushInBackground()
//                
//                
//                
//                print("salvo")
                
                // Find users near a given location
                
                //                let pushquery = PFInstallation.query()
                //                pushquery?.whereKey("deviceType", equalTo: "ios")
                //
                //                PFPush.sendPushMessageToQueryInBackground(pushquery!, withMessage: "Novo evento!!")
                
                //                let push: PFPush = PFPush()
                //                push.setChannel("Reload")
                //
                //
                //                let data:NSDictionary = ["alert":"", "badge":"0", "content-avaliable":"1", "sound":""]
                //
                //                push.setData(data as [NSObject : AnyObject])
                //                push.sendPushInBackground()
                
                
                self.confirmarPresencaParse()
            } else {
                print("n foi")
            }
        }
        
        self.navigationController!.popViewControllerAnimated(true)
        
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

    func confirmarPresencaParse(){
        let eventoPQuery = PFQuery(className: "Event")
        eventoPQuery.whereKey("name", equalTo: nameField.text!)
        eventoPQuery.findObjectsInBackgroundWithBlock{
            (objects: [PFObject]?,error: NSError?) -> Void in
            if error == nil {
                if let objects = objects  {
                    for object in objects {
                        //print("EVENTO PARTICIPAR: \(object)")
                        let user = PFUser.currentUser()
                        let relation = user!.relationForKey("Events")
                        relation.addObject(object)
                        user!.pinInBackground()
                        user!.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                print("The post has been added to the user's likes relation.")
                            } else {
                                print("There was a problem, check error.description")
                            }
                            self.contadorPessoaMais(object)
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    @IBAction func addHashtags(sender: AnyObject) {
        
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
    
    
    
    func contadorPessoaMais(eventoParticipar: PFObject){
        //Atualizando número de avaliações
        var valor = 0
        let nPessoas = eventoParticipar["qtdParticipantes"] as! Int
        valor = nPessoas + 1;
        eventoParticipar["qtdParticipantes"] = valor
        eventoParticipar.saveInBackground()
    }
}

