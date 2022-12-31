//
//  registerViewController.swift
//  GiveAndTake
//
//  Created by YOGESH SONI on 14/09/22.
//

import Foundation
import UIKit

import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

      
class registerViewController: UIViewController, UITextFieldDelegate {

    let db = Firestore.firestore()
    
    var dataSource = DataSource()
    
    var fname: String = ""
    var lname: String = ""
    var email: String = ""
    var password: String = ""
    var state: String = ""
    var pinCode: Int  = 0
    
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var pinCodeField: UITextField!
    @IBOutlet weak var statePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.dataSource = self
        statePicker.delegate = self
    }
    
   
    @IBAction func registerPressed(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text, var fname = firstNameField.text, let lname = lastNameField.text, let pinCode = pinCodeField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                let user = Auth.auth().currentUser
                if let user = user {
                  let uid = user.uid
                    print(uid)
                    
             // Add a new document in collection "users"
                    db.collection("users").document(uid).setData([
                        "First Name":  fname,
                        "Last Name": lname,
                        "email Id": email,
                        "State": state,
                        "Pin Code": pinCode
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            print(fname)
                            performSegue(withIdentifier: "registerToLogin", sender: sender)
                        }
                    }
                } // user bracket ends
            }
        }
    }
}

//MARK: UIPickerViewDataSource
extension registerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { // put the no. of columns we want in PickerView
        return 1
    }
    
    // put the no. of rows we want in PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.state.count
    }
}
    
//MARK: UIPickerViewDelegate
extension registerViewController: UIPickerViewDelegate {
    // jab pickerView chlata  h to sbse pehli row ka title mangta h ..so vo title hum is function se provide kra rhe h ise.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource.state[row]
    }
    
    // when user selects a row in pickerView then this function will be triggered. i.e -> didSelectRow which is Row no.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        state = dataSource.state[row]
        
    }
}
