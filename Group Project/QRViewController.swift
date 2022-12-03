//
//  QRViewController.swift
//  ProjectVC
//
//  Created by Brian Herron on 10/17/22.
//

import UIKit
import AVFoundation
import Firebase
import CoreData

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // variables to start and present the QR camera
    var capture = AVCaptureSession()
    var vid = AVCaptureVideoPreviewLayer()
    var qrcodeinview: UIView?
    var result:String = ""
    var userEmail = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //making session
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil{
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                // we don't know
                AVCaptureDevice.requestAccess(for: .video) {
                    accessGranted in
                    guard accessGranted == true else { return }
                }
            case .authorized:
                // we have permission already
                break
            default:
                // we know we don't have access
                print("Access denied")
                return
            }
            
            guard let capDev = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else{
                print("Failed to open Camera")
                return
            }
            
            do{
                let input = try AVCaptureDeviceInput(device: capDev)
                capture.addInput(input)
                
                // get the output of the QR code
                let captureMetaDataOutput = AVCaptureMetadataOutput()
                capture.addOutput(captureMetaDataOutput)
                
                captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                
                vid = AVCaptureVideoPreviewLayer(session: capture)
                vid.videoGravity = AVLayerVideoGravity.resizeAspectFill
                vid.frame = view.layer.bounds
                view.layer.addSublayer(vid)
                
                capture.startRunning()
                
                //QR Code Frame for QR code
                
                qrcodeinview = UIView()
                
                if let qrcodeinview = qrcodeinview{
                    qrcodeinview.layer.borderColor = UIColor.gray.cgColor
                    qrcodeinview.layer.borderWidth = 3
                    view.addSubview(qrcodeinview)
                    view.bringSubviewToFront(qrcodeinview)
                }
            } catch {
                print(error)
                return
            }
        }
        else{
            let alertVC = UIAlertController(
                title: "No camera",
                message: "Sorry, this device has no rear camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style: .default)
            alertVC.addAction(okAction)
            present(alertVC,animated:true)
        }
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // get the result of the QR code
        if metadataObjects.count == 0{
            qrcodeinview?.frame = CGRect.zero
            result = "No QR code found"
            return
        }
        // make it into a string
        let obj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if obj.type == AVMetadataObject.ObjectType.qr {
            let bcobj = vid.transformedMetadataObject(for: obj)
            qrcodeinview?.frame = bcobj!.bounds
            
            if obj.stringValue != nil{
                result = obj.stringValue ?? ""
            }
        }
        
        // split the result into the user email and title of the cache
        var resultArr = result.components(separatedBy: "-")
        var user = resultArr[0]
        var title = resultArr[1]
        
        // set variables to grab from the database
        var finds = 0
        var arrayFound:[String] = []
        
        // grab the user information from the database
        let db = Firestore.firestore()
        let docRef = db.collection("userInfo").document(userEmail!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let amountOfFinds = data!["amountOfFinds"]! as? Int ?? 0
                // get the amountOfFinds they currently have and the caches they have found
                arrayFound = (data!["foundCaches"]! as? [String])!
                finds = amountOfFinds
            }
            
            // if the cache they scanned is not themselves and they have not found the cache before
            if user != self.userEmail! && self.result != "No QR code found" && arrayFound.contains("cache_\(title)") == false
            {
                // append the cache to the found caches
                arrayFound.append("cache_\(title)")
                
                // update the user's info adding to found caches and number of finds
                db.collection("userInfo").document(self.userEmail!).updateData([ "amountOfFinds": finds+1 ])
                db.collection("userInfo").document(self.userEmail!).updateData([ "foundCaches": arrayFound ])
                
                // send alert that they have found a cache
                let controller = UIAlertController(
                    title: "Cache Scanned!",
                    message: "You Have Found a Cache!",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: {
                        (action) in
                        // pop back to map view controller
                        self.navigationController?.popViewController(animated: true)
                        let docRefCache = db.collection("caches").document("cache_\(title)")
                        // grabs whats in the document of the specific annotation
                        docRefCache.getDocument { (document, error) in
                            if let document = document, document.exists {
                                // grab the data of the current cache
                                let data = document.data()
                                let cDifficulty = data!["difficulty"]! as? String ?? ""
                                let cHazards = data!["hazards"]! as? String ?? ""
                                let cHints = data!["hints"]! as? String ?? ""
                                let cTitle = data!["title"]! as? String ?? ""
                                let cEmail = data!["email"]! as? String ?? ""
                                let cLat = data!["latitude"]! as? Double ?? 0.0
                                let cLong = data!["longitude"]! as? Double ?? 0.0
                                // store the information of the found cache into the coredata
                                self.storeCache(cDiff: Int(cDifficulty)!, cEmail: cEmail, cHazard: cHazards, cHints: cHints, cLatitude: cLat, cLongitude: cLong, cTitle: cTitle)
                            }
                        }
                    }))
                
                self.present(controller, animated: true)
            }
            // if they already found this cache, send an alert
            else if user != self.userEmail! && arrayFound.contains("cache_\(title)") == true{
                let controller = UIAlertController(
                    title: "Invalid Cache",
                    message: "You have already scanned this cache!",
                    preferredStyle: .alert)
                
                controller.addAction(UIAlertAction(
                    title: "OK",
                    style: .default))
                
                self.present(controller, animated: true)
            }
            // if they own this cache
            else{
                let controller = UIAlertController(
                    title: "Invalid Cache",
                    message: "You are the owner of this cache",
                    preferredStyle: .alert)
                
                controller.addAction(UIAlertAction(
                    title: "OK",
                    style: .default))
                
                self.present(controller, animated: true)
            }
        }
    }
    // protocol method to create a cache
    func storeCache(cDiff: Int, cEmail:String, cHazard:String, cHints: String, cLatitude: Double, cLongitude: Double, cTitle: String){
        
        // add a cache to the core data
        let cache = NSEntityDescription.insertNewObject(forEntityName: "CacheData", into: context)
        
        // set the values of the cache in the core data
        cache.setValue(cDiff, forKey: "difficulty")
        cache.setValue(cEmail, forKey: "email")
        cache.setValue(cHazard, forKey: "hazards")
        cache.setValue(cHints, forKey: "hints")
        cache.setValue(cLatitude, forKey: "latitude")
        cache.setValue(cLongitude, forKey: "longitude")
        cache.setValue(cTitle, forKey: "title")
        
        // commit the changes
        saveContext()
    }
    
    // save the core data changes
    func saveContext () {
        // check for changes
        if context.hasChanges {
            do {
                // save
                try context.save()
            } catch {
                // error
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
