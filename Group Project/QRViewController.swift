//
//  QRViewController.swift
//  ProjectVC
//
//  Created by Brian Herron on 10/17/22.
//

import UIKit
import AVFoundation
import Firebase

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
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
        
        if result != userEmail && result != "No QR code found"
        {
            var finds = 0
            let db = Firestore.firestore()
            let docRef = db.collection("userInfo").document(userEmail!)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    let data = document.data()
                    let amountOfFinds = data!["amountOfFinds"]! as? Int ?? 0
                    finds = amountOfFinds
                }
            }
            db.collection("userInfo").document(userEmail!).setData([ "amountOfFinds": finds+1 ], merge: true)
        }
        else{
            let controller = UIAlertController(
                title: "Invalid Cache",
                message: "You are the owner of this cache",
                preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
                    
            present(controller, animated: true)
        }
    }
}
