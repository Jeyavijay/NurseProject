//
//  SpecialitiesTableViewCell.swift
//  NurseProject
//
//  Created by Selva's MacBook Pro on 16/10/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit

class SpecialitiesTableViewCell: UITableViewCell {
    
    @IBOutlet var labelTitle:UILabel!
    @IBOutlet var buttonCheckBox:ButtonIndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
