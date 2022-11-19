//
//  CreateCacheViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/13/22.
//

import UIKit
import Firebase

class CreateCacheViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let cacheRef = db.collection("caches")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cacheButtonPressed(_ sender: Any) {
        
//        cacheRef.document("cache_\(titleLabel)").setData([
//            "title": titleLabel,
//            "latitude": latLabel,
//            "longitude": longLabel,
//            "difficulty": diffLabel,
//            "hazards": hazardLabel,
//            "hints": hintLabel
//       ])
        
        /*let object: [String:Any] = [
            "title": titleLabel,
            "latitude": latLabel,
            "longitude": longLabel,
            "difficulty": diffLabel,
            "hazards": hazardLabel,
            "hints": hintLabel
        ]
        database.child("cache_\(titleLabel)").setValue(object)
        //database.child("cache_\(Int(latLabel))\(Int(longLabel))").setValue(object)*/
    }
}
