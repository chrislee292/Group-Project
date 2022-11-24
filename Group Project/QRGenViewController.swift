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
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    var qrImage: UIImage? = nil
    var titleName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let codeString = "\((Auth.auth().currentUser?.email)!)-\(titleName)"
        
        qrImage = generateQRCode(from: codeString)
                
        print(qrImage!)
                
        qrImageView.image = qrImage

        
        // Do any additional setup after loading the view.
    }
    
    func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)

    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)
     
        if let output = filter.outputImage?.transformed(by: transform) {
            return UIImage(ciImage: output)
        }
    }     
    return nil
}

    
    @IBAction func printButtonPressed(_ sender: Any) {
        let pdfDocument = PDFDocument()
               
        let pdfPage = PDFPage(image: qrImage!)
        pdfDocument.insert(pdfPage!, at: 0)
               
        let data = pdfDocument.dataRepresentation()
                            
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            
        var docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf")
                            
        do{
            try data?.write(to: docURL)
        }catch(let error){
            print("error is \(error.localizedDescription)")
        }
               
        if UIPrintInteractionController.canPrint(docURL) {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = docURL.lastPathComponent
            printInfo.outputType = .photo
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
        
            printController.printingItem = docURL
        
            printController.present(animated: true, completionHandler: nil)
        }
    }
}
