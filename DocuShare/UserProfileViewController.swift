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
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    var user : User?
    var userID : String?
    var userImage : UIImage?
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabCtrllr = self.tabBarController as! UserTabBarController
        user = tabCtrllr.user
        userID = tabCtrllr.userID
        
        name.text = "Name:  " + (user?.firstName)! + " " + (user?.lastName)!
        date.text = "Date of Birth:  " +  (user?.dateOfBirth)!
        if user?.userProfilePictureURL == "" {
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        } else {
            setUpImage()
        }
        // Do any additional setup after loading the view.
        
        
    }

  
    @IBAction func updatePicturePressed(_ sender: Any) {
        if profilePicture.image != nil {
        user?.addProfilePicture(profilePicture, userID!)
            createAlert("Congratulations", "Profile updated successfully!")
        } else {
          createAlert("Warning", "Upload an Image!")
        }
    }
    
    
    func createAlert(_ title : String,_ message : String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {}
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
    
    
    func setUpImage() {
        let session = URLSession(configuration: .default)
        if let Userurl = user?.userProfilePictureURL {
            let url = URL(string: Userurl)
            //print(url)
            let downloadPic = session.dataTask(with: url!, completionHandler: {
                (data,response,error) in
                
                if error != nil {
                    // print(error)
                    return
                }
                if let imageData = data {
                    //print(data!)
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.profilePicture.image = image
                    }
                }
            })
            downloadPic.resume()
            //spinner.stopAnimating()
        }
    }

}
