//
//  tunerViewController.swift
//  GuitarTuner
//
//  Created by cs1201 on 08/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//

import UIKit
import AudioKit

class tunerViewController: UIViewController {

    var mic: AKMicrophone!
    var micTracker: AKFrequencyTracker!
    var ampTracker: AKAmplitudeTracker!
    var silence: AKBooster!
    var timer: Timer!
    @IBOutlet weak var tunerGauge: UISlider!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var pointer: UIImageView!
    
    var lastValue = 0.0
    
    var dataArray = Array(repeating: 0.0, count: 100)
    
    let note = noteInfo()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        pointer.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.8))
        tunerGauge.isEnabled = false
        mic = AKMicrophone()
        micTracker = AKFrequencyTracker(mic)
        ampTracker = AKAmplitudeTracker(micTracker)
        silence = AKBooster(ampTracker, gain: 0)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(self.writeFrequency)), userInfo: nil, repeats: true)
        
        AudioKit.output = silence
        
        AudioKit.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func writeFrequency(){
    
        
        if ampTracker.amplitude > 0.01{
            
            let inputFreq = micTracker.frequency
            
            let averagedFreq = averagingFilter(inputFreq)
            
            for (noteName, noteFreq) in note.noteList{
                
                let cents = calculateCents(averagedFreq, noteFreq.freq)
                
                if cents < 40 && cents > -40 {
                    tunerGauge.minimumTrackTintColor = UIColor.black
                    tunerGauge.maximumTrackTintColor = UIColor.black
                    tunerGauge.value = Float(cents)
                    noteLabel.text = noteName
                    pointerRotation(cents)
                }
                if cents < 5 && cents > -5 {
                    tunerGauge.minimumTrackTintColor = UIColor.green
                    tunerGauge.maximumTrackTintColor = UIColor.green
                    noteLabel.text = noteName
                }
            }
        }
    }
    
    func averagingFilter(_ inputFreq: Double) -> Double{
        
        var averageValue = 0.0
        
        for (i, _) in dataArray.enumerated() {
            
            let j = i+1
            
            //Shift all elements by -1 index
            if j == 100{
                dataArray[i] = inputFreq
            } else{
                dataArray[i] = dataArray[j]
            }
        }
        
        for value in dataArray {
            
            averageValue += value
        }
        
        let computedAverage = averageValue / 100
        
        return computedAverage
    }
    
    func pointerRotation(_ value: Double){
        
        let relativeRotation = value - lastValue
        
        pointer.transform = pointer.transform.rotated(by: CGFloat(.pi/4 * relativeRotation/40))
        
        lastValue = value
    }

    
    func calculateCents(_ f1: Double, _ f2: Double)-> Double{
        
        let cents = -1200 * log(f2/f1) / log(2)
        
        return cents
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
