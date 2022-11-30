//
//  SettingsViewController.swift
//  Group Project
// 
//  Created by Jayashree Ganesan on 11/17/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

let textCellIdentifier = "TextCell"

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let userEmail = Auth.auth().currentUser?.email
    var notifDistance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        create_header()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        create_header()
    }
    
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(true)
        let navVC = tabBarController?.viewControllers?[0] as! UINavigationController
        let gpsVC = navVC.topViewController as! MapViewController
        gpsVC.radNear = notifDistance
    }
    
    func create_header() {
        let headerView: UIView = UIView.init(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: 40))
        headerView.center.x = self.view.center.x

        let label: UILabel = UILabel.init(frame: CGRect(x: 4, y: 5, width: 276, height: 24))
        label.center = headerView.center
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.text = "Settings"
        headerView.addSubview(label)
        
        self.tableView.tableHeaderView = headerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "GPSSegueIdentifier",
            //... ADD SEGUE CODE
            //let nextCacheVC = segue.destination as? MapViewController{
                //nextCacheVC.notifBool = notifTog
            //add delegate to send notification to GPS screen
            // or just send variable???
        //}
    }

    @IBAction func segmentControlFont(_ sender: Any) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let notificationsCell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsTableViewCell
            notificationsCell.textLabel!.text = "Notifications Distance"
            notificationsCell.slider.minimumValue = 0
            notificationsCell.slider.maximumValue = 200
            notificationsCell.slider.value = 25
            
            notificationsCell.callback = { val in
                self.notifDistance = Double(val)
            }
            //notifDistance = Double(notificationsCell.slider.value)
            
            print("settings \(notificationsCell.slider.value)")
            return notificationsCell
        case 1:
            let fontsCell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
            fontsCell.textLabel!.text = "Fonts"
            return fontsCell
        case 2:
            let resetTutorialCell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
            resetTutorialCell.textLabel!.text = "Reset Tutorial"
            return resetTutorialCell
        case 3:
            let resetPasswordCell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
            resetPasswordCell.textLabel!.text = "Reset Password"
            return resetPasswordCell
        case 4:
            let logOutCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            logOutCell.label.text = "Log Out"
            logOutCell.label.textColor = .systemBlue
            return logOutCell
        case 5:
            let DeleteAccountCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            DeleteAccountCell.label.text = "Delete Account"
            DeleteAccountCell.label.textColor = .red
            return DeleteAccountCell
        default:
            let errorCell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
            errorCell.textLabel!.text = "This shouldn't exist"
            return errorCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 3:
            Auth.auth().sendPasswordReset(withEmail: self.userEmail!) { error in
                let controller = UIAlertController(
                    // Actually an Error
                    title: "Email Sent",
                    message: "Your Email Has Been Sent!",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "OK",
                    style: .default))
                self.present(controller, animated: true)
                print(self.userEmail!)
            }
        case 4:
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true)
            } catch {
                print("Sign out error")
            }
        case 5:
            let controller = UIAlertController(
                title: "Enter Current Password",
                message: "Enter Your Current Password.",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel))
            controller.addTextField(configurationHandler: {
                (textField:UITextField!) in
                textField.placeholder = "Enter something"
                textField.isSecureTextEntry = true
            })
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: {
                    (paramAction:UIAlertAction!) in
                    if let textFieldArray = controller.textFields {
                        let textFields = textFieldArray as [UITextField]
                        let enteredText = textFields[0].text
                        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: self.userEmail!, password: enteredText!)
                        
                        self.user!.reauthenticate(with: credential) { (result, error) in
                            if (error == nil) {
                                self.db.collection("userInfo").document(self.userEmail!).delete() { error in
                                    if let error = error {
                                        let controller = UIAlertController(
                                            title: "Error",
                                            message: "There was an error: \(error)",
                                            preferredStyle: .alert)
                                        controller.addAction(UIAlertAction(
                                            title: "OK",
                                            style: .default))
                                        self.present(controller, animated: true)
                                    }
                                }
                                
                                self.user?.delete { error in
                                    if let error = error {
                                        let controller = UIAlertController(
                                            title: "Error",
                                            message: "There was an error: \(error)",
                                            preferredStyle: .alert)
                                        controller.addAction(UIAlertAction(
                                            title: "OK",
                                            style: .default))
                                        self.present(controller, animated: true)
                                    }
                                }
                                
                                do {
                                    try Auth.auth().signOut()
                                    self.dismiss(animated: true)
                                } catch {
                                    print("Sign out error")
                                }
                                
                            } else {
                                let controller = UIAlertController(
                                    title: "Wrong Password",
                                    message: "You entered the wrong password. Please try again.",
                                    preferredStyle: .alert)
                                controller.addAction(UIAlertAction(
                                    title: "OK",
                                    style: .default))
                                self.present(controller, animated: true)
                            }
                        }
                    }
                }))
            present(controller, animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 4, 5:
            return 65
        default:
            return UITableView.automaticDimension
        }
    }

}
