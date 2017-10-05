//
//  NewTableViewCell.swift
//  NurseProject
//
//  Created by Jeyavijay on 29/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import SwipeCellKit


class NewTableViewCell: SwipeTableViewCell {

    @IBOutlet var imageViewUnits: UIImageView!
    @IBOutlet var labelDate: UILabel!
    @IBOutlet var labelHospitalName: UILabel!
    @IBOutlet var labelMedicalUnit: UILabel!
    @IBOutlet var labelShift: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CornerRadius().viewCircular(circleView: imageViewUnits)
    }
    
}
