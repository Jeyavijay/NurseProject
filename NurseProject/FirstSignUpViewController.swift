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
            self.popupAlert(Title: "Information",msg: stringMessages().stringFirstName)
        }else if (textFieldLastName.text?.characters.count)! < 1
        {
            self.popupAlert(Title: "Information",msg: stringMessages().stringLastName)
        }else if (EmailValidation().validateMail(textEmail: self.textFieldMailID.text!) == false)
        {
            self.popupAlert(Title: "Information",msg: stringMessages().stringMail)
        }else if (textFieldPhoneNumber.text?.characters.count)! <= 9
        {
            self.popupAlert(Title: "Information",msg: stringMessages().stringMail)
        }else  if (textFieldPassword.text?.characters.count)! < 6{
            self.popupAlert(Title: "Information",msg: stringMessages().stringPassword)
        }else if textFieldPassword.text != textFieldCPassword.text{
            self.popupAlert(Title: "Information",msg: stringMessages().stringConfirmPassword)
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
    
    func popupAlert(Title:String,msg:String)
    {
        let title = Title
        let message = msg
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonOk = DefaultButton(title: "OK")
        {
        }
        buttonOk.buttonColor = UIColor.red
        buttonOk.titleColor = UIColor.white
        popup.addButtons([buttonOk])
        self.present(popup, animated: true, completion: nil)
    }



}
