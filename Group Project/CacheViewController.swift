//
//  CacheViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/13/22.
//

//import FirebaseDatabase
import UIKit
import Firebase

class CacheViewController: UIViewController {

    /*var ref: DatabaseReference!

    ref = Database.database().reference()
    */
    
    let db = Firestore.firestore()
    
    var titleName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let docRef = db.collection("caches").document("cache_\(titleName)")
        // grabs whats in the document of the specific annotation
        docRef.getDocument{(document, error) in
            if let document = document, document.exists{
                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}
