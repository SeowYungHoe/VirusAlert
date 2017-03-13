//
//  TipsViewController.swift
//  VirusAlert
//
//  Created by Seow Yung Hoe on 01/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {

    var count = 0
  
    //-------------------Outlets-----------------
    @IBOutlet weak var tickBoxOne: UIButton!
    @IBOutlet weak var tickBoxTwo: UIButton!
    @IBOutlet weak var tickBoxThree: UIButton!
    @IBOutlet weak var tickBoxFour: UIButton!
    @IBOutlet weak var tickBoxFive: UIButton!
    @IBOutlet weak var tickBoxSix: UIButton!
    @IBOutlet weak var tickBoxSeven: UIButton!
    @IBOutlet weak var tickBoxEight: UIButton!
    @IBOutlet weak var tickBoxNine: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!

    @IBOutlet weak var resultButton: UIButton!{
        didSet{
                resultButton.addTarget(self, action: #selector(countTotal), for: .touchUpInside)
        }
    }
    
    //-----------------Actions-------------------
    @IBAction func boxOneAction(_ sender: UIButton) {
        if IsBoxClicked1 == true {
            count -= 1
            IsBoxClicked1 = false
        }else{
            count += 1
            IsBoxClicked1 = true
        }
        
        if IsBoxClicked1 == true {
            tickBoxOne.setImage(boxOn, for: UIControlState.normal)
        }else {
            tickBoxOne.setImage(boxOff, for: UIControlState.normal)
        }
    }
    
    @IBAction func boxTwoAction(_ sender: UIButton) {
        if IsBoxClicked2 == true {
            count -= 1
            IsBoxClicked2 = false
        }else{
            count += 1
            IsBoxClicked2 = true
        }
        
        if IsBoxClicked2 == true {
            tickBoxTwo.setImage(boxOn, for: UIControlState.normal)
        }else {
            tickBoxTwo.setImage(boxOff, for: UIControlState.normal)
        }
    }
    
    @IBAction func boxThreeAction(_ sender: UIButton) {
        if IsBoxClicked3 == true {
            IsBoxClicked3 = false
            count -= 1
        }else{
            IsBoxClicked3 = true
            count += 1
        }
        
        if IsBoxClicked3 == true {
            tickBoxThree.setImage(boxOn, for: UIControlState.normal)
        }else {
            tickBoxThree.setImage(boxOff, for: UIControlState.normal)
        }
    }
    
    @IBAction func boxFourAction(_ sender: UIButton) {
        if IsBoxClicked4 == true {
            IsBoxClicked4 = false
            count -= 1
        }else{
            IsBoxClicked4 = true
            count += 1
        }
        
        if IsBoxClicked4 == true {
            tickBoxFour.setImage(boxOn, for: UIControlState.normal)
        }else {
            tickBoxFour.setImage(boxOff, for: UIControlState.normal)
        }
    }
    
    @IBAction func boxFiveAction(_ sender: UIButton) {
        if IsBoxClicked5 == true {
            IsBoxClicked5 = false
            count -= 1
        }else{
            IsBoxClicked5 = true
            count += 1
        }
        
        if IsBoxClicked5 == true {
            tickBoxFive.setImage(boxOn, for: UIControlState.normal)
        }else {
            tickBoxFive.setImage(boxOff, for: UIControlState.normal)
        }
    }
    
    @IBAction func boxSixAction(_ sender: UIButton) {
        if IsBoxClicked6 == true {
            IsBoxClicked6 = false
            count -= 1
        }else{
            IsBoxClicked6 = true
            count += 1
        }
        
        if IsBoxClicked6 == true {
            tickBoxSix.setImage(boxOn, for: UIControlState.normal)
        }else {
            tickBoxSix.setImage(boxOff, for: UIControlState.normal)
        }
    }
    
    @IBAction func boxSevenAction(_ sender: UIButton) {
        if IsBoxClicked7 == true {
            IsBoxClicked7 = false
            count -= 1
        }else{
            IsBoxClicked7 = true
            count += 1
        }
        
        if IsBoxClicked7 == true {
            tickBoxSeven.setImage(boxOn, for: UIControlState.normal)
        }else {
            tickBoxSeven.setImage(boxOff, for: UIControlState.normal)
        }
    }
    @IBAction func boxEightAction(_ sender: UIButton) {
        if IsBoxClicked8 == true {
            count -= 1
            IsBoxClicked8 = false
        }else{
            count += 1
            IsBoxClicked8 = true
        }
        
        if IsBoxClicked8 == true {
            tickBoxEight.setImage(boxOn, for: UIControlState.normal)
        }else {
            tickBoxEight.setImage(boxOff, for: UIControlState.normal)
        }
    }
    
    @IBAction func boxNineAction(_ sender: UIButton) {
        if IsBoxClicked9 == true {
            IsBoxClicked9 = false
            count -= 1
        }else{
            IsBoxClicked9 = true
            count += 1
        }
        
        if IsBoxClicked9 == true {
            tickBoxNine.setImage(boxOn, for: UIControlState.normal)
        }else {
            tickBoxNine.setImage(boxOff, for: UIControlState.normal)
        }
    }
    
    
    var boxOn = UIImage(named: "tick")
    var boxOff = UIImage(named: "untick")
    
    var IsBoxClicked1: Bool!
    var IsBoxClicked2: Bool!
    var IsBoxClicked3: Bool!
    var IsBoxClicked4: Bool!
    var IsBoxClicked5: Bool!
    var IsBoxClicked6: Bool!
    var IsBoxClicked7: Bool!
    var IsBoxClicked8: Bool!
    var IsBoxClicked9: Bool!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allboxClickedFalse()
        view.backgroundColor = UIColor.white
        resultLabel.isHidden = true
        labelChangedColor()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "GradientBlue")!)

        
    }
    
    func countTotal(){
        resultLabel.text = "\(Int(CGFloat(count)/9*100))%"
     print(count)
        resultLabel.isHidden = false
    }

    func allboxClickedFalse(){
        IsBoxClicked1 = false
        IsBoxClicked2 = false
        IsBoxClicked3 = false
        IsBoxClicked4 = false
        IsBoxClicked5 = false
        IsBoxClicked6 = false
        IsBoxClicked7 = false
        IsBoxClicked8 = false
        IsBoxClicked9 = false

    }
    
    func labelChangedColor(){
//        
//        if count = 1..3 {
//            resultLabel.textColor = UIColor.green
//        }else {
//            resultLabel.textColor = UIColor.red
//            
//        }

        
    }

}

