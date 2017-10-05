import UIKit
import TextFieldEffects
import PopupDialog

class ThirdSignUpViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var textFieldSecurityQuestion: HoshiTextField!
    @IBOutlet var textFieldSecurityAnswer: HoshiTextField!
    @IBOutlet var textFieldPassword: HoshiTextField!
    @IBOutlet var textFieldConfirmPassword: HoshiTextField!
    
    @IBOutlet var buttonTermsAndConditions: UIButton!
    var pickerviewList = UIPickerView()
    var arrayPickerview = NSArray()
    var dictStoredValues = NSMutableDictionary()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolBarandColectionViewInitialization()
        self.textFieldUI()
        
        let DSImage:UIImage = UIImage(named: "unchecked")!
        let SImage:UIImage = UIImage(named: "checked")!
        buttonTermsAndConditions.setImage(DSImage, for: .normal)
        buttonTermsAndConditions.setImage(SImage, for: .selected)
    }
    
    func textFieldUI(){
        textFieldSecurityQuestion.borderActiveColor = AppColors().appBlueColor
        textFieldSecurityQuestion.placeholderColor = UIColor.darkGray
        textFieldSecurityQuestion.borderInactiveColor = UIColor.gray
        textFieldSecurityAnswer.borderActiveColor = AppColors().appBlueColor
        textFieldSecurityAnswer.borderInactiveColor = UIColor.gray
        textFieldSecurityAnswer.placeholderColor = UIColor.darkGray
        textFieldPassword.borderActiveColor = AppColors().appBlueColor
        textFieldPassword.placeholderColor = UIColor.darkGray
        textFieldPassword.borderInactiveColor = UIColor.gray
        textFieldConfirmPassword.borderActiveColor = AppColors().appBlueColor
        textFieldConfirmPassword.borderInactiveColor = UIColor.gray
        textFieldConfirmPassword.placeholderColor = UIColor.darkGray

        
    }

    //MARK:- Button Actions
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func buttonAcceptTerms(_ sender: Any)
    {
        if buttonTermsAndConditions.isSelected == true{
            buttonTermsAndConditions.isSelected = false
        }else{
            buttonTermsAndConditions.isSelected = true
        }
    }
    
    
    @IBAction func buttonSubmit(_ sender: Any)
    {
        if (textFieldSecurityQuestion.text?.characters.count)! < 1
        {
            self.popupAlertQuiz(msg: "Please Select Your Security Question")
        }else if (textFieldSecurityAnswer.text?.characters.count)! < 1{
            self.popupAlertQuiz(msg: "Please Enter Your Security Answer")
        }else  if (textFieldPassword.text?.characters.count)! < 6{
            self.popupAlertQuiz(msg: "Password Must atleast 6 Characters")
        }else if textFieldPassword.text != textFieldConfirmPassword.text{
            self.popupAlertQuiz(msg: "Password Doesnot Match")
        }else if buttonTermsAndConditions.isSelected == false{
            self.popupAlertQuiz(msg: "You Must Agree Terms and Conditions to Continue")
        }else{
            
            dictStoredValues.setObject(textFieldSecurityQuestion.text!, forKey: "Question" as NSCopying)
            dictStoredValues.setObject(textFieldSecurityAnswer.text!, forKey: "Answer" as NSCopying)
            dictStoredValues.setObject(textFieldPassword.text!, forKey: "Password" as NSCopying)
            print(dictStoredValues)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"AccountDetailsViewController") as! AccountDetailsViewController
            nextViewController.dictStoredValues = dictStoredValues
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    
    
    
    func toolBarandColectionViewInitialization()
    {
        let toolBar = UIToolbar(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(44)))
        toolBar.tintColor = UIColor.gray
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dateChosen))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, doneBtn]
        textFieldSecurityQuestion.inputAccessoryView = toolBar
        
    }
    
    func dateChosen()
    {
        textFieldSecurityQuestion.resignFirstResponder()
    }
    
    
    // Pragma Mark - Textfield Delegates -
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.textFieldSecurityQuestion{
            arrayPickerview = StaticArrayValues().arraySecurityQuestions as NSArray
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        return true
    }
    //MARK:- PickerView Delegate
    
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
        textFieldSecurityQuestion.text = strSelected
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
