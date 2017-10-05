//
//  AccountDetailsEducationViewController.swift
//  NurseProject
//
//  Created by Jeyavijay on 17/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import MobileCoreServices
import PopupDialog



class AccountDetailsEducationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ChangeDocumentProtocol {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var tableViewEducation: UITableView!
    var nsectionCount = Int()
    var nsectionValue = Int()
    var nArrObject = Int()

    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nsectionCount = 1
        updateUI()

    }

    func updateUI()
    {
        self.tableViewEducation.register(UINib(nibName: "EducationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Education")
        self.tableViewEducation.register(UINib(nibName: "Education2TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "lastCell")
        tableViewEducation.reloadData()
    }


    //MARK: - Tableview Delegate Methods -
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return nsectionCount + 1
    }
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if nsectionCount == (indexPath as NSIndexPath).section{
            return self.view.frame.height/5.59
        }else{
            return self.view.frame.height/2.358
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        return viewHeader
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if nsectionCount == (indexPath as NSIndexPath).section{
            let lastCell = tableView.dequeueReusableCell(withIdentifier: "lastCell") as! Education2TableViewCell!
            lastCell!.buttonNext.addTarget(self, action: #selector(self.buttonNext), for: .touchUpInside)
            lastCell!.buttonAddMore.addTarget(self, action: #selector(self.buttonAddMore), for: .touchUpInside)

            return lastCell!
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "Education") as! EducationTableViewCell!
            Cell!.textFieldState.tag = indexPath.section
            Cell!.textFieldDate.tag = indexPath.section
            Cell!.textFieldNameofSchool.tag = indexPath.section
            Cell!.textFieldDegreeName.tag = indexPath.section
            Cell!.textFieldEducationLevel.tag = indexPath.section
            Cell!.buttonUpload.tag = indexPath.section
            Cell!.delegate = self

            return Cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableViewEducation.deselectRow(at: indexPath, animated: false)
    }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
        {
            if editingStyle == .delete
            {
                let arrayEducationalDetails = NSMutableArray()
                if ((UserDefaults.standard.value(forKey: "arrayEdu") != nil)){
                    if arrayEducationalDetails.count > 1{
                        let array:NSArray = UserDefaults.standard.array(forKey: "arrayEdu")! as NSArray
                        arrayEducationalDetails.addObjects(from: array as! [Any])
                        arrayEducationalDetails.removeObject(at: indexPath.section)
                        print(arrayEducationalDetails)
                        UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayEdu")
                        nsectionCount = nsectionCount - 1
                        self.tableViewEducation.reloadData()
                    }else{
                        nsectionCount = nsectionCount - 1
                        self.tableViewEducation.reloadData()
                    }
                }
            }
        }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0{
            return UITableViewCellEditingStyle.none
        }else if nsectionCount == (indexPath as NSIndexPath).section{
            return UITableViewCellEditingStyle.none
        }else{
            return UITableViewCellEditingStyle.delete
        }
    }
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    func buttonAddMore()
    {
        let arrayEducationalDetails = NSMutableArray()
        if ((UserDefaults.standard.value(forKey: "arrayEdu") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayEdu")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
            print(arrayEducationalDetails)
        }
        if arrayEducationalDetails.count == nsectionCount{
            let strEduLevel:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "educationLevel") as! String
            let strEduDegree:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Degree") as! String
            let strEduSchool:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "School") as! String
            let strState:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "State") as! String
            let strDate:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Date") as! String
            let strDocument:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Document") as! String

            if strEduLevel == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringEducationalLevel)
            }else if strEduDegree == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringDegreeName)
            }else if strEduSchool == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringNameofSchool)
            }else if strState == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringState)
            }else if strDate == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringGraduationDate)
            }else if strDocument == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringUploadFrontDegree)
            }else{
                nsectionCount = nsectionCount + 1
                tableViewEducation.reloadData()
            }
        }else{
            self.popupAlert(Title: "Information",msg: stringMessages().stringAddMore)
        }

    }
    
    func buttonNext()
    {
        let arrayEducationalDetails = NSMutableArray()
        if ((UserDefaults.standard.value(forKey: "arrayEdu") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayEdu")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
            print(arrayEducationalDetails)
        }
        if arrayEducationalDetails.count > 0{
            let strEduLevel:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "educationLevel") as! String
            let strEduDegree:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Degree") as! String
            let strEduSchool:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "School") as! String
            let strState:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "State") as! String
            let strDate:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Date") as! String
            let strDocument:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Document") as! String

            if strEduLevel == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringEducationalLevel)
            }else if strEduDegree == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringDegreeName)
            }else if strEduSchool == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringNameofSchool)
            }else if strState == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringState)
            }else if strDate == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringGraduationDate)
            }else if strDocument == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringUploadFrontDegree)
            }else{
                let nextViewController = storyBoard.instantiateViewController(withIdentifier:"EducationCertificationViewController") as! EducationCertificationViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }
    
    @objc func buttonUpload(_ sender: Any){
        print((sender as AnyObject).tag)
        nArrObject = (sender as AnyObject).tag
    }


    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    //MARK- Popup Alert

    func popupAlert(Title:String,msg:String)
    {
        let popup = PopupDialog(title: Title, message: msg, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonTwo = DefaultButton(title: "OK")
        {
        }
        buttonTwo.buttonColor = UIColor.red
        buttonTwo.titleColor = UIColor.white
        popup.addButtons([buttonTwo])
        self.present(popup, animated: true, completion: nil)
    }
    
    func loadDocScreen(controller: UIViewController) {
        self.present(controller, animated: true) { () -> Void in
        };
    }
    
}