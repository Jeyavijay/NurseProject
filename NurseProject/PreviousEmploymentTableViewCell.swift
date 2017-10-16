import UIKit
import TextFieldEffects

class PreviousEmploymentTableViewCell: UITableViewCell,UITextFieldDelegate {
    var nTextFieldTags = Int()
    var datePickerview = UIDatePicker()
    @IBOutlet var textFieldEndDate: HoshiTextField!
    @IBOutlet var textFieldStartDate: HoshiTextField!
    @IBOutlet var textFieldDepartment: HoshiTextField!
    @IBOutlet var textFieldHospitalName: HoshiTextField!
    @IBOutlet var textFieldTitle: HoshiTextField!
    @IBOutlet var textFieldName: HoshiTextField!
    var arrayEmploymentDetails = NSMutableArray()

    override func awakeFromNib() {
        super.awakeFromNib()
        if ((UserDefaults.standard.value(forKey: "arrayEmp") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayEmp")! as NSArray
            arrayEmploymentDetails.addObjects(from: array as! [Any])
            print(arrayEmploymentDetails)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func layoutSubviews(){
        super.layoutSubviews()
        self.textFieldUI(textField:textFieldEndDate)
        self.textFieldUI(textField:textFieldStartDate)
        self.textFieldUI(textField:textFieldDepartment)
        self.textFieldUI(textField:textFieldHospitalName)
        self.textFieldUI(textField:textFieldName)
        self.textFieldUI(textField:textFieldTitle)
    }
    
    func textFieldUI(textField:HoshiTextField){
        textField.borderActiveColor = AppColors().appBlueColor
        textField.placeholderColor = UIColor.darkGray
        textField.borderInactiveColor = UIColor.gray
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {

        if textField == self.textFieldStartDate{
            datePickerview.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerview
            textField.inputView = datePickerview
            let now = Date()
            let oneDaysAgo: Date? = now.addingTimeInterval(1 * 24 * 60 * 60)
            datePickerview.maximumDate = oneDaysAgo

            nTextFieldTags = 1
            datePickerview.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        if textField == self.textFieldEndDate{
            datePickerview.datePickerMode = UIDatePickerMode.date
            nTextFieldTags = 2
            textField.inputView = datePickerview
            datePickerview.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dictArray = NSMutableDictionary()
        
        if textField.tag == 0{
            dictArray.setValue(textFieldName.text, forKey: "nameofsupervisor")
            dictArray.setValue(textFieldTitle.text, forKey: "titleofsupervisor")
            dictArray.setValue(textFieldHospitalName.text, forKey: "hospitalname")
            dictArray.setValue(textFieldDepartment.text, forKey: "deptofhospital")
            dictArray.setValue(textFieldStartDate.text, forKey: "startdate")
            dictArray.setValue(textFieldEndDate.text, forKey: "enddate")
            if arrayEmploymentDetails.count == 0{
                arrayEmploymentDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEmploymentDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEmploymentDetails, forKey: "arrayEmp")
        }else{
            dictArray.setValue(textFieldName.text, forKey: "nameofsupervisor")
            dictArray.setValue(textFieldTitle.text, forKey: "titleofsupervisor")
            dictArray.setValue(textFieldHospitalName.text, forKey: "hospitalname")
            dictArray.setValue(textFieldDepartment.text, forKey: "deptofhospital")
            dictArray.setValue(textFieldStartDate.text, forKey: "startdate")
            dictArray.setValue(textFieldEndDate.text, forKey: "enddate")
            if arrayEmploymentDetails.count == textField.tag{
                arrayEmploymentDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEmploymentDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEmploymentDetails, forKey: "arrayEmp")
        }
        print(arrayEmploymentDetails)
        
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
        if nTextFieldTags == 1
        {
            textFieldStartDate.text = dateFormatter1.string(from: sender.date)
        }else if nTextFieldTags == 2
        {
            textFieldEndDate.text = dateFormatter1.string(from: sender.date)
        }
    }

}
