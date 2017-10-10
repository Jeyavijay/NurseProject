//
//  AccountDetailStatementViewController.swift
//  NurseProject
//
//  Created by Jeyavijay on 17/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import PopupDialog
import AFNetworking
import NVActivityIndicatorView



class AccountDetailStatementViewController: UIViewController {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

    @IBOutlet var button1No: UIButton!
    @IBOutlet var button1Yes: UIButton!
    @IBOutlet var button2Yes: UIButton!
    @IBOutlet var button2No: UIButton!
    @IBOutlet var button3Yes: UIButton!
    @IBOutlet var button3No: UIButton!
    @IBOutlet var button4Yes: UIButton!
    @IBOutlet var button4No: UIButton!
    @IBOutlet var button5Yes: UIButton!
    @IBOutlet var button5No: UIButton!
    @IBOutlet var labelLine1: UILabel!
    @IBOutlet var labelLine2: UILabel!
    @IBOutlet var labelLine3: UILabel!
    @IBOutlet var labelLine4: UILabel!
    @IBOutlet var labelLine5: UILabel!
    var stringOption1 = NSString()
    var stringOption2 = NSString()
    var stringOption3 = NSString()
    var stringOption4 = NSString()
    var stringOption5 = NSString()
    var activity:NVActivityIndicatorView!
    var dictParameters = NSMutableDictionary()



    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        
    }
    
    func loadUI(){
        let DSImage:UIImage = UIImage(named: "unchecked")!
        let SImage:UIImage = UIImage(named: "checked")!
        button1No.setImage(DSImage, for: .normal)
        button1No.setImage(SImage, for: .selected)
        button1Yes.setImage(DSImage, for: .normal)
        button1Yes.setImage(SImage, for: .selected)
        button2No.setImage(DSImage, for: .normal)
        button2No.setImage(SImage, for: .selected)
        button2Yes.setImage(DSImage, for: .normal)
        button2Yes.setImage(SImage, for: .selected)
        button3No.setImage(DSImage, for: .normal)
        button3No.setImage(SImage, for: .selected)
        button3Yes.setImage(DSImage, for: .normal)
        button3Yes.setImage(SImage, for: .selected)
        button4No.setImage(DSImage, for: .normal)
        button4No.setImage(SImage, for: .selected)
        button4Yes.setImage(DSImage, for: .normal)
        button4Yes.setImage(SImage, for: .selected)
        button5No.setImage(DSImage, for: .normal)
        button5No.setImage(SImage, for: .selected)
        button5Yes.setImage(DSImage, for: .normal)
        button5Yes.setImage(SImage, for: .selected)
        labelLine1.frame = CGRect(x: labelLine1.frame.origin.x, y: labelLine1.frame.origin.y, width: labelLine1.frame.width, height: 1)
        labelLine2.frame = CGRect(x: labelLine2.frame.origin.x, y: labelLine2.frame.origin.y, width: labelLine2.frame.width, height: 1)
        labelLine3.frame = CGRect(x: labelLine3.frame.origin.x, y: labelLine3.frame.origin.y, width: labelLine3.frame.width, height: 1)
        labelLine4.frame = CGRect(x: labelLine4.frame.origin.x, y: labelLine4.frame.origin.y, width: labelLine4.frame.width, height: 1)
        labelLine5.frame = CGRect(x: labelLine5.frame.origin.x, y: labelLine5.frame.origin.y, width: labelLine5.frame.width, height: 1)
        self.setLoadingIndicator()

    }

    //MARK:- Button Actions
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonNext(_ sender: Any)
    {
        if (button1Yes.isSelected || button1No.isSelected) == false{
            self.popupAlert(Title: "Information",msg: stringMessages().stringLisenceInvestigation)
        }else if (button2Yes.isSelected || button2No.isSelected) == false{
            self.popupAlert(Title: "Information",msg: stringMessages().stringConvictedCrime)
        }else if (button3Yes.isSelected || button3No.isSelected) == false{
            self.popupAlert(Title: "Information",msg: stringMessages().stringConvictedFelonyCharges)
        }else if (button4Yes.isSelected || button4No.isSelected) == false{
            self.popupAlert(Title: "Information",msg: stringMessages().stringProfessionalLiability)
        }else if (button5Yes.isSelected || button5No.isSelected) == false{
            self.popupAlert(Title: "Information",msg: stringMessages().stringLegalRightVerification)
        }else{
            let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
            dictParameters.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
            dictParameters.setObject(stringOption1, forKey: "optionsRadios1" as NSCopying)
            dictParameters.setObject(stringOption2, forKey: "optionsRadios2" as NSCopying)
            dictParameters.setObject(stringOption3, forKey: "optionsRadios3" as NSCopying)
            dictParameters.setObject(stringOption4, forKey: "optionsRadios4" as NSCopying)
            dictParameters.setObject(stringOption5, forKey: "optionsRadios5" as NSCopying)
            dictParameters.setObject("1", forKey: "stepid" as NSCopying)
            self.CallWebserviceReistration(params:dictParameters)
        }
    }
    
    @IBAction func button1(_ sender: Any)
    {
        if (sender as AnyObject).tag == 1{
            if button1Yes.isSelected == true{
                button1Yes.isSelected = false
                stringOption1 = "2"
            }else{
                button1Yes.isSelected = true
                button1No.isSelected = false
                stringOption1 = "1"

            }
        }else if (sender as AnyObject).tag == 2{
            if button1No.isSelected == true{
                stringOption1 = "1"
                button1No.isSelected = false
            }else{
                button1No.isSelected = true
                button1Yes.isSelected = false
                stringOption1 = "2"
            }
        }
    }
    @IBAction func button2(_ sender: Any)
    {
        if (sender as AnyObject).tag == 3{
            if button2Yes.isSelected == true{
                stringOption2 = "2"
                button2Yes.isSelected = false
            }else{
                stringOption2 = "1"
                button2Yes.isSelected = true
                button2No.isSelected = false
            }
        }else if (sender as AnyObject).tag == 4{
            if button2No.isSelected == true{
                button2No.isSelected = false
                stringOption2 = "1"

            }else{
                button2No.isSelected = true
                button2Yes.isSelected = false
                stringOption2 = "2"
            }
        }
    }
    @IBAction func button3(_ sender: Any)
    {
        if (sender as AnyObject).tag == 5{
            if button3Yes.isSelected == true{
                stringOption3 = "2"
                button3Yes.isSelected = false
            }else{
                button3Yes.isSelected = true
                button3No.isSelected = false
                stringOption3 = "1"
            }
        }else if (sender as AnyObject).tag == 6{
            if button3No.isSelected == true{
                button3No.isSelected = false
                stringOption3 = "1"
            }else{
                button3No.isSelected = true
                button3Yes.isSelected = false
                stringOption3 = "2"
            }
        }
    }
    @IBAction func button4(_ sender: Any)
    {
        if (sender as AnyObject).tag == 7{
            if button4Yes.isSelected == true{
                button4Yes.isSelected = false
                stringOption4 = "2"
            }else{
                button4Yes.isSelected = true
                button4No.isSelected = false
                stringOption4 = "1"
            }
        }else if (sender as AnyObject).tag == 8{
            if button4No.isSelected == true{
                button4No.isSelected = false
                stringOption4 = "1"
            }else{
                button4No.isSelected = true
                button4Yes.isSelected = false
                stringOption4 = "2"
            }
        }
    }
    @IBAction func button5(_ sender: Any)
    {
        if (sender as AnyObject).tag == 9{
            if button5Yes.isSelected == true{
                button5Yes.isSelected = false
                stringOption5 = "2"
            }else{
                button5Yes.isSelected = true
                button5No.isSelected = false
                stringOption5 = "1"
            }
        }else if (sender as AnyObject).tag == 10{
            if button5No.isSelected == true{
                button5No.isSelected = false
                stringOption5 = "1"
            }else{
                button5No.isSelected = true
                button5Yes.isSelected = false
                stringOption5 = "2"
            }
        }
    }

    //MARK:- Webservices
    
    func CallWebserviceReistration(params:NSMutableDictionary)
    {
        startLoading()
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().completeRegistrationUrl) as NSString
        
        let strAuth:String = UserDefaults.standard.value(forKey: "Authentication") as! String
        manager.requestSerializer.setValue(strAuth, forHTTPHeaderField: "Authorization")
        manager.post(stringURL as String, parameters: params, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            print(responseDictionary)
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == "1"{
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"AccountDetailsViewController") as! AccountDetailsViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }else if strStatus == "401"{
                    self.callWebserviseAccessToken()
                }else{
                    self.stopLoading()
                    if let Msg:String = (responseDictionary).value(forKey: "msg") as? String{
                        self.popupAlert(Title: "Information", msg: Msg)
                    }
                }
            }
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription)
        })
    }
    func callWebserviseAccessToken(){
        startLoading()
        let parameter = NSMutableDictionary()
        let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
        let strPassword:String = UserDefaults.standard.value(forKey: "password") as! String
        parameter.setObject(strNurseID, forKey: "username" as NSCopying)
        parameter.setObject(strPassword, forKey: "password" as NSCopying)
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().getAccessTokenUrl) as NSString
        
        manager.post(stringURL as String, parameters: parameter, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            print(responseDictionary)
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == "1"
                {
                    if let AccessToken:String = (responseDictionary).value(forKey: "access_token") as? String{
                        let strToken:String = String(format: "Bearer %@",AccessToken)
                        UserDefaults.standard.set(strToken, forKey:"Authentication" )
                    }
                    self.CallWebserviceReistration(params:self.dictParameters)
                }
                self.stopLoading()
            }
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription)
        })
    }
    
    //MARK:- Alert PopUps
    
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
    //MARK:- Activity Indicator View
    func setLoadingIndicator()
    {
        activity = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        activity.color = AppColors().appBlueColor
        activity.type = NVActivityIndicatorType.ballScaleMultiple
        activity.startAnimating()
        activity.center = view.center
    }
    func startLoading()
    {
        view.isUserInteractionEnabled = false
        self.view.addSubview(activity)
    }
    
    func stopLoading(){
        activity.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
    
}
