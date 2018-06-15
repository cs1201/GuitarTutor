//
//  audioEngineDelegate.swift
//  GuitarTuner
//
//  Created by cs1201 on 12/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//

import Foundation

protocol audioEngineDelegate {
    
    //Delegated functions to alert VC to update based on audioEngine analysis
    func moveNoteBox(x: Int, y: Int)
    func changeNoteName(_ noteName: String)
    func changeNoteStep(_ noteStep: Int)
    
}
