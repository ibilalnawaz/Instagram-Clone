//
//  editProfileViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 4/4/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class editProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var selectedPhoto = UIImage()
    
    
    @IBOutlet weak var changeProfiePhoto: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    var username :String?
    var FullName :String?
    var downloadURL: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTextField()
        
        getUsersFromDatabase()
        
        
        doneButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        doneButton.isEnabled = false
        
        profilePhoto.layer.cornerRadius = 40
        profilePhoto.clipsToBounds = true
        profilePhoto.isUserInteractionEnabled = true
        profilePhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileViewController.selectPhoto)))
        
        let bottomLayerName = CALayer()
        bottomLayerName.frame = CGRect(x: 0, y: 22, width: 225, height: 1)
        bottomLayerName.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        nameTextField.layer.addSublayer(bottomLayerName)
        
        let bottomLayerUserName = CALayer()
        bottomLayerUserName.frame = CGRect(x: 0, y: 22, width: 225, height: 1)
        bottomLayerUserName.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayerUserName)
        
        // Do any additional setup after loading the view.
    }
    func handleTextField(){
        nameTextField.addTarget(self, action: #selector(editProfileViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        usernameTextField.addTarget(self, action: #selector(editProfileViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    @objc func textFieldDidChange(){
        doneButton.isEnabled = true
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        
    }
    @objc func selectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedPhoto = chosenImage
            profilePhoto.image = chosenImage
            doneButton.isEnabled = true
            doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        dismiss(animated: true, completion: nil)
        doneButton.isEnabled = true
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        
    }
    func getUsersFromDatabase() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users/profile/").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            
            
            self.username  = dictionary["Username"] as? String
            self.FullName  = dictionary["FullName"] as? String
            let profileImage  = dictionary["profile_image"] as? String
            
            
            
            self.nameTextField.text = self.FullName
            self.usernameTextField.text = self.username
            self.profilePhoto.sd_setImage(with: URL(string: profileImage!) , completed: nil)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func updateUsers() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let storageRef = Storage.storage().reference().child("user").child(userID!)
        let metadata = StorageMetadata()
        
        let username = self.usernameTextField.text
        let FullName = self.nameTextField.text
        
        ref.child("users/profile/").child(userID!).updateChildValues(["Username":username as Any,"FullName":FullName as Any])
        
        let profileImg = self.selectedPhoto
        guard let imageData = UIImageJPEGRepresentation(profileImg, 0.5) else { return}
        
        storageRef.putData(imageData, metadata: metadata) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                self.downloadURL = metaData?.downloadURL()?.absoluteString
                ref.child("users/profile/").child(userID!).updateChildValues(["profile_image":self.downloadURL as Any])
            }
            
        }
        
        
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //         if segue.identifier == "test"{
    //        let profileController = segue.destination as! profileViewController
    //        profileController.profileImage = downloadURL
    //        }
    //        dismiss(animated: true, completion: nil)
    //
    //    }
    @IBAction func saveButton(_ sender: Any) {
        updateUsers()
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func changeProfilePhoto(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                selectedPhoto = chosenImage
                profilePhoto.image = chosenImage
            }
            dismiss(animated: true, completion: nil)
            doneButton.isEnabled = true
            doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            
        }
    }
    
    
}
