//
//  ViewController.swift
//  GuitarTuner
//
//  Created by cs1201 on 22/01/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//

import UIKit
import CoreGraphics
import AudioKit

class ViewController: UIViewController {
    
    var mic: AKMicrophone!
    var micTracker: AKFrequencyTracker!
    var ampTracker: AKAmplitudeTracker!
    var silence: AKBooster!
    
    var recorder: AKNodeRecorder!
    var fileToStore: AKAudioFile!
    
    var demoGuitar: AKPluckedString!
    var outputMixer: AKMixer!
    
    var riffPlayer: AKSequencer!
    var track: AKMusicTrack!
    var boxColour: UIColor!
    var nameAlert: UIAlertController!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    var timer: Timer!
    @IBOutlet weak var outputPlot: EZAudioPlot!
    @IBOutlet weak var tunerGauge: UISlider!
    @IBOutlet weak var correctNoteBox: UIView!
    @IBOutlet weak var noteStepLabel: UILabel!
    @IBOutlet weak var targetNoteLabel: UILabel!
    @IBOutlet weak var currNoteView: UIView!
    @IBOutlet weak var riffSelect: UITextField!
    @IBOutlet weak var tabView: UIImageView!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    //let settingsVC = settingsVCViewController()
    let constant = constants.sharedInstance
    let recData = recordingData.sharedInstance
    //var globalLoop = false
    //var noteToFreq = [String: Double]()
    var riff1 : [String] = []
    var noteXPos: [Int] = []
    var noteYPos: [Int] = []
    var playedNote = ""
    var targetNote: String!
    var noteStep = 1
    var correctNote = false
    var numberOfNotes = 0
    var sum = 0.0
    var inputFreq = 0.0
    var selectedRiff: Int?
    var selectedRow: Int?
    var firstOpen = true
    var recording = false
    let note = noteInfo()
    var currentName: String!
    
    var riffs = ["Smoke on the water",
                 "Sweet Child o' Mine"]
    
    override func viewDidLoad() {
        
        tunerGauge.isEnabled = false
        mic = AKMicrophone()
        micTracker = AKFrequencyTracker(mic)
        ampTracker = AKAmplitudeTracker(micTracker)
        silence = AKBooster(ampTracker, gain: 0)
        demoGuitar = AKPluckedString()
        let riffSampler = AKMIDISampler()
        try! riffSampler.loadWav("Sounds/gtrSample")
        riffPlayer = AKSequencer()
        track = riffPlayer.newTrack()
        riffPlayer.setLength(AKDuration(beats: Double(numberOfNotes)))
        riffPlayer.setGlobalMIDIOutput(riffSampler.midiIn)
        outputMixer = AKMixer(demoGuitar, riffSampler, silence)
        
        //Recorder and file setup
        recorder = try? AKNodeRecorder(node: outputMixer)
        fileToStore = recorder.audioFile
        //Refresh docs in data file
        recData.scanDocuments()
        
        currNoteView.backgroundColor = constant.boxColour
        
        if constant.loop{
            loopButton.backgroundColor = UIColor.green
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(self.getInputNote)), userInfo: nil, repeats: true)
        
        AudioKit.output = outputMixer

        AudioKit.start()
        //demoGuitar.start()
        
        setupPlot(true)
        //freqList()
        loadRiff(1)
        riffPicker()
        createToolbar()
        nameAlertInit()
        
        targetNote = riff1[noteStep - 1]
        noteStepLabel.text = String(noteStep)
        targetNoteLabel.text = riff1[noteStep - 1]
        currNoteView.center = CGPoint(x: 80, y: 170)
        
