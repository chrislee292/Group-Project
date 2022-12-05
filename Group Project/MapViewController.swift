//
//  MapViewController.swift
//  ProjectVC
//
//  Created by Justin Vu on 11/10/22.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseCore
import FirebaseAuth
import Firebase

protocol NotifDistance{
    func tellDistance(notif:Bool)
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, NotifDistance{

    // outlet to hold the map view
    @IBOutlet var mapView: MKMapView!
    
    // create a location manager
    let locationManager = CLLocationManager()
    
    // create an instance of a database
    let db = Firestore.firestore()
    
    // establish a local position variable
    var localPos = CLLocation(latitude: 0.0, longitude: 0.0)
    var templocalPos = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    // variables to hold the notification variable
    var notifBool = true
    var radNear = 25.0
    var tempBool = true
    
    // create a background queue
    let timerQueue = DispatchQueue(label: "timeQueue", qos: .background)
    
    let cacheIdentifier = "poptocache"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ask the user to allow local notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) {
            granted, error in
            if granted{
                print("good")
            } else if let error = error{
                print(error.localizedDescription)
            }
        }
        
        // make the pin and icon grey color
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // location manager calls to get authorization and current location
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // show the user location and show the annotations on the map
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        // create an async to scan for notifications
        timerQueue.async {
            while self.tempBool == true{
                //sleep(300)
                sleep(5)
                
                // send an order to the main queue to send a notification
                DispatchQueue.main.async {
                    self.tellDistance(notif: self.notifBool)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        resetMap()
        
        /*
        // wipe the annotations from the mapview
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        // pull the cache documents from the database
        let cacheRef = db.collection("caches")
        cacheRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                // for each cache grab data
                for document in querySnapshot!.documents{
                    
                    // get the latitude, longitude, and title of the cache
                    let data = document.data()
                    let lati = data["latitude"]! as? Double ?? 0
                    let longi = data["longitude"]! as? Double ?? 0
                    let pinTitle = data["title"]! as? String ?? "nil"
                    
                    // create the annotation and add it to the map
                    let pinMarker = MKPointAnnotation()
                    pinMarker.title = pinTitle
                    pinMarker.coordinate = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                    self.mapView.addAnnotation(pinMarker)
                    
                    // add a 20 meter circle around the cache annotation
                    let circle = MKCircle(center: CLLocationCoordinate2D(latitude: lati, longitude: longi), radius: 20)
                    self.mapView.addOverlay(circle)
                }
            }
        }*/
    }
    
    // annotation function
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // get the annotation and make an ID
        if !(annotation is MKPointAnnotation){
            return nil
        }
        let reuseId = "pin"
        
        // create the annotation view
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        // make a small icon button to open annotation features
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = btn
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    // when the annotation is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // segue to the cache description VC when pressed
        if control == view.rightCalloutAccessoryView{
            performSegue(withIdentifier: cacheIdentifier, sender: view)
        }
    }
    
    // render the circle overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // create a circle render object
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        
        // make the color blue and outline the circle
        circleRenderer.strokeColor = UIColor.blue
        circleRenderer.lineWidth = 1.0
        circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
        
        // return the object
        return circleRenderer
    }
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if the segue is to segue to the Cache VC
        if segue.identifier == cacheIdentifier,
           let nextCacheVC = segue.destination as? CacheViewController{
            
            // send the title of the cache selected to the cache VC
            nextCacheVC.titleName = String((sender as! MKAnnotationView).annotation!.title!!)
            nextCacheVC.dismissHandler = {
                self.resetMap()
            }
        }
    }
    
    // location manager for current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // get the current location
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        
        // make the variables equivalent to the current position
        localPos = CLLocation(latitude: lat, longitude: long)
        templocalPos = userLocation.coordinate
    }
    
    // notification method
    func tellDistance(notif: Bool) {
        
        // check if notifications are allowed
        if notif == true{
            // get an array of all annotations
            let anno = mapView.annotations
            
            // variable to count the caches
            var cacheCounter = 0
            
            // iterate through the annotation points
            for point in anno{
                // check if the point is not the current icon point
                if point.coordinate.latitude != localPos.coordinate.latitude && point.coordinate.longitude != localPos.coordinate.longitude{
                    // find the distance
                    let distanceInMeters = localPos.distance(from: CLLocation(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude))
                    // compare the distance to the setting of chosen distance for notifications
                    if distanceInMeters <= radNear {
                        // if the cache is within radNear
                        cacheCounter += 1
                    }
                }
            }
            
            // create notification content
            let content = UNMutableNotificationContent()
            // create the title, subtitle, and body of the notification
            content.title = "Cache Notification!"
            content.subtitle = "We have checked for caches near your location"
            content.body = "There are \(cacheCounter) caches near your position."
            
            // time to wait for notification
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            
            // create a request for a notification
            let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)
            
            // add the request to the center
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    // button to segue to the create cache VC
    @IBAction func addPoint(_ sender: Any) {
        performSegue(withIdentifier: "createCacheSegueIdentifier", sender: view)
    }
    
    func resetMap(){
        // wipe the annotations from the mapview
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        // pull the cache documents from the database
        let cacheRef = db.collection("caches")
        cacheRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                // for each cache grab data
                for document in querySnapshot!.documents{
                    
                    // get the latitude, longitude, and title of the cache
                    let data = document.data()
                    let lati = data["latitude"]! as? Double ?? 0
                    let longi = data["longitude"]! as? Double ?? 0
                    let pinTitle = data["title"]! as? String ?? "nil"
                    
                    // create the annotation and add it to the map
                    let pinMarker = MKPointAnnotation()
                    pinMarker.title = pinTitle
                    pinMarker.coordinate = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                    self.mapView.addAnnotation(pinMarker)
                    
                    // add a 25 meter circle around the cache annotation
                    let circle = MKCircle(center: CLLocationCoordinate2D(latitude: lati, longitude: longi), radius: 25)
                    self.mapView.addOverlay(circle)
                }
            }
        }
    }
}
