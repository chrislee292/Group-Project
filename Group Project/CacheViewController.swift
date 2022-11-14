//
//  CacheViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/13/22.
//

//import FirebaseDatabase
import UIKit

class CacheViewController: UIViewController {

    /*var ref: DatabaseReference!

    ref = Database.database().reference()
    */
    var titleName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
        ref.child("cache_\(titleName)").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else{
                return
            }
            print(\(value))
        })*/
        
    }
}
