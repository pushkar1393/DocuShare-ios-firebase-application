//
//  UserProfileViewController.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/6/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    var user : User?
    var userID : String?
    
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var userNameTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let tabCtrllr = self.tabBarController as! UserTabBarController
        user = tabCtrllr.user
        userID = tabCtrllr.userID
        
        userNameTextField.text = user?.firstName
        emailTextField.text = userID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