        super.viewDidLoad()
        
    }
    
    @IBAction func goToFiles(_ sender: UIButton) {
        AudioKit.stop()
    }
    
    func nameAlertInit(){
        
        nameAlert = UIAlertController(title: "Name the track:", message: "No special characters or spaces permitted", preferredStyle: .alert)
        
        nameAlert.addTextField { (textField) in
            textField.text = ""
        }
        
        nameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let textField = self.nameAlert.textFields![0]
            self.storeTrack(textField.text!)
            textField.text = ""
            self.nameAlert.dismiss(animated: true, completion: nil)
        }))
    }
    
    func storeTrack(_ name: String){
        currentName = name
        fileToStore.exportAsynchronously(name: currentName!, baseDir: .documents, exportFormat: .mp4, callback: callback)
    }

    
    @IBAction func recordPressed(_ sender: UIButton) {
        
        if !recording {
            //DO THIS TO START
            try? recorder.reset()
            
            do{
                try recorder.record()
            }catch{
                print("Could not begin recording")
            }
            
            fileToStore = recorder.audioFile
            
        }else{
            //DO THIS TO STOP
            recorder.stop()
            self.present(nameAlert, animated: true, completion: nil)
            
        }
        
        recording = !recording
    }
    
    func callback(processedFile: AKAudioFile?, error: NSError?) {
        print("Export completed!")
        
        //Refresh recording list in data file
        recData.scanDocuments()
        
        // Check if processed file is valid (different from nil)
        if let converted = processedFile {
            print("Export succeeded, converted file: \(converted.fileNamePlusExtension)")
            // Print the exported file's duration
            print("Exported File Duration: \(converted.duration) seconds")
            // Replace the file being played
            //try? player.replace(file: converted)
        } else {
            // An error occured. So, print the Error
            print("Error: \(String(describing: error?.localizedDescription))")
        }
    }
   
    @IBAction func loopButtonPressed(_ sender: UIButton) {
        
        constant.loop = !constant.loop
        
        if constant.loop {
        loopButton.backgroundColor = UIColor.green
        } else {
        loopButton.backgroundColor = UIColor.clear
        }
    }
    
    func playDemoNote(_ inputNote: String){

        let noteFreq = note.noteList[inputNote]
        
        demoGuitar.trigger(frequency: noteFreq!.freq)
    }
    
    @IBAction func playNoteButtonPressed(_ sender: UIButton) {
        playDemoNote(targetNote)
        print(targetNote)
    }
    
    func playRiff(){
        //Stop listening to mic to avoid false pitch readings
        micTracker.stop()
        
        currNoteView.isHidden = true
        
        //Stop riffPlayer if already triggered
        riffPlayer.stop()
        
        //Clear sequencer track
        track?.clear()
        
        //set length of sequencer track based on selected riff
        riffPlayer.setLength(AKDuration(beats: Double(numberOfNotes)))

        //For each note in selected riff, add midi note to sequencer track
        for i in 1...numberOfNotes{
            
            track?.add(noteNumber: MIDINoteNumber(note.noteList[riff1[i-1]]!.midi), velocity: 60, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 1))
        }
        
        //Play sequencer track
        riffPlayer.play()
        
        //Start listening to mic again once audio finished
        micTracker.start()
        
        //currNoteView.isHidden = false
        
        print(riffPlayer.trackCount)
    }
    
    @IBAction func playRiffButtonPressed(_ sender: UIButton) {
        playRiff()
    }
    
    open func riffPlaythrough(){
        noteStepIncrease()
        noteStepLabel.text = String(noteStep)
        targetNoteLabel.text = riff1[noteStep - 1]
        targetNote = riff1[noteStep - 1]
        currNoteView.center = CGPoint(x: noteXPos[noteStep-1] + 25, y: noteYPos[noteStep-1] + 41)
    }
    
    func stopPlay(){
        //Need to stop playback until re-triggered
    }
    
    
    func noteStepIncrease(){
        if noteStep <= numberOfNotes - 1{
            noteStep += 1
        }
        else{
            if constant.loop{
                noteStep = 1
            }else{
                stopPlay()
            }
        }
    }
    
    open func getInputNote() {
        
        //Constantly check for player stopped to reset and show note box again
        if riffPlayer.currentPosition.seconds >= riffPlayer.length.seconds*2{
            riffPlayer.rewind()
            riffPlayer.stop()
            currNoteView.isHidden = false
        }
        
        //Only check if mic can hear input
        if ampTracker.amplitude > 0.001 {
            
            inputFreq = micTracker.frequency
            
            //Check played note against all frequencies
            for (noteName, noteFreq) in note.noteList {
                
                //Find cent difference
                let cents = calculateCents(inputFreq, noteFreq.freq)
                
                //If played note within 10cent tolerance output played note name
                if cents < constant.pitchAccuracy && cents > -constant.pitchAccuracy {
                    playedNote = noteName
                    frequencyLabel.text = noteName
                    checkNote(playedNote, targetNote)
                }
            }
        }
    }
    
    
    open func checkNote(_ inputNote: String, _ targetNote: String){

        if inputNote == targetNote {
            correctNoteBox.backgroundColor = UIColor.green
            correctNote = true
            
            riffPlaythrough()
            
        } else {
            correctNoteBox.backgroundColor = UIColor.red
            correctNote = false
        }
    }
    
    func setupPlot(_ zoom: Bool) {
        
        let plot = AKNodeOutputPlot(micTracker, frame: outputPlot.bounds)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.shouldCenterYAxis = true
        plot.backgroundColor = UIColor.clear
        plot.color = UIColor.darkGray
        plot.gain = 3
        plot.layer.masksToBounds = true
        //plot.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2.0, 0, 0, 1)
        outputPlot.addSubview(plot)
    }
    
    open func loadRiff(_ riffSelect: Int){
        
        switch(riffSelect){
        case 0: //Smoke on the Water
            //Input note and box position data for riff
            riff1 = ["E2", "G2", "A2", "E2", "G2", "A#2/Bb2", "A2", "E2", "G2", "A2", "G2", "E2"]
            noteXPos = [85, 117, 146, 173, 201, 229, 263, 355, 385, 417, 453, 480]
            noteYPos = [210, 210, 210, 210, 210, 210, 210, 210, 210, 210, 210, 210]
            //Change tab image
            tabView.image = UIImage(named: "SOTW.png")
        case 1: //Sweet child o' mine
            tabView.image = UIImage(named: "SCOM.png")
            riff1 = ["D4", "D5", "A4", "G4", "G5", "A4", "F#5/Gb5", "A4",
                     "E4", "D5", "A4", "G4", "G5", "A4", "F#5/Gb5", "A4"]
            noteXPos = [57, 109, 169, 231, 285, 351, 409, 465,
                        57, 109, 169, 231, 285, 351, 409, 465]
            noteYPos = [120, 120, 120, 120, 120, 120, 120, 120,
                        270, 270, 270, 270, 270, 270, 270, 270]
        default:
            break
        }
        
        noteStep = 1
        targetNote = riff1[0]
        numberOfNotes = riff1.count
        currNoteView.center = CGPoint(x: noteXPos[0]+25 , y: noteYPos[0]+41)
    }
 
    func calculateCents(_ f1: Double, _ f2: Double)-> Double{
        
        let cents = -1200 * log(f2/f1) / log(2)
        
        return cents
    }
    
    func riffPicker(){
        
        let riffPicker = UIPickerView()
        riffPicker.delegate = self
        riffSelect.inputView = riffPicker
    }
    
    func createToolbar(){
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:
            #selector(ViewController.dismissKeyboard))
        
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        riffSelect.inputAccessoryView = toolbar
        
    }
    
    func dismissKeyboard(){
        loadRiff(selectedRow!)
        view.endEditing(true)
    }
    
//End of class
}

extension ViewController: UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return riffs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return riffs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        riffSelect.text = riffs[row]
    }
}

