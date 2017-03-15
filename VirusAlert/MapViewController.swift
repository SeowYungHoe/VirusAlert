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
import Firebase


protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)    
}


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, HospitalSwiftDelegate {
    
    struct Location {
//        let title: String
        let latitude: Double
        let longitude: Double
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var currentLocationButtonTapped: UIButton!{
        didSet{
            currentLocationButtonTapped.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        }
    }

    
//    @IBOutlet weak var switchAnnotationHospital: UISwitch!{
//        didSet{
//            switchAnnotationHospital.addTarget(self, action: #selector(hospitalAnnotation), for: .touchUpInside)
//
//            
//        }
//    }
    
    
    
    //---------------------------------- Constant And Variables -----------------------------
    var hospitalAnnotationArray: [MKAnnotation] = []
    var dengueAnnotationArray: [MKAnnotation] = []
    var userPostedAnnotationArray: [MKAnnotation] = []


    var locationManager = CLLocationManager()
    //rock's
    var resultSearchController:UISearchController? = nil
    var selectedPin : MKPlacemark? = nil
    var hospitalLocation : [Hospital] = []
    var currentLocationCoordinate : CLLocationCoordinate2D?
    var posts: [UserPosted] = []


  //-----------------------------------------------------------------------------------------
    
   
    @IBOutlet weak var openButton: UIBarButtonItem!
    
    
    var sideVC : ResultShowViewController!
    var isShow = false
    
    @IBAction func openButtonTapped(_ sender: Any) {
    
        //if sideVC = empty
        if sideVC == nil {
            //get menu
            let targetStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let vc = targetStoryboard.instantiateViewController(withIdentifier: "ResultShowViewController") as? ResultShowViewController {
                sideVC = vc
                sideVC.view.frame = CGRect.zero
            } else {
                return
            }
            
        }
        
        if isShow {
            //dismiss
            
            UIView.animate(withDuration: 0.5, animations: { 
                self.sideVC.view.frame.size = CGSize.zero
            }, completion: { (bool) in
                self.sideVC.removeFromParentViewController()
                self.sideVC.view.removeFromSuperview()
            })
            
            
            
            //mapView.frame.origin = CGPoint.zero
            
        } else {
            //display
            
            //init secondView
            self.view.addSubview(self.sideVC.view)
//            self.addChildViewController(self.sideVC)
            
            UIView.animate(withDuration: 0.5, animations: {

        
            self.sideVC.view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width / 1.8, height: self.view.frame.height))
                
            }, completion: { (bool) in
              
                self.sideVC.delegate = self
                
                //self.view.addSubview(self.sideVC.view)
                self.addChildViewController(self.sideVC)
                
                self.sideVC.didMove(toParentViewController: self)
            })
            
            //mapView.frame.origin = mapView.frame.origin.applying(CGAffineTransform(translationX: view.frame.width / 2, y: 0))
            
            
            
            
            
            
        }
        
        isShow = !isShow
        
        
       
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        getCurrentLocation()
        fetchAllHospital()
        dengueLocation()
        
        //----------------------rock's start-----------------------
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "TableViewResultDisplay") as! TableViewResultDisplay
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        //resultSearchController?.delegate = self
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self

        //------------------------rock's end----------------------
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                fetchUserPostedDengue()
        
        self.mapView.removeAnnotations(self.userPostedAnnotationArray)
        
        
fetchUserPostedDengue()
        
    }
    

    
 
    func hospitalAnnotationSwitch(show: Bool) {
        print("@@@@4444")
        if show {
            print("show Hospital")
            fetchAllHospital()
        }else{
            print("hide Hospital")
            self.mapView.removeAnnotations(hospitalAnnotationArray)
            
            
        }
    }
    
    
    func mosquitoAnnotationSwitch(show: Bool){
        print("@@@55555")
        if show {
            print("show Hospital")
            dengueLocation()
        }else{
            print("hide Hospital")
            self.mapView.removeAnnotations(dengueAnnotationArray)
    
            for overl in mapView.overlays{
                mapView.remove(overl)

            }
        }
    }
    
    func userAnnotationSwitch(show : Bool){
        print("@@@@@55555")
        if show {
            print("show user post")
            fetchUserPostedDengue()
        }else{
            self.mapView.removeAnnotations(userPostedAnnotationArray)
        }
        
        }
    
    
    //---------------------------------------- LOCATIONS ------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        currentLocationCoordinate = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        
        //Dengue Annotation Title Update
        self.mapView.showsUserLocation = true
        //fetchUserPostedDengue()

        

        
    }
    
    
    func getCurrentLocation(){
        
        guard let location = self.locationManager.location?.coordinate else {return}
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        currentLocationCoordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(currentLocationCoordinate!, span)
        mapView.setRegion(region, animated: true)
        
    }
    
    
    //------------------------rock's start---------------------------
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestLocation()
            getCurrentLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    //-------------------------rock's end-----------------------------
    
    

    
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
                        
                        for hospital in self.hospitalLocation{
                            
                            let hospAnnotation = CustomPointAnnotation()
                            hospAnnotation.coordinate = CLLocationCoordinate2DMake(hospital.latitude!, hospital.longitude!)
                            hospAnnotation.title = hospital.name
                            hospAnnotation.image = "hospital48"
                            hospAnnotation.anotationType = .hospital
                            
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
    
    //waze function
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
//        if let annot = view.annotation {
//            navigateWithWaze(lat: annot.coordinate.latitude, lon: annot.coordinate.longitude)
//        }
        
        
        guard let annott =  view.annotation as? CustomPointAnnotation else {
            return
        }
        
        switch annott.anotationType {
        case .hospital:
            
            if let annot = view.annotation {
                navigateWithWaze(lat: annot.coordinate.latitude, lon: annot.coordinate.longitude)
            }
            
        default:
            break
        }
        
       
    }
    
    
    

    
    
    func navigateWithWaze(lat : Double, lon : Double){

        let url = "waze://?ll=\(lat),\(lon)&navigate=yes"
        open(scheme: url)
        
        let wazeURL = NSURL(string: "waze://")
        
        if UIApplication.shared.canOpenURL(wazeURL as! URL){
            
            open(scheme: url)
        }else{
            open(scheme: "https://itunes.apple.com/us/app/id323229106")
        }
    }
    
    
    
