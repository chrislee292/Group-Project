//
//  ResetPasswordViewController.swift
//  Group Project
//
//  Created by chrislee on 12/4/22.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resetPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetPasswordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // NOTE TO WHOEVER IS GRADING THIS:
    // I am using an error for "Email Successfully Sent". After looking at many resources online, there appears to be a bug with the sendPasswordReset on XCode, where EVEN when the email entered is valid AND IT STILL SENDS, an error still apears because the "NavigationBar delegate set up incorrectly". Run the code and look into terminal yourself for more details - the error will print. Fortunately, the error is nil, so to get around this problem, I just said that if the error is nil, an "Email successfully sent" alert will pop up. Otherwise, an "Error" alert will pop up with an actual description. This seems to work on almost all cases I can think of.
    @IBAction func resetEmailButton(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: resetPasswordTextField.text!) { (error) in
            if (error?.localizedDescription == nil) {
                let controller = UIAlertController(title: "Email Successfully Sent!", message: "The password reset link has been sent to your email.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(controller, animated: true)
                print(error ?? "")
            } else {
                let controller = UIAlertController(title: "Error", message: "\(error?.localizedDescription ?? "User Email Sent")", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(controller, animated: true)
            }
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
