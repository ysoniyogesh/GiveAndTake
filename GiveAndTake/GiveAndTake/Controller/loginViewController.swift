//
//  loginViewController.swift
//  GiveAndTake
//
//  Created by YOGESH SONI on 14/09/22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase


class loginViewController: UIViewController {
    internal var UserEmailid: String = ""
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailId: UITextField!
    
    let db = Firestore.firestore()
    
    @IBAction func logInPressed(_ sender: UIButton) {
        if let email = emailId.text, let password = password.text {
            UserEmailid = email
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
            }
            performSegue(withIdentifier: "LoginToHomeScreen", sender: sender)
        }
    }
}
