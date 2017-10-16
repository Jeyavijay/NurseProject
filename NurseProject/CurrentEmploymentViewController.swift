import TextFieldEffects
import PopupDialog
import MobileCoreServices
import NADocumentPicker
import AFNetworking
import NVActivityIndicatorView

class CurrentEmploymentViewController: UIViewController,UITextFieldDelegate {

    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var datePickerview = UIDatePicker()
    @IBOutlet var textFieldSupervisorName: HoshiTextField!
    @IBOutlet var textFieldHospitalDepartment: HoshiTextField!
    @IBOutlet var textFieldHospitalName: HoshiTextField!
    @IBOutlet var textFieldSupervisorTitle: HoshiTextField!
    @IBOutlet var buttonCheckBox: UIButton!
    @IBOutlet var textFieldDate: HoshiTextField!
    var bUnemployment = Bool()
    var activity:NVActivityIndicatorView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()        
    }

    func updateUI(){
        self.textFieldUI(textField:textFieldSupervisorName)
        self.textFieldUI(textField:textFieldHospitalDepartment)
        self.textFieldUI(textField:textFieldSupervisorTitle)
        self.textFieldUI(textField:textFieldHospitalName)
        self.textFieldUI(textField:textFieldDate)
        let DSImage:UIImage = UIImage(named: "checkboxwithoutTick")!
        let SImage:UIImage = UIImage(named: "checkboxtick")!
        buttonCheckBox.setImage(DSImage, for: .normal)
        buttonCheckBox.setImage(SImage, for: .selected)
        bUnemployment = true
        setLoadingIndicator()
    }
    
    
    func textFieldUI(textField:HoshiTextField){
        textField.borderActiveColor = AppColors().appBlueColor
        textField.placeholderColor = UIColor.darkGray
        textField.borderInactiveColor = UIColor.gray
    }

    @IBAction func buttonNext(_ sender: Any)
    {
        if bUnemployment != false{
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"PreviousEmploymentViewController") as! PreviousEmploymentViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else if (textFieldSupervisorName.text?.characters.count)! < 1{
            self.popupAlert(Title: "Information",msg: stringMessages().stringSupervisorName)
        }else if (textFieldSupervisorTitle.text?.characters.count)! < 1{
            self.popupAlert(Title: "Information",msg: stringMessages().stringSupervisorTitle)
        }else if (textFieldHospitalName.text?.characters.count)! < 1{
            self.popupAlert(Title: "Information",msg: stringMessages().stringHospitalName)
        }else if (textFieldHospitalDepartment.text?.characters.count)! < 1{
            self.popupAlert(Title: "Information",msg: stringMessages().stringDepartmentName)
        }else if (textFieldDate.text?.characters.count)! < 1{
            bUnemployment = true
            self.popupAlert(Title: "Information",msg: stringMessages().stringHospitalDOJ)
        }else if (buttonCheckBox.isSelected) == true{
            popupAlertYesorNo(msg:"If you select this boxYou will Consider as Unemployed for now!")
        }else{
            let dictParameters = NSMutableDictionary()
            let jsonArray = NSMutableArray()
            
            dictParameters.setValue(textFieldHospitalName.text, forKey: "hospitalname")
            dictParameters.setValue(textFieldHospitalDepartment.text, forKey: "deptofhospital")
            dictParameters.setValue(textFieldSupervisorTitle.text, forKey: "nameofsupervisor")
            dictParameters.setValue(textFieldSupervisorTitle.text, forKey: "titleofsupervisor")
            dictParameters.setValue(textFieldDate.text, forKey: "startdate")
            jsonArray.insert(dictParameters, at: 0)
            
            startLoading()
            var dictParameters1 = NSMutableDictionary()
            let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
            dictParameters1.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(JSONString)
                    dictParameters1.setObject(JSONString, forKey: "nurse_experience" as NSCopying)
                    dictParameters1.setObject("7", forKey: "stepid" as NSCopying)
                    self.CallWebserviceReistration(params:dictParameters1)
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
        manager.post(stringURL as String, parameters: params,progress: nil, success: { (operation, responseObject) -> Void in
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
    
    
    @IBAction func buttonCheckBox(_ sender: Any)
    {
        if (sender as AnyObject).tag == 1{
            if buttonCheckBox.isSelected == true{
                buttonCheckBox.isSelected = false
                bUnemployment = false
            }else{
                buttonCheckBox.isSelected = true
                bUnemployment = true
            }
        }
    }
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
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
        textFieldDate.text = dateFormatter1.string(from: sender.date)
        
    }

    //MARK:- Alert PopUps
    
    func popupAlert(Title:String,msg:String)
    {
        let popup = PopupDialog(title: Title, message: msg, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonTwo = DefaultButton(title: "OK")
        {
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"PreviousEmploymentViewController") as! PreviousEmploymentViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)

        }
        buttonTwo.buttonColor = UIColor.red
        buttonTwo.titleColor = UIColor.white
        popup.addButtons([buttonTwo])
        self.present(popup, animated: true, completion: nil)
    }
    func popupAlertYesorNo(msg:String)
    {
        let title = "Information"
        let message = msg
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonTwo = DefaultButton(title: "OK")
        {
            
        }
        buttonTwo.buttonColor = AppColors().appBlueColor
        buttonTwo.titleColor = UIColor.white
        let buttonOne = DefaultButton(title: "Cancel")
        {
            
        }
        buttonTwo.buttonColor = UIColor.red
        buttonTwo.titleColor = UIColor.white
        popup.addButtons([buttonOne,buttonTwo])
        self.present(popup, animated: true, completion: nil)
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
