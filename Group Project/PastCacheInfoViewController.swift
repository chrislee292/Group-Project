//
//  PastCacheInfoViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/29/22.
//

import UIKit

class PastCacheInfoViewController: UIViewController {

    // variables to hold the position of the cache in the coordArray
    var cacheRow:Int = 0
    var cacheSection:Int = 0
    
    var titleInfo = ""
    var diffInfo = 0
    
    var hintInfo = ""
    var hazardInfo = ""
    
    var latInfo:Double = 0.0
    var longInfo:Double = 0.0
    
    // outlets to the labels of the caches
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var diffLabel: UILabel!
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hazardLabel: UILabel!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update all the labels with their correspoinding quality
        titleLabel.text = titleInfo
        diffLabel.text = "Difficulty: \(String(diffInfo))"
        
        hintLabel.text = hintInfo
        hazardLabel.text = hazardInfo
        
        latitudeLabel.text = String(format: "%.4f", latInfo)
        longitudeLabel.text = String(format: "%.4f", longInfo)
    }
}
