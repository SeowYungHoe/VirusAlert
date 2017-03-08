//
//  TipsViewController.swift
//  VirusAlert
//
//  Created by Seow Yung Hoe on 01/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
            
     //--------------Symptoms--------------
        case 0: titleLabel.text = "Symptoms of Dengue";
            mainTextLabel.text = "1.High fever\n2.Severe headache\n3.Pain behind the eyes\n4.Sever joint and muscle pain\n5.Fatigue\n6.Nausea\n7.Vomiting\n8.Rash\n9.Mild bleeding (eg., nose/gum bleed or easy bruising)";
        imageView.loadGif(name: "mosquitobite");

            
     //--------------Preventions-----------
        case 1: titleLabel.text = "Tips to prevent dengue";
        mainTextLabel.text = "1.Replace water tray regularly \n2.Dicard unwanted cups and bottles, which collect rain water and breed mosquito, into litterbins\n3.Remove water from flowerpot plates on alternate days\n4.Remove stagnant water collected on leaves, tree branches and in drains\n5.Turn over all water storage containers and keep them dry";
        imageView.loadGif(name: "mosquitobite");

            
        default: titleLabel.text = nil
        mainTextLabel.text = nil
            
            
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.loadGif(name: "mosquitobite")
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"greengradient")!)

    }



}
