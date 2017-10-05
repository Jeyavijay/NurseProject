//
//  FirstSignUpViewController.swift
//  NurseProject
//
//  Created by Jeyavijay on 15/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import TextFieldEffects
import PopupDialog

class FirstSignUpViewController: UIViewController,UITextFieldDelegate {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var textFieldFirstName: HoshiTextField!
    @IBOutlet var textFieldMiddleName: HoshiTextField!
    @IBOutlet var textFieldLastName: HoshiTextField!
    @IBOutlet var textFieldMailID: HoshiTextField!
    @IBOutlet var textFieldPhoneNumber: HoshiTextField!
    @IBOutlet var textFieldPassword: HoshiTextField!
    @IBOutlet var textFieldCPassword: HoshiTextField!

    var dictStoredValues = NSMutableDictionary()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textFieldUI()
    }
    
    func textFieldUI(){
        textFieldUII(textField: textFieldFirstName)
        textFieldUII(textField: textFieldMiddleName)
        textFieldUII(textField: textFieldLastName)
        textFieldUII(textField: textFieldMailID)
        textFieldUII(textField: textFieldPhoneNumber)
        textFieldUII(textField: textFieldCPassword)
        textFieldUII(textField: textFieldPassword)

    }
    
    func textFieldUII(textField:HoshiTextField){
        textField.borderActiveColor = AppColors().appBlueColor
        textField.placeholderColor = UIColor.darkGray
        textField.borderInactiveColor = UIColor.gray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button Actions

    @IBAction func buttonNext(_ sender: Any)
    {
        if (textFieldFirstName.text?.characters.count)! <= 2
        {
            self.popupAlertQuiz(msg: "Please Enter Valid Name")
        }else if (textFieldLastName.text?.characters.count)! < 1
        {
            self.popupAlertQuiz(msg: "Last Name Must Not be Empty!!")
        }else if (EmailValidation().validateMail(textEmail: self.textFieldMailID.text!) == false)
        {
            self.popupAlertQuiz(msg: "Please Enter Valid Miail-ID")
        }else if (textFieldPhoneNumber.text?.characters.count)! <= 9
        {
            self.popupAlertQuiz(msg: "Please Enter Valid Phone Number")
        }else  if (textFieldPassword.text?.characters.count)! < 6{
            self.popupAlertQuiz(msg: "Password Must atleast 6 Characters")
        }else if textFieldPassword.text != textFieldCPassword.text{
            self.popupAlertQuiz(msg: "Password Doesnot Match")
        }else{
            dictStoredValues.setObject(textFieldFirstName.text!, forKey: "FirstName" as NSCopying)
            dictStoredValues.setObject(textFieldMiddleName.text!, forKey: "MiddleName" as NSCopying)

            dictStoredValues.setObject(textFieldLastName.text!, forKey: "LastName" as NSCopying)
            dictStoredValues.setObject(textFieldMailID.text!, forKey: "Email" as NSCopying)
            dictStoredValues.setObject(textFieldPhoneNumber.text!, forKey: "Mobile" as NSCopying)

            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"ViewController") as! ViewController
            self.navigationController?.pushViewController(nextViewController, animated: false)

        }

    }
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Alert PopUps
    
    func popupAlertQuiz(msg:String)
    {
        let title = "Information"
        let message = msg
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonTwo = DefaultButton(title: "OK")
        {
            
        }
        buttonTwo.buttonColor = AppColors().appBlueColor
        buttonTwo.titleColor = UIColor.white
        popup.addButtons([buttonTwo])
        self.present(popup, animated: true, completion: nil)
    }
    
    


}
