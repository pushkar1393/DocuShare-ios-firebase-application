//
//  SignUpViewController.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/5/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var userID : String?

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        genderPicker()
        createToolbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
    
    // reset fields
    func resetFields() {
        firstNameTextField.text=""
        lastNameTextField.text=""
        genderTextField.text=""
        dateOfBirthTextField.text=""
        emailTextField.text=""
        usernameTextField.text=""
        passwordTextField.text=""
    }
    
    @IBAction func btnSignUpPressed(_ sender: Any) {
        addUserAccountandLogin()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // function to add authenticated user to firebase
    func addUserAccountandLogin(){
        if checkIsValid()==1 {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
            (user,error) in

            if error != nil {
                self.createAlert("User not added","Something went wrong with the details!")
            } else {

                print(user!.uid)
                self.userID = user!.uid
                let ref = Database.database().reference(fromURL: "https://docushare-documents-on-the-go.firebaseio.com/")
                let individual_ref = ref.child("userList").child(user!.uid)
                individual_ref.updateChildValues(["firstName": self.firstNameTextField.text!,
                                                  "lastName": self.lastNameTextField.text!,
                                                  "sex": self.genderTextField.text!,
                                                  "dateOfBirth": self.dateOfBirthTextField.text!,
                                                  "email": self.emailTextField.text!,
                                                  "userName": self.usernameTextField.text!,
                                                  "userProfilePictureURL" : ""])

                self.loginUser();
            }
        })
        } else if checkIsValid() == 2 {
            self.createAlert("Empty fields","Please enter all fields!")
        }
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) {
            (user,error) in
            if user != nil {
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "isUserLoggedin")
                defaults.synchronize()
                self.userID = user?.uid
                self.performSegue(withIdentifier: "toUserProfileFromSignUp", sender: self)

            } else {
                self.createAlert("Invalid Credentials", "Please enter valid credentials")
            }
        }
    }
    
    // function to perform field validations
    func checkIsValid() -> Int {
        if firstNameTextField.text == "" || lastNameTextField.text == "" || genderTextField.text == "" || dateOfBirthTextField.text == "" || emailTextField.text == "" || usernameTextField.text == "" || passwordTextField.text == "" {
            return 2
        }
        return 1;
    }
    
    
    
    // function to pop up an alert
    func createAlert(_ title : String,_ message : String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {}
    }

    
    // select gender picker
    func genderPicker() {
        let genderpicker = UIPickerView()
        genderpicker.delegate = self
        genderTextField.inputView = genderpicker
    }

    
    // create tooblar for pickerview
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barTintColor = .white
        toolBar.tintColor = UIColor.blue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SignUpViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        genderTextField.inputAccessoryView = toolBar
        dateOfBirthTextField.inputAccessoryView = toolBar
    }
    
    
    // dismiss keyboard on lost focus
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //to  setup object for next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        if let viewUser = segue.destination as? UserTabBarController {
            viewUser.userID = userID
        }
        
    }
    
    //function to implement datepicker
    
    @IBAction func txtDateEdit(_ sender: Any) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        dateOfBirthTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(SignUpViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yyyy"
        dateOfBirthTextField.text = dateFormatter.string(from: sender.date)
    }
    
}




extension SignUpViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return User.genderList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return User.genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = User.genderList[row]
    }
    
}
