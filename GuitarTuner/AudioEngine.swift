//
//  AudioEngine.swift
//  GuitarTuner
//
//  This class forms the shared instance of AudioKit handling all audio processing for the app. All other viewControllers and files
//  can access this file to make changes
//
//  Created by cs1201 on 22/01/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//

import UIKit
import AudioKit

class AudioEngine: AKNode{
    
    static let sharedInstance = AudioEngine() //Allow for all relevate files to access this class as a shared instance
    
    var delegate: audioEngineDelegate?
    
    let recData = recordingData.sharedInstance //Access all required external classes
    let varData = constants.sharedInstance
    let note = noteInfo()
    
    var mic: AKMicrophone!                  //AudioKit declarations
    var micTracker: AKFrequencyTracker!
    var ampTracker: AKAmplitudeTracker!
    var silence: AKBooster!
    var micRecordMixer: AKMixer!
    
    var riffSampler: AKMIDISampler!
    var riffPlayer: AKSequencer!
    var track: AKMusicTrack!
    var track2: AKMusicTrack!
    
    var recorder: AKNodeRecorder!
    var fileToStore: AKAudioFile!
    
    var fileToPlay: AKAudioFile!
    var filePlayer: AKAudioPlayer!
    var playerBoost: AKBooster!
    var playerTest: AKAmplitudeTracker!
    
    var outputMixer: AKMixer!
    
