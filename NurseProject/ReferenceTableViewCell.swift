import UIKit
import TextFieldEffects

class ReferenceTableViewCell: UITableViewCell,UITextFieldDelegate {

    
    @IBOutlet var textFieldPhoneNumber: HoshiTextField!
    @IBOutlet var textFieldEmailID: HoshiTextField!
    @IBOutlet var textFieldRelationShip: HoshiTextField!
    @IBOutlet var textFieldFullName: HoshiTextField!
    var arrayRefDetails = NSMutableArray()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if ((UserDefaults.standard.value(forKey: "arrayRef") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayRef")! as NSArray
            arrayRefDetails.addObjects(from: array as! [Any])
            print(arrayRefDetails)
        }
        
        var fixedString: String = "+1 "
        let attributedString = NSMutableAttributedString(string: fixedString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange(location: 0, length: (fixedString.characters.count )))
        textFieldPhoneNumber?.attributedText = attributedString

        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.textFieldUI(textField:textFieldPhoneNumber)
        self.textFieldUI(textField:textFieldEmailID)
        self.textFieldUI(textField:textFieldRelationShip)
        self.textFieldUI(textField:textFieldFullName)

    }
    
    
    func textFieldUI(textField:HoshiTextField){
        textField.borderActiveColor = AppColors().appBlueColor
        textField.placeholderColor = UIColor.darkGray
        textField.borderInactiveColor = UIColor.gray
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textFieldPhoneNumber{
            let substringRange: NSRange = (textFieldPhoneNumber.text! as NSString).range(of: "+1  ")
            
            if range.location >= substringRange.location && range.location < substringRange.location + substringRange.length {
                return false
            }
            let attString: NSMutableAttributedString? = textFieldPhoneNumber.attributedText?.mutableCopy() as? NSMutableAttributedString
            attString?.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: substringRange.length, length: (textFieldPhoneNumber.text?.characters.count)! - substringRange.length))
            textField.attributedText = attString
            
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            switch textField {
            case textFieldPhoneNumber:
                return prospectiveText.containsCharactersIn("0123456789") &&
                    prospectiveText.characters.count <= 14
            default:
                return true
            }
        }
        return true
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dictArray = NSMutableDictionary()
        
        if textField.tag == 0{
            
            dictArray.setValue(textFieldFullName.text, forKey: "FullName")
            dictArray.setValue(textFieldPhoneNumber.text, forKey: "Phone")
            dictArray.setValue(textFieldEmailID.text, forKey: "Email")
            dictArray.setValue(textFieldRelationShip.text, forKey: "Relationship")
            if arrayRefDetails.count == 0{
                arrayRefDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayRefDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayRefDetails, forKey: "arrayRef")
        }else{
            dictArray.setValue(textFieldFullName.text, forKey: "FullName")
            dictArray.setValue(textFieldPhoneNumber.text, forKey: "Phone")
            dictArray.setValue(textFieldEmailID.text, forKey: "Email")
            dictArray.setValue(textFieldRelationShip.text, forKey: "Relationship")
            if arrayRefDetails.count == textField.tag{
                arrayRefDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayRefDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayRefDetails, forKey: "arrayRef")
        }
        print(arrayRefDetails)
        
    }
    
}
