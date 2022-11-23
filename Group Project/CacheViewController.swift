//
//  CacheViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/13/22.
//

//import FirebaseDatabase
import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage

class CacheViewController: UIViewController {

    //var ref: DatabaseReference!

    //ref = Database.database().reference()
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Diff: UILabel!
    @IBOutlet weak var Hazards: UILabel!
    @IBOutlet weak var Hint: UILabel!
    
    let db = Firestore.firestore()
    
    var titleName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = titleName
        let docRef = db.collection("caches").document("cache_\(titleName)")
        // grabs whats in the document of the specific annotation
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let data = document.data()
                self.Diff.text = data!["difficulty"]! as? String ?? ""
                self.Hazards.text = data!["hazards"]! as? String ?? ""
                self.Hint.text = data!["hints"]! as? String ?? ""
                self.name.text = data!["title"]! as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }
}
