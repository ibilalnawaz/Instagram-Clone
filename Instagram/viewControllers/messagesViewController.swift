//
//  messagesViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 4/9/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import Firebase

class messagesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var user = [UserInfo]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .none
        self.tabBarController?.tabBar.isHidden = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.black
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
                    
                    let fullName  = dictionary["FullName"] as? String
                    let profileImage  = dictionary["profile_image"] as? String
                    
                    userToShow.fullName = fullName
                    userToShow.imagePath = profileImage
                    userToShow.userID = uid
                    
                    self.user.append(userToShow)
                    self.tableView.separatorStyle = .singleLine
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messagesTableViewCell
        
        cell.userName.text = self.user[indexPath.row].fullName
        cell.profileImage.sd_setImage(with: URL(string: self.user[indexPath.row].imagePath!), placeholderImage: #imageLiteral(resourceName: "image_placeholder") , completed: nil)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagesViewController : userMessageViewController = self.storyboard?.instantiateViewController(withIdentifier: "messageVC") as! userMessageViewController
        
        messagesViewController.recieverUserId = self.user[indexPath.row].userID
        
        self.navigationController?.pushViewController(messagesViewController, animated: true)

    }

   

}
