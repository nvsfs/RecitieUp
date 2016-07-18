//
//  Event.swift
//  Recitie
//
//  Created by Natalia Souza on 10/12/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import Foundation
import MapKit
import Parse

class Event {
    
    var interests = [String]()
    var name:String =  ""
    var description:String = ""
    var type:String = ""
    var organizers = PFUser()
    var place : Places!
    
    init(name: String, description: String, place: Places, type: String, organizers: PFUser, interests: [String]) {
     
        self.name = name
        self.description = description
        self.place = place
        self.type = type
        self.organizers = organizers
        self.interests = interests
    }

    
}