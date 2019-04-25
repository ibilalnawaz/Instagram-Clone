//
//  userMessageViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 4/9/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import Firebase

class userMessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    var recieverUserId : String!
    
    var message = [Message]()

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.delegate = self
        
        sendButton.isEnabled = false

        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tabBarController?.tabBar.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        
        handleTextField()
        loadPosts()
        
    }
    func handleTextField(){
        messageTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)

    }
    @objc func textFieldDidChange(){
        guard let message = messageTextField.text, !message.isEmpty else {
            sendButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            sendButton.isEnabled = false
            return
        }
        sendButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        sendButton.isEnabled = true
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = 348
            self.view.layoutIfNeeded()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
            self.view.endEditing(true)
        }
    }
    @objc func tableViewTapped(){
        UIView.animate(withDuration: 0.2) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
            
            self.view.endEditing(true)
        }
    }
    
    

    @IBAction func sendButton(_ sender: Any) {
        
        
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("messages").childByAutoId()
        let messageDictionary = ["Sender":userID,"Reciever":recieverUserId,"MeassageBody":messageTextField.text!]
        ref.setValue(messageDictionary) { (error, databaseRef) in
            if error != nil{
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            self.messageTextField.text = ""
            self.messageTextField.endEditing(true)
            self.sendButton.isEnabled = false
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userMessagesCell", for: indexPath)
        
        cell.textLabel?.text = message[indexPath.row].MessageBody
        
        return cell
    }
    func loadPosts(){
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        ref.child("messages").observe(.childAdded) { (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                
                let reciever = dict["Reciever"] as! String
                let sender = dict["Sender"] as! String

                if reciever == self.recieverUserId {

                    let messageBody = dict["MeassageBody"] as! String
                    let messageData = Message()
                    
                    messageData.senderID = sender
                    messageData.MessageBody = messageBody
                    
                    self.message.append(messageData)
                    self.tableView.reloadData()
                
                }

            }
        }
    }
    
}
