//
//  tunerViewController.swift
//  GuitarTuner
//
//  Created by cs1201 on 08/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//
//  ViewController for the in-built guitar tuner, it accesses a global shared
//  instance of the AUDIOENGINE class for all audio processing, UI elements
//  are contorlled here
//
//

import UIKit
import AudioKit

class tunerViewController: UIViewController {

    var timer: Timer!
    @IBOutlet weak var noteLabel: UILabel! //UI Elements
    @IBOutlet weak var pointer: UIImageView!
    var lastValue = 0.0 //Storage variable for last calculated cent difference
    var dataArray = Array(repeating: 0.0, count: 100) //Counting array
    let note = noteInfo() //Access noteInfo dictionary
    let varData = constants.sharedInstance
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        pointer.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.8))
        //tunerGauge.isEnabled = false

        //Initialise timer for constant update of tuner
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(self.updateTuner)), userInfo: nil, repeats: true)
    
    }
    
    //Access global cent value calculated by audioEngine, if within 40cent range
    //update tuner pointer relatively
    open func updateTuner(){
        
        let cents = varData.currentCent
                
                if cents < 40 && cents > -40 {
                    noteLabel.text = varData.currentNote
                    pointerRotation(cents)
                }
    }
    
    //Calculates relative pointer position based on current and last stored value
    // performs relative rotation
    func pointerRotation(_ value: Double){
        
        let relativeRotation = value - lastValue
        
        pointer.transform = pointer.transform.rotated(by: CGFloat(.pi/8 * relativeRotation/40))
        
        lastValue = value
    }

}

//Create new anchor for point of rotation
extension UIView{
    func setAnchorPoint(anchorPoint: CGPoint) {
        
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position : CGPoint = self.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }
}
