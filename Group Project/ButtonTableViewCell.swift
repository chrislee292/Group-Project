//
//  ButtonTableViewCell.swift
//  Group Project
//
//  Created by chrislee on 11/30/22.
//

import UIKit
import FirebaseAuth

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
