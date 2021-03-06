import UIKit
import TextFieldEffects
import NADocumentPicker
import BrightFutures
import MobileCoreServices

protocol ChangeDocumentProtocol : NSObjectProtocol {
    func loadDocScreen(controller: UIViewController) -> Void;
}

class EducationTableViewCell:UITableViewCell ,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIDocumentPickerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIDocumentInteractionControllerDelegate,UINavigationControllerDelegate {
    
    
    weak var delegate: ChangeDocumentProtocol?
    let imagePicker = UIImagePickerController()
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
    var arrayEducationalDetailsFile = NSMutableArray()

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
        if ((UserDefaults.standard.value(forKey: "arrayEduFile") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayEduFile")! as NSArray
            arrayEducationalDetailsFile.addObjects(from: array as! [Any])
            print(arrayEducationalDetailsFile)
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

            dictArray.setValue(textFieldEducationLevel.text, forKey: "highestdegree")
            dictArray.setValue(textFieldDegreeName.text, forKey: "nameofdegree")
            dictArray.setValue(textFieldNameofSchool.text, forKey: "school")
            dictArray.setValue(textFieldState.text, forKey: "state")
            dictArray.setValue(textFieldDate.text, forKey: "gradudate")
            if arrayEducationalDetails.count == 0{
                arrayEducationalDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEducationalDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayEdu")
        }else{
            dictArray.setValue(textFieldEducationLevel.text, forKey: "highestdegree")
            dictArray.setValue(textFieldDegreeName.text, forKey: "nameofdegree")
            dictArray.setValue(textFieldNameofSchool.text, forKey: "school")
            dictArray.setValue(textFieldState.text, forKey: "state")
            dictArray.setValue(textFieldDate.text, forKey: "gradudate")

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
            UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayEduFile")
        }else{
            dictArray.setValue(dataFile, forKey: "Document")
            dictArray.setValue("0", forKey: "image")
            
            if self.arrayEducationalDetailsFile.count == self.buttonUpload.tag{
                self.arrayEducationalDetailsFile.insert(dictArray, at: self.buttonUpload.tag)
            }else{
                self.arrayEducationalDetailsFile.replaceObject(at: self.buttonUpload.tag, with: dictArray)
            }
            UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayEduFile")
        }
        self.labelDocument.text = String(format: "%@",url.lastPathComponent)
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
            UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayEduFile")
        }else{
            dictArray.setValue(imageData1, forKey: "Document")
            dictArray.setValue("1", forKey: "image")
            
            if self.arrayEducationalDetailsFile.count == self.buttonUpload.tag{
                self.arrayEducationalDetailsFile.insert(dictArray, at: self.buttonUpload.tag)
            }else{
                self.arrayEducationalDetailsFile.replaceObject(at: self.buttonUpload.tag, with: dictArray)
            }
            UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayEduFile")
        }
        self.labelDocument.text = "Image Chosen"
        (self.delegate as! UIViewController).dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        (self.delegate as! UIViewController).dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet2()
    {
        imagePicker.delegate = self
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

