import UIKit
import TextFieldEffects
import NADocumentPicker
import BrightFutures
import MobileCoreServices



class CertificationTableViewCell :UITableViewCell ,UITextFieldDelegate,UIDocumentPickerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIDocumentInteractionControllerDelegate,UINavigationControllerDelegate
{
    
    @IBOutlet var imageViewCalender: UIImageView!
    @IBOutlet var labelDocumentFront: UILabel!
    @IBOutlet var labelDocumentBack: UILabel!

    @IBOutlet var textFieldDate: HoshiTextField!
    @IBOutlet var textFieldName: HoshiTextField!
    @IBOutlet var buttonUploadFront: UIButton!
    @IBOutlet var buttonUploadBack: UIButton!
    weak var delegate: ChangeDocumentProtocol?
    var strDocument = NSString()

    var arrayEducationalDetails = NSMutableArray()
    var arrayEducationalDetailsFile = NSMutableArray()
    var datePickerview = UIDatePicker()
    var bButtonFront = Bool()
    let imagePicker = UIImagePickerController()

    @IBOutlet var buttonNonPermanent: UIButton!
    @IBOutlet var buttonPermanent: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let DSImage:UIImage = UIImage(named: "unchecked")!
        let SImage:UIImage = UIImage(named: "checked")!
        buttonNonPermanent.setImage(DSImage, for: .normal)
        buttonNonPermanent.setImage(SImage, for: .selected)
        buttonPermanent.setImage(DSImage, for: .normal)
        buttonPermanent.setImage(SImage, for: .selected)

