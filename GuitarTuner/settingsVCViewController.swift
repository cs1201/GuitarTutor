//
//  settingsVCViewController.swift
//  GuitarTuner
//
//  Created by cs1201 on 03/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//

import UIKit

class settingsVCViewController: UIViewController {
    
    
    @IBOutlet weak var resLabel: UILabel!
    @IBOutlet weak var greenSelect: UIButton!
    @IBOutlet weak var redSelect: UIButton!
    @IBOutlet weak var blueSelect: UIButton!
    @IBOutlet weak var accuracySlider: UISlider!
    
    var boxColour: UIColor?
    let viewController = ViewController()
    let constant = constants.sharedInstance

    override func viewDidLoad() {
        
    accuracySlider.value = Float(constant.pitchAccuracy)
    
    super.viewDidLoad()
    
    }
    
    
    @IBAction func changeResSlider(_ sender: UISlider) {
        
        let sliderValue = sender.value
        resLabel.text = String(Int(sender.value)) + " cents"
        
        constant.pitchAccuracy = Double(sliderValue)
    }
    
    @IBAction func changeBoxColour(_ sender: UIButton) {
        
        //higlight doesn't do anything. need to make more obvious
        
        switch (sender.tag){
        case 1:
            constant.boxColour = UIColor.green

        case 2:
            constant.boxColour = UIColor.red

        case 3:
            constant.boxColour = UIColor.blue
        default:
            break
        }
        
    }
    
}
