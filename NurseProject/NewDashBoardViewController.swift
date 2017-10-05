//
//  NewDashBoardViewController.swift
//  NurseProject
//
//  Created by Jeyavijay on 28/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwipeCellKit



class NewDashBoardViewController: UIViewController, IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate {

    @IBOutlet var tableViewNew: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
    }
    
    func configureUI(){
        
        self.tableViewNew.register(UINib(nibName: "NewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "New")
        tableViewNew.reloadData()

    }
    
    //MARK: - Tableview Delegate Methods -
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "New") as! NewTableViewCell!
        Cell!.delegate = self
        
        if indexPath.section == 0{
            Cell!.imageViewUnits.image = UIImage(named: "lady")
            Cell!.labelHospitalName.text = "Hospital of Monterery Peninsula"
            Cell!.labelMedicalUnit.text = "Labor & Delivery"
            Cell!.labelShift.text = "Night Shift"
            Cell!.labelDate.text = "August 14, 2017"
            
        }else if indexPath.section == 1{
            Cell!.imageViewUnits.image = UIImage(named: "bed")
            Cell!.labelHospitalName.text = "Natividad Medical Centre"
            Cell!.labelMedicalUnit.text = "Intensiva Care Unit (ICU)"
            Cell!.labelShift.text = "12 Hour Shift"
            Cell!.labelDate.text = "August 15, 2017"

            
        }else if indexPath.section == 2{
            Cell!.imageViewUnits.image = UIImage(named: "tablet")
            Cell!.labelHospitalName.text = "Natividad Medical Centre"
            Cell!.labelMedicalUnit.text = "Mental Health"
            Cell!.labelShift.text = "Day Shift"
            Cell!.labelDate.text = "August 17, 2017"

            
        }
        
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
        
        if orientation == .left{
            let deleteAction = SwipeAction(style: .default, title: "") { action, indexPath in
                // handle action by updating model with deletion
            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "cash")
            
            return [deleteAction]
        }else{
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
            }

            deleteAction.image = UIImage(named: "Trash-circle")
            
            return [deleteAction]
        }

    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "New")
    }
    
}

