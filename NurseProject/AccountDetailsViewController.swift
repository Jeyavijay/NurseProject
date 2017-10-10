import UIKit
import TextFieldEffects
import PopupDialog
import MobileCoreServices
import NADocumentPicker
import AFNetworking
import NVActivityIndicatorView


class AccountDetailsViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate {
    
    @IBOutlet var buttonNext: UIButton!
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var viewDocumentView: UIView!
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet var viewScroll: UIView!
    @IBOutlet var imageViewDocument: UIImageView!
    @IBOutlet var imageViewUserImage: UIImageView!
    @IBOutlet var buttonAddImage: UIButton!
    @IBOutlet var textFieldFirstName: HoshiTextField!
    @IBOutlet var textFieldMiddleName: HoshiTextField!
    @IBOutlet var textFieldLastName: HoshiTextField!
    
    @IBOutlet var textFieldStreetName: HoshiTextField!
    @IBOutlet var textFieldFlatNumber: HoshiTextField!
    @IBOutlet var textFieldAddress: HoshiTextField!
    @IBOutlet var textFieldDOB: HoshiTextField!
    @IBOutlet var textFieldDocument: HoshiTextField!
    @IBOutlet var textFielsSSN: HoshiTextField!
    @IBOutlet var textFieldZipCode: HoshiTextField!
    @IBOutlet var textFieldCountry: HoshiTextField!
    @IBOutlet var textFieldState: HoshiTextField!
    @IBOutlet var buttonNoEligible: UIButton!
    @IBOutlet var buttonYesEligible: UIButton!
    @IBOutlet var buttonNotToSay: UIButton!
    @IBOutlet var buttonFemale: UIButton!
    @IBOutlet var buttonMale: UIButton!
    var datePickerview = UIDatePicker()
    var arrayPickerview = NSArray()
    var pickerviewList = UIPickerView()
    var nTextFieldTags = Int()
    var strDate = String()
    let imagePicker = UIImagePickerController()
    var bUpload = Bool()
    var imageUpload = UIImage()
    var dictParameters = NSMutableDictionary()
    var activity:NVActivityIndicatorView!
    var stringGender = NSString()
    var fileData = NSData()
    var fileName = NSString()



    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.updateUI()
    }
    
    func updateUI(){
        CornerRadius().viewCircular(circleView: imageViewUserImage)
        CornerRadius().viewCircular(circleView: buttonAddImage)
        ScrollView.contentSize = CGSize(width: self.viewScroll.frame.width, height: self.buttonNext.frame.height+self.buttonNext.frame.origin.y+25)
        let DSImage:UIImage = UIImage(named: "unchecked")!
        let SImage:UIImage = UIImage(named: "checked")!
        buttonMale.setImage(DSImage, for: .normal)
        buttonMale.setImage(SImage, for: .selected)
        buttonFemale.setImage(DSImage, for: .normal)
        buttonFemale.setImage(SImage, for: .selected)
        buttonNotToSay.setImage(DSImage, for: .normal)
        buttonNotToSay.setImage(SImage, for: .selected)
        buttonYesEligible.setImage(DSImage, for: .normal)
        buttonYesEligible.setImage(SImage, for: .selected)
        buttonNoEligible.setImage(DSImage, for: .normal)
        buttonNoEligible.setImage(SImage, for: .selected)
        viewDocumentView.isHidden = true
        setLoadingIndicator()
    }


    //MARK:- Textfield Delegates

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {

        if textField == self.textFieldState{
            arrayPickerview = StaticArrayValues().arrayUSStates as NSArray
            nTextFieldTags = 1
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        if textField == self.textFieldCountry{
            arrayPickerview = StaticArrayValues().arrayCountry as NSArray
            nTextFieldTags = 2
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        if textField == self.textFieldZipCode{
        }
        if textField == self.textFieldDocument{
            arrayPickerview = StaticArrayValues().arrayDocuments as NSArray
            nTextFieldTags = 4
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        if textField == self.textFieldDOB{
            datePickerview.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerview
            textField.inputView = datePickerview
            datePickerview.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string.characters.count == 0
            {
                return true
            }
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            switch textField {
            case textFieldZipCode:
                return prospectiveText.containsCharactersIn("0123456789") &&
                    prospectiveText.characters.count <= 8
            default:
                return true
        }
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
        strDate = dateFormatter.string(from: sender.date)
            textFieldDOB.text = dateFormatter1.string(from: sender.date)

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
        print(arrayPickerview)
        var title = String()
        title = (arrayPickerview[row] as AnyObject)as! String
        return title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var strSelected = String()
        strSelected = (arrayPickerview[row] as AnyObject)as! String
        if nTextFieldTags == 1{
            textFieldState.text = strSelected
        }else if nTextFieldTags == 2{
            textFieldCountry.text = strSelected
        }else if nTextFieldTags == 3{
            textFieldZipCode.text = strSelected
        }else if nTextFieldTags == 4 {
            textFieldDocument.text = strSelected
        }
    }
    
    //MARK:- Button Actions
    
    @IBAction func buttonEligible(_ sender: Any)
    {
        if (sender as AnyObject).tag == 1{
            if buttonYesEligible.isSelected == true{
                buttonYesEligible.isSelected = false
            }else{
                buttonYesEligible.isSelected = true
                buttonNoEligible.isSelected = false
            }

        }else if (sender as AnyObject).tag == 2{
            if buttonNoEligible.isSelected == true{
                buttonNoEligible.isSelected = false
            }else{
                buttonNoEligible.isSelected = true
                buttonYesEligible.isSelected = false
            }
        }
    }
    
    @IBAction func buttonGender(_ sender: Any)
    {
        if (sender as AnyObject).tag == 1{
            
            if buttonMale.isSelected == true{
                buttonMale.isSelected = false
            }else{
                buttonMale.isSelected = true
                buttonFemale.isSelected = false
                buttonNotToSay.isSelected = false
            }
        }else if (sender as AnyObject).tag == 2{
            if buttonFemale.isSelected == true{
                buttonFemale.isSelected = false
            }else{
                buttonFemale.isSelected = true
                buttonMale.isSelected = false
                buttonNotToSay.isSelected = false
            }
        }else if (sender as AnyObject).tag == 3{
            if buttonNotToSay.isSelected == true{
                buttonNotToSay.isSelected = false
            }else{
                buttonNotToSay.isSelected = true
                buttonMale.isSelected = false
                buttonFemale.isSelected = false
            }
        }
    }
    
    @IBAction func buttonUpload(_ sender: Any)
    {
        bUpload = true
        self.SelectImage()
    }

    @IBAction func buttonPickImage(_ sender: Any)
    {
        bUpload = false
        self.SelectImage()
    }

    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    
    @IBAction func buttonNext(_ sender: Any)
    {
        if imageViewUserImage.image == nil {
            self.popupAlert(Title: "Information",msg: stringMessages().stringSelectImage)
        }else if (textFieldFirstName.text?.characters.count)! == 0{
            self.popupAlert(Title: "Information",msg: stringMessages().stringFirstName)
        }else if (textFieldLastName.text?.characters.count)! < 1{
            self.popupAlert(Title: "Information",msg: stringMessages().stringLastName)
        }else if (textFieldDOB.text?.characters.count)! < 2{
            self.popupAlert(Title: "Information",msg: stringMessages().stringDOB)
        }else if (buttonMale.isSelected || buttonFemale.isSelected || buttonNotToSay.isSelected) == false{
            self.popupAlert(Title: "Information",msg: stringMessages().stringGender)
        }else if (textFieldAddress.text?.characters.count)! < 5{
            self.popupAlert(Title: "Information",msg: stringMessages().stringAddress)
        }else if (textFieldFlatNumber.text?.characters.count)! < 1{
            self.popupAlert(Title: "Information",msg: "Please Enter Your House/Flat Number")
        }else if (textFieldFlatNumber.text?.characters.count)! < 1{
            self.popupAlert(Title: "Information",msg: "Please Enter Your Street Name")
        }else if (textFieldState.text?.characters.count)! < 2{
            self.popupAlert(Title: "Information",msg: stringMessages().stringState)
        }else if (textFieldCountry.text?.characters.count)! < 2{
            self.popupAlert(Title: "Information",msg: stringMessages().stringCountry)
        }else if (textFieldZipCode.text?.characters.count)! < 2{
            self.popupAlert(Title: "Information",msg: stringMessages().stringZipCode)
        }else if (textFielsSSN.text?.characters.count)! < 2{
            self.popupAlert(Title: "Information",msg: stringMessages().stringSSN)
        }else if (textFieldDocument.text?.characters.count)! < 2{
            self.popupAlert(Title: "Information",msg: stringMessages().stringIdentityDocument)
        }else if bUpload == false{
            self.popupAlert(Title: "Information",msg: stringMessages().stringUploadDocument)
        }else if (buttonNoEligible.isSelected || buttonYesEligible.isSelected) == false{
            self.popupAlert(Title: "Information",msg: stringMessages().stringEligibility)
        }else{
            
            let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
            dictParameters.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
            dictParameters.setObject(stringGender, forKey: "gender" as NSCopying)
            dictParameters.setObject(textFieldFirstName.text!, forKey: "name" as NSCopying)
            dictParameters.setObject(textFieldDOB.text!, forKey: "dob" as NSCopying)
            dictParameters.setObject(textFielsSSN.text!, forKey: "ssc" as NSCopying)
            dictParameters.setObject(textFieldDocument.text!, forKey: "idcard" as NSCopying)

            dictParameters.setObject(textFieldAddress.text!, forKey: "address" as NSCopying)
            dictParameters.setObject(textFieldFlatNumber.text!, forKey: "houseno" as NSCopying)
            dictParameters.setObject(textFieldStreetName.text!, forKey: "street" as NSCopying)
            dictParameters.setObject(textFieldZipCode.text!, forKey: "zipcode" as NSCopying)
            dictParameters.setObject(textFieldState.text!, forKey: "state" as NSCopying)
            dictParameters.setObject(textFieldCountry.text!, forKey: "country" as NSCopying)
            dictParameters.setObject("2", forKey: "stepid" as NSCopying)
            
            self.CallWebserviceReistration(params:dictParameters, fileData: fileData)

            
           
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func SelectImage()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.delegate = self;
            self.showActionSheet2()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if bUpload == false
        {
            bUpload = true
            imageViewUserImage.image = chosenImage
            CornerRadius().viewCircular(circleView: imageViewUserImage)
            
        }else{
            imageUpload = chosenImage
            self.imageViewDocument.image = chosenImage
            self.viewDocumentView.isHidden = false
            let imageData:Data = UIImageJPEGRepresentation(chosenImage, 0.5)!
            print(imageData)
            fileData = imageData as NSData


        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: ActionSheet Delegate
    
    func showActionSheet2()
    {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        if bUpload == true{
            actionSheet.addAction(UIAlertAction(title: "From Document", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                self.DocLibrary()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    func camera()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func photoLibrary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func DocLibrary(){
       var types: [Any]? = [(kUTTypeData as? String),(kUTTypeBMP as? String),(kUTTypeXML as? String),(kUTTypeItem as? String),(kUTTypeRTF as? String),(kUTTypeText as? String),(kUTTypeRTFD as? String),(kUTTypeInkText as? String),(kUTTypeContent as? String),(kUTTypeDelimitedText as? String),(kUTTypePlainText as? String), (kUTTypePresentation as? String),(kUTTypeFolder as? String),(kUTTypePDF as? String)]
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: types as! [String], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(documentPicker, animated: true, completion: nil)

    }
    
    //MARK:- DocumentMenu Delegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController,didPickDocumentAt url: URL) {
        print(url)
        fileName = url.lastPathComponent as NSString
        let data = NSData.init(contentsOf: url)
        fileData = data!
        print(fileData)
        bUpload = true
        viewDocumentView.isHidden = false
        if controller.documentPickerMode == UIDocumentPickerMode.import {
        }
    }
    
    func doc(asd:URL)
    {
        var documentInteractionController = UIDocumentInteractionController()
        documentInteractionController = UIDocumentInteractionController(url: asd)
        // Configure Document Interaction Controller
        documentInteractionController.delegate = self
        // Preview PDF
        documentInteractionController.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    
    //MARK:- Alert PopUps
    
    func popupAlert(Title:String,msg:String)
    {
        let popup = PopupDialog(title: Title, message: msg, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonTwo = DefaultButton(title: "OK")
        {
        }
        buttonTwo.buttonColor = UIColor.red
        buttonTwo.titleColor = UIColor.white
        popup.addButtons([buttonTwo])
        self.present(popup, animated: true, completion: nil)
    }
    
    //MARK:- Webservices
    
    func CallWebserviceReistration(params:NSMutableDictionary, fileData:NSData)
    {
        startLoading()
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().completeRegistrationUrl) as NSString
        let strAuth:String = UserDefaults.standard.value(forKey: "Authentication") as! String
        manager.requestSerializer.setValue(strAuth, forHTTPHeaderField: "Authorization")
        manager.post(stringURL as String, parameters: params, constructingBodyWith: {
            (data: AFMultipartFormData!) in
            let imageData = Data()
            //= UIImageJPEGRepresentation(imageUpload, 0.5)!
            data.appendPart(withFileData: fileData as Data, name: "idfile", fileName: self.fileName as String, mimeType: (kUTTypePDF as String))
        }, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            print(responseDictionary)
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == "1"{
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"AccountDetailsViewController") as! AccountDetailsViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }else if strStatus == "401"{
                    self.callWebserviseAccessToken()
                }else{
                    self.stopLoading()
                    if let Msg:String = (responseDictionary).value(forKey: "msg") as? String{
                        self.popupAlert(Title: "Information", msg: Msg)
                    }
                }
            }
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription)
        })
    }
    func callWebserviseAccessToken(){
        startLoading()
        let parameter = NSMutableDictionary()
        let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
        let strPassword:String = UserDefaults.standard.value(forKey: "password") as! String
        parameter.setObject(strNurseID, forKey: "username" as NSCopying)
        parameter.setObject(strPassword, forKey: "password" as NSCopying)
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().getAccessTokenUrl) as NSString
        
        manager.post(stringURL as String, parameters: parameter, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            print(responseDictionary)
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == "1"
                {
                    if let AccessToken:String = (responseDictionary).value(forKey: "access_token") as? String{
                        let strToken:String = String(format: "Bearer %@",AccessToken)
                        UserDefaults.standard.set(strToken, forKey:"Authentication" )
                    }
                    self.CallWebserviceReistration(params:self.dictParameters, fileData: self.fileData)
                }
                self.stopLoading()
            }
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription)
        })
    }

    
    //MARK:- Activity Indicator View
    func setLoadingIndicator()
    {
        activity = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        activity.color = AppColors().appBlueColor
        activity.type = NVActivityIndicatorType.ballScaleMultiple
        activity.startAnimating()
        activity.center = view.center
    }
    func startLoading()
    {
        view.isUserInteractionEnabled = false
        self.view.addSubview(activity)
    }
    
    func stopLoading(){
        activity.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }


}
