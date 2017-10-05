import UIKit
import TextFieldEffects
import PopupDialog

class CurrentEmploymentViewController: UIViewController,UITextFieldDelegate {

    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var datePickerview = UIDatePicker()
    @IBOutlet var textFieldSupervisorName: HoshiTextField!
    @IBOutlet var textFieldHospitalDepartment: HoshiTextField!
    @IBOutlet var textFieldHospitalName: HoshiTextField!
    @IBOutlet var textFieldSupervisorTitle: HoshiTextField!
    @IBOutlet var buttonCheckBox: UIButton!
    @IBOutlet var textFieldDate: HoshiTextField!
    var bUnemployment = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()        
    }

    func updateUI(){
        self.textFieldUI(textField:textFieldSupervisorName)
        self.textFieldUI(textField:textFieldHospitalDepartment)
        self.textFieldUI(textField:textFieldSupervisorTitle)
        self.textFieldUI(textField:textFieldHospitalName)
        self.textFieldUI(textField:textFieldDate)
        let DSImage:UIImage = UIImage(named: "checkboxwithoutTick")!
        let SImage:UIImage = UIImage(named: "checkboxtick")!
        buttonCheckBox.setImage(DSImage, for: .normal)
        buttonCheckBox.setImage(SImage, for: .selected)
        bUnemployment = true

    }
    
    
    func textFieldUI(textField:HoshiTextField){
        textField.borderActiveColor = AppColors().appBlueColor
        textField.placeholderColor = UIColor.darkGray
        textField.borderInactiveColor = UIColor.gray
    }

    @IBAction func buttonNext(_ sender: Any)
    {
        if bUnemployment == false{
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"PreviousEmploymentViewController") as! PreviousEmploymentViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else if (textFieldSupervisorName.text?.characters.count)! < 1{
            self.popupAlertQuiz(msg: "Please Enter Valid Name")
        }else if (textFieldSupervisorTitle.text?.characters.count)! < 1{
            self.popupAlertQuiz(msg: "Please Enter Valid Title")
        }else if (textFieldHospitalName.text?.characters.count)! < 1{
            self.popupAlertQuiz(msg: "Please Enter Valid Name")
        }else if (textFieldHospitalDepartment.text?.characters.count)! < 1{
            self.popupAlertQuiz(msg: "Please Enter Valid Department Name")
        }else if (textFieldDate.text?.characters.count)! < 1{
            bUnemployment = true
            self.popupAlertQuiz(msg: "Please Select your Date of Joining in This Hospital")
        }else if (buttonCheckBox.isSelected) == true{
            popupAlertYesorNo(msg:"If you select this boxYou will Consider as Unemployed for now!")

        }else{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"PreviousEmploymentViewController") as! PreviousEmploymentViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    @IBAction func buttonCheckBox(_ sender: Any)
    {
        if (sender as AnyObject).tag == 1{
            if buttonCheckBox.isSelected == true{
                buttonCheckBox.isSelected = false
                bUnemployment = false
            }else{
                buttonCheckBox.isSelected = true
                bUnemployment = true
            }
        }
    }
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.textFieldDate{
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
        let oneDaysAgo: Date? = now.addingTimeInterval(-1 * 24 * 60 * 60)
        datePickerview.maximumDate = oneDaysAgo
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "MM/dd/yyyy"
        textFieldDate.text = dateFormatter1.string(from: sender.date)
        
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
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"PreviousEmploymentViewController") as! PreviousEmploymentViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)

        }
        buttonTwo.buttonColor = UIColor.red
        buttonTwo.titleColor = UIColor.white
        popup.addButtons([buttonTwo])
        self.present(popup, animated: true, completion: nil)
    }
    func popupAlertYesorNo(msg:String)
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
        let buttonOne = DefaultButton(title: "Cancel")
        {
            
        }
        buttonTwo.buttonColor = UIColor.red
        buttonTwo.titleColor = UIColor.white
        popup.addButtons([buttonOne,buttonTwo])
        self.present(popup, animated: true, completion: nil)
    }
    
    
}
