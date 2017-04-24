//
//  AccountsTableViewCell.swift
//  Twitter
//
//  Created by Anup Kher on 4/23/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class AccountsTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageVIew: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User! {
        didSet {
            if let url = user.profileUrl {
                posterImageVIew.setImageWith(url)
            }
            screennameLabel.text = user.screenname!
            nameLabel.text = user.name!
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageVIew.layer.cornerRadius = 5.0
        posterImageVIew.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
