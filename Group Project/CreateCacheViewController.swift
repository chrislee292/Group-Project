//
//  CreateCacheViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/13/22.
//

import UIKit
import Firebase
import CoreLocation

class CreateCacheViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    // outlets for the labels of the screen
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var hazardLabel: UITextField!
    @IBOutlet weak var hintLabel: UITextField!
    @IBOutlet weak var diffLabel: UISegmentedControl!
    
    // variables for the qualities of the cache
    var diff:Int = 1
    var lat:Double = 0.0
    var long:Double = 0.0
    var currentPos = CLLocation(latitude: 0.0, longitude: 0.0)
    
    // segue identifiers
    let QRSegueIdentifier = "codeSegueIdentifier"
    let confirmSegueIdentifier = "confirmSegueIdentifier"
    
    // segmented controller to change the difficulty of the cache
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
    
    // start a location manager
    /*var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!*/
    
    // get an instance of database
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the delegates
        titleLabel.delegate = self
        hazardLabel.delegate = self
        hintLabel.delegate = self
        
        /*
        locationManager.delegate = self
        
        // get the current location
        startLocation = nil
        locationManager.desiredAccuracy = kCLLocationAccuracyBest       // Use the "best accuracy" setting
        locationManager.requestWhenInUseAuthorization()                 // Ask user for permission to use location
        locationManager.startUpdatingLocation()*/
        
    }
    
    @IBAction func cacheButtonPressed(_ sender: Any) {
        
        var test:Bool = false
        
        let docRef = db.collection("caches").document("cache_\(titleLabel.text ?? "")")
        // grabs whats in the document of the specific annotation
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("true")
                test = true
            }
            
            // make sure there are values in the text fields
            if self.titleLabel.text!.isEmpty{
                let controller = UIAlertController(title: "Title error", message: "Please input a valid title", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(controller, animated: true)
            }
            else if self.hazardLabel.text!.isEmpty{
                let controller = UIAlertController(title: "Hazard Error", message: "Please input  any hazard", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(controller, animated: true)
            }
            else if self.hintLabel.text!.isEmpty{
                let controller = UIAlertController(title: "Hint Error", message: "Please input a hint", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(controller, animated: true)
            }
            else if test == true{
                print("test")
                let controller = UIAlertController(title: "Title is already taken", message: "Please input a different title", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(controller, animated: true)
            }
            else {
                // create a document if all cache fields are filled
                let cacheRef = self.db.collection("caches")
                cacheRef.document("cache_\( self.titleLabel.text ?? "")").setData([
                    "title": self.titleLabel.text ?? "",
                    "latitude": 0.0, // change to other value?
                    "longitude": 0.0, // change to other value?
                    "difficulty": "\(self.diff)",
                    "hazards": self.hazardLabel.text ?? "",
                    "hints": self.hintLabel.text ?? "",
                    "email": String((Auth.auth().currentUser?.email)!)
                    ])
                let controller = UIAlertController(title: "Cache Created", message: "\(self.titleLabel.text ?? "") has been created", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(controller, animated: true)
                //performSegue(withIdentifier: "return", sender: (Any).self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue to QR generator and send the title name
        if segue.identifier == QRSegueIdentifier,
           let nextVC = segue.destination as? QRGenViewController{
            nextVC.titleName = titleLabel.text!
        }
        // segue to confirmation QR code and send title name
        if segue.identifier == confirmSegueIdentifier,
           let nextVC = segue.destination as? ConfirmationViewController{
            nextVC.titleName = titleLabel.text!
        }
    }
    
    // Called when 'return' key pressed
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
