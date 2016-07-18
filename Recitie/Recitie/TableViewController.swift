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

class TableViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    var currentObject : String?
    var shouldUpdateFromServer:Bool = true
    var image: UIImage = UIImage(named: "search")!
    var image2: UIImage = UIImage(named: "clear")!

    @IBOutlet var data: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("searchText: " + currentObject!)
        
        if currentObject != ""{
            searchbar.text = currentObject
        }
        
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
        self.loadObjects()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        // Delegate the search bar to this table view class
        searchbar.delegate = self
        
        //searchBar
        self.searchbar.layer.borderColor = UIColor.init(red: 41.0/255.0, green: 157.0/255.0, blue: 141.0/255.0, alpha: 1.0).CGColor
        self.searchbar.layer.borderWidth = 1
        self.searchbar.setImage(image, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        self.searchbar.setImage(image2, forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Normal)
        
        for subView in searchbar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    textField.layer.cornerRadius = 13
                    textField.bounds = bounds
                    textField.layer.borderWidth = 0.5
                    textField.layer.borderColor = UIColor.whiteColor().CGColor
                    textField.borderStyle = UITextBorderStyle.RoundedRect
                    textField.backgroundColor = UIColor.init(red: 41.0/255.0, green: 157.0/255.0, blue: 141.0/255, alpha: 1.0)
                    textField.textColor = UIColor.whiteColor()
                    textField.attributedPlaceholder =  NSAttributedString(string:NSLocalizedString("Procurar eventos", comment:""),
                        attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
                }
            }
        }
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        // self.searchbar.resignFirstResponder()
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
	
    func baseQuery() -> PFQuery {
        let query = PFQuery(className: "Event")
        
        query.includeKey("place")
        query.includeKey("user")
        query.orderByDescending("created_at")
        
        // Add a where clause if there is a search criteria
        if searchbar.text != "" {
            query.whereKey("searchText", containsString: searchbar.text!.lowercaseString)
        }
        return query
    }
    
    func refreshLocalDataStoreFromServer() {
        self.baseQuery().findObjectsInBackgroundWithBlock { ( parseObjects: [PFObject]?, error: NSError?) -> Void in
            //print (parseObjects)
            if error == nil {
                //print("Found \(parseObjects!.count) parseObjects from server")
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
    
	// Define the query that will provide the data for the table view
	override func queryForTable() -> PFQuery {
        return self.baseQuery()//.fromLocalDatastore()
	}
	
	//override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
		
		var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell!
		if cell == nil {
			cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
		}
        if let data = object?["data"] as? String {
            (cell.contentView.viewWithTag(2) as! UILabel).text = data
        }
        if let nameEnglish = object?["name"] as? String {
            (cell.contentView.viewWithTag(3)as! UILabel).text = nameEnglish
		}
//		if let capital = object?["place"]["name"] as? String {
//         //   print("Place.name: " + capital)
//            (cell.contentView.viewWithTag(4)as! UILabel).text = capital
//		}

        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
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
        
        //searchBar
        self.searchbar.layer.borderColor = UIColor.init(red: 41.0/255.0, green: 157.0/255.0, blue: 141.0/255.0, alpha: 1.0).CGColor
        self.searchbar.layer.borderWidth = 1
        
		// Refresh the table to ensure any data changes are displayed
		tableView.reloadData()
        
        self.tableView.rowHeight = 80
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        
	}
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        // Force reload of table data
        self.loadObjects()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.loadObjects()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        // Force reload of table data
        self.loadObjects()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Clear any search criteria
        searchBar.text = ""
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        // Force reload of table data
        self.loadObjects()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        tableView.keyboardDismissMode = .OnDrag
    }
}
