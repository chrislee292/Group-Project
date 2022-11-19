//
//  LoginViewController.swift
//  ProjectVC
//
//  Created by Lee, Christopher D on 11/7/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let segueIdentifier = "LoginToNavControl"
    
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
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {
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
    }
    
}
    
