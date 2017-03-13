//
//  ResultShowViewController.swift
//  
//
//  Created by Rock on 11/03/2017.



import UIKit

protocol HospitalSwiftDelegate {
    func hospitalAnnotationSwitch()
}

class ResultShowViewController: UIViewController{
    
    
    @IBAction func hospitalSwitch(_ sender: Any) {
        print("@@@1111")
        delegate?.hospitalAnnotationSwitch()
    }
    
    @IBAction func mosquitoSwitch(_ sender: Any) {
        print("@@@22222")
        delegate?.hospitalAnnotationSwitch()
    }
    
    @IBAction func userPostSwitch(_ sender: Any) {
        print("@@@33333")
        delegate?.hospitalAnnotationSwitch()
    }
   

    var delegate : HospitalSwiftDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func handleSwitch() {
        delegate?.hospitalAnnotationSwitch()
    }


}
