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
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
            loginButton.layer.borderWidth = 1
            loginButton.layer.cornerRadius = 5
            loginButton.layer.masksToBounds = true
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
        
        FIRef = FIRDatabase.database().reference()
        
        gifView.loadGif(name: "micro")
        
        hideLogOutButton()
        
        
        
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "endKeyBoard")
        
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayUserLogInWith()

    }
    
    func login() {
        FIRAuth.auth()?.signIn(withEmail: userEmail.text!, password: userPassword.text!, completion: { (user, error) in
            if error != nil {
                print(error! as NSError)
                print("successfull log in")
                return
            }
            
        })
        
    }
    
    func presentPostPage() {
        let storyboard = UIStoryboard(name: "Statistics", bundle: Bundle.main)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "UserPostViewController")
        
        let  _ = navigationController?.popViewController(animated: false)
        //navigationController?.pushViewController(controller, animated: true)
        
        //present(controller, animated: true, completion: nil)
    }
    
    //this function is to display is user using facebook to log in or email to log in
    func displayUserLogInWith() {
        if let providerData = FIRAuth.auth()?.currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("user is signed in with facebook")
                    loginButton.isHidden = true
                    logOutButton.isHidden = true
                    registerButton2.isHidden = true
                    
                    
                default:
                    print("user is signed in with \(userInfo.providerID)")
                    fbsdkLogin.isHidden = true
                    loginButton.isHidden = true
                    registerButton2.isHidden = true
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
       
        showLogInFB()
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
        }catch let logoutError {
            print(logoutError)
        }
        ;
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func endKeyBoard() {
        view.endEditing(true)
    }
    
    func hideLogOutButton(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        if uid == nil {
            logOutButton.isHidden = true
        }
    }
}


