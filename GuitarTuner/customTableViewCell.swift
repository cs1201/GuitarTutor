//
//  customTableViewCell.swift
//  GuitarTuner
//
//  Created by cs1201 on 11/04/2018.
//  Copyright © 2018 Connor Stoner. All rights reserved.
//
//  Defines UI elements of the custom table cell to be used in the
//  recording files page
//

import UIKit

class customTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
