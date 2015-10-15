//
//  DetalheEventosViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/14/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit

class DetalheEventosViewController: UIViewController {
    
    @IBOutlet weak var numeroEvento: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        numeroEvento.text = eventoteste?.description
        
    }
    
    var numero:String?
    var eventoteste:Event?
    
    
}
