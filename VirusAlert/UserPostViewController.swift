//
//  UserPostViewController.swift
//  VirusAlert
//
//  Created by Rock on 09/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserPostViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!{
        didSet{
            logOutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detectedNotLogIn()
    }
    
    func detectedNotLogIn() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        if uid == nil {
            //self.postButton.isEnabled = false
            userNotLogInNotification()
            
            return
        }else {
            return
        }
    }
    
    func userNotLogInNotification() {
        //alert will appear if no user found
        let alert = UIAlertController(title: "Not Logged In", message: "Please Log In to Post Location", preferredStyle: .alert)
        
        //present to login page
        let loginAction = UIAlertAction(title: "Log In", style: .default) { (action) in
            
            //code(applying the function below)
            self.presentLogInPage()
        }
        //cancel button in UIAlertController
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        //input action into UIAlertController
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        
        //presenting the alert
        present(alert, animated:true, completion: nil)
    }
    
    func presentLogInPage() {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        navigationController?.pushViewController(controller, animated: true)
        }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        ;
        self.dismiss(animated: true, completion: nil)
        
    }

}
