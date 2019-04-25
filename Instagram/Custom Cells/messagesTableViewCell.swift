//
//  messagesTableViewCell.swift
//  Instagram
//
//  Created by Bilal Nawaz on 4/9/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit

class messagesTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
