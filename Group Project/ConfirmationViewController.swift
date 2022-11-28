//
//  ConfirmationViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/23/22.
//

import UIKit
import AVFoundation
import Firebase
import Foundation
import CoreLocation

class ConfirmationViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate {

    var capture = AVCaptureSession()
    var vid = AVCaptureVideoPreviewLayer()
    var qrcodeinview: UIView?
    var result:String = ""
    var userEmail = Auth.auth().currentUser?.email
    var titleName:String = ""
    var currentLat:Double = 0.0
    var currentLong:Double = 0.0
    var currentPos = CLLocation(latitude: 0.0, longitude: 0.0)
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    //let timerQueue = DispatchQueue(label: "timeQueue", qos: .background)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        startLocation = nil
        locationManager.desiredAccuracy = kCLLocationAccuracyBest       // Use the "best accuracy" setting
        locationManager.requestWhenInUseAuthorization()                 // Ask user for permission to use location
        locationManager.startUpdatingLocation()
        
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
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let latestLocation:CLLocation = locations[locations.count - 1]
        
        currentLat = Double(latestLocation.coordinate.latitude)
        currentLong = Double(latestLocation.coordinate.longitude)
        
        //lat = Double(String(format: "%.4f",latestLocation.coordinate.latitude))
        //long = Double(String(format: "%.4f",latestLocation.coordinate.longitude))
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        if metadataObjects.count == 0{
            qrcodeinview?.frame = CGRect.zero
            result = "No QR code found"
            return
        }
        let obj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if obj.type == AVMetadataObject.ObjectType.qr {
            let bcobj = vid.transformedMetadataObject(for: obj)
            qrcodeinview?.frame = bcobj!.bounds
            
            if obj.stringValue != nil{
                result = obj.stringValue ?? ""
            }
        }
        
        var resultArr = result.components(separatedBy: "-")
        
        var user = resultArr[0]
        var title = resultArr[1]
        
        let db = Firestore.firestore()
        //let docRef = db.collection("caches").document()
        
        let docRefBool = db.collection("caches").document("cache_\(title)")
        var docExist = false
        
        docRefBool.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                docExist = true
                let clat = data!["latitude"]! as? Double ?? 0.0
                
                if user == self.userEmail! && self.result != "No QR code found" && docExist && (data!["latitude"]! as? Double ?? 0.0 == 0.0) && (data!["longitude"]! as? Double ?? 0.0 == 0.0)
                {
                    let db = Firestore.firestore()
                    var newCoords = self.randomCoord(lati: self.currentLat, longi: self.currentLong)
                    db.collection("caches").document("cache_\(title)").updateData(["latitude": newCoords[0], "longitude": newCoords[1]])
                    let controller = UIAlertController(
                        title: "Cache Created",
                        message: "This cache is created at your location",
                        preferredStyle: .alert)
                    
                    controller.addAction(UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler:{
                            (action) in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                            
                    self.present(controller, animated: true)
                } else if user == self.userEmail! && (data!["latitude"]! as? Double ?? 0.0 != 0.0) && (data!["longitude"]! as? Double ?? 0.0 != 0.0){
                    
                    let controller = UIAlertController(
                        title: "Cannot Create Cache",
                        message: "This cache has already been established",
                        preferredStyle: .alert)
                    
                    controller.addAction(UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler:{
                            (action) in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                            
                    self.present(controller, animated: true)
                }
                else{
                    let controller = UIAlertController(
                        title: "Invalid Cache",
                        message: "This is the wrong QR code",
                        preferredStyle: .alert)
                    
                    controller.addAction(UIAlertAction(
                        title: "OK",
                        style: .default))
                            
                    self.present(controller, animated: true)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    func randomCoord(lati:Double, longi:Double) -> [Double]{
        var addLat = Double.random(in: -20.0 ..< 20.0) * 0.000008983
        var newLat = lati + addLat
        var addLong = (Double.random(in: -20.0 ..< 20.0) * 0.000008983)/cos(lati * 0.01745)
        var newLong = longi + addLong
        
        var newCoord = [newLat, newLong]
        
        return newCoord
    }
}
