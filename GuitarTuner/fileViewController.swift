//
//  fileViewController.swift
//  GuitarTuner
//
//  Created by cs1201 on 11/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//

import UIKit
import AudioKit

//ViewController for recording file page
class fileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! //Declare table view
    let recData = recordingData.sharedInstance //Access shared instances of required classes
    let audioEngine = AudioEngine.sharedInstance
    var fileURL: String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Setup tableView delegates
        tableView.delegate = self
        tableView.dataSource = self
        //Set background image of page
        let tempImageView = UIImageView(image: UIImage(named: "table_BG.png"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
    }
    
    //Table View Setup - number of cells derived from accessing file storage
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recData.urlNames.count
    }
    
    //Create table cells based on custom cell file
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
    
    //Load file URL from global array and trigger audioEngine to begin playback
    func loadFile(sender: UIButton) {
        let index = sender.tag
        
        fileURL = recData.urlNames[index]
        audioEngine.loadFile(fileURL)
        
    }
}
