//
//  TutorialViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/30/22.
//

import UIKit

class TutorialViewController: UIViewController {

    var imageArray = [UIImage(named: "firsttut"), UIImage(named: "secondtutorial"), UIImage(named: "newqr"), UIImage(named: "newpast"), UIImage(named: "firsttut-2")]
    
    var wordsArray = ["Look for Cache Pins!", "Click on the Cache Pin to check its details!", "Once Found, scan it using the QR code Scanner!", "Check your past accomplishments using the Past Caches", "Add your own caches and join the fun!"]
    
    var numPressed = 0
    
    let segueIdentifier = "TabVCSegueIdentifier"
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numPressed = 0
        
        print("hello")
        
        // create a tap recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.view.addGestureRecognizer(tap)
        
        imageView.image = imageArray[0]
        tutLabel.text = wordsArray[0]
        
        // Do any additional setup after loading the view.
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        print("hello")
        
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
                // when complete, set the new image while dark
                self.imageView.image = self.imageArray[self.numPressed]
                self.tutLabel.text = self.wordsArray[self.numPressed]
                // use an animation to bring back the image by turning alpha to 1 and ease in
                UIView.animate(
                    withDuration: 1.0,
                    delay: 0.0,
                    options: .curveEaseIn,
                    animations: {
                        self.imageView.alpha = 1.0
                        self.tutLabel.alpha = 1.0
                    })
            })
        numPressed += 1
        
        if numPressed >= 5{
            numPressed = 0
        }
    }
}
