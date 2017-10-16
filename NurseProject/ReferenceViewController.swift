import TextFieldEffects
import PopupDialog
import MobileCoreServices
import NADocumentPicker
import AFNetworking
import NVActivityIndicatorView

class ReferenceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var tableViewReference: UITableView!
    var nsectionCount = Int()
    var nsectionValue = Int()
    var activity:NVActivityIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        nsectionCount = 1
        updateUI()
    }
    
    func updateUI()
    {
        setLoadingIndicator()
        self.tableViewReference.register(UINib(nibName: "ReferenceTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Reference")
        self.tableViewReference.register(UINib(nibName: "PreviousEmployment2TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PECell2")
        tableViewReference.reloadData()
    }
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Tableview Delegate Methods -
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return nsectionCount + 1
    }
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if nsectionCount == section
        {
            return self.view.frame.height/30
        }else{
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if nsectionCount == (indexPath as NSIndexPath).section{
            return self.view.frame.height/5.59
        }else{
            return self.view.frame.height/2.2
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        return viewHeader
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0{
            return UITableViewCellEditingStyle.none
        }else if nsectionCount == (indexPath as NSIndexPath).section{
            return UITableViewCellEditingStyle.none
        }else{
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if nsectionCount == (indexPath as NSIndexPath).section{
            let lastCell = tableView.dequeueReusableCell(withIdentifier: "PECell2") as! PreviousEmployment2TableViewCell!
            lastCell!.buttonNext.addTarget(self, action: #selector(self.buttonNext), for: .touchUpInside)
            lastCell!.buttonAddMore.addTarget(self, action: #selector(self.buttonAddMore), for: .touchUpInside)
            return lastCell!
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "Reference") as! ReferenceTableViewCell!
            Cell!.textFieldFullName.tag = indexPath.section
            Cell!.textFieldPhoneNumber.tag = indexPath.section
            Cell!.textFieldEmailID.tag = indexPath.section
            Cell!.textFieldRelationShip.tag = indexPath.section

            return Cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableViewReference.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let arrayEmpDetails = NSMutableArray()
            if ((UserDefaults.standard.value(forKey: "arrayRef") != nil)){
                if arrayEmpDetails.count > 1{
                    let array:NSArray = UserDefaults.standard.array(forKey: "arrayRef")! as NSArray
                    arrayEmpDetails.addObjects(from: array as! [Any])
                    arrayEmpDetails.removeObject(at: indexPath.section)
                    print(arrayEmpDetails)
                    UserDefaults.standard.set(arrayEmpDetails, forKey: "arrayRef")
                    nsectionCount = nsectionCount - 1
                    self.tableViewReference.reloadData()
                }else{
                    nsectionCount = nsectionCount - 1
                    self.tableViewReference.reloadData()
                }
            }
        }
    }

    func buttonAddMore()
    {
        let textField = UITextField()
        let arrayEmpDetails = NSMutableArray()
        if ((UserDefaults.standard.value(forKey: "arrayRef") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayRef")! as NSArray
            arrayEmpDetails.addObjects(from: array as! [Any])
            print(arrayEmpDetails)
        }
        if arrayEmpDetails.count > 0{
            let strName:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "nameofrefer") as! String
            let strPhone:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "reference_phone") as! String
            let strEmail:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "reference_email") as! String
            textField.text = strEmail
            let strRelationShip:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "reference_designation") as! String
            if strName == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringName)
            }else if strPhone.characters.count < 10 {
                self.popupAlert(Title: "Information",msg: stringMessages().stringPhoneNumber)
            }else if (EmailValidation().validateMail(textEmail: textField.text!) == false){
                self.popupAlert(Title: "Information",msg: stringMessages().stringMail)
            }else if strRelationShip == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringRelationship)
            }else{
                nsectionCount = nsectionCount + 1
                tableViewReference.reloadData()
            }
        }else{
            self.popupAlert(Title: "Information",msg: stringMessages().stringAddMore)
        }
    }
    
    
    func buttonNext()
    {
        let arrayEmpDetails = NSMutableArray()
        if ((UserDefaults.standard.value(forKey: "arrayRef") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayRef")! as NSArray
            arrayEmpDetails.addObjects(from: array as! [Any])
            print(arrayEmpDetails)
        }
        let textField = UITextField()
        if arrayEmpDetails.count > 0{
            let strName:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "nameofrefer") as! String
            let strPhone:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "reference_phone") as! String
            let strEmail:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "reference_email") as! String
            textField.text = strEmail
            let strRelationShip:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "reference_designation") as! String
            if strName == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringName)
            }else if strPhone.characters.count < 10 {
                self.popupAlert(Title: "Information",msg: stringMessages().stringPhoneNumber)
            }else if (EmailValidation().validateMail(textEmail: textField.text!) == false){
                self.popupAlert(Title: "Information",msg: stringMessages().stringMail)
            }else if strRelationShip == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringRelationship)
            }else
            {
                
                startLoading()
                var dictParameters1 = NSMutableDictionary()
                let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
                dictParameters1.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: arrayEmpDetails, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        print(JSONString)
                        dictParameters1.setObject(JSONString, forKey: "reference_details" as NSCopying)
                        dictParameters1.setObject("9", forKey: "stepid" as NSCopying)
                        self.CallWebserviceReistration(params:dictParameters1)
                    }
                }catch
                {
                    self.stopLoading()
                }
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
                    self.stopLoading()
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"ResumeViewController") as! ResumeViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                else if strStatus == AccessToken{
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
