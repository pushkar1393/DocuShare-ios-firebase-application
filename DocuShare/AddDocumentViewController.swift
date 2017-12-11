//
//  AddDocumentViewController.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/10/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit

class AddDocumentViewController: UIViewController {

    var user : User?
    var userID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = user?.userName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
