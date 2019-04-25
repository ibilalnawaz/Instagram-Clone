//
//  logInViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 3/24/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class logInViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!,
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor(white:1.0,alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 335, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!,
                                                                     attributes:[NSAttributedStringKey.foregroundColor: UIColor(white:1.0,alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 335, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        signInButton.isEnabled = false
        
        handleTextField()
    }
    func handleTextField(){
        emailTextField.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(signUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    @objc func textFieldDidChange(){
        guard let email = emailTextField.text, !email.isEmpty,let pasword = passwordTextField.text, !pasword.isEmpty else {
            signInButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            signInButton.isEnabled = false
            return
        }
        signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInButton.isEnabled = true
        
        
    }
    @IBAction func signInButton(_ sender: Any) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Signing In")
        SVProgressHUD.setDefaultMaskType(.black)
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            self.performSegue(withIdentifier: "signInToMain", sender: nil)
            SVProgressHUD.dismiss()
        }, onError: { error in
            SVProgressHUD.showError(withStatus: error!)

        })
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signInToMain", sender: nil)
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