        if ((UserDefaults.standard.value(forKey: "arrayCertificate") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificate")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
            print(arrayEducationalDetails)
        }
        if ((UserDefaults.standard.value(forKey: "arrayCertificateFile") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificateFile")! as NSArray
            arrayEducationalDetailsFile.addObjects(from: array as! [Any])
            print(arrayEducationalDetailsFile)
        }

    }
    
    @IBAction func buttonPermanent(_ sender: Any)
    {
        if (sender as AnyObject).tag == 1{
            if buttonPermanent.isSelected == true{
                buttonPermanent.isSelected = false
                buttonNonPermanent.isSelected = true
                textFieldDate.isHidden = false
                imageViewCalender.isHidden = false
            }else{
                buttonPermanent.isSelected = true
                buttonNonPermanent.isSelected = false
                textFieldDate.isHidden = true
                textFieldDate.text = ""
                imageViewCalender.isHidden = true
            }
            
        }else if (sender as AnyObject).tag == 2{
            if buttonNonPermanent.isSelected == true{
                buttonNonPermanent.isSelected = false
                buttonPermanent.isSelected = true
                textFieldDate.text = ""
                imageViewCalender.isHidden = true
                textFieldDate.isHidden = true
            }else{
                buttonNonPermanent.isSelected = true
                buttonPermanent.isSelected = false
                imageViewCalender.isHidden = false
                textFieldDate.isHidden = false
                textFieldDate.text = ""
            }
        }
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
            dictArray.setValue(textFieldName.text, forKey: "certificate_name")
            dictArray.setValue(textFieldDate.text, forKey: "expiry_date")
            if textFieldDate.text != ""{
                dictArray.setValue("permanent", forKey: "permanent")
            }else{
                dictArray.setValue("", forKey: "permanent")
            }

            
            if arrayEducationalDetails.count == 0{
                arrayEducationalDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEducationalDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayCertificate")
        }else{
            dictArray.setValue(textFieldName.text, forKey: "certificate_name")
            dictArray.setValue(textFieldDate.text, forKey: "expiry_date")
            if textFieldDate.text != ""{
                dictArray.setValue("permanent", forKey: "permanent")
            }else{
                dictArray.setValue("", forKey: "permanent")
            }

            if arrayEducationalDetails.count == textField.tag{
                arrayEducationalDetails.insert(dictArray, at: textField.tag)
            }else{
                arrayEducationalDetails.replaceObject(at: textField.tag, with: dictArray)
            }
            UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayCertificate")
        }
        print(arrayEducationalDetails)
        
    }
    
    func DocLibrary(){
        var types: [Any]? = [(kUTTypePDF as? String)]
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: types as! [String], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        (self.delegate as! UIViewController).present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController,didPickDocumentAt url: URL) {
        let dictArray = NSMutableDictionary()
        let dataFile = try! Data(contentsOf: url)
        print(dataFile)
        let Front:String  = "12"
        var dataFront:Data = Front.data(using: .utf8)!
        var dataBack:Data = Front.data(using: .utf8)!
        
        dictArray.setValue("0", forKey: "image")
        
        if arrayEducationalDetailsFile.count != 0{
            dataFront = (arrayEducationalDetailsFile[0] as AnyObject).value(forKey: "blsfront") as! Data
            dataBack = (arrayEducationalDetailsFile[0] as AnyObject).value(forKey: "blsback") as! Data
        }
        


        if bButtonFront == true{
            if self.buttonUploadFront.tag == 0{
                self.labelDocumentFront.text = String(format: "%@",url.lastPathComponent)
                dictArray.setValue(dataFile, forKey: "blsfront")
                if dataBack.count != 2{
                    dictArray.setValue(dataBack, forKey: "blsback")
                }else{
                    dictArray.setValue(dataBack, forKey: "blsback")
                }

                if self.arrayEducationalDetails.count == 0{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUploadFront.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUploadFront.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificateFile")
            }else{
                dictArray.setValue(url.absoluteString, forKey: "Document")
                
                if self.arrayEducationalDetails.count == self.buttonUploadFront.tag{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUploadFront.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUploadFront.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificateFile")
            }
            print(self.arrayEducationalDetails)

        }else{
            if self.buttonUploadBack.tag == 0{
                self.labelDocumentBack.text = String(format: "%@",url.lastPathComponent)
                dictArray.setValue(url.absoluteString, forKey: "Document")
                if self.arrayEducationalDetails.count == 0{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUploadBack.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUploadBack.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificateFile")
            }else{
                dictArray.setValue(url.absoluteString, forKey: "Document")
                
                if self.arrayEducationalDetails.count == self.buttonUploadBack.tag{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUploadBack.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUploadBack.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificateFile")
            }
            print(self.arrayEducationalDetails)
            
        }
    }

    @IBAction func buttonUploadFront(_ sender: UIButton) {
        bButtonFront = true
        showActionSheet2()
        
    }
    @IBAction func buttonUploadBack(_ sender: UIButton) {
        bButtonFront = false
        showActionSheet2()

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
//        actionSheet.addAction(UIAlertAction(title: "From Document", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
//            self.DocLibrary()
//        }))
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        (self.delegate as! UIViewController).dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //  imageViewUserImage.image = chosenImage
        let imageData1:Data = UIImageJPEGRepresentation(chosenImage, 0.5)!
        print(imageData1)
        let dictArray = NSMutableDictionary()
        
        if bButtonFront == true{
            if self.buttonUploadFront.tag == 0{
                self.labelDocumentFront.text = "Image File Chosen"
                dictArray.setValue(imageData1, forKey: "Document")
                if self.arrayEducationalDetails.count == 0{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUploadFront.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUploadFront.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificateFile")
            }else{
                dictArray.setValue(imageData1, forKey: "Document")
                
                if self.arrayEducationalDetails.count == self.buttonUploadFront.tag{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUploadFront.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUploadFront.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificateFile")
            }
            print(self.arrayEducationalDetails)
            
        }else{
            if self.buttonUploadBack.tag == 0{
                self.labelDocumentBack.text = "Image File Chosen"
                dictArray.setValue(imageData1, forKey: "Document")
                if self.arrayEducationalDetails.count == 0{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUploadBack.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUploadBack.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificateFile")
            }else{
                dictArray.setValue(imageData1, forKey: "Document")
                
                if self.arrayEducationalDetails.count == self.buttonUploadBack.tag{
                    self.arrayEducationalDetails.insert(dictArray, at: self.buttonUploadBack.tag)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: self.buttonUploadBack.tag, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayCertificateFile")
            }
            print(self.arrayEducationalDetails)
            
        }
        (self.delegate as! UIViewController).dismiss(animated: true, completion: nil)

    }
}
