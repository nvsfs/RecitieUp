//
//  EventosViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/14/15.
//  Copyright © 2015 Natalia. All rights reserved.
//


import UIKit
import CloudKit
import Parse

class EventosViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var eventostableview: UITableView!
    
    
    var eventos: [(name:String, numero:String)] = []
    
    var events:[Event] = []
    
    //var e1:Event = Event()
    
    var teste:Event?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recieveEvent:", name: "eventPosted", object: nil)
       
        let query = PFQuery(className:"Event")
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    //print(object.objectId)
                    //print(object["user"])
                    
                    //let nome = object["place"]["name"]
                    print("antes")
                    
                    let place = Places(objectId: object.objectId!, title: object["place"]["name"] as! String, coordinate: CLLocationCoordinate2D(latitude: object["place"]["latitude"] as! Double, longitude: object["place"]["longitude"] as! Double), info: object["place"]["description"] as! String)
                    
                    
                    let newEvent: Event = Event(name: object["name"] as! String, description: object["description"] as! String, place: place, type: object["type"] as! String, organizers: object["user"] as! PFUser, interests: object["interests"] as! [String])
                    
                    self.events.append(newEvent)
                    print("depois")
                    print("eventos")
                    //print(self.events)
                    
                    self.eventostableview.reloadData()
                    //                    dispatch_async(
                    //                        dispatch_get_main_queue(), {()-> Void in
                    //                            self.eventostableview.reloadData()
                    //                    })
                }
            } else {
                print(error)
            }
        }
        print(events)
        
        
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
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus_novo", bundle: nil)
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
        
        let info = sender.userInfo!
        let event = info["event"] as! Event
        events.append(event)
  
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

