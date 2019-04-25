//
//  activityViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 3/24/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import Firebase

class activityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var post = [PostInfo]()
    
    var user = [UserInfo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()

        loadPosts()
    }
    func loadPosts(){
        let ref = Database.database().reference()
        
        ref.child("posts").observe(.childAdded) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                
                let uid = dict["uid"] as! String
                let profileImage = dict["profile_image"] as! String
                let userName = dict["Username"] as! String
                let name = dict["FullName"] as! String
                let captionText = dict["caption"] as! String
                let postPhotoUrl = dict["photoUrl"] as! String
                let timeStamp = dict["timestamp"] as! Double
                
                let postData = PostInfo()
                postData.fullName = name
                postData.username = userName
                postData.imagePath = profileImage
                postData.postImagePath = postPhotoUrl
                postData.postImageCaption = captionText
                postData.postTime = timeStamp
                postData.userID = uid
                
                self.post.append(postData)
                self.post.reverse()
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell
        cell.postInit(profileImageString: post[indexPath.row].imagePath, profileName: "\(post[indexPath.row].username!) has posted a photo", postImageUrl: post[indexPath.row].postImagePath)
        return cell
    }
   
}
