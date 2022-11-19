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
    @IBOutlet weak var usernameLabel: UILabel!
    
    let segueIdentifier = "ProfileToEditProfile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        implement_profile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        implement_profile()
    }
    
    func implement_profile() {
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
                let amountOfFinds = data!["amountOfFinds"]! as? Int ?? 0
                let username = data!["username"]! as? String ?? ""
                self.nameLabel.text! = "\(firstName) \(lastName)"
                self.findAmountLabel.text! = "\(amountOfFinds) Finds"
                self.usernameLabel.text! = "\(username)"
            } else {
                print("Document does not exist")
            }
        }
    }

    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: self.segueIdentifier, sender: self)
    }
    
}
