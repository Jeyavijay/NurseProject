//
//  CornerRadius.swift
//  NurseProject
//
//  Created by Jeyavijay on 16/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit

class CornerRadius: NSObject {
    
    func viewCircular(circleView : UIView)
    {
        
        circleView.frame = CGRect(x: circleView.frame.origin.x, y: circleView.frame.origin.y, width: circleView.frame.size.width, height: circleView.frame.size.width)
        circleView.layer.cornerRadius = circleView.layer.frame.size.width/2
        circleView.layer.masksToBounds = true
    }
}
