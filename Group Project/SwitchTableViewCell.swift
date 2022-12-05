//
//  SwitchTableViewCell.swift
//  Group Project
//
//  Created by chrislee on 12/4/22.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func `switch`(_ sender: UISwitch) {
        let mapvc = MapViewController()
        if(!(cellSwitch.isOn)){
            mapvc.notifBool = false
        }
        else{
            mapvc.notifBool = true
            
        }
    }

}
