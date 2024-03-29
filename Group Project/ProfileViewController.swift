//
//  ProfileViewController.swift
//  Group Project
//
//  Created by chrislee on 11/15/22.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var findAmountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    
    let segueIdentifier = "ProfileToEditProfile"
    let userEmail = Auth.auth().currentUser?.email
    
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
        let storage = Storage.storage()
        var profilePhotoReference: StorageReference!
        
        // Set user profile labels to whatever is corresponding in document
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let firstName = data!["firstName"]! as? String ?? ""
                let lastName = data!["lastName"]! as? String ?? ""
                let amountOfFinds = data!["amountOfFinds"]! as? Int ?? 0
                let username = data!["username"]! as? String ?? ""
                self.nameLabel.text! = "\(firstName) \(lastName)"
                self.findAmountLabel.text! = "\(amountOfFinds) Finds"
                self.usernameLabel.text! = "\(username)"
                if (amountOfFinds < 5) {
                    self.levelLabel.text! = "Novice"
                } else if (amountOfFinds >= 5 && amountOfFinds < 15) {
                    self.levelLabel.text! = "Intermediate"
                } else if (amountOfFinds >= 15 && amountOfFinds < 30) {
                    self.levelLabel.text! = "Advanced"
                } else if (amountOfFinds >= 30 && amountOfFinds < 50) {
                    self.levelLabel.text! = "Expert"
                } else {
                    self.levelLabel.text! = "God"
                }
            } else {
                print("Document does not exist")
            }
        }
        
        // Set profile photo from document profile photo link
        Firestore.firestore().collection("userInfo").document(userEmail!).getDocument { snapshot, error in
            if error != nil {
                print ("Error")
                return
            } else {
                let profilePhotoURL = snapshot?.get("profilePhotoLink")
                if (profilePhotoURL as! String != "") {
                    print("profilePhotoURL = \(profilePhotoURL!)")
                    profilePhotoReference = storage.reference(forURL: profilePhotoURL as! String)
                    profilePhotoReference.downloadURL { (url, error) in
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                        self.profilePhoto.contentMode = .scaleAspectFill
                        self.profilePhoto.image = image
                        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.height / 2
                        self.profilePhoto.clipsToBounds = true
                        self.profilePhoto.layer.borderColor = UIColor.black.cgColor
                        self.profilePhoto.layer.borderWidth = 1
                        
                }
                }
            }
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: self.segueIdentifier, sender: self)
    }
    
}
