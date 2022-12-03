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
    
    // connect the outlets to the labels on screen
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Diff: UILabel!
    @IBOutlet weak var Hazards: UILabel!
    @IBOutlet weak var Hint: UILabel!
    
    // create an instance of firestore
    let db = Firestore.firestore()
    
    // variables to hold the creator and titlename
    var creator:String = ""
    var titleName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make the title of the cache appear
        name.text = titleName
        
        // grabs whats in the document of the specific annotation
        let docRef = db.collection("caches").document("cache_\(titleName)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                // grab the qualities of the cache from the database
                self.Diff.text = "Difficulty: \(data!["difficulty"]! as? String ?? "")"
                self.Hazards.text = "Hazards: \(data!["hazards"]! as? String ?? "")"
                self.Hint.text = "Hint: \(data!["hints"]! as? String ?? "")"
                self.name.text = data!["title"]! as? String ?? ""
                self.creator = data!["email"]! as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        // get the current user
        let userEmail = Auth.auth().currentUser?.email
        
        // check if the email of the user matches the cache creator
        if userEmail! == creator{
            
            // create an alert - confirmation if user wants to delete the cache
            let controller = UIAlertController(
                title: "Delete this Cache?",
                message: "Are you sure you want to delete this cache?",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel))
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: {action in
                    // remove the cache from the database
                    self.db.collection("caches").document("cache_\(self.titleName)").delete(){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }))
            present(controller, animated: true)
        }else{
            // alert for if the user does not own the cache
            let controller = UIAlertController(
                title: "Cannot Delete Cache",
                message: "You are not the creator of this cache",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(controller, animated: true)
        }
    }
}
