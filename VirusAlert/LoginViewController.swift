//
//  LoginViewController.swift
//  VirusAlert
//
//  Created by Rock on 01/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var fbsdkLogin: FBSDKLoginButton!
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var fbsdkButton: FBSDKButton!
    
    @IBAction func registerButton(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {return}
        
        navigationController?.pushViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func login() {
        FIRAuth.auth()?.signIn(withEmail: userEmail.text!, password: userPassword.text!, completion: { (user, error) in
            if error != nil {
                print(error! as NSError)
                print("successfull log in")
                return
            }
            
            
            
            
            self.presentPostPage()
            
        })
        
    }
    
    func presentPostPage() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController else {return}
        
        present(controller, animated: true, completion: nil)
        
   
    }
    
//    func loadHomePage(){
//        let virusMapPage = CustomTabBarController()
//        present(virusMapPage, animated:true, completion: nil)
//        
//        //        present(virusMapPage, animated: true, completion: nil)
//    }



}
