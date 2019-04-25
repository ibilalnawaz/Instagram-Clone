//
//  searchViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 3/24/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import Firebase

class searchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var user = [UserInfo]()
    
    @IBOutlet weak var tableView: UITableView!
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .none

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersFromDatabase()
    }
    func getUsersFromDatabase() {
        let ref = Database.database().reference()
        ref.child("users/profile/").observe(.childAdded, with: { (snapshot) in
            let userToShow = UserInfo()
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            if let uid = dictionary["uid"] as? String {
                if uid != Auth.auth().currentUser!.uid {
                    
                    let username  = dictionary["Username"] as? String
                    let profileImage  = dictionary["profile_image"] as? String
                    
                    userToShow.fullName = username
                    userToShow.imagePath = profileImage
                    userToShow.userID = uid
                    
                    self.user.append(userToShow)
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followUserCell", for: indexPath) as! followUserCell
        
        cell.userName.text = self.user[indexPath.row].fullName
        cell.profileImage.sd_setImage(with: URL(string: self.user[indexPath.row].imagePath!), placeholderImage: #imageLiteral(resourceName: "image_placeholder") , completed: nil)
        
        checkFollowing(index: indexPath.row,followButton: cell.followButton)
        cell.cellDelegate = self
        cell.index = indexPath
        return cell
    }
    func checkFollowing(index: Int,followButton: UIButton) {
        
        let UID = self.user[index].userID
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        ref.child("users/profile/").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as? String == UID {
                        followButton.setTitle("Following", for: .normal)
                        
                    }
                    
                    
                }
            }
        })
        ref.removeAllObservers()
    }
    
}

extension searchViewController: followUserButton{
   
    
    func onclickButton(index: Int) {
        updateFollowers(index: index)
    }
    func updateFollowers(index:Int) {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        let UID = self.user[index].userID
        let key = ref.child("users/profile/").childByAutoId().key
        
        var isFollower = false
        
        
        ref.child("users/profile/").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as? String == UID {
                        isFollower = true
                        
                        ref.child("users/profile/").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users/profile/").child(UID!).child("followers/\(ke)").removeValue()
                        
                    }
                }
            }
            if !isFollower {
                let following = ["following/\(key)" : UID]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("users/profile/").child(uid).updateChildValues(following)
                ref.child("users/profile/").child(UID!).updateChildValues(followers)
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}

