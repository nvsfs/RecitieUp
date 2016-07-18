//
//  MapViewController.swift
//  Recitie
//
//  Created by Natalia Souza on 10/15/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CloudKit
import Parse
import Bolts

class MapViewController : UIViewController, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate, UISearchBarDelegate {
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var popViewController : PopUpViewControllerSwift = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus_novo", bundle: nil)
    var locationManager = CLLocationManager()
    var myPosition  = CLLocationCoordinate2D()
    var places:[Places] = []
    var image: UIImage = UIImage(named: "search")!
    var image2: UIImage = UIImage(named: "clear")!
    var pino:Places?
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var searchBarMap: UISearchBar!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //MARK: viewFunctions
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("viewDidLoad")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        //searchBar
        self.searchBarMap.layer.borderColor = UIColor.init(red: 41.0/255.0, green: 157.0/255.0, blue: 141.0/255.0, alpha: 1.0).CGColor
        self.searchBarMap.layer.borderWidth = 1
        self.searchBarMap.setImage(image, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        self.searchBarMap.setImage(image2, forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Normal)
        
        for subView in searchBarMap.subviews  {
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
                    textField.attributedPlaceholder =  NSAttributedString(string:NSLocalizedString("Procurar lugares", comment:""),
                        attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
                }
            }
        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let query = PFQuery(className:"Place")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    // print(object)
                    
                    let longitude:Double = object["longitude"] as! Double
                    let latitude:Double = object["latitude"] as! Double
                    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let idObjeto:String = object.objectId! as String
                    
                    let newPlace = Places(objectId: idObjeto, title: object["name"] as! String, coordinate: coordinate, info: object["description"] as! String)
                    
                    self.places.append(newPlace)
                    dispatch_async(
                        dispatch_get_main_queue(), {()-> Void in
                            self.mapView.addAnnotation(newPlace)
                            self.mapView.reloadInputViews()
                    })
                }
            } else {
                
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        // self.searchbar.resignFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if (PFUser.currentUser() == nil) {
            print("NoUser->Login")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
                
            })
        }
        
