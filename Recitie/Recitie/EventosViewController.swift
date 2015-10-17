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
    var popViewController : PopUpViewControllerSwift = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
    
    
    @IBAction func tedte(sender: AnyObject) {
        
        //        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        //        {
        //            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPad", bundle: nil)
        //            self.popViewController.title = "This is a popup view"
        //            self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
        //        } else
        //{
        if UIScreen.mainScreen().bounds.size.width > 320 {
            if UIScreen.mainScreen().scale == 3 {
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                self.popViewController.title = "This is a popup view"
                self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "iphone 6+", animated: true)
            } else {
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6", bundle: nil)
                self.popViewController.title = " esse é o 6"
                self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "esse é o 6", animated: true)
            }
        } else {
            self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
            self.popViewController.title = "This is a popup view"
            self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
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
        
        dtVC.eventoteste = events[idxPath!.row]

        }

    }
    

}
