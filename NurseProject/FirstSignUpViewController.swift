import UIKit
import TextFieldEffects
import PopupDialog
import AFNetworking
import NVActivityIndicatorView


class FirstSignUpViewController: UIViewController,UITextFieldDelegate {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var textFieldFirstName: HoshiTextField!
    @IBOutlet var textFieldMiddleName: HoshiTextField!
    @IBOutlet var textFieldLastName: HoshiTextField!
    @IBOutlet var textFieldMailID: HoshiTextField!
    @IBOutlet var textFieldPhoneNumber: HoshiTextField!
    @IBOutlet var textFieldPassword: HoshiTextField!
    @IBOutlet var textFieldCPassword: HoshiTextField!
    var activity:NVActivityIndicatorView!
    var dictStoredValues = NSMutableDictionary()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingIndicator()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button Actions

    @IBAction func buttonNext(_ sender: Any)
    {
        if (textFieldFirstName.text?.characters.count)! <= 2
        {
            self.popupAlert(Title: "Information",msg: stringMessages().stringFirstName, butttonColor: UIColor.red)
        }else if (textFieldLastName.text?.characters.count)! < 1
        {
            self.popupAlert(Title: "Information",msg: stringMessages().stringLastName, butttonColor: UIColor.red)
        }else if (EmailValidation().validateMail(textEmail: self.textFieldMailID.text!) == false)
        {
            self.popupAlert(Title: "Information",msg: stringMessages().stringMail, butttonColor: UIColor.red)
        }else if (textFieldPhoneNumber.text?.characters.count)! <= 9
        {
            self.popupAlert(Title: "Information",msg: stringMessages().stringMail, butttonColor: UIColor.red)
        }else  if (textFieldPassword.text?.characters.count)! < 6{
            self.popupAlert(Title: "Information",msg: stringMessages().stringPassword, butttonColor: UIColor.red)
        }else if textFieldPassword.text != textFieldCPassword.text{
            self.popupAlert(Title: "Information",msg: stringMessages().stringConfirmPassword, butttonColor: UIColor.red)
        }else{
            dictStoredValues.setObject(textFieldFirstName.text!, forKey: "firstname" as NSCopying)
            dictStoredValues.setObject(textFieldMiddleName.text!, forKey: "middlename" as NSCopying)

            dictStoredValues.setObject(textFieldLastName.text!, forKey: "lastname" as NSCopying)
            dictStoredValues.setObject(textFieldMailID.text!, forKey: "email" as NSCopying)
            dictStoredValues.setObject(textFieldPhoneNumber.text!, forKey: "phonenumber" as NSCopying)
            dictStoredValues.setObject(textFieldPassword.text!, forKey: "password" as NSCopying)
            if ((UserDefaults.standard.value(forKey: "DEVICETOKEN") != nil)){
                let strDeviceToken:String = String(format: "%@",UserDefaults.standard.value(forKey: "DEVICETOKEN") as! CVarArg)
                dictStoredValues.setObject(strDeviceToken, forKey: "devicetoken" as NSCopying)
            }else{
                dictStoredValues.setObject("", forKey: "devicetoken" as NSCopying)
            }
            dictStoredValues.setObject("3", forKey: "devicetype" as NSCopying)
            
            CallWebserviceReistration(params: dictStoredValues)

        }

    }
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    //MARK:- Alert PopUps
    
    func popupAlert(Title:String,msg:String,butttonColor:UIColor)
    {
        let title = Title
        let message = msg
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonOk = DefaultButton(title: "OK")
        {
        }
        buttonOk.buttonColor = butttonColor
        buttonOk.titleColor = UIColor.white
        popup.addButtons([buttonOk])
        self.present(popup, animated: true, completion: nil)
    }
    
    func popupAlertToNavigate(Title:String,msg:String,butttonColor:UIColor)
    {
        let title = Title
        let message = msg
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonOk = DefaultButton(title: "OK")
        {
                        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"ViewController") as! ViewController
                        self.navigationController?.pushViewController(nextViewController, animated: false)
        
        }
        buttonOk.buttonColor = butttonColor
        buttonOk.titleColor = UIColor.white
        popup.addButtons([buttonOk])
        self.present(popup, animated: true, completion: nil)
    }

    //MARK:- Webservices

    func CallWebserviceReistration(params:NSMutableDictionary)
    {
        startLoading()
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().signupUrl) as NSString

//        let strAuth:String = UserDefaults.standard.value(forKey: "Authentication") as! String
//        manager.requestSerializer.setValue(strAuth, forHTTPHeaderField: "Auth-Token")
        
        manager.post(stringURL as String, parameters: params, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == "1"{
                    if let Msg:String = (responseDictionary).value(forKey: "msg") as? String{
                        
                        self.popupAlertToNavigate(Title: "Information", msg: Msg, butttonColor: AppColors().appBlueColor)
                    }
                }else{
                    if let Msg:String = (responseDictionary).value(forKey: "msg") as? String{

                        self.popupAlertToNavigate(Title: "Information", msg: Msg, butttonColor: UIColor.red)
                    }
                }

            }
            self.stopLoading()
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription, butttonColor: UIColor.red)
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
