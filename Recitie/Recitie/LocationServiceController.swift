//
//  LocationServiceController.swift
//  Recitie
//
//  Created by Natalia Souza on 11/24/15.
//  Copyright © 2015 Natalia. All rights reserved.
//
import Foundation

class LocationServiceController : NSObject {
    
    override init() {
        
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationAvailable:", name: "LOCATION_AVAILABLE", object: nil)
    }
    
    func locationAvailable(notification:NSNotification) -> Void {
        let userInfo = notification.userInfo as! Dictionary<String,String>
        
        print("Location service:  Location available \(userInfo)")
        
    }
    
}