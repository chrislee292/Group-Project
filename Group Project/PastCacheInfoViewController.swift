//
//  PastCacheInfoViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/29/22.
//

import UIKit

class PastCacheInfoViewController: UIViewController {

    var cacheRow:Int = 0
    var cacheSection:Int = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var diffLabel: UILabel!
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hazardLabel: UILabel!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = coordArray[cacheSection][cacheRow].cacheTitle
        diffLabel.text = "Difficulty: \(String(coordArray[cacheSection][cacheRow].cacheDifficulty))"
        
        hintLabel.text = coordArray[cacheSection][cacheRow].cacheHints
        hazardLabel.text = coordArray[cacheSection][cacheRow].cacheHazards
        
        latitudeLabel.text = String(format: "%.4f", coordArray[cacheSection][cacheRow].cacheLatitude)
        longitudeLabel.text = String(format: "%.4f", coordArray[cacheSection][cacheRow].cacheLongitude)
        // Do any additional setup after loading the view.
    }
}
