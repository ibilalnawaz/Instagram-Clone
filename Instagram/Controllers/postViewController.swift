//
//  postViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 4/7/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import Firebase

class postViewController: UIViewController {
    
    var profileImageString : String!
    var profileNameString: String!
    var postImageString: String!
    var postAutherString: String!
    var postId : String!
    
    var pressed = false

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postAuther: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageLike))
        doubleTapGesture.numberOfTapsRequired = 2
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(doubleTapGesture)
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        profileImage.sd_setImage(with: URL(string: self.profileImageString!), placeholderImage: #imageLiteral(resourceName: "image_placeholder") , completed: nil)
        postImage.sd_setImage(with: URL(string: self.postImageString!), placeholderImage: #imageLiteral(resourceName: "image_placeholder") , completed: nil)
        profileName.text = profileNameString
        postAuther.text = postAutherString
    }
    @IBAction func optionsButton(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete Post", style: .destructive, handler: { ( _ ) in
            let ref = Database.database().reference()
            ref.child("posts").child(self.postId).removeValue()
            
            self.performSegue(withIdentifier: "unwindToPost", sender: self)
            //self.navigationController?.dismiss(animated: false, completion: nil)
            self.navigationController?.dismiss(animated: false, completion: {
                self.navigationController?.tabBarController?.selectedIndex = 4

            })


        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
 
    
    func getUserPostsFromDatabase() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("posts").queryOrderedByValue().observe(.childAdded) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let uid = dict["uid"] as! String
                if uid == userID{
                    
                    let postData = UserPostsInfo()
                    let userPostImage  = dict["photoUrl"] as? String
                    postData.postImagePath = userPostImage
                    
                    
                }
                
                
            }
            
        }
        
    }
  

}
