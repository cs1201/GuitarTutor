//
//  calibrationViewController.swift
//  GuitarTuner
//
//  Created by cs1201 on 13/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//

import UIKit
import AudioKit

//*****************************************************************
// MARK: - View Controller for calibration page. Uses it's own audio engine
//          to average input amplitude over 5s and set global threshold
//          to improve perfomance analysis triggering
//*****************************************************************
class calibrationViewController: UIViewController {
    
    let varData = constants.sharedInstance  //Access shared instance of required classes
    var mic: AKMicrophone!                  //Declare audioKit elements
    var freqTracker: AKFrequencyTracker!
    var ampTracker: AKAmplitudeTracker!
    var silence: AKBooster!
    var timer: Timer!
    var count = 0
    var avgSum = 0.0
    var calibratedAvg = 0.0
    var isCalibratingInput = false
    var wasCalibrated = false
    
    @IBOutlet weak var timeSlider: UISlider!    //UIElements
    @IBOutlet weak var startCalibrating: UIButton!
    
    var calibrationSuccessAlert: UIAlertController! //Alerts
    var notCalibratedAlert: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertInit() //Initialise alert
        
        timeSlider.isEnabled = false    //Setup UI elements
        timeSlider.isHidden = true
        timeSlider.setThumbImage(UIImage(named: "timePointer.png"), for: .normal)
        
        //Timer to constantly update input analysis
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(listen)), userInfo: nil, repeats: true)

        mic = AKMicrophone()    //Audio kit signal path setup
        freqTracker = AKFrequencyTracker(mic)
        ampTracker = AKAmplitudeTracker(freqTracker)
        silence = AKBooster(ampTracker, gain: 0)
        
        AudioKit.output = silence
        AudioKit.start()
    }
    
    //*****************************************************************
    // MARK: - ALERT INITIALISATIONS
    //*****************************************************************
    func alertInit(){
        
        calibrationSuccessAlert = UIAlertController(title: "Success!", message: "Calibration stored", preferredStyle: .alert)
        
        calibrationSuccessAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            
        self.calibrationSuccessAlert.dismiss(animated: true, completion: nil)
        }))
        
        notCalibratedAlert = UIAlertController(title: "Not calibrated!", message: "No calibration was stored, this may affect performance analysis", preferredStyle: .alert)
        
        notCalibratedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            
            self.notCalibratedAlert.dismiss(animated: true, completion: nil)
        }))
        
    }
    
    //*****************************************************************
    // MARK: - MIC ANALYSIS
    //*****************************************************************
    func listen(){
        
        let inputAmp = ampTracker.amplitude //Get amplitude of input signal
        
        if isCalibratingInput {
            //Send to averaging function over 5 seconds
            if count <= 50{
                getAverage(inputAmp, count)
                timeSlider.isHidden = false
                count += 1
            }else{
                finishCalibrating()
            }
            //Update UI to give user visual feedback of time remaining in calibration process
            timeSlider.value = Float(count)
        }
    }
    
    //Function returns an amplitude threshold based on calibration process and stores this as global variable
    func finishCalibrating(){
        
        count = 0 //Reset counter
        isCalibratingInput = false
        timeSlider.isHidden = true
        wasCalibrated = true
        //Show user alert to confirm successful calibration
        self.present(calibrationSuccessAlert, animated: true, completion: nil)
        //Send calibrated average to global data file
        //Set to 1/2 of average found in calibration to allow for any discrepencies in input signal changes
        varData.amplitudeThreshold = calibratedAvg * 0.5
        print("calibrated average is \(calibratedAvg)")
        
    }
    
    //Averaging function performs sum average over counter period
    func getAverage(_ input: Double, _ count: Int){
        
        avgSum += input
        
        calibratedAvg = avgSum/count
    }
    
    //*****************************************************************
    // MARK: - USER BUTTON HANDLING
    //*****************************************************************
    
    @IBAction func startCalibrating(_ sender: UIButton) {
        
        isCalibratingInput = true
    }

    
    @IBAction func exitVC(_ sender: UIButton) {
        
        if !wasCalibrated {
            self.present(notCalibratedAlert, animated: true, completion: nil)
        }
    }
}
