//
//  RegisterViewController.swift
//  VirusAlert
//
//  Created by Rock on 01/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference!
    
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userRegisterEmailTextField: UITextField!
    @IBOutlet weak var userRegisterPassTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!{
        didSet{
                signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gifView.loadGif(name: "dna")
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "endKeyBoard")
        
        view.addGestureRecognizer(tap)
        
    }
    
    func handleSignUp() {
        
        let username = userNameTextField.text
        let email = userRegisterEmailTextField.text
        let password = userRegisterPassTextField.text
        
        
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if error != nil{
                print(error! as NSError)
                //if user input error/mising info this pop up will appear. (userDidNotFillUp)
                self.userDidNotFillUp()
                return
            }
            
            let ref = FIRDatabase.database().reference()
            let values = ["username": username, "email": email]
            self.succesfullSignUp()
            ref.child("user").child(user!.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("err")
                    return
                    }                
                })
            })
    }

    func presentPostPage() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController else {return}
        
        present(controller, animated: true, completion: nil)
    }
    
    func userDidNotFillUp() {
        //alert will appear if no user found
        let alert = UIAlertController(title: "Fail to Create", message: "Missing Info / Detail not Fill in correctly", preferredStyle: .alert)
        
        //present to login page
        let okAction = UIAlertAction(title: "Okay", style: .default)
        
        //input action into UIAlertController
        alert.addAction(okAction)
   
        
        //presenting the alert
        present(alert, animated:true, completion: nil)
    }
    
    func succesfullSignUp(){
        
        let alert = UIAlertController(title: "Successlly Signup", message: "You've successfully sign up your account", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okAction)
        present(alert, animated:true, completion: nil)
    }
    
    func endKeyBoard() {
        view.endEditing(true)
    }



}
