//
//  recordingData.swift
//  GuitarTuner
//
//  Created by cs1201 on 11/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//

import Foundation

class recordingData {
    
    static let sharedInstance = recordingData()
    
    var urlNames = [String]()
    //var urlPaths = [String]()
    var fileManager = FileManager.default
    var docURL: String!
    
    func scanDocuments(){
        //Find URL of documents directory for application
        docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        
        //Return array of all URL names of files in docs
        try? urlNames = fileManager.contentsOfDirectory(atPath: docURL)
    }
    
    
    //Delete specific file in documents folder
    func deleteDocument(_ index: Int){
        
        //Re-construct full URL path for files in doc directory
        let toDelete = docURL + "/" + urlNames[index]
        print(toDelete)
        
        //Try to delete file at URL
        do{
            try fileManager.removeItem(atPath: toDelete)
        }catch{
            print("Could not delete file")
        }
        //Re scan file name array to reinstate present files
        scanDocuments()
    }
    
    //Deletes all files in documents folder
    func deleteAll(){
        
        for url in urlNames{
            let toDelete = docURL + "/" + url
            print(toDelete)
            
            do{
                try fileManager.removeItem(atPath: toDelete)
            }catch{
                print("Could not delete file")
            }
        }
        scanDocuments()
        
    }
}