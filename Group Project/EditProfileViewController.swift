//
//  EditProfileViewController.swift
//  Group Project
//
//  Created by chrislee on 11/18/22.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var newUsernameField: UITextField!
    @IBOutlet weak var newFirstName: UITextField!
    @IBOutlet weak var newLastName: UITextField!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    let userEmail = Auth.auth().currentUser?.email
    let picker = UIImagePickerController()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let storage = Storage.storage()
        var profilePhotoReference: StorageReference!
        
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
    
    @IBAction func libraryButtonPressed(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let storage = Storage.storage()
        var profilePhotoReference: StorageReference!
        
        let chosenImage = info[.originalImage] as! UIImage
        uploadUserImage(withImage: chosenImage, fileName: "profilePhoto")
        
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
                        self.profilePhoto.contentMode = .scaleAspectFit
                        self.profilePhoto.image = image
                        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.height / 2
                        self.profilePhoto.clipsToBounds = true
                        self.profilePhoto.layer.borderColor = UIColor.black.cgColor
                        self.profilePhoto.layer.borderWidth = 1
                    }
                }
            }
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func cameraButtonSelected(_ sender: Any) {
        
        if UIImagePickerController.availableCaptureModes(for: .front) != nil {
            // we have a front camera
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) {
                    accessGranted in
                    guard accessGranted == true else { return }
                }
            case .authorized:
                break
            default:
                print("Access Denied")
                return
            }
            
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            
            present(picker, animated: true)
            
        } else {
            
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device does not have a front camera.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertVC.addAction(okAction)
            present(alertVC, animated: true)
            
        }
    }
    
    func uploadUserImage(withImage: UIImage, fileName: String) {
        let docRef = db.collection("userInfo").document(userEmail!)
        
        guard let imageData = withImage.jpegData(compressionQuality: 0.5) else { return }
        let storageRef = Storage.storage().reference()
        let thisUserPhotoStorageRef = storageRef.child(userEmail!).child(fileName)

        let uploadTask = thisUserPhotoStorageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // error while uploading
                return
            }

            thisUserPhotoStorageRef.downloadURL { (url, error) in
                print(metadata.size)
                thisUserPhotoStorageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // error occured after uploading and then getting the URL
                        return
                    }
                    var stringURL = downloadURL.absoluteString
                    docRef.updateData([
                        "profilePhotoLink": stringURL
                    ])
                }
            }
        }
    }
}
