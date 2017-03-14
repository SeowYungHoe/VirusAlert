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
import FBSDKLoginKit

class PostViewController: UIViewController {



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customFbButton = UIButton(type: .system)
        customFbButton.backgroundColor = UIColor.blue
        customFbButton.frame = CGRect(x: 60, y: 436, width: 280, height: 40)
        customFbButton.setTitle("FaceBook Login", for: .normal)
        view.addSubview(customFbButton)
        
        customFbButton.addTarget(self, action: #selector(handleCustomeFBLogin), for: .touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detectedNotLogIn()
    }
    
    func handleCustomeFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public profile"], from: self) { (result, error) in
            if error != nil {
                print("fb log in failed", error)
                return
            }
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
                
                if error != nil{
                    print("Failed to start graph request:", error ?? "")
                    return
                }
            }
        }
    }
    
    
        

    
    //if user not log in pop up message will appear
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
    
    
    
    //user not detected 
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
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        ;
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //check user logining in with fb or email
    func displayUserLogInWith() {
        if let providerData = FIRAuth.auth()?.currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("user is signed in with facebook")
                default:
                    print("user is signed in with \(userInfo.providerID)")
                }
            }
        }
    }

}
