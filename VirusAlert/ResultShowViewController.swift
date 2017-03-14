//
//  ResultShowViewController.swift
//  
//
//  Created by Rock on 11/03/2017.



import UIKit

protocol HospitalSwiftDelegate {
    func hospitalAnnotationSwitch(show : Bool)
    func mosquitoAnnotationSwitch(show : Bool)
    func userAnnotationSwitch(show : Bool)
}

class ResultShowViewController: UIViewController{
    
    @IBOutlet weak var hospitalSwitchOutlet: UISwitch!
    @IBOutlet weak var mosquitoSwitchOutlet: UISwitch!
    @IBOutlet weak var userPostedSwitchOutlet: UISwitch!
    
    
    
    
    @IBAction func hospitalSwitch(_ sender: Any) {
        print("@@@1111")
        if let switchButton = sender as? UISwitch {
            
            delegate?.hospitalAnnotationSwitch(show : switchButton.isOn)
            hospitalSwitchOutlet.tintColor = UIColor.red
            
        }
        
    }
    
    @IBAction func mosquitoSwitch(_ sender: Any) {
        print("@@@22222")
        if let switchButton1 = sender as? UISwitch {
            
            delegate?.mosquitoAnnotationSwitch(show: switchButton1.isOn)
            mosquitoSwitchOutlet.tintColor = UIColor.red
        }
        
    }
    
    @IBAction func userPostSwitch(_ sender: Any) {
        print("@@@33333")
        
        if let switchButton2 = sender as? UISwitch{
            
        
        delegate?.userAnnotationSwitch(show: switchButton2.isOn)
            userPostedSwitchOutlet.tintColor = UIColor.red
            
        }
    }
   
    @IBAction func closeButton(_ sender: Any) {
        
    }

    var delegate : HospitalSwiftDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func handleSwitch() {
        delegate?.hospitalAnnotationSwitch(show: true)
    }
    

    
}



