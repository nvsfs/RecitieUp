//
//  PlacesViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/18/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import CloudKit


class PlacesViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        
//        let predicate = NSPredicate(format: ("name = %@",place.name), <#T##args: CVarArgType...##CVarArgType#>)
//        
//        let query = ckfe(recordType: "Place", predicate: <#T##NSPredicate#>)
    }
}