//
//  TableTableViewController.swift
//  ParseTutorial
//
//  Created by Ian Bradbury on 05/02/2015.
//  Copyright (c) 2015 bizzi-body. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class EventosConfirmadosViewController: PFQueryTableViewController {
    
    var shouldUpdateFromServer:Bool = true

    
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
    override func queryForTable() -> PFQuery {
        
        return self.baseQuery().fromLocalDatastore()

            }
    
    func baseQuery() -> PFQuery {
        let user = PFUser.currentUser()
        let relation = user?.relationForKey("Events")
        var query = PFQuery(className: "Event")
        query = (relation?.query())!
        query.orderByAscending("created_at")
        return query

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
                                print("Failed to pin objects")
                            }
                        })
                    }
                })
            } else {
                print("Couldn't get objects")
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Confirmados") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Confirmados")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let nameEnglish = object?["name"] as? String {
            cell?.textLabel?.text = nameEnglish
        }
        if let capital = object?["description"] as? String {
            cell?.detailTextLabel?.text = capital
        }
        
        return cell
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
        tableView.reloadData()
    }
    
}
