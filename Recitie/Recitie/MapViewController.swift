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

class MapViewController : UIViewController, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
    var popViewController : PopUpViewControllerSwift = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
    var locationManager = CLLocationManager()
    var myPosition  = CLLocationCoordinate2D()
    
    @IBOutlet var mapView: MKMapView!
    
    
    @IBOutlet var teste: UILongPressGestureRecognizer!
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    var places:[Places] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = CKContainer.defaultContainer()
        let publicData = container.publicCloudDatabase
        
        
        let query = CKQuery(recordType: "Place", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        
        publicData.performQuery(query, inZoneWithID: nil, completionHandler: { results, error in
            
            if error == nil {
                
                for place in results! {
                    
                    
                    let longitude:Double = place["longitude"] as! Double
                    let latitude:Double = place["latitude"] as! Double
                    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    
                    let newPlace = Places(title: place["name"] as! String, coordinate: coordinate, info: place["description"] as! String)
                    
                    
                    self.places.append(newPlace)
                    dispatch_async(
                        dispatch_get_main_queue(), {()-> Void in
                            self.mapView.addAnnotation(newPlace)
                            self.mapView.reloadInputViews()
                            
                    })
                    
                }
            }else {
                
            }
        })
        
        
        //Mapa
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievePlace:", name: "newPlacePosted", object: nil)
    }
    
    //fim do viewDidLoad
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievePlace:", name: "newPlacePosted", object: nil)
        
        
        
        
    }
    
    var pino:Places?
    
    func recievePlace (sender: NSNotification){
        
        
        //let container = CKContainer.defaultContainer()
        //let publicData = container.publicCloudDatabase
        
        let info = sender.userInfo!
        let place = info["newPlace"] as! Places
        
        pino = place
        
        self.places.append(place)
        dispatch_async(
            dispatch_get_main_queue(), {()-> Void in
                self.mapView.addAnnotation(self.pino!)
                self.mapView.reloadInputViews()
                
        })
        
        
        //self.mapView.reloadInputViews()
        
        //        let newTitle = "PINOOOOOOO"
        //        let newSubtitle = "Funcionaaaaa!!"
        //if pino == nil{
        //}
        //else {
        //  let newPin = pino as! MKAnnotation
        //Places(title: newTitle, coordinate: locCoord, info: newSubtitle)
        //self.mapView.dele
        //self.mapView.addAnnotations([newPin])
        
        //            let record = CKRecord(recordType: "Place")
        //            record.setValue(place.title, forKey: "name")
        //            record.setValue(place.description, forKey: "description")
        //            record.setValue(place.coordinate.latitude, forKey: "latitude")
        //            record.setValue(place.coordinate.longitude, forKey: "longitude")
        //            publicData.saveRecord(record, completionHandler: { record, error in
        //                if error != nil {
        //                    print(error)
        //                }
        //            })
        
        //}
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        // 1
        let identifier = "Places"
        
        // 2
        if annotation.isKindOfClass(Places.self) {
            // 3
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                //4
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                // 5
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 6
                annotationView!.annotation = annotation
            }
            //alterar imagem do pino
            annotationView!.image = UIImage(named: "Places")
            
            return annotationView
        }
        
        // 7
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        //let capital = view.annotation as! Places
        //let placeName = capital.title
        //let placeInfo = capital.info
        
        //let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        //ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        //presentViewController(ac, animated: true, completion: nil)
        if let resultController = storyboard!.instantiateViewControllerWithIdentifier("Places") as? PlacesViewController {
            //presentViewController(resultController, animated: true, completion: nil)
            self.navigationController?.pushViewController(resultController, animated: true)
            
        }
    }
    
    @IBOutlet var labelGPS: UILabel!
    
    @IBAction func getLocation(sender: AnyObject) {
        print("Update Location")
        locationManager.startUpdatingLocation()
    }
    
    
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
            
            mapView.setCenterCoordinate(location.coordinate, animated: true)
            mapView.camera.altitude = pow(2, 11)
            
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        print("Got Location \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        myPosition = newLocation.coordinate
        locationManager.stopUpdatingLocation()
        
        labelGPS.text = "\(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)"
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    
    
    
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
                self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPad", bundle: nil)
                self.popViewController.title = "This is a popup view"
                self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
            } else
            {
                if UIScreen.mainScreen().bounds.size.width > 320 {
                    if UIScreen.mainScreen().scale == 3 {
                        self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                        self.popViewController.title = "This is a popup view"
                        self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "iphone 6+", animated: true)
                    } else {
                        self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController_iPhone6Plus", bundle: nil)
                        self.popViewController.title = " esse é o 6"
                        self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "esse é o 6", animated: true)
                    }
                } else {
                    self.popViewController = PopUpViewControllerSwift(nibName: "PopUpViewController", bundle: nil)
                    self.popViewController.title = "This is a popup view"
                    self.popViewController.showInView(self.view, withImage: UIImage(named: "typpzDemo"), withMessage: "You just triggered a great popup window", animated: true)
                }
            }
            //        self.viewDidLoad()
            //
            ////        let newTitle = "PINOOOOOOO"
            ////        let newSubtitle = "Funcionaaaaa!!"
            //            if pino == nil{
            //            }
            //            else {
            //        let newPin = pino as! MKAnnotation
            //            //Places(title: newTitle, coordinate: locCoord, info: newSubtitle)
            //        self.mapView.addAnnotations([newPin])
            //            }
            //        }
            
        }
        
    }
}