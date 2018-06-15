//
//  settingsVCViewController.swift
//  GuitarTuner
//
//  Created by cs1201 on 03/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//
//  ViewController for settings page
//
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
    let varData = constants.sharedInstance

    override func viewDidLoad() {
        
    //Get global value 
    accuracySlider.value = Float(varData.pitchAccuracy)
    
    super.viewDidLoad()
    
    }
    
    //User value change of slider will change global accuracy setting and update
    // label on this page
    @IBAction func changeResSlider(_ sender: UISlider) {
        
        let sliderValue = sender.value
        resLabel.text = String(Int(sender.value)) + " cents"
        
        varData.pitchAccuracy = Double(sliderValue)
    }
    
    //Change note box colour based on user selection by accessing global setting
    @IBAction func changeBoxColour(_ sender: UIButton) {
        
        switch (sender.tag){
        case 1:
            varData.boxColour = UIColor.green
        case 2:
            varData.boxColour = UIColor.red
        case 3:
            varData.boxColour = UIColor.blue
        default:
            break
        }
        
    }
    
}
