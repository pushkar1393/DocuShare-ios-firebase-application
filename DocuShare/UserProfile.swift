//
//  UserProfile.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/5/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import Foundation

class UserProfile {
    
    var email : String
    var userName : String
    var password : String
    var myDocumentStore : DocumentStoreList
    var sharedDcoumentStore : DocumentStoreList
    
    init(_ email : String,_ userName : String, _ password : String) {
        self.userName = userName
        self.email = email
        self.password = password
        myDocumentStore = DocumentStoreList()
        sharedDcoumentStore = DocumentStoreList()
    }
}
