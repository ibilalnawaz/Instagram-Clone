//
//  followersTableViewCell.swift
//  Instagram
//
//  Created by Bilal Nawaz on 4/6/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit

protocol followUserButtonFollowers {
    func onclickButton(index: Int)
}


class followersTableViewCell: UITableViewCell {
    
    var cellDelegate:followUserButtonFollowers?
    var index: IndexPath?
    
        @IBOutlet weak var profileImage: UIImageView!
        @IBOutlet weak var userName: UILabel!
        @IBOutlet weak var followButton: UIButton!
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            
            
            
            profileImage.layer.cornerRadius = profileImage.bounds.height / 2
            profileImage.clipsToBounds = true
            
            
            followButton.layer.cornerRadius = 16
            followButton.clipsToBounds = true
            followButton.layer.borderWidth = 2
            followButton.layer.borderColor = UIColor.black.cgColor
            
            
            
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
        @IBAction func followButton(_ sender: Any) {
            
            cellDelegate?.onclickButton(index: (index?.row)!)

            
            if followButton.titleLabel?.text == "Follow" {
                followButton.setTitle("Following", for: .normal)
                
                
            }
            if followButton.titleLabel?.text == "Following" {
                followButton.setTitle("Follow", for: .normal)
                
            }
            
        }

}
