//
//  NotificationsTableViewCell.swift
//  Group Project
//
//  Created by chrislee on 11/29/22.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    var callback: ((Float) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func changeSliderLabel(sender: UISlider!) {
        // get the slider value
        let v = slider.value
        
        // change the slider text
        sliderLabel.text! = "\(Int(slider.value))"
        
        // send the value to the settings tableview
        callback?(v)
    }

}
