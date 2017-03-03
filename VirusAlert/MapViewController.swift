//
//  MapViewController.swift
//  VirusAlert
//
//  Created by Seow Yung Hoe on 01/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import FirebaseAuth

class MapViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIBarButtonItem! {
        didSet {
            handleLogout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    
    }
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }



}




