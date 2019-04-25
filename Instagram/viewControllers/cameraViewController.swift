//
//  cameraViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 3/26/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class cameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{
    
    
    
    var selectedPhoto :UIImage?
    
  
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var captionTextLabel: UITextField?
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectPhoto)))
        photo.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost(){
        if selectedPhoto != nil{
            self.shareButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor.black
        }else{
            self.shareButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.shareButton.backgroundColor = UIColor.lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    @objc func selectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedPhoto = chosenImage
            photo.image = chosenImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectPhotoButton(_ sender: Any) {
//        let pickerController = UIImagePickerController()
//        pickerController.delegate = self
//        pickerController.allowsEditing = true
//        present(pickerController, animated: true, completion: nil)
        selectPhoto()
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                selectedPhoto = chosenImage
                photo.image = chosenImage
            }
            dismiss(animated: true, completion: nil)
            
        }
       
    }
   
    @IBAction func camerButton(_ sender: Any) {
        selectFromCamera()
    }
    func selectFromCamera(){
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            pickerController.allowsEditing = false
            present(pickerController, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Error", message: "No Camera Availabale", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (alertAction) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
        }

    }
    @IBAction func removePhoto(_ sender: Any) {
        clear()
        handlePost()
    }
    
    @IBAction func shareButton(_ sender: Any) {
       // ProgressHUD.show("Waiting...", interaction: false)
        SVProgressHUD.show(withStatus: "Wait")
        SVProgressHUD.setDefaultMaskType(.black)
        view.endEditing(true)
        if let profileImg = self.selectedPhoto, let imageData = UIImageJPEGRepresentation(profileImg, 0.2) {
            let photoIdString = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                let photoUrl = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabse(photoUrl: photoUrl!)
            })
        } else {
            ProgressHUD.showError("")
        }
        
    }
    func sendDataToDatabse(photoUrl : String){
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostID = postsReference.childByAutoId()
        // let newPostID = postsReference.childByAutoId().child(userID!)
        // let newPostReference = postsReference.childByAutoId().key
        
        ref.child("users/profile/").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {
                return
            }
            
            
            let username  = dictionary["Username"] as? String
            let name  = dictionary["FullName"] as? String
            let profileImage  = dictionary["profile_image"] as? String
            let uid  = dictionary["uid"] as? String
            
            
            
            newPostID.setValue(["photoUrl" : photoUrl,"caption":self.captionTextLabel?.text ?? "","Username":username!,"FullName":name!,"profile_image":profileImage!,"uid":uid!,"timestamp": [".sv":"timestamp"],
                                     ]) { (error, ref) in
                                        if error != nil{
                                            ProgressHUD.showError(error!.localizedDescription)
                                            return
                                        }
                                        self.clear()
                                        self.tabBarController?.selectedIndex = 0
                                        SVProgressHUD.dismiss()
            }
            
            
        })
        
        
    }
    func clear(){
        self.photo.image = UIImage(named : "image_placeholder")
        self.selectedPhoto = nil
        self.captionTextLabel = nil
    }
    
    
}
