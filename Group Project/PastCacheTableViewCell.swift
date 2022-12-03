//
//  PastCacheTableViewCell.swift
//  Group Project
//
//  Created by Justin Vu on 11/29/22.
//

import UIKit

class PastCacheTableViewCell: UITableViewCell {
    
    // outlets to the imageView and title label
    @IBOutlet weak var textImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
