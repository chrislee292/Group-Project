//
//  SwitchTableViewCell.swift
//  Group Project
//
//  Created by chrislee on 12/4/22.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellSwitch: UISwitch!

    var callback: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func `switch`(_ sender: UISwitch) {
        // get the value of the switch
        var switchBool = true
        if(sender.isOn){
            switchBool = true
        }
        else{
            switchBool = false
        }
        callback?(switchBool)
    }
}
