//
//  userAllPostsCell.swift
//  Instagram
//
//  Created by Bilal Nawaz on 4/2/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit

class userAllPostsCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func postInit(profileImage:String){
        
        //postImage.downloadImageForUserPost(from: profileImage)
        postImage.sd_setImage(with: URL(string: profileImage), placeholderImage: #imageLiteral(resourceName: "image_placeholder") , completed: nil)
        
    }
    
    
}

