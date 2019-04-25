//
//  settingsViewController.swift
//  Instagram
//
//  Created by Bilal Nawaz on 4/3/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import UIKit
import Firebase

class settingsViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutButton.layer.cornerRadius = 16
        logOutButton.clipsToBounds = true
        

        // Do any additional setup after loading the view.
    }
    @IBAction func logOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }catch let logOutError{
            print(logOutError)
        }
        let storyboard = UIStoryboard(name: "start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "logInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
   
}
