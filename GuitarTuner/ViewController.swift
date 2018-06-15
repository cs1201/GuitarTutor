//
//  ViewController.swift
//  GuitarTuner
//
//  Created by cs1201 on 22/01/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//
//  MAIN APP PAGE VIEWCONTROLLER
//

import UIKit
import CoreGraphics
import AudioKit

class ViewController: UIViewController {
    
    var boxColour: UIColor!
    var nameAlert: UIAlertController! //Alert for naming a recorded file
    var recDoneAlert: UIAlertController! //Alert for confirming a recorded file
    
    @IBOutlet weak var frequencyLabel: UILabel! //UI Elements declarations
    @IBOutlet weak var outputPlot: EZAudioPlot!
    @IBOutlet weak var tunerGauge: UISlider!
    @IBOutlet weak var noteStepLabel: UILabel!
    @IBOutlet weak var targetNoteLabel: UILabel!
    @IBOutlet weak var currNoteView: UIView!
    @IBOutlet weak var riffSelect: UITextField!
    @IBOutlet weak var tabView: UIImageView!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var threshLabel: UILabel!
    @IBOutlet weak var recordIcon: UIImageView!
    @IBOutlet weak var loopIcon: UIImageView!
    
    
    var riffsList: [String] = [] //Array to store list of available riffs
    
    //Access shared instances of required external classes
    let varData = constants.sharedInstance
    let recData = recordingData.sharedInstance
    let audioEngine = AudioEngine.sharedInstance

    var selectedRow = 0 //Empty variables to be initialised in viewDidLoad()
    var lastText = ""
    var sRiff: Int!
    var sNoteSt: Int!
    
    //*****************************************************************
    // MARK: - PAGE INITIALISATION ON LOADING
    //*****************************************************************
    
    //On the page loading
    override func viewDidLoad() {
        
        //Refresh docs in data file
        recData.scanDocuments()
        
        //Update box colour with global setting
        currNoteView.backgroundColor = varData.boxColour
        
        //Update loop icon based on global setting
        if !varData.loop{
            loopIcon.image = UIImage(named: "loopOFF.png")
        }
        
        //Instantiate delegate to allow audioEngine to trigger UI updates
        audioEngine.delegate = self
        
        riffsList = varData.riffsList
        
        AudioKit.start()
        
        //setupPlot(true)
    
        riffPicker()
        createToolbar()
        nameAlertInit()
        recordingDoneAlertInit()
        
        sRiff = varData.storedRiff
        sNoteSt = varData.storedNoteStep
        
        tabView.image = UIImage(named: varData.storedTabImg)
        targetNoteLabel.text = varData.riffInfo[sRiff].notes[sNoteSt]
        riffSelect.text = varData.riffsList[sRiff]
        currNoteView.center = CGPoint(x: varData.riffInfo[sRiff].xPos[sNoteSt] + 25, y: varData.riffInfo[sRiff].yPos[sNoteSt] + 41)
        //Change TAB View Image to blank prompt! tabView.image = UIImage(named: )
        currNoteView.isHidden = varData.isNotLoaded
        
        super.viewDidLoad()
        
    }
    
    //Hide navigation bar on this page
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    //*****************************************************************
    // MARK: - ALERT INITIALISATIONS
    //*****************************************************************
    
