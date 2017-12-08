//
//  User.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/5/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var firstName : String
    var lastName : String
    var dateOfBirth : String
    static var genderList = ["Male","Female","Unspecified"]
    var sex : String
    var userProfile : UserProfile?
    var userProfilePicture : UIImage?
    
    init(_ firstName : String, _ lastName : String, _ dateOfBirth : String, _ sex : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.sex = sex
    }
    
    func addUserProfile(_ userProfile : UserProfile) {
       self.userProfile = userProfile
    }

    func addProfilePicture(_ userProfilePicture : UIImage) {
        self.userProfilePicture = userProfilePicture
    }
}
