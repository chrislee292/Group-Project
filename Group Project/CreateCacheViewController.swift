//
//  CreateCacheViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/13/22.
//

import UIKit
import Firebase
import CoreLocation

class CreateCacheViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var hazardLabel: UITextField!
    @IBOutlet weak var hintLabel: UITextField!
    @IBOutlet weak var diffLabel: UISegmentedControl!
    var diff:Int = 1
    var lat:Double = 0.0
    var long:Double = 0.0
    var currentPos = CLLocation(latitude: 0.0, longitude: 0.0)
    
    @IBAction func diffLabelchanged(_ sender: Any) {
        switch diffLabel.selectedSegmentIndex {
        case 0:
            diff = 1
        case 1:
            diff = 2
        case 2:
            diff = 3
        case 3:
            diff = 4
        case 4:
            diff = 5
        default:
            diff = 0
        }
    }
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        startLocation = nil
        locationManager.desiredAccuracy = kCLLocationAccuracyBest       // Use the "best accuracy" setting
        locationManager.requestWhenInUseAuthorization()                 // Ask user for permission to use location
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let latestLocation:CLLocation = locations[locations.count - 1]
        
        lat = Double(latestLocation.coordinate.latitude)
        long = Double(latestLocation.coordinate.longitude)
        
        //lat = Double(String(format: "%.4f",latestLocation.coordinate.latitude))
        //long = Double(String(format: "%.4f",latestLocation.coordinate.longitude))
    }
    
    @IBAction func cacheButtonPressed(_ sender: Any) {
        
        var test:Bool = false
        
        let docRef = db.collection("caches").document("cache_\(titleLabel.text ?? "")")
        // grabs whats in the document of the specific annotation
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                test = true
            }
        }
        if titleLabel.text == nil{
            let controller = UIAlertController(title: "Title error", message: "Please input a valid title", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default))
            present(controller, animated: true)
        }
        else if hazardLabel.text == nil{
            let controller = UIAlertController(title: "Hazard Error", message: "Please input  any hazard", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default))
            present(controller, animated: true)
        }
        else if hintLabel.text == nil{
            let controller = UIAlertController(title: "Hint Error", message: "Please input a hint", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default))
            present(controller, animated: true)
        }
        else if(test){
            let controller = UIAlertController(title: "Title is already taken", message: "Please input a different title", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default))
            present(controller, animated: true)
        }
        else {
            let cacheRef = db.collection("caches")
            cacheRef.document("cache_\( titleLabel.text ?? "")").setData([
                "title": titleLabel.text ?? "",
                "latitude": lat,
                "longitude": long,
                "difficulty": "\(diff)",
                "hazards": hazardLabel.text ?? "",
                "hints": hintLabel.text ?? "",
                "email": String((Auth.auth().currentUser?.email)!)
                ])
            let controller = UIAlertController(title: "Cache Created", message: "\(titleLabel.text ?? "") has been created", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default))
            present(controller, animated: true)
            //performSegue(withIdentifier: "return", sender: (Any).self)
        }
    }
}