    var riff: [String] = []     //Setup variable declarations
    var noteXPos: [Int] = []
    var noteYPos: [Int] = []
    var playedNote = ""
    var targetNote = ""
    var noteStep = 1
    var correctNote = false
    var numberOfNotes = 0
    var sum = 0.0
    var inputFreq = 0.0
    var selectedRiff = 0
    var selectedRow: Int?
    var firstOpen = true
    var recording = false
    var currentName: String!
    var noteFreq = 0.0
    var riffs = [String]()
    
    
    private override init(){
        //AudioKit signal path
        mic = AKMicrophone()
        micRecordMixer = AKMixer(mic)
        micTracker = AKFrequencyTracker(micRecordMixer)
        ampTracker = AKAmplitudeTracker(micTracker)
        silence = AKBooster(ampTracker, gain: 0) //Set gain of mic input to 0 to avoid feedback loop
        
        riffSampler = AKMIDISampler() //Midi Sampler for riffplayback
        //Intended guitar sample for riffPlayback although in-built audioKit bug means only sin-wave oscillator is produced
        try! riffSampler.loadWav("Sounds/gtrSample")
 
        riffPlayer = AKSequencer()  //Sequencer for riffPlayback
        track = riffPlayer.newTrack()
        track2 = riffPlayer.newTrack()
        riffPlayer.setLength(AKDuration(beats: Double(numberOfNotes))) //Setup sequencer track based on notes in riff files
        riffPlayer.setGlobalMIDIOutput(riffSampler.midiIn)
        
        //Dummy audio file initalised with audioPlayer
        fileToPlay = try? AKAudioFile(readFileName: "dummy.wav", baseDir: .resources)
        filePlayer = try? AKAudioPlayer(file: fileToPlay)
        playerBoost = AKBooster(filePlayer)
        filePlayer.volume = 10.0
        playerTest = AKAmplitudeTracker(playerBoost)
        
        outputMixer = AKMixer(riffSampler, playerTest, silence)

        //Recorder and file setup
        recorder = try? AKNodeRecorder(node: micRecordMixer)
        fileToStore = recorder.audioFile
        //Refresh docs in data file
        recData.scanDocuments()

        AudioKit.output = outputMixer
        
        AudioKit.start()

        super.init()
        
        loadRiff(selectedRiff)  //Load inital riff
        riffs = varData.riffsList

            //Timer for constant update of audio input anylsis
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(self.noteAnalysis)), userInfo: nil, repeats: true)
    }

    //Load riff based on picker view selection in main page UI by accessing gloabl data file
    open func loadRiff(_ riffSelect: Int){
        
        switch(riffSelect){
            
        case 0: //Default/Blank
            
            riff = varData.riffInfo[0].notes
            
        case 1: //Smoke on the water
            
            riff = varData.riffInfo[1].notes
            
        case 2: //Sweet child o' mine
            
            riff = varData.riffInfo[2].notes
            
        case 3: //Seven Nation Army
            
            riff = varData.riffInfo[3].notes
            
        case 4: //Enter Sandman
            
            riff = varData.riffInfo[4].notes
            
        case 5: //Billie Jean
            
            riff = varData.riffInfo[5].notes
            
        default:
            break
        }
        
        selectedRiff = riffSelect
        noteStep = 1
        targetNote = riff[0]
        numberOfNotes = riff.count
    }
   
    //*****************************************************************
    // MARK: - NOTE ANALYSIS
    //*****************************************************************
 
    open func noteAnalysis() {
        
        //Constantly check for player stopped to reset
        if riffPlayer.currentPosition.seconds >= riffPlayer.length.seconds*2{
            riffPlayer.rewind()
            riffPlayer.stop()
        }
        
        //Only check if mic can hear input based on calibrated amplitude threshold
        if ampTracker.amplitude > varData.amplitudeThreshold {
            
            inputFreq = micTracker.frequency //Take input from device microphone

            //Check played note against all frequencies
            for (noteName, noteFreq) in note.noteList {
                
                //Find cent difference
                let cents = calculateCents(inputFreq, noteFreq.freq)
                
                //Update global values for tuner VC to access
                if cents < 40 && cents > -40 {
                    varData.currentNote = playedNote
                    varData.currentCent = cents
                }
                
                //Range for playthrough analysis!
                //If played note within tolerance output played note name
                if cents < varData.pitchAccuracy && cents > -varData.pitchAccuracy {
                    
                    playedNote = noteName
                    
                    if checkNote(playedNote, targetNote) {
                        riffAdvance()
                    }
                }
            }
        }
    }
    
    //Function calculate the difference in cents between two input frequencies
    func calculateCents(_ f1: Double, _ f2: Double)-> Double{
        
        let cents = -1200 * log(f2/f1) / log(2)
        
        return cents
    }
    
    //Checks if played note matches the target note based on stored riff
    open func checkNote(_ inputNote: String, _ targetNote: String) -> Bool{
        
        if inputNote == targetNote {
            correctNote = true
            return true

            
        } else {
            correctNote = false
            return false
        }
    }
    
    //Handles advance to next note in current riff, updating relevant ui elements
    open func riffAdvance(){

        if noteStep <= numberOfNotes - 1{
            noteStep += 1
        }
        else{
            if varData.loop{
                noteStep = 1
            }else{
                noteStep = numberOfNotes
            }
        }

        targetNote = riff[noteStep - 1]
        
        delegate?.changeNoteStep(noteStep) //Update UI
        delegate?.changeNoteName(targetNote)
        let xPos = varData.riffInfo[selectedRiff].xPos[noteStep-1] //Get UI Box positions
        let yPos = varData.riffInfo[selectedRiff].yPos[noteStep-1]
        delegate?.moveNoteBox(x: xPos, y: yPos)
    }
    

    //*****************************************************************
    // MARK: - AUDIOTKIT SETUP & CONTROL
    //*****************************************************************
     open func audiokitStop(){
        
        AudioKit.stop()
    }
    
    //*****************************************************************
    // MARK: - RIFF PLAYBACK
    //*****************************************************************
    
    
    func playRiff(){
        
        //Stop listening to mic to avoid false pitch readings
        micTracker.stop()
        
        //Stop riffPlayer if already triggered
        riffPlayer.stop()
        
        //Clear sequencer track
        track2?.clear()
        
        //set length of sequencer track based on selected riff
        riffPlayer.setLength(AKDuration(beats: Double(numberOfNotes)))
        
        //For each note in selected riff, add midi note to sequencer track
        for i in 1...numberOfNotes{
            
        if note.noteList[riff[i-1]]?.midi != nil{
            track2?.add(noteNumber: MIDINoteNumber(note.noteList[riff[i-1]]!.midi), velocity: 60, position: AKDuration(beats: Double(i)), duration: AKDuration(beats: 1))
            }
        }
        
        //Play sequencer track
        riffPlayer.play()
        
        //Start listening to mic again once audio finished
        micTracker.start()

    }

    
    //*****************************************************************
    // MARK: - RECORDING/FILE PLAYBACK
    //*****************************************************************
    
    //Begin recording
    open func beginRecording(){
        
        try? recorder.reset()
        
        do{
            try recorder.record()
        }catch{
            print("Could not begin recording")
        }

        fileToStore = recorder.audioFile
    }
    
    //Stop recording audio
    open func stopRecording(){
        
        recorder.stop()
    }
    
    //Called by UIAlert to store track
    func storeTrack(_ name: String){
        currentName = name
        fileToStore.exportAsynchronously(name: currentName!, baseDir: .documents, exportFormat: .mp4, callback: callback)
    }
    
    //Call back from file store process to re-scan documents and error handling
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
    
    //Load file based on URL selection in file access VC Page
    func loadFile(_ fileURL: String){

        do{
            try fileToPlay = AKAudioFile(readFileName: fileURL, baseDir: .documents)
        }catch{
            print("could not locate file")
        }
        
        try? filePlayer.replace(file: fileToPlay)
        
        print("Player should be playing...")
        filePlayer.play()

    }

    //End of class
}

//*****************************************************************
// MARK: - DEPRECATED FUNCTIONS: This averaging filter was designed and implemented
//          to create a smoother frequency input but after testing proved to actually be
//          detrimental to the analaysis procedure so was omitted. It is commented here for 
//          reference
//*****************************************************************

//    func averagingFilter(_ inputFreq: Double) -> Double{
//
//        var averageValue = 0.0
//
//        for (i, _) in dataArray.enumerated() {
//
//            let j = i+1
//
//            //Shift all elements by -1 index
//            if j == 100{
//                dataArray[i] = inputFreq
//            } else{
//                dataArray[i] = dataArray[j]
//            }
//        }
//
//        for value in dataArray {
//
//            averageValue += value
//        }
//
//        let computedAverage = averageValue / 100
//
//        return computedAverage
//    }


