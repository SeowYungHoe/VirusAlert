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
        let title: String
        let latitude: Double
        let longitude: Double
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var currentLocationButtonTapped: UIButton!{
        didSet{
            
            currentLocationButtonTapped.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
            
        }
    }
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBAction func logOutTapped(_ sender: Any) {
        handleLogout()
    }
    
    
    
    var pinAnnotationView:MKPinAnnotationView!
    
    var dengueLatAndLong = [
        Location(title: "Glomac Damansara",    latitude: 3.135, longitude: 101.63),
        Location(title: "Tropicana City Mall", latitude: 3.1308, longitude: 101.627)
    ]
    
    
    
    
    var locationManager = CLLocationManager()
    //    var isInitialized = false
    var hospitalLocation : [Hospital] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllHospital()
        dengueLocation()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
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
//        self.mapView.showsUserLocation = true
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
                            
                           
                            
                        }

                        
                        
                        
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
                        
                    }
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        }
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
    
    //-------------------------------------Annotation Related-----------------------------------------------
    
      
    
    func dengueLocation(){
        
        for location in dengueLatAndLong {
            let dengueAnnotation = CustomPointAnnotation()
            dengueAnnotation.title = location.title
            dengueAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            dengueAnnotation.image = "mosquito"
            mapView.addAnnotation(dengueAnnotation)
            
            //            hospitalAnnotation.title = location.title
            //            hospitalAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            //            mapView.addAnnotation(hospitalAnnotation)
        }
        
    }
    let annotationIdentifier = "o0o"
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



