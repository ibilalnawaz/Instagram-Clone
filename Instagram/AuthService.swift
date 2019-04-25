//
//  AuthService.swift
//  Instagram
//
//  Created by Bilal Nawaz on 3/26/18.
//  Copyright © 2018 Bilal Nawaz. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    static func signIn(email:String,password:String,onSuccess:@escaping () -> Void,onError:@escaping (_ errorMessage:String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password,completion: { (user, error) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    static func signUp(fullName:String,username:String,email:String,password:String,imageData:Data,onSuccess:@escaping () -> Void,onError:@escaping (_ errorMessage:String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error: Error?) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            // let uid = user?.uid
            //            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let storageRef = Storage.storage().reference().child("user/\(uid)")
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    return
                }
                let profileImgUrl = metadata?.downloadURL()?.absoluteString
                self.setUserInformation(fullName: fullName, username: username, email: email, uid: uid, profileImage: profileImgUrl!,onSuccess: onSuccess)
            })
        })
    }
    
    
    static func setUserInformation(fullName:String,username:String,email:String,uid:String,profileImage:String,onSuccess:@escaping () -> Void){
        //        let ref = Database.database().reference()
        //        let userReference = ref.child("Users")
        //        let newUserReference = userReference.child(uid)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        
        databaseRef.setValue(["uid" :uid,"FullName":fullName,"Username":username,"Email":email,"profile_image":profileImage])
        onSuccess()
    }
}
