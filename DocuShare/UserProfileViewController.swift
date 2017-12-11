//
//  UserProfileViewController.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/6/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var user : User?
    var userID : String?
    var userImage : UIImage?
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        // Do any additional setup after loading the view.
        
        let tabCtrllr = self.tabBarController as! UserTabBarController
        user = tabCtrllr.user
        userID = tabCtrllr.userID
    }

  
    @IBAction func updatePicturePressed(_ sender: Any) {
        user?.addProfilePicture(profilePicture, userID!)
        
    }
    
    

    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logError {
            print(logError)
        }
        
        performSegue(withIdentifier: "toSignOut", sender: self)
    }
   
    
    
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
     //   userImage = info[UIImagePickerControllerOriginalImage] as? UIImage
      //  profilePicture.image = userImage
       // picker.dismiss(animated: true, completion: nil)
        
        
    //}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePicture.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    

}
