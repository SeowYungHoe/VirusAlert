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
import FirebaseDatabase
import FBSDKLoginKit
import SwiftyJSON
import Alamofire

class LoginViewController: UIViewController {

    var FIRef : FIRDatabaseReference!
    
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var fbsdkLogin: FBSDKLoginButton!{
        didSet{
            fbsdkLogin.delegate = self
            //if it doesnt show email at first, apply this and specifically name the item that you would like it to be printed out.
            fbsdkLogin.readPermissions = ["email"]
            fbsdkLogin.layer.borderWidth = 1
            fbsdkLogin.layer.cornerRadius = 5
            fbsdkLogin.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var loginButtonEmail: UIButton! {
        didSet {
            loginButtonEmail.addTarget(self, action: #selector(login), for: .touchUpInside)
            loginButtonEmail.layer.borderWidth = 1
            loginButtonEmail.layer.cornerRadius = 5
            loginButtonEmail.layer.masksToBounds = true
                    }
    }
    
    @IBOutlet weak var logOutButton: UIButton!{
        didSet{
        logOutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        }
    }
        
    @IBOutlet weak var registerButton2: UIButton!{
        didSet{
            registerButton2.layer.borderWidth = 1
            registerButton2.layer.cornerRadius = 5
            registerButton2.layer.masksToBounds = true
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {return}
        
        navigationController?.pushViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /////////////hideLogOutButton()
        
        logOutButton.isHidden = true
        logOutButton.isHidden = true
       
        
        ////////////hideLogOutButton()
        
        FIRef = FIRDatabase.database().reference()
        
        //dismiss keyboard when tap els where
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "endKeyBoard")
        view.addGestureRecognizer(tap)
        
        displayUserLogInWith()
        
        //dada()
        
    }
    
    //displaying the toolbar black
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //displayUserLogInWith()
        //hideLogOutButton()
    }
    
    func login() {
        FIRAuth.auth()?.signIn(withEmail: userEmail.text!, password: userPassword.text!, completion: { (user, error) in
            if error != nil {
                print(error! as NSError)
                self.failToLogInNoti()
                print("failed to log in")
                return
            }else{
                print("successfully log in")
                self.successfullLogInNoti()
                self.loginButtonEmail.isHidden = true
                self.registerButton2.isHidden = true
                self.fbsdkLogin.isHidden = true
                self.logOutButton.isHidden = false
                
            }
            
        })
        
    }
    
    func successfullLogInNoti() {
        let alert = UIAlertController(title: "Log In Successfully", message: "You've Successfully Logged In", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okayAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func failToLogInNoti(){
        let failAlert = UIAlertController(title: "Log In Failed", message: "Please Try Again", preferredStyle: .alert)
        
        let okayAction1 = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        failAlert.addAction(okayAction1)
        
        present(failAlert, animated: true, completion: nil)
    }
    
    
    
    func successfullyLogOutNoti() {
        let logOutAlert = UIAlertController(title: "Log Out Successfully", message: "Successfully Logged Out", preferredStyle: .alert)
        
        let done = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        logOutAlert.addAction(done)
        
        present(logOutAlert, animated: true, completion: nil)
        
        loginButtonEmail.isHidden = false
        registerButton2.isHidden = false
    }
    
    
    //this function is to display is user using facebook to log in or email to log in
    func displayUserLogInWith() {
        if let providerData = FIRAuth.auth()?.currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("user is signed in with facebook")
                    
                            logOutButton.isHidden = true
                            registerButton2.isHidden = true
                            loginButtonEmail.isHidden = true

                    
                default:
                    print("user is signed in with \(userInfo.providerID)")
                    
                    fbsdkLogin.isHidden = true
                    logOutButton.isHidden = false
                }
            }
        }
    }
    
}
extension LoginViewController : FBSDKLoginButtonDelegate {
   
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        handleLogout()
        
        print("Did log out from FB")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        
        //try 2 hiding buttons
        showLogInFB()
        successfullLogInNoti()
//        logOutButton.isHidden = true
//        registerButton2.isHidden = true
//        loginButtonEmail.isHidden = true
    }
    
    func showLogInFB() {
        
        //token provided by facebook
        let accessToken = FBSDKAccessToken.current()
    
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        
        //firebase facebook login (has to enable FB login from FireB)
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil{
                print("something went wrong",error ?? "")
                return
            }
            
            print("success logged in with user", user ?? "")
            
//            self.loginButtonEmail.isHidden = true
//            self.registerButton2.isHidden = true
            
            
            
        

        
        //below part is to get information from facebook.
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
            
        let userReference = ref.child("user").child(uid!)
           
        //FBSDKGraphRequest is to request to get infromation from FB. In this feature we are requesting for id, name and also email add.
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            
            if error != nil{
                print("Failed to start graph request:", error ?? "")
                
            }else{
                
                //this part is if successfully fetch information from FB it will generate it from the dictionary into our firebase
                print("fetched user: \(result)")
                
                let values: [String : Any] = result as! [String : Any]
                
                userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    print("saved user info successfully into firebase")
                })
            }
            }
        })
    }
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
            //past popup here to show user that hi's already logged out
            successfullyLogOutNoti()
            fbsdkLogin.isHidden = false
            logOutButton.isHidden = true
            
        }catch let logoutError {
            
            print(logoutError)
        }
        
    }
    
    func endKeyBoard() {
        view.endEditing(true)
    }
    
//    func hideLogOutButton(){
//        
//        let ref = FIRDatabase.database().reference()
//        
//        let uid = FIRAuth.auth()?.currentUser?.uid
//        
//        if uid != nil {
//        
//        ref.child("username").child(uid!).observe(.value, with: { (snapshot) in
//            print(snapshot)
//            
//            guard let value = snapshot.value as? NSDictionary else {return}
//            
//            let id = value["id"]
//            
//            if  id != nil {
//                //user loging in with fb 
//                
//                self.loginButtonEmail.isHidden = true
//                self.registerButton2.isHidden = true
//            }
//            
//        })
//        }else{
//            
//        }
//    }
    
//    func dada(){
//        
//        let uid = FIRAuth.auth()?.currentUser?.uid
//
//        if uid != nil {
//
//        logOutButton.isHidden = false
//        registerButton2.isHidden = false
//        loginButtonEmail.isHidden = false
//    }
//    }
}


        
            //user log in
            
//            loginButton.isHidden = true
//            registerButton2.isHidden = true
//            logOutButton.isHidden = true
//        }else{
//            // user not log in
//            
//            logOutButton.isHidden = true
//            return
//        }
//    }


