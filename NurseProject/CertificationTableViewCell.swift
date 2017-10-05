
import UIKit
import TextFieldEffects
import NADocumentPicker
import BrightFutures


class CertificationTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet var labelDocument: UILabel!

    @IBOutlet var textFieldDate: HoshiTextField!
    @IBOutlet var textFieldName: HoshiTextField!
    @IBOutlet var buttonUpload: UIButton!
    weak var delegate: ChangeDocumentProtocol?
    var strDocument = NSString()



    
    var arrayEducationalDetails = NSMutableArray()
    var datePickerview = UIDatePicker()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        strDocument = ""
        if ((UserDefaults.standard.value(forKey: "arrayCertificate") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificate")! as NSArray
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
        self.textFieldUI(textField:textFieldName)
        
    }
    
    func textFieldUI(textField:HoshiTextField){
        textField.borderActiveColor = AppColors().appBlueColor
        textField.placeholderColor = UIColor.darkGray
        textField.borderInactiveColor = UIColor.gray
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

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dictArray = NSMutableDictionary()
        
        if textField.tag == 0{
            dictArray.setValue(textFieldName.text, forKey: "Name")
            dictArray.setValue(textFieldDate.text, forKey: "Date")
            dictArray.setValue(strDocument, forKey: "Document")
            if arrayEducationalDetails.count == 0{
                arrayEducationalDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEducationalDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayCertificate")
        }else{
            dictArray.setValue(textFieldName.text, forKey: "Name")
            dictArray.setValue(textFieldDate.text, forKey: "Date")
            dictArray.setValue(strDocument, forKey: "Document")
            if arrayEducationalDetails.count == textField.tag{
                arrayEducationalDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEducationalDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayCertificate")
        }
        print(arrayEducationalDetails)
        
    }
    
    
    @IBAction func pickerButtonPressed(_ sender: UIButton) {
        let viewController = UIViewController()
        let urlPickedfuture = NADocumentPicker.show(from: sender, parentViewController: self.delegate as! UIViewController)
        let dictArray = NSMutableDictionary()
        
        urlPickedfuture.onSuccess { url in
            
            if self.buttonUpload.tag == 0{
                
                dictArray.setValue(self.textFieldName.text, forKey: "Name")
                dictArray.setValue(self.textFieldDate.text, forKey: "Date")
                dictArray.setValue(url.absoluteString, forKey: "Document")
                if self.arrayEducationalDetails.count == 0{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUpload.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUpload.tag, with: dictArray)
                }
                
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificate")
            }else{
                dictArray.setValue(self.textFieldName.text, forKey: "Name")
                dictArray.setValue(self.textFieldDate.text, forKey: "Date")
                dictArray.setValue(url.absoluteString, forKey: "Document")

                if self.arrayEducationalDetails.count == self.buttonUpload.tag{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUpload.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUpload.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificate")
            }
            self.strDocument = url.absoluteString as NSString
            print(self.arrayEducationalDetails)
            self.labelDocument.text = String(format: "%@",url.lastPathComponent)
            }.onFailure { (error) in
        }
    }
    
    
}
