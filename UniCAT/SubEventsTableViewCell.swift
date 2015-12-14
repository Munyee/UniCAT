//
//  SubEventsTableViewCell.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 6/2/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation
import UIKit

class SubEventsTableViewCell: PFTableViewCell {
    
    
    @IBOutlet weak var coverImage: PFImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favouriteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
