//
//  EditProfileViewController.swift
//  Group Project
//
//  Created by chrislee on 11/18/22.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var newUsernameField: UITextField!
    @IBOutlet weak var newFirstName: UITextField!
    @IBOutlet weak var newLastName: UITextField!
    
    let userEmail = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("userInfo").document(self.userEmail!)
        
        if (!self.newUsernameField.text!.isEmpty) {
            docRef.updateData([
                "username": self.newUsernameField.text!
            ])
        }
        
        if (!self.newFirstName.text!.isEmpty) {
            docRef.updateData([
                "firstName": self.newFirstName.text!
            ])
        }
        
        if (!self.newLastName.text!.isEmpty) {
            docRef.updateData([
                "lastName": self.newLastName.text!
            ])
        }
        
    }
    
}
