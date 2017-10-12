import UIKit
import TextFieldEffects
import NADocumentPicker
import BrightFutures
import MobileCoreServices



class RNDetailsTableViewCell: UITableViewCell ,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIDocumentPickerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIDocumentInteractionControllerDelegate,UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    @IBOutlet var textFieldIssueDate: HoshiTextField!
    @IBOutlet var textFieldExpirationDate: HoshiTextField!
    @IBOutlet var textFieldState: HoshiTextField!
    @IBOutlet var textFieldRNNumber: HoshiTextField!
    @IBOutlet var buttonUpload: UIButton!
    @IBOutlet var labelDocumentName: UILabel!
    weak var delegate: ChangeDocumentProtocol?
    var datePickerview = UIDatePicker()
    var arrayPickerview = NSArray()
    var pickerviewList = UIPickerView()
    var nTextFieldTags = Int()
    var arrayEducationalDetails = NSMutableArray()
    var arrayEducationalDetailsFile = NSMutableArray()

    var strDocument = Data()

    override func awakeFromNib() {
        super.awakeFromNib()
        if ((UserDefaults.standard.value(forKey: "arrayRN") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayRN")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
        }
        if ((UserDefaults.standard.value(forKey: "arrayRNFile") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayRNFile")! as NSArray
            arrayEducationalDetailsFile.addObjects(from: array as! [Any])
        }

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        let datePickerview1 = UIDatePicker()
        datePickerview = datePickerview1
        if textField == self.textFieldState{
            arrayPickerview = StaticArrayValues().arrayUSStates as NSArray
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        if textField == self.textFieldIssueDate{
            nTextFieldTags = 4
            let now = Date()
            let oneDaysAgo: Date? = now.addingTimeInterval(1 * 24 * 60 * 60)
            datePickerview.maximumDate = oneDaysAgo
            datePickerview.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerview
            textField.inputView = datePickerview
            datePickerview.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        if textField == self.textFieldExpirationDate{
            nTextFieldTags = 3
            datePickerview.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerview
            textField.inputView = datePickerview
            datePickerview.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
            let now = Date()
            let oneDaysAgo: Date? = now.addingTimeInterval(-1 * 24 * 60 * 60)
            datePickerview.minimumDate = oneDaysAgo

        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dictArray = NSMutableDictionary()
        
        if textField.tag == 0{
            
            dictArray.setValue(textFieldRNNumber.text, forKey: "nursern")
            dictArray.setValue(textFieldState.text, forKey: "state")
            dictArray.setValue(textFieldExpirationDate.text, forKey: "expirydate")
            dictArray.setValue(textFieldIssueDate.text, forKey: "issuedate")
            if arrayEducationalDetails.count == 0{
                arrayEducationalDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEducationalDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayRN")
        }else{
            dictArray.setValue(textFieldRNNumber.text, forKey: "nursern")
            dictArray.setValue(textFieldState.text, forKey: "state")
            dictArray.setValue(textFieldExpirationDate.text, forKey: "expirydate")
            dictArray.setValue(textFieldIssueDate.text, forKey: "issuedate")

            if arrayEducationalDetails.count == textField.tag{
                arrayEducationalDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEducationalDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayRN")
        }
        
    }

    //MARK:- DatePicker
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "MM/dd/yyyy"
        if nTextFieldTags == 3{
            textFieldExpirationDate.text = dateFormatter1.string(from: sender.date)
        }else{
            textFieldIssueDate.text = dateFormatter1.string(from: sender.date)
        }
        
    }
    
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
        textFieldState.text = strSelected
    
    }

    
    @IBAction func pickerButtonPressed(_ sender: UIButton) {
        imagePicker.delegate = self
        showActionSheet2()
        
    }
    
    func DocLibrary(){
        var types: [Any]? = [(kUTTypePDF as? String)]
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: types as! [String], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        (self.delegate as! UIViewController).present(documentPicker, animated: true, completion: nil)
    }
    
    //MARK:- DocumentMenu Delegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController,didPickDocumentAt url: URL) {
        let dictArray = NSMutableDictionary()
        let dataFile = try! Data(contentsOf: url)
        print(dataFile)
        if self.buttonUpload.tag == 0{
            dictArray.setValue(dataFile, forKey: "Document")
            dictArray.setValue("0", forKey: "image")
            if self.arrayEducationalDetailsFile.count == 0{
                self.arrayEducationalDetailsFile.insert(dictArray, at: self.buttonUpload.tag)
            }else{
                self.arrayEducationalDetailsFile.replaceObject(at: self.buttonUpload.tag, with: dictArray)
            }
            UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayRNFile")
        }else{
            dictArray.setValue(dataFile, forKey: "Document")
            dictArray.setValue("0", forKey: "image")

            if self.arrayEducationalDetailsFile.count == self.buttonUpload.tag{
                self.arrayEducationalDetailsFile.insert(dictArray, at: self.buttonUpload.tag)
            }else{
                self.arrayEducationalDetailsFile.replaceObject(at: self.buttonUpload.tag, with: dictArray)
            }
            UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayRNFile")
        }
       // self.strDocument = dataFile
        self.labelDocumentName.text = String(format: "%@",url.lastPathComponent)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
          //  imageViewUserImage.image = chosenImage
            let imageData1:Data = UIImageJPEGRepresentation(chosenImage, 0.5)!
            print(imageData1)
        let dictArray = NSMutableDictionary()

        if self.buttonUpload.tag == 0{
            dictArray.setValue(imageData1, forKey: "Document")
            dictArray.setValue("1", forKey: "image")

            if self.arrayEducationalDetailsFile.count == 0{
                self.arrayEducationalDetailsFile.insert(dictArray, at: self.buttonUpload.tag)
            }else{
                self.arrayEducationalDetailsFile.replaceObject(at: self.buttonUpload.tag, with: dictArray)
            }
            UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayRNFile")
        }else{
            dictArray.setValue(imageData1, forKey: "Document")
            dictArray.setValue("1", forKey: "image")

            if self.arrayEducationalDetailsFile.count == self.buttonUpload.tag{
                self.arrayEducationalDetailsFile.insert(dictArray, at: self.buttonUpload.tag)
            }else{
                self.arrayEducationalDetailsFile.replaceObject(at: self.buttonUpload.tag, with: dictArray)
            }
            UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayRNFile")
        }
        self.labelDocumentName.text = "Image Chosen"
        
        (self.delegate as! UIViewController).dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        (self.delegate as! UIViewController).dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet2()
    {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
            actionSheet.addAction(UIAlertAction(title: "From Document", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                self.DocLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        (self.delegate as! UIViewController).present(actionSheet, animated: true, completion: nil)
    }
    
    func camera()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        (self.delegate as! UIViewController).present(imagePicker, animated: true, completion: nil)
    }
    
    func photoLibrary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        (self.delegate as! UIViewController).present(imagePicker, animated: true, completion: nil)
    }
    
}
