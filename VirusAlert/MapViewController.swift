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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    struct Location {
//        let title: String
        let latitude: Double
        let longitude: Double
    }
    
    var currentLocationCoordinate : CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var currentLocationButtonTapped: UIButton!{
        didSet{
            currentLocationButtonTapped.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        }
    }

    
    @IBOutlet weak var switchAnnotationHospital: UISwitch!{
        didSet{
            switchAnnotationHospital.addTarget(self, action: #selector(hospitalAnnotationSwitch), for: .touchUpInside)

            
        }
    }
    
    @IBOutlet weak var logoutButton: UIBarButtonItem! {
        didSet {
            handleLogout()
        }
    }
    
    
    
    var dengueLatAndLong = [
        Location(latitude: 3.135, longitude: 101.63),
        Location(latitude: 3.1308, longitude: 101.627)
    ]
    

    var hospitalAnnotationArray: [MKAnnotation] = []

    
    
    var locationManager = CLLocationManager()
    var isInitialized = false
    var hospitalLocation : [Hospital] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     fetchAllHospital()
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true

        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    func hospitalAnnotationSwitch(){
        
        if switchAnnotationHospital.isOn == true {
            fetchAllHospital()
        }else{
            self.mapView.removeAnnotations(hospitalAnnotationArray)
        }
      
      
    }
    
    //---------------------------------------- LOCATIONS ------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
                if !isInitialized {
        
                isInitialized = true
        
//        let location = self.locationManager.location!
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        currentLocationCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(currentLocationCoordinate!, span)
        mapView.setRegion(region, animated: true)
//        self.mapView.showsUserLocation = true
//        locationManager.stopUpdatingLocation()
        
        dengueLocation()
        // here fetch
        }
        
    }
    
    
    func getCurrentLocation(){
        
        let location = self.locationManager.location?.coordinate
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        currentLocationCoordinate = CLLocationCoordinate2DMake(location!.latitude, location!.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(currentLocationCoordinate!, span)
        mapView.setRegion(region, animated: true)
        
    }
    
    //------------------------------------- FETCHING INFORMATION ------------------------------------
    
    func fetchAllHospital() {
        

        
        let url = "https://api.foursquare.com/v2/venues/search?client_id=JBNXRUDYIBJP1MGSLXH2UOAFX3M0YZK3CVVINQE3OLK1R2CX%20&client_secret=0NIZEJGP0Q1YQCD0OOBBYI4TYEHWTDNOKT0P4GF4BOIDYTNL%20&v=20130815%20&near=%20Kuala+Lumpur%20&query=hospital"
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var tempHospital : [Hospital] = []
                
                
                if let hospitals = json["response"]["venues"].array {
                    for hospital in hospitals {
                        
                        let newHospital = Hospital(json: hospital)
                        tempHospital.append(newHospital)
                        
                        self.hospitalLocation = tempHospital
                        dump (self.hospitalLocation)
                        
                        
                        for hospital in self.hospitalLocation{
                            
                            let hospAnnotation = CustomPointAnnotation()
                            hospAnnotation.coordinate = CLLocationCoordinate2DMake(hospital.latitude!, hospital.longitude!)
                            hospAnnotation.title = hospital.name
                            hospAnnotation.image = "hospital"
                            self.mapView.addAnnotation(hospAnnotation)
                            self.hospitalAnnotationArray.append(hospAnnotation)

                           
                            
                        
                        
                        }
                    
                        
                    }
                    
                    
                }
            
            case .failure(let error):
                print(error)
            }
        }
    

    }
    
//    func filterAnnotation(){
//        for annot in mapView.annotations {
//            annot.
//        }
//    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        ;
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //-------------------------------------Annotation Related-----------------------------------------------
    
    
    
    func dengueLocation(){
        
        for location in dengueLatAndLong {
            let dengueAnnotation = CustomPointAnnotation()
//            dengueAnnotation.title = location.title
            dengueAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            dengueAnnotation.image = "mosquito"
            
            let dengueLoc = CLLocation(latitude: location.latitude, longitude: location.longitude)


            if let currentLocation = currentLocationCoordinate {
                
                
                var myLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                var distanceFromDengue = myLocation.distance(from: dengueLoc) / 1000
                
                dengueAnnotation.title = "Distance from dengue (in KM):\(distanceFromDengue)KM"

                mapView.addAnnotation(dengueAnnotation)
            }
            
        }
        
    }
    let annotationIdentifier = "aaa"
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named:customPointAnnotation.image)
        
        return annotationView
        

    }
    
    }

//------------------------------------------TESTING ZONE----------------------------------------------


//                        for hospital in self.hospitalLocation{
//                            let hospAnnotation = MKPointAnnotation()
//
//                            hospAnnotation.coordinate = CLLocationCoordinate2DMake(hospital.latitude!, hospital.longitude!)
//
//                            hospAnnotation.title = "\(hospital.name)"
////                            hospAnnotation.image = "hospital"
//
//                            self.mapView.addAnnotation(hospAnnotation)
//
//
//                        }
