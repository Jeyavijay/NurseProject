import TextFieldEffects
import PopupDialog
import MobileCoreServices
import NADocumentPicker
import AFNetworking
import NVActivityIndicatorView

class ProfessionalEducationViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var activity:NVActivityIndicatorView!
    var dictArray = NSMutableDictionary()
    @IBOutlet var textFieldEducationLevel: HoshiTextField!
    @IBOutlet var textFieldDegreeName: HoshiTextField!
    @IBOutlet var textFieldGraduationDate: HoshiTextField!
    @IBOutlet var textFieldState: HoshiTextField!
    @IBOutlet var textFieldNameOfSchool: HoshiTextField!
    @IBOutlet var labelDocumentName: UILabel!
    var datePickerview = UIDatePicker()
    var arrayPickerview = NSArray()
    var pickerviewList = UIPickerView()
    var nTextFieldTags = Int()
    var strDate = String()
    let imagePicker = UIImagePickerController()
    var imageUpload = UIImage()
    var fileData = Data()



    override func viewDidLoad() {
        super.viewDidLoad()

        setLoadingIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    //MARK:- Textfield Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        if textField == self.textFieldEducationLevel{
            arrayPickerview = StaticArrayValues().arrayEducationLevel as NSArray
            nTextFieldTags = 2
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        if textField == self.textFieldState{
            arrayPickerview = StaticArrayValues().arrayUSStates as NSArray
            nTextFieldTags = 1
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }
        if textField == self.textFieldGraduationDate{
            datePickerview.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerview
            textField.inputView = datePickerview
            datePickerview.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
        if textField == self.textFieldDegreeName{
            arrayPickerview = StaticArrayValues().arrayDegree as NSArray
            nTextFieldTags = 3
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
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
        strDate = dateFormatter.string(from: sender.date)
        textFieldGraduationDate.text = dateFormatter1.string(from: sender.date)
        
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
            textFieldEducationLevel.text = strSelected
        }else if nTextFieldTags == 3{
            textFieldDegreeName.text = strSelected
        }
    }
    
    // MARK:- Button Actions
    
    @IBAction func buttonNext(_ sender: Any)
    {
        if (textFieldEducationLevel.text?.characters.count)! <= 1{
            self.popupAlert(Title: "Information",msg: stringMessages().stringEducationalLevel)
        }else if (textFieldDegreeName.text?.characters.count)! == 0{
            self.popupAlert(Title: "Information",msg: stringMessages().stringDegreeName)
        }else if (textFieldGraduationDate.text?.characters.count)! == 0{
            self.popupAlert(Title: "Information",msg: stringMessages().stringNameofSchool)
        }else if (textFieldState.text?.characters.count)! == 0{
            self.popupAlert(Title: "Information",msg: stringMessages().stringState)
        }else if (textFieldNameOfSchool.text?.characters.count)! == 0{
            self.popupAlert(Title: "Information",msg: stringMessages().stringGraduationDate)
        }else if (labelDocumentName.text?.characters.count)! == 0{
            self.popupAlert(Title: "Information",msg: stringMessages().stringUploadFrontDegree)
        }else{
            
            let arrayEducationalDetails = NSMutableArray()
            
            dictArray.setValue(textFieldEducationLevel.text, forKey: "highestdegree")
            dictArray.setValue(textFieldDegreeName.text, forKey: "nameofdegree")
            dictArray.setValue(textFieldNameOfSchool.text, forKey: "school")
            dictArray.setValue(textFieldState.text, forKey: "state")
            dictArray.setValue(textFieldGraduationDate.text, forKey: "gradudate")
            arrayEducationalDetails.insert(dictArray, at: 0)

            
                startLoading()
                var dictParameters = NSMutableDictionary()
                let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
                dictParameters.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: arrayEducationalDetails, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        print(JSONString)
                        dictParameters.setObject(JSONString, forKey: "educationdetails" as NSCopying)
                        dictParameters.setObject("5", forKey: "stepid" as NSCopying)
                        self.CallWebserviceReistration(params:dictParameters)
                    }
                }catch
                {
                    self.stopLoading()
                }
            


        }
    }
    //MARK:- Webservices
    
    func CallWebserviceReistration(params:NSMutableDictionary)
    {
        startLoading()
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().completeRegistrationUrl) as NSString
        let strAuth:String = UserDefaults.standard.value(forKey: "Authentication") as! String
        manager.requestSerializer.setValue(strAuth, forHTTPHeaderField: "Authorization")
        manager.post(stringURL as String, parameters: params, constructingBodyWith: {
            (data: AFMultipartFormData!) in

            if  self.labelDocumentName.text != "Image copy chosen!"{
                    data.appendPart(withFileData: self.fileData, name: "educationfiledetails[]", fileName: "file.pdf", mimeType: "application/pdf")
                }else{
                    data.appendPart(withFileData: self.fileData, name: "educationfiledetails[]", fileName: "photo.jpg", mimeType: "image/jpeg")
                }
        }, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            print(responseDictionary)
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == statusSuccess{
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"EducationCertificationViewController") as! EducationCertificationViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }else if strStatus == AccessToken{
                    self.callWebserviseAccessToken(params:params)
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
    func callWebserviseAccessToken(params:NSMutableDictionary){
        startLoading()
        let parameter = NSMutableDictionary()
        let strNurseID:String = UserDefaults.standard.value(forKey: "Email-ID") as! String
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
                    self.CallWebserviceReistration(params:params)
                }
                self.stopLoading()
            }
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription)
        })
    }
    

    @IBAction func buttonUpload(_ sender: Any)
    {
        self.SelectImage()
    }
    
    //MARK- Popup Alert
    
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
        labelDocumentName.text = "Image copy chosen!"
        let imageData:Data = UIImageJPEGRepresentation(chosenImage, 0.5)!
        print(imageData)
        fileData = imageData
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
            actionSheet.addAction(UIAlertAction(title: "From Document", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                self.DocLibrary()
            }))
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
        var types: [Any]? = [(kUTTypePDF as? String)]
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: types as! [String], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    //MARK:- DocumentMenu Delegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController,didPickDocumentAt url: URL) {
        print(url)

        self.labelDocumentName.text = url.lastPathComponent
        let dataFile = try! Data(contentsOf: url)
        fileData = dataFile

        if controller.documentPickerMode == UIDocumentPickerMode.import {
        }
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
