//
//  TutorialViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/30/22.
//

import UIKit
import Firebase
import CoreData

class TutorialViewController: UIViewController {
    
    let userEmail = Auth.auth().currentUser?.email
    
    // arrays for presets that appear on the VC - images and captions that appear
    var imageArray = [UIImage(named: "firsttut"), UIImage(named: "secondtutorial"), UIImage(named: "newqr"), UIImage(named: "newpast"), UIImage(named: "firsttut-2")]
    var wordsArray = ["Look for Cache Pins!", "Click on the Cache Pin to check its details!", "Once Found, scan it using the QR code Scanner!", "Check your past accomplishments using the Past Caches", "Add your own caches and join the fun!"]
    
    // variable for how many times the screen is pressed
    var numPressed = 0
    
    // segue identifier variable
    let segueIdentifier = "TabVCSegueIdentifier"
    
    // outlets to the image view and label
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the times pressed to 0
        numPressed = 0
        
        // create a tap recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        // add it to the view
        self.view.addGestureRecognizer(tap)
        
        // set the image and text to the first component
        imageView.image = imageArray[0]
        tutLabel.text = wordsArray[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let logPath = login
        //print("\(logPath) tutorial")
        
        if logPath == false{
            //docRef.updateData(["logout": false])
            self.navigationController?.popToRootViewController(animated: false)
        }
        
        var tutPath = false
        
        let db = Firestore.firestore()
        let docRef = db.collection("userInfo").document(userEmail!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let tutorial = data!["resetTut"]! as? Bool ?? false
                //let tutorial = true
                tutPath = tutorial
            }
            
            if tutPath == false{
                self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
            }
            else if tutPath == true && logPath == true{
                docRef.updateData(["resetTut": false])
            }
        }
    }
    
    // when the screen is tapped
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        // set the image to be 1.0 alpha
        self.imageView.alpha = 1.0
        
        // create an animation when pressed with 1 duration, 0 delay, ease out, while turning the alpha to 0
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.imageView.alpha = 0.0
                self.tutLabel.alpha = 0.0
            },
            completion: { finished in
                // when complete, set the new image and text while dark
                self.imageView.image = self.imageArray[self.numPressed]
                self.tutLabel.text = self.wordsArray[self.numPressed]
                // use an animation to bring back the image by turning alpha to 1 and ease in
                UIView.animate(
                    withDuration: 1.0,
                    delay: 0.0,
                    options: .curveEaseIn,
                    animations: {
                        // bring the image and text back
                        self.imageView.alpha = 1.0
                        self.tutLabel.alpha = 1.0
                    })
            })
        // iterate to the next image/text in the array
        numPressed += 1
        
        // if the number of times pressed goes past the array value, start over
        if numPressed >= 5{
            performSegue(withIdentifier: segueIdentifier, sender: nil)
            numPressed = 0
        }
    }
}
