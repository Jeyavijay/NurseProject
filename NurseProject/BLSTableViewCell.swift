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
    var arrayFront = NSMutableArray()
    var arrayBack = NSMutableArray()
    var nTextFieldTags = Int()
    var bButtonFront = Bool()

    override func awakeFromNib() {
        super.awakeFromNib()

        if ((UserDefaults.standard.value(forKey: "arrayBLSFront") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayBLSFront")! as NSArray
            arrayFront.addObjects(from: array as! [Any])
            print(arrayFront)
        }
        if ((UserDefaults.standard.value(forKey: "arrayBLSBack") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayBLSBack")! as NSArray
            arrayBack.addObjects(from: array as! [Any])
            print(arrayBack)
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
        let dictArray = NSMutableDictionary()

        if bButtonFront == true{
            if self.buttonFront.tag == 0{
                self.labelFront.text = String(format: "%@",url.lastPathComponent)
                dictArray.setValue(dataFile, forKey: "blsfront")
                dictArray.setValue("0", forKey: "image")

                if self.arrayBack.count == 0{
                    self.arrayFront.insert(dictArray, at: 0)
                }else{
                    self.arrayFront.replaceObject(at: 0, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayFront, forKey: "arrayBLSFront")
            }
        }else{
            if self.buttonBack.tag == 0{
                self.labelBack.text = String(format: "%@",url.lastPathComponent)
                dictArray.setValue(dataFile, forKey: "blsback")
                dictArray.setValue("0", forKey: "image")
                
                if self.arrayBack.count == 0{
                    self.arrayBack.insert(dictArray, at: 0)
                }else{
                    self.arrayBack.replaceObject(at: 0, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayBack, forKey: "arrayBLSBack")
            }
        }
        print(self.arrayFront)
        print(self.arrayBack)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = imageURL.lastPathComponent

        let dataFile:Data = UIImageJPEGRepresentation(chosenImage, 0.5)!
        print(dataFile)
        let dictArray = NSMutableDictionary()

        if bButtonFront == true{
            if self.buttonFront.tag == 0{
                self.labelFront.text = String(format: "%@",imageName!)
                dictArray.setValue(dataFile, forKey: "blsfront")
                dictArray.setValue("1", forKey: "image")
                
                if self.arrayFront.count == 0{
                    self.arrayFront.insert(dictArray, at: 0)
                }else{
                    self.arrayFront.replaceObject(at: 0, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayFront, forKey: "arrayBLSFront")
            }
        }else{
            if self.buttonBack.tag == 0{
                self.labelBack.text = String(format: "%@",imageName!)
                dictArray.setValue(dataFile, forKey: "blsback")
                dictArray.setValue("1", forKey: "image")
                
                if self.arrayBack.count == 0{
                    self.arrayBack.insert(dictArray, at: 0)
                }else{
                    self.arrayBack.replaceObject(at: 0, with: dictArray)
                }
                UserDefaults.standard.set(self.arrayBack, forKey: "arrayBLSBack")
            }
        }
        print(self.arrayBack)
        print(self.arrayFront)
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


