//
//  homeViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 3/24/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class homeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,PostActions {


    var post = [PostInfo]()
    
    var user = [UserInfo]()
    
    var following = [String]()

    
    var followingUsers = [String]()
    var activityIndicatorView: UIActivityIndicatorView!
    let dispatchQueue = DispatchQueue(label: "Dispatch Queue", attributes: [], target: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
            tableView.separatorStyle = .none
            activityIndicatorView.startAnimating()
            dispatchQueue.async {
                Thread.sleep(forTimeInterval: 3)
                OperationQueue.main.addOperation() {
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.black

        let label = UILabel()
        label.text = "Instagram"
        label.font = UIFont(name: "Billabong", size: 32)
        
        let xibFile = UINib(nibName: "postTableViewCell", bundle: nil)
        tableView.register(xibFile, forCellReuseIdentifier: "postCell")
        
        navigationItem.titleView = label
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        tableView.backgroundView = activityIndicatorView
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        configureTableView()
        
        loadPosts()
    }

    @IBAction func cameraButton(_ sender: Any) {
        tabBarController?.selectedIndex = 2
    }
    func configureTableView(){
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    func optionsButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Hide Post", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func likeButton(index: Int) {
        print("like\(index)")
    }
    
    func commentButton() {
        print("comment")
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
                self.configureTableView()
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! postTableViewCell
        cell.postActionDelegate = self
        cell.index = indexPath
        cell.postInit(profileImage: post[indexPath.row].imagePath, profileName: post[indexPath.row].fullName, postImageUrl: post[indexPath.row].postImagePath, userNameForCaption: post[indexPath.row].username, captionTextString: post[indexPath.row].postImageCaption)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
    
}
