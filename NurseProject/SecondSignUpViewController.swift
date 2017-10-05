import UIKit
import TextFieldEffects
import PopupDialog


class SecondSignUpViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var textFieldProfession: HoshiTextField!
    @IBOutlet var textFieldState: HoshiTextField!
    @IBOutlet var textFieldLicenceNumber: HoshiTextField!
    @IBOutlet var textFieldRNExpirationDate: HoshiTextField!
    @IBOutlet var buttonBLSCheckBox: UIButton!
    @IBOutlet var trxtFieldBLSExpirationDate: HoshiTextField!
    var dictStoredValues = NSMutableDictionary()


    var datePickerview = UIDatePicker()
    var arrayPickerview = NSArray()
    var pickerviewList = UIPickerView()
    var nTextFieldTags = Int()
    var strDate = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldUI()
        
        let DSImage:UIImage = UIImage(named: "unchecked")!
        let SImage:UIImage = UIImage(named: "checked")!
        buttonBLSCheckBox.setImage(DSImage, for: .normal)
        buttonBLSCheckBox.setImage(SImage, for: .selected)
        self.toolBarandColectionViewInitialization()
    }

    
    func textFieldUI(){
        textFieldProfession.borderActiveColor = AppColors().appBlueColor
        textFieldProfession.placeholderColor = UIColor.darkGray
        textFieldProfession.borderInactiveColor = UIColor.gray
        textFieldState.borderActiveColor = AppColors().appBlueColor
        textFieldState.borderInactiveColor = UIColor.gray
        textFieldState.placeholderColor = UIColor.darkGray
        textFieldLicenceNumber.borderActiveColor = AppColors().appBlueColor
        textFieldLicenceNumber.placeholderColor = UIColor.darkGray
        textFieldLicenceNumber.borderInactiveColor = UIColor.gray
        textFieldRNExpirationDate.borderActiveColor = AppColors().appBlueColor
        textFieldRNExpirationDate.borderInactiveColor = UIColor.gray
        textFieldRNExpirationDate.placeholderColor = UIColor.darkGray
        trxtFieldBLSExpirationDate.borderActiveColor = AppColors().appBlueColor
        trxtFieldBLSExpirationDate.placeholderColor = UIColor.darkGray
        trxtFieldBLSExpirationDate.borderInactiveColor = UIColor.gray
        
    }

    //MARK:- Button Actions
    
    @IBAction func buttonBLS(_ sender: Any)
    {
        if buttonBLSCheckBox.isSelected == true{
            buttonBLSCheckBox.isSelected = false
        }else{
            buttonBLSCheckBox.isSelected = true
        }
    }
    
    @IBAction func buttonNext(_ sender: Any)
    {
        if (textFieldProfession.text?.characters.count)! < 1
        {
            self.popupAlertQuiz(msg: "Please Enter Your Profession")
        }else if (textFieldState.text?.characters.count)! < 1
        {
            self.popupAlertQuiz(msg: "Please Select Your State")
        }else if (textFieldLicenceNumber.text?.characters.count)! < 1
        {
            self.popupAlertQuiz(msg: "Please Enter Your RN License Number")
        }else if (textFieldRNExpirationDate.text?.characters.count)! < 1
        {
            self.popupAlertQuiz(msg: "Please Select Your License Expiry Date")
        }else if (trxtFieldBLSExpirationDate.text?.characters.count)! < 1
        {
            self.popupAlertQuiz(msg: "Please Select BLS Expiration Date")
        }else if (buttonBLSCheckBox.isSelected) == false{
            self.popupAlertQuiz(msg: "Select BLS Option ")
        }else{
            
            dictStoredValues.setObject(textFieldProfession.text!, forKey: "Profession" as NSCopying)
            dictStoredValues.setObject(textFieldState.text!, forKey: "State" as NSCopying)
            dictStoredValues.setObject(textFieldLicenceNumber.text!, forKey: "LicenseNumber" as NSCopying)
            dictStoredValues.setObject(textFieldRNExpirationDate.text!, forKey: "RNExpirationDate" as NSCopying)
            dictStoredValues.setObject(trxtFieldBLSExpirationDate.text!, forKey: "BLS" as NSCopying)

            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"ThirdSignUpViewController") as! ThirdSignUpViewController
            nextViewController.dictStoredValues = dictStoredValues
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
    }
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    // Pragma Mark - Textfield Delegates -
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.textFieldState{
            arrayPickerview = StaticArrayValues().arrayUSStates as NSArray
            nTextFieldTags = 0
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        if textField == self.textFieldRNExpirationDate{
            nTextFieldTags = 1
            datePickerview.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerview
            textField.inputView = datePickerview
            datePickerview.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        if textField == self.trxtFieldBLSExpirationDate{
            nTextFieldTags = 2
            datePickerview.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerview
            textField.inputView = datePickerview
            datePickerview.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        
        return true
    }

    //MARK:- DatePicker
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let now = Date()
        let oneDaysAgo: Date? = now.addingTimeInterval(1 * 24 * 60 * 60)
        datePickerview.minimumDate = oneDaysAgo
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "E,MMM d,yyyy"
        
        strDate = dateFormatter.string(from: sender.date)
        if nTextFieldTags == 1{
            textFieldRNExpirationDate.text = dateFormatter1.string(from: sender.date)

        }else if nTextFieldTags == 2{
            trxtFieldBLSExpirationDate.text = dateFormatter1.string(from: sender.date)
        }


    }
    
    func dateChosen()
    {
        textFieldRNExpirationDate.resignFirstResponder()
        trxtFieldBLSExpirationDate.resignFirstResponder()
        textFieldState.resignFirstResponder()
    }
    
    //MARK:- Picker View Delegate and Datasource    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayPickerview.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        print(arrayPickerview)
        var title = String()
        title = (arrayPickerview[row] as AnyObject)as! String
        return title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var strSelected = String()
        strSelected = (arrayPickerview[row] as AnyObject)as! String
        textFieldState.text = strSelected
    }
    
    //MARK:- Tool Bar Initialization
    
    func toolBarandColectionViewInitialization()
    {
        let toolBar = UIToolbar(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(44)))
        toolBar.tintColor = UIColor.gray
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dateChosen))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, doneBtn]
        textFieldState.inputAccessoryView = toolBar
        trxtFieldBLSExpirationDate.inputAccessoryView = toolBar
        textFieldRNExpirationDate.inputAccessoryView = toolBar

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
        buttonTwo.buttonColor = UIColor.red
        buttonTwo.titleColor = UIColor.white
        popup.addButtons([buttonTwo])
        self.present(popup, animated: true, completion: nil)
    }
    
    
}
