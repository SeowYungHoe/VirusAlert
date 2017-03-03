//
//  PostViewController.swift
//  VirusAlert
//
//  Created by Rock on 01/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PostViewController: UIViewController {
    
    var displayNameInLabel : String?

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var inputAddressTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detectedNotLogIn()
    }
    
//    func displayUserName() {
//        let ref = FIRDatabase.database().reference()
//        
//        let uid = FIRAuth.auth()?.currentUser?.uid
//        
//        ref.child("username").child(uid!).observe(.value) { (snapshot) in
//            
//            print(snapshot)
//            
//            let value = snapshot.value as? NSDictionary
//            let displayName = value?["name"] as? String ?? ""
//            
//            self.displayNameInLabel = displayName
//            self.usernameLabel.text = self.displayNameInLabel
//        }
//        
//    }
    
    func detectedNotLogIn() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        //detected user not logged in.
        if uid == nil {
            self.postButton.isEnabled = false
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
    // present to loginPage function
    func presentLogInPage() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}

        navigationController?.pushViewController(controller, animated: true)
    }


}
