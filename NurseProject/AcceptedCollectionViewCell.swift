//
//  AcceptedCollectionViewCell.swift
//  NurseProject
//
//  Created by Jeyavijay on 28/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit

class AcceptedCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageViewLady: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CornerRadius().viewCircular(circleView: imageViewLady)
    }

}