//if there's waze they'll open waze if no waze will go to appstore.
    
    func open(scheme: String, otherSchemeIfFail secondScheme: String? = nil) {
        if let url = URL(string: scheme) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in
                    if !success,
                        let secondUrl = secondScheme {
                        self.open(scheme: secondUrl)
                    }
                })
            } else {
                // Fallback on earlier versions
                let success = UIApplication.shared.openURL(url)
                if !success,
                    let secondUrl = secondScheme
                {
                    open(scheme: secondUrl)
                }
            }
        }
    }

    
    func fetchUserPostedDengue() {

        let ref = FIRDatabase.database().reference()
        
        
        ref.child("Location").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            
            guard let snapValues = snapshot.value as? NSDictionary else { return }
            
            var tempPost : [UserPosted] = []
            for (_, value) in snapValues {
                
                if let postDictionary = value as? [String: Any] {
                    
                    let newPost = UserPosted(withDictionary: postDictionary)
                    tempPost.append(newPost) //save it to temporary channel
                }
            }

            self.posts = tempPost
            for userPost in self.posts {
                
                let userPostedAnnotation = CustomPointAnnotation()
                userPostedAnnotation.coordinate = CLLocationCoordinate2DMake(userPost.latitude!, userPost.longitude!)
                userPostedAnnotation.image = "userPostedSick"
                userPostedAnnotation.anotationType = .userPosted
                self.userPostedAnnotationArray.append(userPostedAnnotation)
                
                self.mapView.addAnnotation(userPostedAnnotation)
      

//                self.mapView.removeAnnotations(self.userPostedAnnotationArray)
//                self.mapView.addAnnotation(userPostedAnnotation)

                
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
    
    //-------------------------------------Annotation Related-----------------------------------------------

    
    
    func dengueLocation(){
        
        for location in dengueLatAndLong {
            
            let dengueAnnotation = CustomPointAnnotation()
            dengueAnnotation.anotationType = .dengue
            dengueAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            dengueAnnotation.image = "mosquito"
            
            let dengueLoc = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let loc = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            

            dengueAnnotation.title = "a"
            
            self.dengueAnnotationArray.append(dengueAnnotation)
            self.mapView.addAnnotation(dengueAnnotation)
            self.mapView.add(MKCircle(center: loc, radius: 150))
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
        guard let selectedAnnotation =  view.annotation as? CustomPointAnnotation else {
            return
        }
        
        switch selectedAnnotation.anotationType {
        case .dengue:
            
            guard let locationz = self.locationManager.location?.coordinate else {return}
            let myLocation = CLLocation(latitude: (locationz.latitude), longitude: locationz.longitude)
            let dengueLoc = CLLocation(latitude: selectedAnnotation.coordinate.latitude, longitude: selectedAnnotation.coordinate.longitude)
                let distanceFromDengue = myLocation.distance(from: dengueLoc)
                print(distanceFromDengue)
                selectedAnnotation.title = "\(distanceFromDengue.roundTo(places: 2))Meter Away"
            
        default:
            break
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
            
            //callout button
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
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
    

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let overlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor.red
            circleRenderer.alpha = 0.1
            return circleRenderer
        }
        else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    

    
    //------------------------------Dengue Longitude and Latitude------------------------------------
    var dengueLatAndLong = [
        Location(latitude: 3.135, longitude: 101.63),
        Location(latitude: 3.145733, longitude: 101.688906),
        Location(latitude: 3.1308, longitude: 101.627),
        Location(latitude: 3.1308, longitude: 101.631),
        Location(latitude: 3.1363, longitude: 101.620),
        Location(latitude: 3.1333, longitude: 101.619),
        Location(latitude: 3.1435, longitude: 101.615),
        Location(latitude: 3.133, longitude: 101.609),
        Location(latitude: 3.154, longitude: 101.625),
        Location(latitude: 3.157, longitude: 101.712),
        Location(latitude: 3.073, longitude: 101.607),
        Location(latitude: 3.153, longitude: 101.615),
        Location(latitude: 3.178, longitude: 101.691),
        Location(latitude: 3.185, longitude: 101.706),
        Location(latitude: 3.153, longitude: 101.692)


    ]
    
}


//-------------------------rock's function's zone-------------------------
extension MapViewController : HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        //cache the pin
        selectedPin = placemark
        //clear existing pins on the map. this feature ensure dealing with ONE ANNOTATION PIN ON THE MAP AT A TIME.
        
        //--------below code are to remove all annotation--------
        //mapView.removeAnnotations(mapView.annotations)
        
        //MKPointAnnotation contains coordinate, title and subtitle, has similar information like coordinates and address info
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city)(state)"
        }
        
        //--------below is to add annotation on the map search--------------
        //mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        //this allows map to zoom to the coordinate
        mapView.setRegion(region, animated: true)
    }
}



extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

