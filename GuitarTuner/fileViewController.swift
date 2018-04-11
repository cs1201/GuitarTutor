//
//  fileViewController.swift
//  GuitarTuner
//
//  Created by cs1201 on 11/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//

import UIKit
import AudioKit

class fileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let recData = recordingData.sharedInstance
    var player: AKAudioPlayer!
    var fileToPlay: AKAudioFile!
    var fileURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup tableView delegates
        tableView.delegate = self
        tableView.dataSource = self

        //Dummy audio file initalised with audioPlayer
        fileToPlay = try? AKAudioFile(readFileName: "dummy.wav", baseDir: .resources)
        player = try? AKAudioPlayer(file: fileToPlay)
        
        AudioKit.output = player
        AudioKit.start()
    }
    
    //Table View Setup
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recData.urlNames.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! customTableViewCell
        
        cell.nameLabel.text = removeFileEx(recData.urlNames[indexPath.row])
        cell.playButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(loadFile), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteFile), for: .touchUpInside)
        
        return cell
    }
    
    //Remove file extension
    func removeFileEx(_ string: String) -> String {
        let endIndex = string.index(string.endIndex, offsetBy: -4)
        return string.substring(to: endIndex)
    }
    
    //Delete all files in list if button pressed
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        
        recData.deleteAll()
        tableView.reloadData()
    }
    
    
    
    //Delete file from table view and external array of clips
    func deleteFile(sender: UIButton){
        
        let index = sender.tag
        
        recData.deleteDocument(index)
        
        //Remove cell in tableview at index
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    func loadFile(sender: UIButton) {
        let index = sender.tag
        
        fileURL = recData.urlNames[index]
        
        do{
            try fileToPlay = AKAudioFile(readFileName: fileURL, baseDir: .documents)
        }catch{
            print("could not locate file")
        }
        
        try? player.replace(file: fileToPlay)
        
        print("Player should be playing...")
        player.play()
        
    }
}
