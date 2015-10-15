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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //PopUp

//        self.view.backgroundColor = UIColor().colorWithAlphaComponent(0.6)
//        self.popViewController.layer
//
        //Mapa
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Criando os pinos do mapa
        let london = Places(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Places(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Places(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Places(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Places(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        //Adicionando os pinos no mapa
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "recievePlace:", name: "newPlacePosted", object: nil)
        
    }
    
    var pino:Places?
    
    func recievePlace (sender: NSNotification){
        
        let info = sender.userInfo!
        let place = info["newPlace"] as! Places
        
        pino = place
        
        self.viewDidLoad()
        
        //        let newTitle = "PINOOOOOOO"
        //        let newSubtitle = "Funcionaaaaa!!"
        if pino == nil{
        }
        else {
            let newPin = pino as! MKAnnotation
            //Places(title: newTitle, coordinate: locCoord, info: newSubtitle)
            self.mapView.addAnnotations([newPin])
        }



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
        let capital = view.annotation as! Places
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
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