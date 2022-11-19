//
//  SignUpViewController.swift
//  ProjectVC
//
//  Created by Lee, Christopher D on 11/7/22.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    let segueIdentifier = "SignUpToNavControl"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.isSecureTextEntry = true
        
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!.lowercased(), password: passwordField.text!) {
            authResult, error in
            if let error = error as NSError? {
                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style:.default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Test", message: "There was an Unknown Error. Contact Support for Help.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style:.default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
        
        let db = Firestore.firestore()
        db.collection("userInfo").document(emailField.text!.lowercased()).setData([
            "username": usernameField.text!,
            "firstName": firstNameField.text!,
            "lastName": lastNameField.text!,
            "password": passwordField.text!,
            "amountOfFinds": 0
        ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
        }
    }
    
}
