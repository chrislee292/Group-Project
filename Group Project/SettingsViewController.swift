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
    var notifDistance = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fillData()
        
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
            notificationsCell.slider.value = 25
            
            let navVC = tabBarController?.viewControllers?[0] as! UINavigationController
            let gpsVC = navVC.topViewController as! MapViewController
            
            notificationsCell.callback = { val in
                //self.notifDistance = Double(val)

                gpsVC.radNear = Double(val)
            }
            //notifDistance = Double(notificationsCell.slider.value)
            
            print("settings \(notificationsCell.slider.value)")
            return notificationsCell
        case 1:
            let fontsCell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
            fontsCell.textLabel!.text = "Dark Mode"
            return fontsCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
//        case 3:
//            Auth.auth().sendPasswordReset(withEmail: self.userEmail!) { error in
//                let controller = UIAlertController(
//                    // Actually an Error
//                    title: "Error",
//                    message: "There was an error sending the password reset email.",
//                    preferredStyle: .alert)
//                controller.addAction(UIAlertAction(
//                    title: "OK",
//                    style: .default))
//                self.present(controller, animated: true)
//                print(self.userEmail!)
//            }
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
        case 3:
            do {
                login = false
                //print("\(login) settings")
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
        case 0, 3, 4:
            return 65
        default:
            return UITableView.automaticDimension
        }
    }
    /*
    func fillData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            // fetch the caches as an array
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs display it
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        for user in fetchedResults!{
            userArray.append(User(loginVar: ((user.value(forKey: "logout")) != nil)))
        }
    }
    
    // save the core data changes
    func saveContext () {
        // check for changes
        if context.hasChanges {
            do {
                // save
                try context.save()
            } catch {
                // error
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }*/
}
