//
//  ViewController.swift
//  GiveAndTake
//
//  Created by YOGESH SONI on 11/09/22.
//

import UIKit

class ViewController: UIViewController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    @IBAction func registerPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "mainToRegister", sender: sender)
    }
    
    
    @IBAction func logInPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "mainToLogin", sender: sender)
    }
}

