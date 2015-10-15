//
//  Cadastro.swift
//  Recitie
//
//  Created by Natalia Souza on 10/13/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CadastroViewController:UIViewController{

    
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextField!

    var arrayEventos:[Event]?
   
    @IBAction func saveButton(sender: AnyObject) {
        
        let event: Event = Event()

        event.name = nameField.text!
        event.description = descriptionField.text!
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("eventPosted", object: self, userInfo: ["event": event])

        
        self.dismissViewControllerAnimated(true, completion: nil)
   
    }
    
    
    
    
    
   
    
    
    
    
}

