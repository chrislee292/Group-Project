//
//  QRGenViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/23/22.
//

import UIKit
import CoreImage.CIFilterBuiltins
import Firebase
import WebKit
import PDFKit

class QRGenViewController: UIViewController {
    
    // create an image view for the QR code
    @IBOutlet weak var qrImageView: UIImageView!
    
    // create variables for the titlename and qrIamge
    var qrImage: UIImage? = nil
    var titleName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the email and title of the cache into the QR-code
        let codeString = "\((Auth.auth().currentUser?.email)!)-\(titleName)"
        
        // generate the QR code
        qrImage = generateQRCode(from: codeString)
                
        //print(qrImage!)
        
        // set the image to be the qrcode
        qrImageView.image = qrImage
    }
    
    // generate the QR code from a string
    func generateQRCode(from string: String) -> UIImage? {
        // set the data to the string in ascii
        let data = string.data(using: String.Encoding.ascii)
        
        // set up a filter for the QR code and input the image, then scale it up
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
     
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
}
    // when the print button is pressed
    @IBAction func printButtonPressed(_ sender: Any) {
        
        // set the pdf
        let pdfDocument = PDFDocument()
        
        // put the QR code onto the pdf page
        let pdfPage = PDFPage(image: qrImage!)
        pdfDocument.insert(pdfPage!, at: 0)
        
        // set the data to a URL
        let data = pdfDocument.dataRepresentation()
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf")
        
        // write it to a URL
        do{
            try data?.write(to: docURL)
        }catch(let error){
            print("error is \(error.localizedDescription)")
        }
        
        // set a UIPrintInteraction Controller to print the document at the docURL
        if UIPrintInteractionController.canPrint(docURL) {
            // set the information and create the controller
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = docURL.lastPathComponent
            printInfo.outputType = .photo
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
            printController.printingItem = docURL
            
            // present controller
            printController.present(animated: true, completionHandler: nil)
        }
    }
}
