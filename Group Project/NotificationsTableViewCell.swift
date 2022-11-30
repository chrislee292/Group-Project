//
//  NotificationsTableViewCell.swift
//  Group Project
//
//  Created by chrislee on 11/29/22.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        slider.value = 25
//        slider.minimumValue = 0
//        slider.maximumValue = 200
//        print(slider.value)
    }
    
    func setCell() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
