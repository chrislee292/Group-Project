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
    
    /*
    var ref: DatabaseReference!
    ref = Database.database().reference()*/
    
    let db = Firestore.firestore()
    var localLong:Double = 0.0
    var localLat:Double = 0.0
    
    var localPos = CLLocation(latitude: 0.0, longitude: 0.0)
    var templocalPos = CLLocation(latitude: 0.0, longitude: 0.0)
    
    var distTrav:Double = 0.0
    
    var notifBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let db = Firestore.firestore()

        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        // Do any additional setup after loading the view.
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
        
        /*// Access Firebase database
        let test1 = MKPointAnnotation()
        test1.coordinate = CLLocationCoordinate2D(latitude: 38.897, longitude: -77.0369)
        let test2 = MKPointAnnotation()
        test2.coordinate = CLLocationCoordinate2D(latitude: 2, longitude: 2)
        
        let annoList: [MKPointAnnotation] = [test1, test2]
        
        for annotation in annoList{
            print(annotation)
            mapView.addAnnotation(annotation)
        }*/
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
        //localPos.coordinate.longitude = long
        
        if distTrav < 10{
            let userLocationMapPoint = userLocation
            let lastUserLocationMapPoint = locations[locations.endIndex-1]
                
            distTrav += userLocationMapPoint.distance(from: lastUserLocationMapPoint)
        }else{
            tellDistance(notif: notifBool)
            distTrav = 0
        }
        
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    
    
    // notification method
    func tellDistance(notif: Bool) {
        
        // get this to cycle at certain time frame-10 min? or at certain distance?
        
        if notif == true{
            var anno = mapView.annotations
            
            var radNear:Double = 50.0
            for point in anno{
                let distanceInMeters = localPos.distance(from: point as! CLLocation)
                
                if distanceInMeters <= radNear{
                    // create notification content
                    let content = UNMutableNotificationContent()
                    // create the title, subtitle, and body of the notification
                    content.title = "A cache is near!"
                    content.subtitle = "A cache has been detected near your position."
                    content.body = "It is \(distanceInMeters) meters away."
                    
                    // time to wait for notification
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                    
                    // create a request for a notification
                    let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)
                    
                    // add the request to the center
                    UNUserNotificationCenter.current().add(request)
                }
            }
        }
    }
    
    @IBAction func addPoint(_ sender: Any) {
        performSegue(withIdentifier: "createCacheSegueIdentifier", sender: view)
    }
}
