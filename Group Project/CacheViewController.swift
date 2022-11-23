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
    
    // add to button on View Controller
    // also add the identifier for creator
    func deleteCache(){
        let userEmail = Auth.auth().currentUser?.email
        print(userEmail!)
        var creator = ""
        
        let docRef = db.collection("caches").document("cache_\(titleName)")
        // grabs whats in the document of the specific annotation
        docRef.getDocument{(document, error) in
            if let document = document, document.exists{
                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                print("Document data: \(dataDescription)")
                let data = document.data()
                creator = data!["creator"]! as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
        
        if userEmail == creator{
            
            let controller = UIAlertController(
                title: "Alert Controller",
                message: "Are you sure you want to delete this cache?",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel))
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: {action in
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
            let controller = UIAlertController(
                title: "Alert Controller",
                message: "You are not the creator of this cache",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            present(controller, animated: true)
        }
    }
}
