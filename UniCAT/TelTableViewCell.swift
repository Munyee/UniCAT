//
//  TelTableViewCell.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 7/2/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import UIKit

class TelTableViewCell: UITableViewCell {

    @IBOutlet weak var telThumb: UIImageView!
    @IBOutlet weak var telNo: UILabel!
    var telephone = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func tapped(sender: AnyObject) {
        let phone = Int(telephone)
        if telNo.text != "None" {
            if let url = NSURL(string: "telprompt://+60\(phone!)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
