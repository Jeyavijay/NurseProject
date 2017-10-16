import UIKit
import TextFieldEffects
import PopupDialog
import MobileCoreServices
import AFNetworking
import NVActivityIndicatorView

class AccountDetailsEducationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ChangeDocumentProtocol {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var tableViewEducation: UITableView!
    var nsectionCount = Int()
    var nsectionValue = Int()
    var nArrObject = Int()
    var activity:NVActivityIndicatorView!
    var dictParameters = NSMutableDictionary()


    override func viewDidLoad()
    {
        super.viewDidLoad()
        nsectionCount = 1
        updateUI()

    }

    func updateUI()
    {
        self.tableViewEducation.register(UINib(nibName: "EducationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Education")
        self.tableViewEducation.register(UINib(nibName: "Education2TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "lastCell")
        setLoadingIndicator()
        tableViewEducation.reloadData()
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
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if nsectionCount == (indexPath as NSIndexPath).section{
            return self.view.frame.height/5.59
        }else{
            return self.view.frame.height/1.6
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        return viewHeader
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if nsectionCount == (indexPath as NSIndexPath).section{
            let lastCell = tableView.dequeueReusableCell(withIdentifier: "lastCell") as! Education2TableViewCell!
            lastCell!.buttonNext.addTarget(self, action: #selector(self.buttonNext), for: .touchUpInside)
            lastCell!.buttonAddMore.addTarget(self, action: #selector(self.buttonAddMore), for: .touchUpInside)

            return lastCell!
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "Education") as! EducationTableViewCell!
            Cell!.textFieldState.tag = indexPath.section
            Cell!.textFieldDate.tag = indexPath.section
            Cell!.textFieldNameofSchool.tag = indexPath.section
            Cell!.textFieldDegreeName.tag = indexPath.section
            Cell!.textFieldEducationLevel.tag = indexPath.section
            Cell!.buttonUpload.tag = indexPath.section
            Cell!.delegate = self

            return Cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableViewEducation.deselectRow(at: indexPath, animated: false)
    }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
        {
            if editingStyle == .delete
            {
                let arrayEducationalDetails = NSMutableArray()
                if ((UserDefaults.standard.value(forKey: "arrayEdu") != nil)){
                    if arrayEducationalDetails.count > 1{
                        let array:NSArray = UserDefaults.standard.array(forKey: "arrayEdu")! as NSArray
                        arrayEducationalDetails.addObjects(from: array as! [Any])
                        arrayEducationalDetails.removeObject(at: indexPath.section)
                        print(arrayEducationalDetails)
                        UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayEdu")
                        nsectionCount = nsectionCount - 1
                        self.tableViewEducation.reloadData()
                    }else{
                        nsectionCount = nsectionCount - 1
                        self.tableViewEducation.reloadData()
                    }
                }
            }
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
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    func buttonAddMore()
    {
        let arrayEducationalDetails = NSMutableArray()
        let arrayEducationalDetailsFile = NSMutableArray()

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

        if arrayEducationalDetails.count == nsectionCount{
            let strEduLevel:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "highestdegree") as! String
            let strEduDegree:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "nameofdegree") as! String
            let strEduSchool:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "school") as! String
            let strState:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "state") as! String
            let strDate:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "gradudate") as! String

            if strEduLevel == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringEducationalLevel)
            }else if strEduDegree == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringDegreeName)
            }else if strEduSchool == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringNameofSchool)
            }else if strState == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringState)
            }else if strDate == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringGraduationDate)
            }else if arrayEducationalDetailsFile.count != nsectionCount{
                self.popupAlert(Title: "Information",msg: stringMessages().stringUploadFrontDegree)
            }else{
                nsectionCount = nsectionCount + 1
                tableViewEducation.reloadData()
            }
        }else{
            self.popupAlert(Title: "Information",msg: stringMessages().stringAddMore)
        }

    }
    
    func buttonNext()
    {
        let arrayEducationalDetails = NSMutableArray()
        let arrayEducationalDetailsFile = NSMutableArray()

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

        if arrayEducationalDetails.count > 0{
            let strEduLevel:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "highestdegree") as! String
            let strEduDegree:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "nameofdegree") as! String
            let strEduSchool:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "school") as! String
            let strState:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "state") as! String
            let strDate:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "gradudate") as! String
            if strEduLevel == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringEducationalLevel)
            }else if strEduDegree == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringDegreeName)
            }else if strEduSchool == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringNameofSchool)
            }else if strState == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringState)
            }else if strDate == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringGraduationDate)
            }else if arrayEducationalDetailsFile.count != nsectionCount{
                self.popupAlert(Title: "Information",msg: stringMessages().stringUploadFrontDegree)
            }else{
                startLoading()

                let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
                dictParameters.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: arrayEducationalDetails, options: JSONSerialization.WritingOptions.prettyPrinted)
                    
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        print(JSONString)
                        dictParameters.setObject(JSONString, forKey: "educationdetails" as NSCopying)
                        dictParameters.setObject("4", forKey: "stepid" as NSCopying)
                        self.CallWebserviceReistration(params:dictParameters,arrayImages: arrayEducationalDetailsFile)
                    }
                }catch
                {
                    self.stopLoading()
                }
            }
        }
    }
    
    @objc func buttonUpload(_ sender: Any){
        print((sender as AnyObject).tag)
        nArrObject = (sender as AnyObject).tag
    }

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    //MARK:- Webservices
    
    func CallWebserviceReistration(params:NSMutableDictionary, arrayImages:NSMutableArray)
    {
        startLoading()
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().completeRegistrationUrl) as NSString
        let strAuth:String = UserDefaults.standard.value(forKey: "Authentication") as! String
        manager.requestSerializer.setValue(strAuth, forHTTPHeaderField: "Authorization")
        manager.post(stringURL as String, parameters: params, constructingBodyWith: {
            (data: AFMultipartFormData!) in
            for i in 0...arrayImages.count-1{
                let strData:Data = (arrayImages[i] as AnyObject).value(forKey: "Document") as! Data
                let strimage:String = (arrayImages[i] as AnyObject).value(forKey: "image") as! String
                if strimage == "0"{
                    data.appendPart(withFileData: strData, name: "educationfiledetails[]", fileName: "file.pdf", mimeType: "application/pdf")
                }else{
                    data.appendPart(withFileData: strData, name: "educationfiledetails[]", fileName: "photo\(i).jpg", mimeType: "image/jpeg")
                }
            }
        }, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            print(responseDictionary)
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == statusSuccess{
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"ProfessionalEducationViewController") as! ProfessionalEducationViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }else if strStatus == AccessToken{
                    self.callWebserviseAccessToken(params:params,arrayImages:arrayImages)
                }else{
                    if let Msg:String = (responseDictionary).value(forKey: "msg") as? String{
                        self.popupAlert(Title: "Information", msg: Msg)
                    }
                }
                self.stopLoading()
            }
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription)
        })
    }
    func callWebserviseAccessToken(params:NSMutableDictionary,arrayImages:NSMutableArray){
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
                    self.CallWebserviceReistration(params:params,arrayImages:arrayImages)
                }
                self.stopLoading()
            }
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription)
        })
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
    
    func loadDocScreen(controller: UIViewController) {
        self.present(controller, animated: true) { () -> Void in
        };
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
