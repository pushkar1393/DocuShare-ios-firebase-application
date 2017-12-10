//
//  LoginViewController.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/5/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userToSignIn : User?
    var uid : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewUser = segue.destination as? UserTabBarController {
            
            viewUser.user = userToSignIn
            viewUser.userID = uid
        }
        
    }
 
    @IBAction func loginPressed(_ sender: Any) {
            loginAccount()
    

    }
    
    //function to login account
    func loginAccount() {
        if checkIsValid() == 1 {
            print(emailTextField.text!)
            print(passwordTextField.text!)
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (user,error) in
                if user != nil {
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "isUserLoggedin")
                    defaults.synchronize()
                    self.uid = user?.uid
                    self.performSegue(withIdentifier: "toUserProfileFromLogin", sender: self)
                    print(self.uid!)
                    
                } else {
                    self.createAlert("Invalid Credentials", "Please enter valid credentials")
                                    }
            }
            
        }else if checkIsValid() == 2 {
            createAlert("Empty fields", "Please enter all the fields!")
        }
    }
    
    
    
    
    // function to pop up an alert
    func createAlert(_ title : String,_ message : String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {}
    }
    
    // function to perform field validations
    func checkIsValid() -> Int {
        if emailTextField.text == "" || passwordTextField.text == "" {
            return 2
        }
        return 1;
    }
    
    

}
