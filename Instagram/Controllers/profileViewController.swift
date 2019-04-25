//
//  profileViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 3/24/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import Firebase

class profileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var userPosts = [UserPostsInfo]()
    var profileImage : String?
    
    var fullName:String!
    var userName:String!
    var userProfileImage:String!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        self.collectionView.reloadData()
        
    }

    
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var numberOfPosts: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        getUsersFromDatabase()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let xibFile = UINib(nibName: "userAllPostsCell", bundle: nil)
        collectionView.register(xibFile, forCellWithReuseIdentifier: "allPostsCell")
        
        getUserPostsFromDatabase()
        //getUsersFromDatabase()
        
        
        collectionView.reloadData()
        
        displayImage.layer.cornerRadius = 40
        displayImage.clipsToBounds = true
        
        editProfile.layer.cornerRadius = 5
        editProfile.layer.borderWidth = 1
        editProfile.layer.borderColor = UIColor.black.cgColor
        
        
        settingView.layer.cornerRadius = 5
        settingView.layer.borderWidth = 1
        settingView.layer.borderColor = UIColor.black.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allPost = userPosts.count
        numberOfPosts.text = "\(allPost)"
        return allPost
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allPostsCell", for: indexPath) as! userAllPostsCell
        cell.postInit(profileImage: userPosts[indexPath.row].postImagePath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:view.frame.width/3.0, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postViewController : postViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! postViewController
        
        postViewController.postImageString = self.userPosts[indexPath.row].postImagePath
        postViewController.postId = self.userPosts[indexPath.row].postID
        postViewController.postAutherString = self.userName
        postViewController.profileImageString = self.userProfileImage
        postViewController.profileNameString = self.fullName
        
        self.navigationController?.pushViewController(postViewController, animated: true)
    }

    
    func getUsersFromDatabase() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users/profile/").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            
            let username  = dictionary["Username"] as? String
            let fullname  = dictionary["FullName"] as? String
            let profileImage  = dictionary["profile_image"] as? String
            let following  = dictionary["following"] as? [String:Any]
            let followers  = dictionary["followers"] as? [String:Any]
            
            let followingCount = following?.count
            let followerCount = followers?.count

            self.numberOfFollowing.text = "\(followingCount ?? 0)"
            self.numberOfFollowers.text = "\(followerCount ?? 0)"
            
            self.navigationController?.navigationBar.topItem?.title = username
            
            self.fullName = fullname
            self.userName = username
            self.userProfileImage = profileImage
            
            self.displayName.text = self.fullName
            self.displayImage.sd_setImage(with: URL(string: self.userProfileImage!), placeholderImage: #imageLiteral(resourceName: "image_placeholder") , completed: nil)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func getUserPostsFromDatabase() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("posts").queryOrderedByValue().observe(.childAdded) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let uid = dict["uid"] as! String
                if uid == userID{
                    
                    let postId = snapshot.key
                    
                    let postData = UserPostsInfo()
                    let userPostImage  = dict["photoUrl"] as? String
                    
                    postData.postImagePath = userPostImage
                    postData.postID = postId

                    self.userPosts.append(postData)
                    self.collectionView.reloadData()
                }
             
            }
            
        }

    }
    
}

