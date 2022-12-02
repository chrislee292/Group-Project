//
//  DarkModeTableViewCell.swift
//  Group Project
//
//  Created by chrislee on 12/2/22.
//

import UIKit
import CoreData

class DarkModeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func `switch`(_ sender: Any) {
        let darkModeEnabled = NSEntityDescription.insertNewObject(forEntityName: "DarkMode", into: context)
        
        if (darkModeSwitch.isOn) {
            darkModeEnabled.setValue(true, forKey: "darkModeEnabled")
            print("Dark mode enabled")
        } else {
            print("Dark mode disabled")
            darkModeEnabled.setValue(false, forKey: "darkModeEnabled")
        }
    }
    
}
