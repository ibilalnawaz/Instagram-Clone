//
//  ActivityTableViewCell.swift
//  Instagram
//
//  Created by Bilal Nawaz on 4/8/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func postInit(profileImageString:String,profileName:String,postImageUrl:String){
        profileImage.sd_setImage(with: URL(string: profileImageString), placeholderImage: #imageLiteral(resourceName: "image_placeholder") , completed: nil)
        userName.text = profileName
        postImage.sd_setImage(with: URL(string: postImageUrl) , completed: nil)
    
    }

}
