//
//  PopoverDetalhesViewController.swift
//  Recitie
//
//  Created by Frederica Teixeira on 26/11/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import Parse
import Social

class PopoverDetalhesViewController: UIViewController {
    
    @IBAction func share(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Evou para o \(nameEnglish.text!) venha voce tambem! www.google.com")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

}
