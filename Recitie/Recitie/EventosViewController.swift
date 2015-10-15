//
//  EventosViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/14/15.
//  Copyright © 2015 Natalia. All rights reserved.
//


import UIKit
import CloudKit

class EventosViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var eventostableview: UITableView!
    
    
    var eventos: [(name:String, numero:String)] = []
   
    var events:[Event] = []
    
    var e1:Event = Event()
    
    var teste:Event?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveEvent:", name: "eventPosted", object: nil)

        
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        
        let query = CKQuery(recordType: "Events", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        publicData.performQuery(query, inZoneWithID: nil){ results, error in
            
            if error == nil {
                
                for event in results! {
                    let newEvent = Event()
                    newEvent.name = event["name"] as! String
                    newEvent.description = event["description"] as! String
                    
                    
                    self.events.append(newEvent)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.eventostableview.reloadData()
                    
                })
            }
        }
            else {
            
        }
        }
    }
    
    
    
    
    func recieveEvent(sender: NSNotification) {
    
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        
        let info = sender.userInfo!
        let event = info["event"] as! Event
        events.append(event)
        
        
        let record = CKRecord(recordType: "Events")
        record.setValue(event.name, forKey: "name")
        record.setValue(event.description, forKey: "description")
        
        publicData.saveRecord(record, completionHandler: { record, error in
            if error != nil{
                print(error)
            }
        })
        
        
        eventostableview.reloadData()
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let tableViewCell:UITableViewCell = eventostableview.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        tableViewCell.textLabel?.text = events[indexPath.row].name
        
        
        return tableViewCell
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        
        if segue.identifier == "showDetalhe"{
        let dtVC = segue.destinationViewController as! DetalheEventosViewController
        
        let idxPath = eventostableview.indexPathForCell(sender as! UITableViewCell) as NSIndexPath?
        
        //dtVC.numero = events[idxPath!.row].description
        dtVC.eventoteste = events[idxPath!.row]

        }

    }
    

}