    //Initialise name alert for when recording is stopped and recording is saved
    func nameAlertInit(){
        //Create new alert with relevant name and message
        nameAlert = UIAlertController(title: "Name the track:", message: "No special characters or spaces permitted", preferredStyle: .alert)
        //Default textfield text is blank
        nameAlert.addTextField { (textField) in textField.text = ""
        }
        //Action to store track and clear textfield when OK button pressed, dismiss alert
        nameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            //Get text from textfield
            let textField = self.nameAlert.textFields![0]
            //Call store track method in audioEngine
            self.recDoneAlert.message = "Recording \(textField.text!) was saved."
            self.audioEngine.storeTrack(textField.text!)
            
            //Clear txtfield and dismiss alert
            self.nameAlert.dismiss(animated: true, completion: nil)
            self.present(self.recDoneAlert, animated: true, completion: nil)
            textField.text = ""
        }))
    }
    //Show user alert to confirm recording is complete and stored with file name
    func recordingDoneAlertInit(){
        
        recDoneAlert = UIAlertController(title: "Success!", message: "Recording \(lastText) was saved", preferredStyle: .alert)
        
        recDoneAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            
            self.recDoneAlert.dismiss(animated: true, completion: nil)
        }))
    }
    
    //*****************************************************************
    // MARK: -UI BUTTON HANDLING
    //*****************************************************************
    
    //Recording button pressed
    @IBAction func recordPressed(_ sender: UIButton) {
        
        //To record
        if !varData.isRecording {
            
            recordIcon.flash()
            audioEngine.beginRecording()
            
        }else{ //To stop recording
            recordIcon.stopFlash()
            audioEngine.stopRecording()
            self.present(nameAlert, animated: true, completion: nil)
        }
        //Switch global recording state boolean
        varData.isRecording = !varData.isRecording
    }
   
    //Loop button pressed
    @IBAction func loopButtonPressed(_ sender: UIButton) {
        
        varData.loop = !varData.loop //Toggle global boolean
        //Update icon image based on loop state
        if varData.loop {
            loopIcon.image = UIImage(named: "loopON.png")
        } else {
            loopIcon.image = UIImage(named: "loopOFF.png")
        }
    }
    //Trigger audioEngine to play current riff with sequencer
    @IBAction func playRiffButtonPressed(_ sender: UIButton) {
        audioEngine.playRiff()
    }

    //*****************************************************************
    // MARK: - PICKER VIEW INITIALISATION
    //*****************************************************************
    
    func riffPicker(){
        //Picker View initialisation
        let riffPicker = UIPickerView()
        riffPicker.delegate = self
        riffSelect.inputView = riffPicker
    }
    
    //Create UIToolbar to confirm selection in pickerView
    func createToolbar(){
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:
            #selector(ViewController.dismissKeyboard))
        
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        riffSelect.inputAccessoryView = toolbar
        
    }
    
    //When riff is selected
    func dismissKeyboard(){
        
        audioEngine.loadRiff(selectedRow) //Load selected riff
        tabView.image = UIImage(named: varData.imageName[selectedRow]) //Update TAB image
        noteStepLabel.text = "1"
        let note2wrt = varData.riffInfo[selectedRow].notes[0]
        targetNoteLabel.text = String(note2wrt)
        currNoteView.isHidden = false
        currNoteView.center = CGPoint(x: varData.riffInfo[selectedRow].xPos[0] + 25, y: varData.riffInfo[selectedRow].yPos[0] + 41)
        varData.storedRiff = selectedRow //Update global values
        varData.storedTabImg = varData.imageName[selectedRow]
        
        varData.isNotLoaded = false

        view.endEditing(true)
    }
//End of class
}

//Create Flash animation for Record icon
extension UIImageView {
    
    func flash() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatDuration = 100000
        
        layer.add(flash, forKey: nil)
    }
    
    func stopFlash() {
        layer.removeAllAnimations()
    }
}

//*****************************************************************
// MARK: - AUDIOENGINE DELEGATE
//*****************************************************************
extension ViewController: audioEngineDelegate{
    
    //Move note box when correct note recieved
    func moveNoteBox(x: Int, y: Int) {
        currNoteView.center = CGPoint(x: x+25, y: y+41)
    }
    //Change note label to next target note
    func changeNoteName(_ noteName: String) {
        targetNoteLabel.text = noteName
    }
    //Update note position identifier
    func changeNoteStep(_ noteStep: Int) {
        print(noteStep)
        noteStepLabel.text = String(noteStep)
        varData.storedNoteStep = noteStep
    }
    
}
//*****************************************************************
// MARK: - PICKER VIEW
//*****************************************************************

extension ViewController: UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return riffsList.count //Access global riff list
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return riffsList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        riffSelect.text = riffsList[row]
    }
}

