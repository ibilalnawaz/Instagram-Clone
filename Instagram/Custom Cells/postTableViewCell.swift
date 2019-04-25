//
//  postTableViewCell.swift
//  Instagram
//
//  Created by Bilal Nawaz on 3/27/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit

protocol PostActions {
    func optionsButton()
    func likeButton(index : Int)
    func commentButton()
    
}

class postTableViewCell: UITableViewCell {
    
    var index: IndexPath?
    var pressed = false

    var postActionDelegate:PostActions?
    
    @IBOutlet weak var usernameForCaption: UILabel!
    @IBOutlet weak var captionText: UILabel!
    @IBOutlet weak var postProfileImage: UIImageView!
    @IBOutlet weak var postProfileName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        likeButton.setImage(#imageLiteral(resourceName: "LikeIcon"), for: UIControlState.normal)
        pressed = true
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageLike))
        doubleTapGesture.numberOfTapsRequired = 2
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(doubleTapGesture)
        
        postProfileImage.layer.cornerRadius = postProfileImage.bounds.height / 2
        postProfileImage.clipsToBounds = true
        
    }
    @objc func imageLike(_ gesture: UITapGestureRecognizer){
     
        if !pressed {
            
            likeButton.setImage(#imageLiteral(resourceName: "LikeIcon"), for: UIControlState.normal)
            pressed = true
        } else {
            
            likeButton.setImage(#imageLiteral(resourceName: "icon-like-filled-2"), for: UIControlState.normal)
            pressed = false
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func saveToCollectionButton(_ sender: Any) {
        
    }
    @IBAction func optionsButton(_ sender: Any) {
        
        postActionDelegate?.optionsButton()
        
    }
    @IBAction func likeButton(_ sender: Any) {
        
        postActionDelegate?.likeButton(index: (index?.row)!)
        if !pressed {

            likeButton.setImage(#imageLiteral(resourceName: "LikeIcon"), for: UIControlState.normal)
            pressed = true
        } else {

            likeButton.setImage(#imageLiteral(resourceName: "icon-like-filled-2"), for: UIControlState.normal)
            pressed = false
        }
        
    }
    @IBAction func commentButton(_ sender: Any) {
        
        postActionDelegate?.commentButton()
        
    }
    @IBAction func messageButton(_ sender: Any) {
    }
    
    func postInit(profileImage:String,profileName:String,postImageUrl:String,userNameForCaption:String,captionTextString:String){
        postProfileImage.sd_setImage(with: URL(string: profileImage), placeholderImage: #imageLiteral(resourceName: "image_placeholder") , completed: nil)
        postProfileName.text = profileName
        postImage.sd_setImage(with: URL(string: postImageUrl) , completed: nil)
        postImage.sd_setImage(with: URL(string: postImageUrl), placeholderImage: #imageLiteral(resourceName: "image_placeholder"), completed: nil)
        usernameForCaption.text = userNameForCaption
        captionText.text = captionTextString
    }
}
