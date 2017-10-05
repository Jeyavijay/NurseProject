//
//  MyDashBoardViewController.swift
//  NurseProject
//
//  Created by Jeyavijay on 28/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class MyDashBoardViewController: ButtonBarPagerTabStripViewController {
    
    
    
    
    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var imageViewUserImage: UIImageView!
    
    

    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = AppColors().appBlueColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 18)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = AppColors().appBlueColor
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
                guard changeCurrentIndex == true else { return }
                
            oldCell?.label.textColor = UIColor.darkGray
            newCell?.label.textColor = AppColors().appBlueColor
                
                if animated {
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    })
                } else {
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }
        }
        
        
        super.viewDidLoad()
        self.configureUI()
    }
    
    func configureUI(){
        CornerRadius().viewCircular(circleView: imageViewUserImage)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDashBoardViewController")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AcceptedDashBoardViewController")
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashBoardViewController")
        return [child_1, child_2, child_3]
    }
    
    
    
}
