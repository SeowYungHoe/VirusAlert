//
//  MapViewController.swift
//  VirusAlert
//
//  Created by Seow Yung Hoe on 01/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import CoreLocation
import FirebaseAuth

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var currentLocationButtonTapped: UIButton!{
        didSet{
            
            currentLocationButtonTapped.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
            
        }
    }
    
    @IBOutlet weak var logoutButton: UIBarButtonItem! {
        didSet {
            handleLogout()
        }
    }

    var locationManager = CLLocationManager()
//    var isInitialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAllHospital()
        
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
      
        
        
    }

    


    
    //---------------------------------------- LOCATIONS ------------------------------------------------

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        if !isInitialized {
//            
//        isInitialized = true
        
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
        


            
        }
    

    
    func getCurrentLocation(){
    
        locationManager.startUpdatingLocation()
        
    }

    //------------------------------------- FETCHING INFORMATION ------------------------------------

    func fetchAllHospital() {
        
        let url = "https://api.foursquare.com/v2/venues/search?client_id=JBNXRUDYIBJP1MGSLXH2UOAFX3M0YZK3CVVINQE3OLK1R2CX%20&client_secret=0NIZEJGP0Q1YQCD0OOBBYI4TYEHWTDNOKT0P4GF4BOIDYTNL%20&v=20130815%20&near=%20Kuala+Lumpur%20&query=hospital"
    
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let hospitals = json["response"]["venues"].array {
                    for hospital in hospitals {
                        let newHospital = Hospital(json: hospital)
                        Hospital.allHospital.append(newHospital)
                        print (newHospital)
                    }
                }
            case .failure(let error):
                print(error)
            }
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

//---------------------------------




