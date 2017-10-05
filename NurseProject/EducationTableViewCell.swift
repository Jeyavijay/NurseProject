//
//  EducationTableViewCell.swift
//  NurseProject
//
//  Created by Jeyavijay on 17/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import TextFieldEffects
import NADocumentPicker
import BrightFutures

protocol ChangeDocumentProtocol : NSObjectProtocol {
    func loadDocScreen(controller: UIViewController) -> Void;
}
class EducationTableViewCell: UITableViewCell,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    weak var delegate: ChangeDocumentProtocol?

    
    var datePickerview = UIDatePicker()
    @IBOutlet var textFieldDate: HoshiTextField!
    @IBOutlet var textFieldState: HoshiTextField!
    @IBOutlet var textFieldNameofSchool: HoshiTextField!
    @IBOutlet var textFieldDegreeName: HoshiTextField!
    @IBOutlet var textFieldEducationLevel: HoshiTextField!
    var arrayPickerview = NSArray()
    var pickerviewList = UIPickerView()
    var nTextFieldTags = Int()
    var arrayEducationalDetails = NSMutableArray()
    var strDocument = NSString()
    
    @IBOutlet var labelDocument: UILabel!
    @IBOutlet var buttonUpload: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        strDocument = ""
        if ((UserDefaults.standard.value(forKey: "arrayEdu") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayEdu")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
            print(arrayEducationalDetails)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.textFieldUI(textField:textFieldDate)
        self.textFieldUI(textField:textFieldState)
        self.textFieldUI(textField:textFieldNameofSchool)
        self.textFieldUI(textField:textFieldDegreeName)
        self.textFieldUI(textField:textFieldEducationLevel)

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.textFieldEducationLevel{
            arrayPickerview = StaticArrayValues().arrayEducationLevel as NSArray
            nTextFieldTags = 1
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        if textField == self.textFieldDegreeName{
            arrayPickerview = StaticArrayValues().arrayDegree as NSArray
            nTextFieldTags = 2
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }

        if textField == self.textFieldState{
            arrayPickerview = StaticArrayValues().arrayUSStates as NSArray
            nTextFieldTags = 4
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        if textField == self.textFieldDate{
            datePickerview.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerview
            textField.inputView = datePickerview
            datePickerview.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dictArray = NSMutableDictionary()

        if textField.tag == 0{

            dictArray.setValue(textFieldEducationLevel.text, forKey: "educationLevel")
            dictArray.setValue(textFieldDegreeName.text, forKey: "Degree")
            dictArray.setValue(textFieldNameofSchool.text, forKey: "School")
            dictArray.setValue(textFieldState.text, forKey: "State")
            dictArray.setValue(textFieldDate.text, forKey: "Date")
            dictArray.setValue(strDocument, forKey: "Document")
            if arrayEducationalDetails.count == 0{
                arrayEducationalDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEducationalDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayEdu")
        }else{
            dictArray.setValue(textFieldEducationLevel.text, forKey: "educationLevel")
            dictArray.setValue(textFieldDegreeName.text, forKey: "Degree")
            dictArray.setValue(textFieldNameofSchool.text, forKey: "School")
            dictArray.setValue(textFieldState.text, forKey: "State")
            dictArray.setValue(textFieldDate.text, forKey: "Date")
            dictArray.setValue(strDocument, forKey: "Document")

            if arrayEducationalDetails.count == textField.tag{
                arrayEducationalDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEducationalDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayEdu")
        }
        print(arrayEducationalDetails)
        
    }
    //MARK:- DatePicker
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let now = Date()
        let oneDaysAgo: Date? = now.addingTimeInterval(1 * 24 * 60 * 60)
        datePickerview.maximumDate = oneDaysAgo
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "MM/dd/yyyy"
      //  let strDate:String = dateFormatter.string(from: sender.date)
        textFieldDate.text = dateFormatter1.string(from: sender.date)
        
    }
    
    
    func textFieldUI(textField:HoshiTextField){
        textField.borderActiveColor = AppColors().appBlueColor
        textField.placeholderColor = UIColor.darkGray
        textField.borderInactiveColor = UIColor.gray
    }
    
    //MARK:- Picker View Delegate and Datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayPickerview.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{

        var title = String()
        title = (arrayPickerview[row] as AnyObject)as! String
        return title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var strSelected = String()
        strSelected = (arrayPickerview[row] as AnyObject)as! String
        
        if nTextFieldTags == 1{
            textFieldEducationLevel.text = strSelected
        }else if nTextFieldTags == 2{
            textFieldDegreeName.text = strSelected
        }else if nTextFieldTags == 3{
            textFieldNameofSchool.text = strSelected
        }else if nTextFieldTags == 4 {
            textFieldState.text = strSelected
        }
    }
    

    @IBAction func pickerButtonPressed(_ sender: UIButton) {
        let viewController = UIViewController()
        let urlPickedfuture = NADocumentPicker.show(from: sender, parentViewController: self.delegate as! UIViewController)
        let dictArray = NSMutableDictionary()

        urlPickedfuture.onSuccess { url in
            
            if self.buttonUpload.tag == 0{
                
                dictArray.setValue(self.textFieldEducationLevel.text, forKey: "educationLevel")
                dictArray.setValue(self.textFieldDegreeName.text, forKey: "Degree")
                dictArray.setValue(self.textFieldNameofSchool.text, forKey: "School")
                dictArray.setValue(self.textFieldState.text, forKey: "State")
                dictArray.setValue(self.textFieldDate.text, forKey: "Date")
                dictArray.setValue(url.absoluteString, forKey: "Document")
                if self.arrayEducationalDetails.count == 0{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUpload.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUpload.tag, with: dictArray)
                }

                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayEdu")
            }else{
                dictArray.setValue(self.textFieldEducationLevel.text, forKey: "educationLevel")
                dictArray.setValue(self.textFieldDegreeName.text, forKey: "Degree")
                dictArray.setValue(self.textFieldNameofSchool.text, forKey: "School")
                dictArray.setValue(self.textFieldState.text, forKey: "State")
                dictArray.setValue(self.textFieldDate.text, forKey: "Date")
                dictArray.setValue(url.absoluteString, forKey: "Document")
                if self.arrayEducationalDetails.count == self.buttonUpload.tag{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUpload.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUpload.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayEdu")
            }
            self.strDocument = url.absoluteString as NSString
            print(self.arrayEducationalDetails)
            self.labelDocument.text = String(format: "%@",url.lastPathComponent)
            }.onFailure { (error) in
        }
    }
    
    
}