//        let query = PFQuery(className:"Place")
//        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                for object in objects! {
//                    // print(object)
//                    let longitude:Double = object["longitude"] as! Double
//                    let latitude:Double = object["latitude"] as! Double
//                    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                    let idObjeto:String = object.objectId! as String
//                    
//                    let newPlace = Places(objectId: idObjeto, title: object["name"] as! String, coordinate: coordinate, info: object["description"] as! String)
//                    
//                    
//                    
//                    self.places.append(newPlace)
//                    dispatch_async(
//                        dispatch_get_main_queue(), {()-> Void in
//                            self.mapView.addAnnotation(newPlace)
//                            self.mapView.reloadInputViews()
//                            
//                    })
//                }
//            } else {
//                
//            }
//        }
        
        
//        PFGeoPoint.geoPointForCurrentLocationInBackground {
//            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
//            if error == nil {
//                let userQuery = PFUser.query()
//                userQuery!.whereKey("location", nearGeoPoint: geoPoint! )
//                
//                // Find devices associated with these users
//                let pushQuery = PFInstallation.query()
//                pushQuery!.whereKey("user", matchesQuery: userQuery!)
//                
//                // Send push notification to query
//                let push = PFPush()
//                push.setQuery(pushQuery) // Set our Installation query
//                push.setMessage("Free hotdogs at the Parse concession stand!")
//                push.sendPushInBackground()
//            }
//            else {
//                print("ERRO BUGOU GERAL")
//            }
//        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievePlace:", name: "newPlacePosted", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        //print("viewDidAppear")
        
    }
    
    func recievePlace (sender: NSNotification) {
        
        let info = sender.userInfo!
        let place = info["newPlace"] as! Places
        
        pino = place
        //print(pino)
        
        self.places.append(place)
        dispatch_async(
            dispatch_get_main_queue(), {()-> Void in
                self.mapView.addAnnotation(self.pino!)
                self.mapView.reloadInputViews()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: locationFunctions
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            
            if let location = locationManager.location?.coordinate {
                mapView.setCenterCoordinate(location, animated: true)
                mapView.camera.altitude = pow(2, 11)
            } else {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
    
        if let location = locations.last {
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
                if let error = e {
                    print("Error:  \(e!.localizedDescription)")
                } else {
                    let placemark = placemarks!.last! as CLPlacemark
                    
                    let userInfo = [
                        "city":     placemark.locality!,
                        "state":    placemark.administrativeArea!,
                        "country":  placemark.country!
                    ]
                    
                    print("Location:  \(userInfo)")
                    NSNotificationCenter.defaultCenter().postNotificationName("LOCATION_AVAILABLE", object: nil, userInfo: userInfo)
                }
            })
            self.locationManager.distanceFilter  = 3000 // Must move at least 3km
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // Accurate within a kilometer
            
            
            mapView.setCenterCoordinate(location.coordinate, animated: true)
            mapView.camera.altitude = pow(2, 11)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        //print("Got Location \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        myPosition = newLocation.coordinate
        locationManager.stopUpdatingLocation()
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: Actions
    @IBAction func addPin(sender: UILongPressGestureRecognizer) {
        
        //pegando a localizacao do mapa
        let location =  sender.locationInView(self.mapView)
        let locCoord = self.mapView.convertPoint(location, toCoordinateFromView: self.mapView)
        
        let longitude:Double = locCoord.longitude
        let latitude:Double = locCoord.latitude
        
        NSNotificationCenter.defaultCenter().postNotificationName("longitudePosted", object: self, userInfo: ["longitude": longitude])
        NSNotificationCenter.defaultCenter().postNotificationName("latitudePosted", object: self, userInfo: ["latitude": latitude])
        
        if sender.state == UIGestureRecognizerState.Began {
            
            
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
            {
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus_novo", bundle: nil)
                self.popViewController.title = "This is a popup view"
                self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
                self.popViewController.view.frame.size = CGSizeMake(768, 1024)
            } else
            {
                if UIScreen.mainScreen().bounds.size.width > 320 {
                    if UIScreen.mainScreen().scale == 3 {
                        self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus_novo", bundle: nil)
                        self.popViewController.title = "This is a popup view"
                        self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "iphone 6+", animated: true)
                        self.popViewController.view.frame.size = CGSizeMake(414, 736)
                    } else {
                        self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus_novo", bundle: nil)
                        self.popViewController.title = " esse é o 6"
                        self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "esse é o 6", animated: true)
                        self.popViewController.view.frame.size = CGSizeMake(375, 667)
                    }
                } else {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus_novo", bundle: nil)
                    self.popViewController.title = "iPhone 5"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "iPhone 5", animated: true)
                    self.popViewController.view.frame.size = CGSizeMake(320, 480)
                    
                }
            }
        }
    }
    
    //MARK: mapFunctions
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        //print("viewForAnnotation")
        let identifier = "Places"
        
        if annotation.isKindOfClass(Places.self) {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                annotationView!.annotation = annotation
            }
            //alterar imagem do pino
            annotationView!.image = UIImage(named: "Places")
            
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        //print("calloutAccessoryControlTapped")
        if control == view.rightCalloutAccessoryView{
            
            //print(view.annotation!.title) // annotation's title
            
            if let title = view.annotation?.title {
                
                for lugar in places{
                    if (lugar.title == title){
                        //print("objectID map: \(lugar.objectId)")
                        //print("objectID novo evento: \(placeId)")

                        if lugar.objectId != nil && lugar.objectId != ""{
                            NSUserDefaults.standardUserDefaults().setObject(lugar.objectId, forKey: "placeId")
                        }
                        NSUserDefaults.standardUserDefaults().setObject(lugar.title, forKey: "placeName")
                    }
                }
                NSUserDefaults.standardUserDefaults().setObject(title, forKey: "place")
            }
        }
        
        if let resultController = storyboard!.instantiateViewControllerWithIdentifier("Places") as? PlacesViewController {
            self.navigationController?.pushViewController(resultController, animated: true)
            
        }
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        //print("didAddAnnotationViews")
        for annotation in views{
            let endFrame = annotation.frame
            annotation.frame = CGRectOffset(endFrame, 0, -500)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                annotation.frame = endFrame
            })
        }
    }
    
    //MARK: SearchBar
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
}