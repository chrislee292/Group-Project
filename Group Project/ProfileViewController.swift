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
    @IBOutlet weak var findAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userEmail = Auth.auth().currentUser?.email
        let db = Firestore.firestore()
        let docRef = db.collection("userInfo").document(userEmail!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let data = document.data()
                let firstName = data!["firstName"]! as? String ?? ""
                let lastName = data!["lastName"]! as? String ?? ""
                let amountOfFinds = data!["amountOfFinds"]! as? String ?? ""
                print(amountOfFinds)
                self.nameLabel.text! = "\(firstName) \(lastName)"
                self.findAmountLabel.text! = "\(amountOfFinds)"
            } else {
                print("Document does not exist")
            }
        }
    }

}
