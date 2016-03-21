//
//  DiscussionTableViewCell.swift
//  UniCAT
//
//  Created by Munyee on 21/03/2016.
//  Copyright © 2016 Sweatshop Solutions. All rights reserved.
//

import UIKit

class DiscussionTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfile: PFImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
