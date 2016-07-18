//
//  Place.swift
//  Recitie
//
//  Created by Natalia Souza on 10/12/15.
//  Copyright © 2015 Natalia. All rights reserved.
//
import CloudKit
import MapKit
import UIKit

class Places: NSObject, MKAnnotation {
    var objectId : String?
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var events = [Event]()
    
    init(objectId: String, title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.objectId = objectId
    }
}