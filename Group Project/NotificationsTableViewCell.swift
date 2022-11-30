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
        let v = slider.value
        
        sliderLabel.text! = "\(Int(slider.value))"
        
        callback?(v)
    }

}
