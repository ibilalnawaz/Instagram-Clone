//
//  signUpViewController.swift
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

class signUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var selectedPhoto :UIImage?
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var signUpName: UITextField!
    @IBOutlet weak var signUpProfilePic: UIImageView!
    @IBOutlet weak var signUpUserName: UITextField!
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //FullName
        signUpName.backgroundColor = .clear
        signUpName.tintColor = .white
        signUpName.textColor = .white
        signUpName.attributedPlaceholder = NSAttributedString(string: signUpName.placeholder!,
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor(white:1.0,alpha: 0.6)])
        let bottomLayerName = CALayer()
        bottomLayerName.frame = CGRect(x: 0, y: 29, width: 335, height: 0.6)
        bottomLayerName.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        signUpName.layer.addSublayer(bottomLayerName)
        //UserName
        signUpUserName.backgroundColor = .clear
        signUpUserName.tintColor = .white
        signUpUserName.textColor = .white
        signUpUserName.attributedPlaceholder = NSAttributedString(string: signUpUserName.placeholder!,
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor(white:1.0,alpha: 0.6)])
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: 335, height: 0.6)
        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        signUpUserName.layer.addSublayer(bottomLayerUsername)
        //Email
        signUpEmail.backgroundColor = .clear
        signUpEmail.tintColor = .white
        signUpEmail.textColor = .white
        signUpEmail.attributedPlaceholder = NSAttributedString(string: signUpEmail.placeholder!,
                                                               attributes:[NSAttributedStringKey.foregroundColor: UIColor(white:1.0,alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 335, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        signUpEmail.layer.addSublayer(bottomLayerEmail)
        //Password
        signUpPassword.backgroundColor = .clear
        signUpPassword.tintColor = .white
        signUpPassword.textColor = .white
        signUpPassword.attributedPlaceholder = NSAttributedString(string: signUpPassword.placeholder!,
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor(white:1.0,alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 335, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        signUpPassword.layer.addSublayer(bottomLayerPassword)
        //ProfilePic
        
        signUpProfilePic.layer.cornerRadius = 40
        signUpProfilePic.clipsToBounds = true
        signUpProfilePic.isUserInteractionEnabled = true
        signUpProfilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpViewController.selectPhoto)))
        
        signUpButton.isEnabled = false
        
        handleTextField()
    }
    func handleTextField(){
        signUpName.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        signUpUserName.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        signUpEmail.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        signUpPassword.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    @objc func textFieldDidChange(){
        guard let username = signUpUserName.text, !username.isEmpty,let name = signUpName.text, !name.isEmpty ,let email = signUpEmail.text, !email.isEmpty,let pasword = signUpPassword.text, !pasword.isEmpty else {
            signUpButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpButton.isEnabled = true
        
        
    }
    @objc func selectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedPhoto = chosenImage
            signUpProfilePic.image = chosenImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Creating Account")
        SVProgressHUD.setDefaultMaskType(.black)
        if let profileImg = self.selectedPhoto, let imageData = UIImageJPEGRepresentation(profileImg, 0.5) {
            AuthService.signUp(fullName:signUpName.text!,username: signUpUserName.text!, email: signUpEmail.text!, password: signUpPassword.text!, imageData: imageData, onSuccess: {
                
                self.performSegue(withIdentifier: "signUpToMain", sender: nil)
                SVProgressHUD.dismiss()
            }, onError: { (errorString) in
                SVProgressHUD.showError(withStatus: errorString!)
            })
        } else {
            SVProgressHUD.showError(withStatus: "Profile Image can't be empty")
        }
    
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}





