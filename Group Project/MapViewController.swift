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

var coordArray: [MKPointAnnotation] = []

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    /*
    var ref: DatabaseReference!
    ref = Database.database().reference()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        /*
        for id in coordArray{
            ref.child(id).observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? [String: Any]
                let lati = value?["latitude"] as? Double ?? 0
                let longi = value?["longitude"] as ? Double ?? 0
                let pinTitle = value?["title"] as ? String ?? ""
                
            })
            // Access Firebase database
            let pinMarker = MKPointAnnotation()
            pinMarker.title = pinTitle
            pinMarker.coordinate = CLLocationCoordinate2D(latitude: lati, longitude: longi)
            mapView.addAnnotation(pinMarker)
        }*/
        
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
        
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    /*@IBAction func addPoint(_ sender: Any) {
        let controller = UIAlertController (
            title: "Establish A Point",
            message: "Would you like to leave a Code?",
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(
            title: "Confirm",
            style: .default,
            handler: { action in
                // add in way to get the current location
                testArray.append(locations[0])
            }
        ))
        
        controller.addAction(UIAlertAction(
            title: "Confirm",
            style: .cancel
        ))
        present(controller, animated: true)
    }*/
}
