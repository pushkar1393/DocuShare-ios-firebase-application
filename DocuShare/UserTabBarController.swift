//
//  UserTabBarController.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/9/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit
import Firebase

class UserTabBarController: UITabBarController {

    var user : User?
    var userID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUser() {
        Database.database().reference(fromURL: "https://docushare-documents-on-the-go.firebaseio.com/").child("userList").child(userID!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                self.user = User()
                self.user!.setValuesForKeys(dictionary)
                
            }
        }, withCancel: nil)
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
