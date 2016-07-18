//
//  PlacesEventsViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/28/15.
//  Copyright © 2015 Natalia. All rights reserved.
//



import UIKit
import ParseUI
import Parse

class PlacesEventsViewController: PFQueryTableViewController {
    
    var shouldUpdateFromServer:Bool = true
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var nome: UILabel!
    
    let lugarEvento = NSUserDefaults.standardUserDefaults().objectForKey("place") as! String
    let lugarId = NSUserDefaults.standardUserDefaults().objectForKey("placeId") as! String
    //let lugarName = NSUserDefaults.standardUserDefaults().objectForKey("placeName") as! String
    var currentObject : PFObject?
    
    let place = []
    

    override func viewDidLoad() {
        //self.loadObjects()
    }
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Event"
        self.textKey = "name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    
    func baseQuery() -> PFQuery {
        let query = PFQuery(className: "Event")
        query.includeKey("place")
        query.includeKey("user")
        query.orderByAscending("created_at")
        query.whereKey("place", equalTo: PFObject(withoutDataWithClassName:"Place", objectId:lugarId))
        //query.whereKey("place", equalTo: self.lugarName)
        return query
    }
    
    override func queryForTable() -> PFQuery {
        return self.baseQuery().fromLocalDatastore()
    }
    
    func refreshLocalDataStoreFromServer() {
        self.baseQuery().findObjectsInBackgroundWithBlock { ( parseObjects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Found \(parseObjects!.count) parseObjects from server")
                // First, unpin all existing objects
                PFObject.unpinAllInBackground(self.objects as? [PFObject], block: { (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        // Pin all the new objects
                        PFObject.pinAllInBackground(parseObjects, block: { (succeeded: Bool, error: NSError?) -> Void in
                            if error == nil {
                                // Once we've updated the local datastore, update the view with local datastore
                                self.shouldUpdateFromServer = false
                                self.loadObjects()
                            } else {
            //                    print("Failed to pin objects")
                            }
                        })
                    }
                })
            } else {
              //  print("Couldn't get objects")
            }
        }
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        // If we just updated from the server, do nothing, otherwise update from server.
        if self.shouldUpdateFromServer {
            self.refreshLocalDataStoreFromServer()
            tableView.reloadData()

        } else {
            self.shouldUpdateFromServer = true
            tableView.reloadData()

        }
    }
    
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("celula") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "celula")
        }
        if let data = object?["name"] as? String {
            (cell.contentView.viewWithTag(2) as! UILabel).text = data
        }
        if let nameEnglish = object?["data"] as? String {
            (cell.contentView.viewWithTag(1)as! UILabel).text = nameEnglish
        }
//        if let capital = object?["place"]["name"] as? String {
//            (cell.contentView.viewWithTag(4)as! UILabel).text = capital
//        }
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
//        // Extract values from the PFObject to display in the table cell
//        if let nameEnglish = object?["name"] as? String {
//            cell?.textLabel?.text = nameEnglish
//        }
//        if let capital = object?["description"] as? String {
//            cell?.detailTextLabel?.text = capital
//        }
//        
//        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        let detailScene = segue.destinationViewController as! DetalheEventosViewController
        
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let row = Int(indexPath.row)
            detailScene.currentObject = (objects?[row] as! PFObject)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
      //  self.loadObjects()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadObjects()
    }
}
