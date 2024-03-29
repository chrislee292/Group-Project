//
//  SignUpViewController.swift
//  ProjectVC
//
//  Created by Lee, Christopher D on 11/7/22.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    let segueIdentifier = "SignUpToNavControl"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        usernameField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        passwordField.delegate = self
        
        passwordField.isSecureTextEntry = true
        
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                //self.storeUser(login: false)
                //self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
                self.emailField.text = nil
                self.usernameField.text = nil
                self.firstNameField.text = nil
                self.lastNameField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        // If all fields are NOT empty
        if (!emailField.text!.isEmpty) && (!usernameField.text!.isEmpty) && (!firstNameField.text!.isEmpty) && (!lastNameField.text!.isEmpty) && (!passwordField.text!.isEmpty) {
            
            // Create a user in FirebaseAuth
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
                    //self.present(alert, animated: true)
                }
            }
            
            login = true
            
            // Also create said user's corresponding document
            let db = Firestore.firestore()
            db.collection("userInfo").document(emailField.text!.lowercased()).setData([
                "username": usernameField.text!,
                "firstName": firstNameField.text!,
                "lastName": lastNameField.text!,
                "password": passwordField.text!,
                "amountOfFinds": 0,
                "profilePhotoLink": "",
                "foundCaches":[],
                "resetTut": true,
                "notifDistance": 25.0,
                "notifSwitch": true
                //"login":true
            ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                }
            }
        } else {
            // Generate an alert if fields are not filled out
            let alert = UIAlertController(title: "Missing Fields", message: "Please ensure ALL fields are filled out.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style:.default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    // Called when 'return' key pressed

    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
