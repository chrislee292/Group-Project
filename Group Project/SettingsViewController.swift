//
//  SettingsViewController.swift
//  Group Project
// 
//  Created by Jayashree Ganesan on 11/17/22.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseStorage

let textCellIdentifier = "TextCell"

var login = true

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userArray:[User] = []
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let userEmail = Auth.auth().currentUser?.email
    var notifDistance = 25.0
    var nBool = true
    
    var tempDistance = 0.0
    var tempBool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        create_header()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        create_header()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(true)
    }
    
    func create_header() {
        // Create a custom header that says, "Settings" because of a lack of navigation bar
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let notificationsCell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsTableViewCell
            notificationsCell.textLabel!.text = "Notifications Distance"
            notificationsCell.slider.minimumValue = 0
            notificationsCell.slider.maximumValue = 200
            notificationsCell.slider.value = Float(notifDistance)
            notificationsCell.sliderLabel.text! = "\(Int(notifDistance)) m"
            
            // get the GPS VC as a controller
            let navVC = tabBarController?.viewControllers?[0] as! UINavigationController
            let gpsVC = navVC.topViewController as! MapViewController
            
            var change = false
            
            // check for changes
            notificationsCell.callback = { val in
                gpsVC.radNear = Double(val)
                self.tempDistance = Double(val)
                change = true
                
                // if no changes set the distance to be the same past distance
                if change == false{
                    self.tempDistance = self.notifDistance
                }
                
                // store in firebase
                let db = Firestore.firestore()
                let docRef = db.collection("userInfo").document(self.userEmail!)
                docRef.updateData(["notifDistance": self.tempDistance])
            }
            
            return notificationsCell
        case 1:
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchTableViewCell
            switchCell.textLabel!.text = "Enable Notifications"
            switchCell.cellSwitch.setOn(nBool, animated: false)
            
            // get the GPS VC as a controller
            let navVC = tabBarController?.viewControllers?[0] as! UINavigationController
            let gpsVC = navVC.topViewController as! MapViewController
            
            var change = false
            
            // get the value from the table VC
            switchCell.callback = { val in
                gpsVC.notifBool = Bool(val)
                self.tempBool = Bool(val)
                change = true
                
                // check if there are any changes
                if change == false{
                    self.tempBool = self.nBool
                }
                
                // store in firebase
                let db = Firestore.firestore()
                let docRef = db.collection("userInfo").document(self.userEmail!)
                docRef.updateData(["notifSwitch": self.tempBool])
            }
            
            return switchCell
        case 2:
            let resetTutorialCell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
            resetTutorialCell.textLabel!.text = "Reset Tutorial"
            return resetTutorialCell
        case 3:
            let logOutCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            logOutCell.label.text = "Log Out"
            logOutCell.label.textColor = .systemBlue
            return logOutCell
        case 4:
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
    
    //tutorial and reset functionality
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //tutorial reset
        switch indexPath.row {
        case 2:
            let db = Firestore.firestore()
            let docRef = db.collection("userInfo").document(userEmail!)
            docRef.updateData(["resetTut": true])
            let controller = UIAlertController(
                title: "Tutorial Reset",
                message: "The next time you log in, you should see the tutorial again!",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            self.present(controller, animated: true)
        //logging out error try catch
        case 3:
            do {
                login = false
                print("\(login) settings")
                try Auth.auth().signOut()
                self.dismiss(animated: true)
            } catch {
                let controller = UIAlertController(
                    title: "Error",
                    message: "There was an error logging out. Please contact support.",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "OK",
                    style: .default))
                self.present(controller, animated: true)
            }
        //reset password and error creation
        case 4:
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
                        
                        // If user could be authenticated, then delete account document
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
                                
                                // deleete account for FirebaseAuth
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
                                
                                // Sign Out
                                do {
                                    login = false
                                    try Auth.auth().signOut()
                                    self.dismiss(animated: true)
                                } catch {
                                    print("Sign out error")
                                }
                                
                            } else {
                                // Alert user of an error
                                
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
        // Return different heights for rows depending on the cell
        case 0, 3, 4:
            return 65
        case 1:
            return 55
        default:
            return UITableView.automaticDimension
        }
    }
}
