//
//  UsersViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/16/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import CloudKit
class UsersViewController : UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        
        
        let query = CKQuery(recordType: "User", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        
        publicData.performQuery(query, inZoneWithID: nil, completionHandler: { results, error in
            
            if error == nil {
                
                for user in results! {
                    
                    
                    let name:String = user["name"] as! String
                    let photoURL:String = user["photoURL"] as! String
                    let email:String = user["email"] as! String
                    let id:String = user["id"] as! String
                    
                    print(name)
                    print(email)
                    print(id)
                    self.nameLabel.text = name
                    self.emailLabel.text = email
                    self.load_image(photoURL)
                    
                }
            }else {
                
            }
        })
    }


    
    
    func load_image(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.profilePicture.image = UIImage(data: data!)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
 

    

    
    
    
}