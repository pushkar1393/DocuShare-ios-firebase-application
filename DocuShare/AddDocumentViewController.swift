//
//  AddDocumentViewController.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/10/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit
import Firebase

class AddDocumentViewController: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var saveLockSwitch: UISwitch!
    @IBOutlet weak var documentNameTextField: UITextField!
    
    var docImage : UIImage?
    
    var user : User?
    var userID : String?
    var documentUploaded : UIImage?
   
    
    @IBOutlet weak var docDisplay: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userID!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetDoc() {
        documentNameTextField.text = ""
        docDisplay.image = nil
    }

    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        createDocumentAndStore()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            docDisplay.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func browse(_ sender: Any) {
        browse()
    }
    
    func browse()  {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        let libController = UIAlertController(title: "Photo Source", message: "", preferredStyle: .actionSheet)
        
        libController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }))
        
        libController.addAction(UIAlertAction(title: "Cam", style: .default, handler: { (action:UIAlertAction) in
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }))
        libController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(libController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func storeDocumentToDB(_ values : [String : AnyObject]){
        let ref = Database.database().reference(fromURL: "https://docushare-documents-on-the-go.firebaseio.com/").child("documentList").childByAutoId()
        ref.updateChildValues(values)
    }
    
    func createDocumentAndStore() {
        
        if checkIsValid() == 1 {
            print(Date())

            let date = String(describing: Date())
            print(date)
            
            let ref_root = Storage.storage().reference(forURL: "gs://docushare-documents-on-the-go.appspot.com/")
            let document_store = ref_root.child("document_store").child(date + "_user_" + userID! + "_scan.jpg")
            if let upload_Image = UIImageJPEGRepresentation(docDisplay.image!, 0.3){
                document_store.putData(upload_Image, metadata: nil, completion: {
                    (metadata,error) in

                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if var docURL = metadata?.downloadURL()?.absoluteString {
                       var val = self.saveLockSwitch.isOn ? "true" : "false"
                        docURL = "save=" + val + docURL
                        print(docURL)
                        let values = ["documentName" : self.documentNameTextField.text!, "uploadedOn" :date, "saveLock" : self.saveLockSwitch.isOn ? "true" : "false", "documentURL" : docURL, "userID" : self.userID!] as [String : AnyObject]
                        
                        
                        self.storeDocumentToDB(values)
                        self.createAlert("Congratulations!", "Document uploaded successfully!")
                        self.resetDoc()
                    }
     
                })
            }
            
        } else if checkIsValid() == 2 {
            createAlert("Missing Fields", "Enter the document name")
        } else if checkIsValid() == 3 {
            createAlert("Document Missing", "Select or Scan Document to save")
        }
        
    }
    
    
    
    
    func checkIsValid() -> Int {
        if documentNameTextField.text == "" {
            return 2
        }else if docDisplay.image == nil {
            return 3
        }
        return 1
    }
    
    func createAlert(_ title : String,_ message : String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
    

