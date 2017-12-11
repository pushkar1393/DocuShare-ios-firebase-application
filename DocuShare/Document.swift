//
//  Document.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/5/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Document: NSObject {
    
    var documentName : String?
    var uploadedOn : String?
    var saveProtectionLock : Bool?
    var documentURL : String?

    
    
    //init(_ documentID : Int,_ documentName : String, _ uploadedOn : Date, _ saveProtectionLock : Bool, _ qrCodeDisplayImage : UIImage) {
    //    self.documentName = documentName
    //    self.uploadedOn = uploadedOn
     //   self.saveProtectionLock = saveProtectionLock
    //    self.qrCodeDisplayImage = qrCodeDisplayImage
   // }
}
