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

var coordArray: [MKPointAnnotation] = []

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, NotifDistance{

    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    let db = Firestore.firestore()
    var localLong:Double = 0.0
    var localLat:Double = 0.0
    
    var localPos = CLLocation(latitude: 0.0, longitude: 0.0)
    var templocalPos = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var distTrav:Double = 0.0
    
    var notifBool = true
    
    let timerQueue = DispatchQueue(label: "timeQueue", qos: .background)
    
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

        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view.
        
        if notifBool == true{
            timerQueue.async {
                while self.notifBool == true{
                    //sleep(300)
                    sleep(5)
                    
                    DispatchQueue.main.async {
                        self.tellDistance(notif: self.notifBool)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let cacheRef = db.collection("caches")
        
        cacheRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else {
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let lati = data["latitude"]! as? Double ?? 0
                    let longi = data["longitude"]! as? Double ?? 0
                    let pinTitle = data["title"]! as? String ?? "nil"
                    
                    let pinMarker = MKPointAnnotation()
                    pinMarker.title = pinTitle
                    pinMarker.coordinate = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                    self.mapView.addAnnotation(pinMarker)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            performSegue(withIdentifier: "locationSegueIdentifier", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationSegueIdentifier",
            //... ADD SEGUE CODE
           let nextCacheVC = segue.destination as? CacheViewController{
            
            //nextCacheVC.titleName = (sender as! MKPointAnnotation).annotation!.title
            nextCacheVC.titleName = (sender as! MKPointAnnotation).title!
        }
        
        if segue.identifier == "createCacheSegueIdentifier"{
            // segue code to send the position of the person
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        
        localLat = lat
        localLong = long
        
        localPos = CLLocation(latitude: lat, longitude: long)
        templocalPos = userLocation.coordinate
        
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    // notification method
    func tellDistance(notif: Bool) {
        print("hello")
        
        if notif == true{
            let anno = mapView.annotations
            
            var cacheCounter = 0
            var skipFirst = 0
            
            let radNear:Double = 50.0
            for point in anno{
                if skipFirst != 0{
                    print("\(point.coordinate.latitude),\(point.coordinate.longitude)")
                    let distanceInMeters = localPos.distance(from: CLLocation(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude))
                    print(distanceInMeters)
                    if distanceInMeters <= radNear {
                        print(distanceInMeters <= radNear)
                        cacheCounter += 1
                    }
                }
                skipFirst += 1
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
    
    @IBAction func addPoint(_ sender: Any) {
        performSegue(withIdentifier: "createCacheSegueIdentifier", sender: view)
    }
}
