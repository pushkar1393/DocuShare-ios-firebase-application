//
//  User.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/5/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class User : NSObject{
    
    var firstName : String?
    var lastName : String?
    var dateOfBirth : String?
    static var genderList = ["---","Male","Female","Unspecified"]
    var sex : String?
    var email : String?
    var userName : String?
    var userProfilePictureURL : String?
    //var myDocumentStore : DocumentStoreList?
    //var sharedDcoumentStore : DocumentStoreList?
    
    
    
    //init(_ firstName : String, _ lastName : String, _ dateOfBirth : String, _ sex : String, _ email : String, _ userName : String) {
   //     self.myDocumentStore = DocumentStoreList()
     //   self.sharedDcoumentStore = DocumentStoreList()
    //    self.firstName = firstName
      //  self.lastName = lastName
      //  self.dateOfBirth = dateOfBirth
      //  self.sex = sex
      //  self.email = email
       // self.userName = userName
    //}
    


    func addProfilePicture(_ userProfilePicture : UIImageView,_ uid : String) -> String {
        var returnURL = ""
        
        let ref_root = Storage.storage().reference(forURL: "gs://docushare-documents-on-the-go.appspot.com/")
        let profile_picture_store = ref_root.child("profile_pic_store").child(uid + "_profile_pic.png")
        
        if let upload_Image = UIImagePNGRepresentation(userProfilePicture.image!){
            
            profile_picture_store.putData(upload_Image, metadata: nil, completion: {
                (metadata,error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let profileImage = metadata?.downloadURL()?.absoluteString {
                    
                    let values = ["firstName" : self.firstName, "lastName" : self.lastName, "sex" : self.sex, "dateOfBirth" : self.dateOfBirth, "userName" : self.userName, "email" : self.email, "userProfilePictureURL" : profileImage
                    ]
                    
                    self.addPictureURLToFireBase(uid, values as [String : AnyObject])
                }
                
                
                
                
                
                
            })
        }
      return returnURL
    }
    
    
    func addPictureURLToFireBase(_ uid : String, _ values : [String : AnyObject]) {
        
        let db_ref = Database.database().reference(fromURL: "https://docushare-documents-on-the-go.firebaseio.com/").child("userList").child(uid)
        db_ref.updateChildValues(values)
        
    }
}
