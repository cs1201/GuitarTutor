//
//  constants.swift
//  GuitarTuner
//
//  Created by cs1201 on 08/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//
//
//  This file is a globally accessed store of all constants and data needed
//  by the system.
//
//

import Foundation
import UIKit

class constants{
    
    //Singleton class to be accessed app-wide
    static let sharedInstance = constants()
    
    //Various global variables
    var boxColour = UIColor.green
    var pitchAccuracy = 20.0 //Inital pitch resolution accuracy
    var loop = true
    var isRecording = false
    var targetNote = ""

    var currentNote = ""
    var currentCent = 0.0
    
    var storedRiff = 0
    var storedNoteStep = 0
    var storedTabImg = "blank.png"
    var isNotLoaded = true
    
    var amplitudeThreshold = 0.001
    
    var riffsList = ["Choose riff...",
                     "Smoke on the water",
                     "Sweet Child o' Mine",
                     "Seven Nation Army",
                     "Enter Sandman",
                     "Billie Jean"]
    
    //Custom data struct for storing Riff note and position info
    struct notePos {

        let notes: [String]
        let xPos: [Int]
        let yPos: [Int]
    }
    
    var riffInfo = [notePos]()
    
    var riff0 = ["E2", "G2", "A2", "E2", "G2", "A#2/Bb2", "A2", "E2",
                 "G2", "A2", "G2", "E2"]
    var riff0_x = [85, 117, 146, 173, 201, 229, 263, 355, 385, 417, 453, 480]
    var riff0_y = [210, 210, 210, 210, 210, 210, 210, 210, 210, 210, 210, 210]
    
    var riff1 = ["D4", "D5", "A4", "G4", "G5", "A4", "F#5/Gb5", "A4",
                "E4", "D5", "A4", "G4", "G5", "A4", "F#5/Gb5", "A4"]
    var riff1_x = [57, 109, 169, 231, 285, 351, 409, 465,
                   57, 109, 169, 231, 285, 351, 409, 465]
    var riff1_y = [152, 152, 152, 152, 152, 152, 152, 152,
                   282, 282, 282, 282, 282, 282, 282, 282]
    
    var riff2 = ["E3", "E3", "G3", "E3", "D3", "C3", "B2",
                 "E3", "E3", "G3", "E3", "D3", "C3", "D3",
                 "C3", "B2"]
    
    var riff2_x = [91, 171, 216, 262, 308, 375, 474,
                   91, 171, 216, 262, 308, 375, 420, 468, 474]
    var riff2_y = [157, 157, 157, 157, 157, 157, 157,
                   272, 272, 272, 272, 272, 272, 272,
                   272, 272]
    
    var riff3 = ["E2", "E3", "G3", "A#2/Bb2", "A2", "E3",
                 "E2", "E3", "G3", "A#2/Bb2", "A2", "E3",
                 "E2", "E3", "G3", "A#2/Bb2", "A2", "E3",
                 "E2", "E3", "G3", "A#2/Bb2", "A2", "E3"]
    
    var riff3_x = [49, 84, 120, 165, 211, 270,
                   351, 386, 422, 472, 512, 573,
                   49, 84, 120, 165, 211, 270,
                   351, 386, 422, 472, 512, 573]
    
    var riff3_y = [165, 165, 165, 165, 165, 165,
                   165, 165, 165, 165, 165, 165,
                   263, 263, 263, 263, 263, 263,
                   263, 263, 263, 263, 263, 263]
    
    var riff4 = ["E2", "G2", "B2", "G3", "E3", "F#3/Gb3", "E3", "D3", "D3",
                 "E2", "G2", "B2", "G3", "E3", "F#3/Gb3", "E3", "D3"]
    
    var riff4_x = [49, 86, 127, 165, 207, 285, 374, 436, 500,
                   49, 86, 127, 165, 207, 285, 374, 436]
    
    var riff4_y = [166, 166, 166, 166, 166, 166, 166, 166, 166,
                   270, 270, 270, 270, 270, 270, 270, 270]
    
    var imageName = [ "blank.png",
                      "SOTW.png",
                      "SCOM.png",
                      "SNA.png",
                      "ESM.png",
                      "BJN.png"]
    
    init(){
        
        //Place above info into array using pre-defined custom struct
        riffInfo = [
            notePos(notes: [""], xPos: [0], yPos: [0]),
            notePos(notes: riff0, xPos: riff0_x, yPos: riff0_y),
            notePos(notes: riff1, xPos: riff1_x, yPos: riff1_y),
            notePos(notes: riff2, xPos: riff2_x, yPos: riff2_y),
            notePos(notes: riff3, xPos: riff3_x, yPos: riff3_y),
            notePos(notes: riff4, xPos: riff4_x, yPos: riff4_y)
        ]
    }
}
