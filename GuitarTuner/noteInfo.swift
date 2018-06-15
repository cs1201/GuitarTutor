//
//  noteInfo.swift
//  GuitarTuner
//
//  Created by cs1201 on 07/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//
//  Contains globally accessible dictionary for all note names, frequency/midi
//  values. Utilising a custom data structure to store string, double and Int values
//

import Foundation

//  Contains globally accessible dictionary for all note names, frequency/midi
//  values. Utilising a custom data structure to store string, double and Int values
class noteInfo{
    
    struct noteFreqMidi {
        let freq: Double
        let midi: Int
    }
    
    var noteList = [
        "C0":       noteFreqMidi(freq: 16.35, midi: 12),
        "C#0/Db0":  noteFreqMidi(freq: 17.32, midi: 13),
        "D0":       noteFreqMidi(freq: 18.35, midi: 14),
        "D#0/Eb0":	noteFreqMidi(freq: 19.45, midi: 15),
        "E0":       noteFreqMidi(freq: 20.60, midi: 16),
        "F0":       noteFreqMidi(freq: 21.83, midi: 17),
        "F#0/Gb0":	noteFreqMidi(freq: 23.12, midi: 18),
        "G0":       noteFreqMidi(freq: 24.50, midi: 19),
        "G#0/Ab0":	noteFreqMidi(freq: 25.96, midi: 20),
        "A0":       noteFreqMidi(freq: 27.50, midi: 21),
        "A#0/Bb0":	noteFreqMidi(freq: 29.14, midi: 22),
        "B0":       noteFreqMidi(freq: 30.87, midi: 23),
        "C1":       noteFreqMidi(freq: 32.70, midi: 24),
        "C#1/Db1": 	noteFreqMidi(freq: 34.65, midi: 25),
        "D1":       noteFreqMidi(freq: 36.71, midi: 26),
        "D#1/Eb1": 	noteFreqMidi(freq: 38.89, midi: 27),
        "E1":       noteFreqMidi(freq: 41.20, midi: 28),
        "F1":       noteFreqMidi(freq: 43.65, midi: 29),
        "F#1/Gb1": 	noteFreqMidi(freq: 46.25, midi: 30),
        "G1":       noteFreqMidi(freq: 49.00, midi: 31),
        "G#1/Ab1": 	noteFreqMidi(freq: 51.91, midi: 32),
        "A1":       noteFreqMidi(freq: 55.00, midi: 33),
        "A#1/Bb1": 	noteFreqMidi(freq: 58.27, midi: 34),
        "B1":       noteFreqMidi(freq: 61.74, midi: 35),
        "C2":       noteFreqMidi(freq: 65.41, midi: 36),
        "C#2/Db2": 	noteFreqMidi(freq: 69.30, midi: 37),
        "D2":       noteFreqMidi(freq: 73.42, midi: 38),
        "D#2/Eb2": 	noteFreqMidi(freq: 77.78, midi: 39),
        "E2":       noteFreqMidi(freq: 82.41, midi: 40),
        "F2":       noteFreqMidi(freq: 87.31, midi: 41),
        "F#2/Gb2": 	noteFreqMidi(freq: 92.50, midi: 42),
        "G2":       noteFreqMidi(freq: 98.00, midi: 43),
        "G#2/Ab2": 	noteFreqMidi(freq: 103.83, midi: 44),
        "A2":       noteFreqMidi(freq: 110.00, midi: 45),
        "A#2/Bb2": 	noteFreqMidi(freq: 116.54, midi: 46),
        "B2":       noteFreqMidi(freq: 123.47, midi: 47),
        "C3":       noteFreqMidi(freq: 130.81, midi: 48),
        "C#3/Db3": 	noteFreqMidi(freq: 138.59, midi: 49),
        "D3":       noteFreqMidi(freq: 146.83, midi: 50),
        "D#3/Eb3": 	noteFreqMidi(freq: 155.56, midi: 51),
        "E3":       noteFreqMidi(freq: 164.81, midi: 52),
        "F3":       noteFreqMidi(freq: 174.61, midi: 53),
        "F#3/Gb3": 	noteFreqMidi(freq: 185.00, midi: 54),
        "G3":       noteFreqMidi(freq: 196.00, midi: 55),
        "G#3/Ab3":	noteFreqMidi(freq: 207.65, midi: 56),
        "A3":       noteFreqMidi(freq: 220.00, midi: 57),
        "A#3/Bb3": 	noteFreqMidi(freq: 233.08, midi: 58),
        "B3":       noteFreqMidi(freq: 246.94, midi: 59),
        "C4":       noteFreqMidi(freq: 261.63, midi: 60),
        "C#4/Db4":	noteFreqMidi(freq: 277.18, midi: 61),
        "D4":       noteFreqMidi(freq: 293.66, midi: 62),
        "D#4/Eb4": 	noteFreqMidi(freq: 311.13, midi: 63),
        "E4":       noteFreqMidi(freq: 329.63, midi: 64),
        "F4":       noteFreqMidi(freq: 349.23, midi: 65),
        "F#4/Gb4":	noteFreqMidi(freq: 369.99, midi: 66),
        "G4":       noteFreqMidi(freq: 392.00, midi: 67),
        "G#4/Ab4": 	noteFreqMidi(freq: 415.30, midi: 68),
        "A4":       noteFreqMidi(freq: 440.00, midi: 69),
        "A#4/Bb4": 	noteFreqMidi(freq: 466.16, midi: 70),
        "B4":       noteFreqMidi(freq: 493.88, midi: 71),
        "C5":       noteFreqMidi(freq: 523.25, midi: 72),
        "C#5/Db5":	noteFreqMidi(freq: 554.37, midi: 73),
        "D5":       noteFreqMidi(freq: 587.33, midi: 74),
        "D#5/Eb5": 	noteFreqMidi(freq: 622.25, midi: 75),
        "E5":       noteFreqMidi(freq: 659.25, midi: 76),
        "F5":       noteFreqMidi(freq: 698.46, midi: 77),
        "F#5/Gb5": 	noteFreqMidi(freq: 739.99, midi: 78),
        "G5":       noteFreqMidi(freq: 783.99, midi: 79),
        "G#5/Ab5": 	noteFreqMidi(freq: 830.61, midi: 80),
        "A5":       noteFreqMidi(freq: 880.00, midi: 81),
        "A#5/Bb5": 	noteFreqMidi(freq: 932.33, midi: 82),
        "B5":       noteFreqMidi(freq: 987.77, midi: 83),
        "C6":       noteFreqMidi(freq: 1046.50, midi: 84),
        "C#6/Db6":	noteFreqMidi(freq: 1108.73, midi: 85),
        "D6":       noteFreqMidi(freq: 1174.66, midi: 86),
        "D#6/Eb6": 	noteFreqMidi(freq: 1244.51, midi: 87),
        "E6":       noteFreqMidi(freq: 1318.51, midi: 88),
        "F6":       noteFreqMidi(freq: 1396.91, midi: 89),
        "F#6/Gb6":	noteFreqMidi(freq: 1479.98, midi: 90),
        "G6":       noteFreqMidi(freq: 1567.98, midi: 91),
        "G#6/Ab6": 	noteFreqMidi(freq: 1661.22, midi: 92),
        "A6":       noteFreqMidi(freq: 1760.00, midi: 93),
        "A#6/Bb6":	noteFreqMidi(freq: 1864.66, midi: 94),
        "B6":       noteFreqMidi(freq: 1975.53, midi: 95),
        "C7":       noteFreqMidi(freq: 2093.00, midi: 96),
        "C#7/Db7":	noteFreqMidi(freq: 2217.46, midi: 97),
        "D7":       noteFreqMidi(freq: 2349.32, midi: 98),
        "D#7/Eb7":	noteFreqMidi(freq: 2489.02, midi: 99),
        "E7":       noteFreqMidi(freq: 2637.02, midi: 100),
        "F7":       noteFreqMidi(freq: 2793.83, midi: 101),
        "F#7/Gb7":	noteFreqMidi(freq: 2959.96, midi: 102),
        "G7":       noteFreqMidi(freq: 3135.96, midi: 103),
        "G#7/Ab7":	noteFreqMidi(freq: 3322.44, midi: 104),
        "A7":       noteFreqMidi(freq: 3520.00, midi: 105),
        "A#7/Bb7": 	noteFreqMidi(freq: 3729.31, midi: 106),
        "B7":       noteFreqMidi(freq: 3951.07, midi: 107),
        "C8":       noteFreqMidi(freq: 4186.01, midi: 108),
        "C#8/Db8": 	noteFreqMidi(freq: 4434.92, midi: 109),
        "D8":       noteFreqMidi(freq: 4698.63, midi: 110),
        "D#8/Eb8": 	noteFreqMidi(freq: 4978.03, midi: 111),
        "E8":       noteFreqMidi(freq: 5274.04, midi: 112),
        "F8":       noteFreqMidi(freq: 5587.65, midi: 113),
        "F#8/Gb8":	noteFreqMidi(freq: 5919.91, midi: 114),
        "G8":       noteFreqMidi(freq: 6271.93, midi: 115),
        "G#8/Ab8":	noteFreqMidi(freq: 6644.88, midi: 116),
        "A8":       noteFreqMidi(freq: 7040.00, midi: 117),
        "A#8/Bb8":	noteFreqMidi(freq: 7458.62, midi: 118),
        "B8":       noteFreqMidi(freq: 7902.13, midi: 119)
    ]   
}
