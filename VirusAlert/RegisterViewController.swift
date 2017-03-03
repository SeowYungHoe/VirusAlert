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
    }
    
    func handleSignUp() {
        
        let username = userNameTextField.text
        let email = userRegisterEmailTextField.text
        let password = userRegisterPassTextField.text
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if error != nil{
                print(error! as NSError)
                self.presentPostPage()
                return
            }
            
            let ref = FIRDatabase.database().reference()
            let values = ["username": username, "email": email]
            
            ref.child("user").child(user!.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("err")
                    return
                }
                
                self.presentPostPage()
            })
        })
    }
    
    
    func presentPostPage() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController else {return}
        
        present(controller, animated: true, completion: nil)
    }


}
