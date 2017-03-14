//
//  UserPostViewController.swift
//  VirusAlert
//
//  Created by Rock on 09/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit
import Firebase

class UserPostViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var textShown: UITextView!
    
    @IBOutlet weak var postButton: UIButton!{
        didSet{
            postButton.addTarget(self, action: #selector(postCurrentLocation), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var map: MKMapView!
    
    //---------------------------Constant and Variables----------------------------------
    let ref = FIRDatabase.database().reference()
    let locationManager = CLLocationManager()


    //----------------properties-----------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        
        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textShown.isHidden = true
        postButton.isEnabled = false
        noUid()
    }
    
    
    //---------------------------PostCurrentLocationToFirebase----------------------------
  
    func postCurrentLocation() {
        
        let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
        let lat: Double = (locationManager.location?.coordinate.latitude)!
        let long: Double = (locationManager.location?.coordinate.longitude)! 
        
        ref.child("Location").child(userID).setValue(["Latitude": lat, "Longitude": long])
        print(lat)
        print(long)
    }
    
    //--------------------------------------------------------------------------------------
    
//    func detectedNotLogIn() {
//        let uid = FIRAuth.auth()?.currentUser?.uid
//        
//        if uid == nil {
//            //no user logged in
//            
//            self.postButton.isEnabled = false
//            userNotLogInNotification()
//            
//            return
//        }else {
//            return
//        }
//    }
//    
//    func userNotLogInNotification() {
//        //alert will appear if no user found
//        let alert = UIAlertController(title: "Not Logged In", message: "Please Log In to Post Location", preferredStyle: .alert)
//        
//        //present to login page
//        let loginAction = UIAlertAction(title: "Log In", style: .default) { (action) in
//            
//        }
//        //cancel button in UIAlertController
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//        
//        //input action into UIAlertController
//        alert.addAction(loginAction)
//        alert.addAction(cancelAction)
//        
//        //presenting the alert
//        present(alert, animated:true, completion: nil)
//    }
    
    func presentMainMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController")
        
        navigationController?.present(controller, animated: true, completion: nil)
        }
    
    
    func noUid() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        if uid != nil {
            //user loged in
            textShown.isHidden = true
            postButton.isEnabled = true
        }
        
//        if uid == nil {
//            //no user
//            
//            postButton.isEnabled = false
//            
//        }else {
//            textShown.isHidden = true
//            postButton.isEnabled = true
//            
//        }
//    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        
//        print(location.coordinate)
        
        self.map.showsUserLocation = true
        
    }
    
}
}
