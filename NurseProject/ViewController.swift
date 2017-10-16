import UIKit
import TextFieldEffects
import PopupDialog
import AFNetworking
import NVActivityIndicatorView


class ViewController: UIViewController {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var textFieldPassword: HoshiTextField!
    @IBOutlet var textFieldEmail: HoshiTextField!
    var activity:NVActivityIndicatorView!
    var dictParameters = NSMutableDictionary()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingIndicator()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Button Actions
    
    @IBAction func buttonForgetPassword(_ sender: Any)
    {
        
    }
    
    @IBAction func buttonLogin(_ sender: Any)
    {
        if (EmailValidation().validateMail(textEmail: self.textFieldEmail.text!) == false)
        {
            self.popupAlert(Title: "Information",msg: stringMessages().stringMail)
        }else if (textFieldPassword.text?.characters.count)! <= 5
        {
            self.popupAlert(Title: "Information",msg: stringMessages().stringPassword)
        }else{
            if ((UserDefaults.standard.value(forKey: "DEVICETOKEN") != nil)){
                let strDeviceToken:String = String(format: "%@",UserDefaults.standard.value(forKey: "DEVICETOKEN") as! CVarArg)
                dictParameters.setObject(strDeviceToken, forKey: "devicetoken" as NSCopying)
            }else{
                dictParameters.setObject("ncjkchskjchsjkhcjkschjkscs", forKey: "devicetoken" as NSCopying)
            }
            UserDefaults.standard.set(textFieldPassword.text!, forKey:"password" )
            dictParameters.setObject("3", forKey: "devicetype" as NSCopying)
            dictParameters.setObject(textFieldPassword.text!, forKey: "password" as NSCopying)
            dictParameters.setObject(textFieldEmail.text!, forKey: "username" as NSCopying)
            UserDefaults.standard.set(textFieldEmail.text!, forKey: "Email-ID")
            self.CallWebserviceReistration(params:dictParameters)
        }
        
    }
    
    @IBAction func buttonSignUp(_ sender: Any)
    {
        let nextViewController = storyBoard.instantiateViewController(withIdentifier:"FirstSignUpViewController") as! FirstSignUpViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK:- Webservices
    
    func CallWebserviceReistration(params:NSMutableDictionary)
    {
        startLoading()
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().loginUrl) as NSString

        manager.post(stringURL as String, parameters: params, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            print(responseDictionary)
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                self.stopLoading()
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == statusSuccess{
                    if let AccessToken:String = (responseDictionary).value(forKey: "access_token") as? String{
                        let strToken:String = String(format: "Bearer %@",AccessToken)
                        UserDefaults.standard.set(strToken, forKey:"Authentication" )
                    }
                    if let strNurseID:String = (responseDictionary).value(forKey: "userid") as? String{
                        UserDefaults.standard.set(strNurseID, forKey:"nurse_ID" )
                    }
                    if let strCompletedSteps = (responseDictionary).value(forKey: "completed_steps"){
                        let strStatusStep:NSString = ConvertToString().anyToStr(convert: strCompletedSteps)
                        self.NavigateToViewcontroller(StepID: strStatusStep)


                    }

                }else if strStatus == AccessToken{

                }else if strStatus == "2"{
                    
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
    
    //MARK:- Navigate to StepID
    func NavigateToViewcontroller(StepID: NSString) {
        switch StepID {
        case "1":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"AccountDetailsViewController") as! AccountDetailsViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case "2":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"RNDetailsViewController") as! RNDetailsViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case "3":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"AccountDetailsEducationViewController") as! AccountDetailsEducationViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)

            break
        case "4":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"ProfessionalEducationViewController") as! ProfessionalEducationViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case "5":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"EducationCertificationViewController") as! EducationCertificationViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case "6":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"CurrentEmploymentViewController") as! CurrentEmploymentViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case "7":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"PreviousEmploymentViewController") as! PreviousEmploymentViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case "8":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"ReferenceViewController") as! ReferenceViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case "9":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"ResumeViewController") as! ResumeViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        case "10":
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"SpecialitiesViewController") as! SpecialitiesViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        default:
            let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"AccountDetailStatementViewController") as! AccountDetailStatementViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break

        }
    }

    //MARK:- Alert PopUps
    
    func popupAlert(Title:String,msg:String)
    {
        let title = Title
        let message = msg
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonOk = DefaultButton(title: "OK")
        {
        }
        buttonOk.buttonColor = UIColor.red
        buttonOk.titleColor = UIColor.white
        popup.addButtons([buttonOk])
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

