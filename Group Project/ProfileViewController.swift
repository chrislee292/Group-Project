//
//  ProfileViewController.swift
//  Group Project
//
//  Created by chrislee on 11/15/22.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
//        db.collection("userInfo").getDocuments() { (QuerySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in QuerySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//
//        }
//
//        Firestore.firestore().collection("userInfo").doc("1").update({
//          [nameLabel]: 'text'
//        })
        let docRef = db.collection("userInfo").document("1")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let data = document.data()
                let username = data!["userName"]! as? String ?? ""
                self.nameLabel.text! = username
                print(username)
            } else {
                print("Document does not exist")
            }
            
        }
        
   
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
