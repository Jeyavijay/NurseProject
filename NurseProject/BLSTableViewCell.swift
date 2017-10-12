import UIKit
import TextFieldEffects
import NADocumentPicker
import BrightFutures
import MobileCoreServices


class  BLSTableViewCell :UITableViewCell ,UITextFieldDelegate,UIDocumentPickerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIDocumentInteractionControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var buttonBack: UIButton!
    @IBOutlet var buttonFront: UIButton!
    @IBOutlet var labelBack: UILabel!
    @IBOutlet var labelFront: UILabel!
    weak var delegate: ChangeDocumentProtocol?
    let imagePicker = UIImagePickerController()
    var datePickerview = UIDatePicker()
    var arrayEducationalDetails = NSMutableArray()
    var arrayEducationalDetailsFile = NSMutableArray()
    var nTextFieldTags = Int()
    var bButtonFront = Bool()


    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        if ((UserDefaults.standard.value(forKey: "arrayBLS") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayBLS")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
            print(arrayEducationalDetails)
        }
        if ((UserDefaults.standard.value(forKey: "arrayBLSFile") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayBLSFile")! as NSArray
            arrayEducationalDetailsFile.addObjects(from: array as! [Any])
            print(arrayEducationalDetailsFile)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pickerButtonfront(_ sender: UIButton) {
            bButtonFront = true
            showActionSheet2()

    }
    @IBAction func pickerButtonBack(_ sender: UIButton) {
        bButtonFront = false
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
        let dataFile = try! Data(contentsOf: url)
        print(dataFile)
        let Front:String  = "12"
        var dataFront:Data = Front.data(using: .utf8)!
        var dataBack:Data = Front.data(using: .utf8)!
        
        let dictArray = NSMutableDictionary()
        dictArray.setValue("0", forKey: "image")
        
        if arrayEducationalDetailsFile.count != 0{
            dataFront = (arrayEducationalDetailsFile[0] as AnyObject).value(forKey: "blsfront") as! Data
            dataBack = (arrayEducationalDetailsFile[0] as AnyObject).value(forKey: "blsback") as! Data
        }
        

        if bButtonFront == true{
            if self.buttonFront.tag == 0{
                self.labelFront.text = String(format: "%@",url.lastPathComponent)
                dictArray.setValue(dataFile, forKey: "blsfront")
                if dataBack.count != 2{
                    dictArray.setValue(dataBack, forKey: "blsback")
                }else{
                    dictArray.setValue(dataBack, forKey: "blsback")
                }
                if self.arrayEducationalDetailsFile.count == 0{
                    self.arrayEducationalDetailsFile.insert(dictArray, at: 0)
                }else{
                    self.arrayEducationalDetailsFile.replaceObject(at: 0, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayBLSFile")
            }
        }else{
            if self.buttonBack.tag == 0{
                dictArray.setValue(dataFile, forKey: "blsfront")
                if dataFront.count != 2{
                    dictArray.setValue(dataFront, forKey: "blsback")
                }else{
                    dictArray.setValue(dataFront, forKey: "blsback")
                }
                self.labelBack.text = String(format: "%@",url.lastPathComponent)
                if self.arrayEducationalDetailsFile.count == 0{
                    self.arrayEducationalDetailsFile.insert(dictArray, at: 0)
                }else{
                    self.arrayEducationalDetailsFile.replaceObject(at: 0, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetailsFile, forKey: "arrayBLSFile")
            }
        }
        print(self.arrayEducationalDetailsFile)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //  imageViewUserImage.image = chosenImage
        let imageData1:Data = UIImageJPEGRepresentation(chosenImage, 0.5)!
        print(imageData1)
        let Front:String  = "12"
        var dataFront:Data = Front.data(using: .utf8)!
        var dataBack:Data = Front.data(using: .utf8)!

        let dictArray = NSMutableDictionary()
        dictArray.setValue("1", forKey: "image")
        
        if arrayEducationalDetails.count != 0{
             dataFront = (arrayEducationalDetails[0] as AnyObject).value(forKey: "blsfront") as! Data
             dataBack = (arrayEducationalDetails[0] as AnyObject).value(forKey: "blsback") as! Data
        }

        if bButtonFront == true{
            if self.buttonFront.tag == 0{
                dictArray.setValue(imageData1, forKey: "blsfront")
                if dataBack.count != 2{
                    dictArray.setValue(dataBack, forKey: "blsback")
                }else{
                    dictArray.setValue(dataBack, forKey: "blsback")
                }
                self.labelFront.text = "Image File Chosen"
                if self.arrayEducationalDetails.count == 0{
                    self.arrayEducationalDetails.insert(dictArray, at: 0)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: 0, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayBLS")
            }
        }else{
            if self.buttonBack.tag == 0{
                dictArray.setValue(imageData1, forKey: "blsback")
                if dataFront.count != 2{
                    dictArray.setValue(dataFront, forKey: "blsfront")
                }else{
                    dictArray.setValue(dataFront, forKey: "blsfront")
                }

                self.labelBack.text = "Image File Chosen"
                if self.arrayEducationalDetails.count == 0{
                    self.arrayEducationalDetails.insert(dictArray, at: 0)
                }else{
                    self.arrayEducationalDetails.replaceObject(at: 0, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayEducationalDetails, forKey: "arrayBLS")
            }
        }
        print(self.arrayEducationalDetailsFile)
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


