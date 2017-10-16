import UIKit
import TextFieldEffects
import PopupDialog
import MobileCoreServices
import AFNetworking
import NVActivityIndicatorView


class EducationCertificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChangeDocumentProtocol  {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var tableViewCertificate: UITableView!
    var nsectionCount = Int()
    var nsectionValue = Int()
    var strDocument = NSString()
    var activity:NVActivityIndicatorView!
    var dictParameters = NSMutableDictionary()



    override func viewDidLoad()
    {
        super.viewDidLoad()
        setLoadingIndicator()
        nsectionCount = 2
        updateUI()
    }
    
    func updateUI()
    {
        self.tableViewCertificate.register(UINib(nibName: "BLSTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BLS")
        self.tableViewCertificate.register(UINib(nibName: "CertificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Certificate")
        self.tableViewCertificate.register(UINib(nibName: "Education2TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "lastCell")
        tableViewCertificate.reloadData()
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
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0{
            return self.view.frame.height/4.9
        }else if nsectionCount > (indexPath as NSIndexPath).section{
            return self.view.frame.height/2
        }else{
            return self.view.frame.height/5.59
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
         if (indexPath as NSIndexPath).section == 0 {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "BLS") as! BLSTableViewCell!
            
            Cell!.buttonBack.tag = indexPath.section
            Cell!.delegate = self
            Cell!.buttonFront.tag = indexPath.section
            return Cell!
        }else if nsectionCount > (indexPath as NSIndexPath).section{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "Certificate") as! CertificationTableViewCell!
            Cell!.textFieldName.tag = indexPath.section - 1
            Cell!.textFieldDate.tag = indexPath.section - 1
            Cell!.buttonUploadFront.tag = indexPath.section - 1
            Cell!.buttonUploadBack.tag = indexPath.section - 1
            Cell!.delegate = self
            
            return Cell!
        }else{

            let lastCell = tableView.dequeueReusableCell(withIdentifier: "lastCell") as! Education2TableViewCell!
            lastCell!.buttonNext.addTarget(self, action: #selector(self.buttonNext), for: .touchUpInside)
            lastCell!.buttonAddMore.addTarget(self, action: #selector(self.buttonAddMore), for: .touchUpInside)
            
            return lastCell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableViewCertificate.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let arrayEducationalDetails = NSMutableArray()
            if ((UserDefaults.standard.value(forKey: "arrayCertificate") != nil)){
                if arrayEducationalDetails.count > 1{
                    let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificate")! as NSArray
                    arrayEducationalDetails.addObjects(from: array as! [Any])
                    arrayEducationalDetails.removeObject(at: indexPath.section)
                    print(arrayEducationalDetails)
                    UserDefaults.standard.set(arrayEducationalDetails, forKey: "arrayCertificate")
                    nsectionCount = nsectionCount - 1
                    self.tableViewCertificate.reloadData()
                }else{
                    nsectionCount = nsectionCount - 1
                    self.tableViewCertificate.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    
    func buttonAddMore()
    {
        let arrayEducationalDetails = NSMutableArray()
        let arrayEducationalDetailsFront = NSMutableArray()
        let arrayEducationalDetailsBack = NSMutableArray()

        if ((UserDefaults.standard.value(forKey: "arrayCertificate") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificate")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
            print(arrayEducationalDetails)
        }

        if ((UserDefaults.standard.value(forKey: "arrayCertificateFileFront") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificateFileFront")! as NSArray
            arrayEducationalDetailsFront.addObjects(from: array as! [Any])
            print(arrayEducationalDetailsFront)
        }
        if ((UserDefaults.standard.value(forKey: "arrayCertificateFileBack") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificateFileBack")! as NSArray
            arrayEducationalDetailsBack.addObjects(from: array as! [Any])
            print(arrayEducationalDetailsBack)
        }

        if arrayEducationalDetails.count == nsectionCount-1{
            let strName:String = (arrayEducationalDetails[nsectionCount-2] as AnyObject).value(forKey: "certificate_name") as! String
            if strName == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringCertificate)
            } else if arrayEducationalDetailsFront.count == 0
        {
            self.popupAlert(Title: "Information",msg: "Please Upload Front Copy of Your Certificate")
        }else{
                nsectionCount = nsectionCount + 1
                tableViewCertificate.reloadData()
            }
        }else{
                self.popupAlert(Title: "Information",msg: stringMessages().stringAddMore)
        }
    }
    
    func buttonNext()
    {
        let arrayEducationalDetails = NSMutableArray()
        let arrayBLSFront = NSMutableArray()
        let arrayBLSBack = NSMutableArray()
        let arrayCertificateFront = NSMutableArray()
        let arrayCertificateBack = NSMutableArray()

        if ((UserDefaults.standard.value(forKey: "arrayBLSFront") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayBLSFront")! as NSArray
            arrayBLSFront.addObjects(from: array as! [Any])
            print(arrayBLSFront)
        }

        if ((UserDefaults.standard.value(forKey: "arrayBLSBack") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayBLSBack")! as NSArray
            arrayBLSBack.addObjects(from: array as! [Any])
            print(arrayBLSBack)
        }
        if ((UserDefaults.standard.value(forKey: "arrayCertificate") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificate")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
            print(arrayEducationalDetails)
        }
        if ((UserDefaults.standard.value(forKey: "arrayCertificateFileFront") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificateFileFront")! as NSArray
            arrayCertificateFront.addObjects(from: array as! [Any])
            print(arrayCertificateFront)
        }
        if ((UserDefaults.standard.value(forKey: "arrayCertificateFileBack") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificateFileBack")! as NSArray
            arrayCertificateBack.addObjects(from: array as! [Any])
            print(arrayCertificateBack)
        }

        
        if arrayBLSFront.count == 0{
            self.popupAlert(Title: "Information",msg: "Choose Front Copy of BLS Certificate")
        }else if arrayBLSBack.count == 0 {
            self.popupAlert(Title: "Information",msg: "Choose Back Copy of BLS Certificate")
        }else{
            if arrayEducationalDetails.count == nsectionCount-1{
                let strName:String = (arrayEducationalDetails[nsectionCount-2] as AnyObject).value(forKey: "certificate_name") as! String
                if arrayBLSFront.count == nsectionCount
                {
                    self.popupAlert(Title: "Information",msg: "Please Upload Front Copy of Your Certificate")
                }else if strName == ""{
                    self.popupAlert(Title: "Information",msg: stringMessages().stringCertificate)
                }else if arrayCertificateFront.count == 0
                {
                    self.popupAlert(Title: "Information",msg: "Please Upload Front Copy of Your Certificate")
                }else{
                    startLoading()
                    let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
                    dictParameters.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: arrayEducationalDetails, options: JSONSerialization.WritingOptions.prettyPrinted)
                        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                            print(JSONString)
                            dictParameters.setObject(JSONString, forKey: "certification_details" as NSCopying)
                            dictParameters.setObject("6", forKey: "stepid" as NSCopying)
                            self.CallWebserviceReistration(params:dictParameters,arrayImages: arrayCertificateFront,arrayImagesBack: arrayCertificateBack, BLSFront: arrayBLSFront,BLSBack: arrayBLSBack )
                        }
                    }catch
                    {
                        self.stopLoading()
                    }
                }
            }
        }
    }
    
    
    //MARK:- Webservices
    
    func CallWebserviceReistration(params:NSMutableDictionary, arrayImages:NSMutableArray,arrayImagesBack:NSMutableArray,BLSFront:NSMutableArray,BLSBack:NSMutableArray)
    {
        startLoading()
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().completeRegistrationUrl) as NSString
        let strAuth:String = UserDefaults.standard.value(forKey: "Authentication") as! String
        manager.requestSerializer.setValue(strAuth, forHTTPHeaderField: "Authorization")
        manager.post(stringURL as String, parameters: params, constructingBodyWith: {
            (data: AFMultipartFormData!) in
            
            let strimageFront:String = (BLSFront[0] as AnyObject).value(forKey: "image") as! String
            let strimageBack:String = (BLSBack[0] as AnyObject).value(forKey: "image") as! String
            let strDataBLSFront:Data = (BLSFront[0] as AnyObject).value(forKey: "blsfront") as! Data
            let strDataBLSBack:Data = (BLSBack[0] as AnyObject).value(forKey: "blsback") as! Data

            if strimageFront == "1"{
                data.appendPart(withFileData: strDataBLSFront, name: "blsfront", fileName: "photo12).jpg", mimeType: "image/jpeg")
            }else{
                data.appendPart(withFileData: strDataBLSFront, name: "blsfront", fileName: "file.pdf", mimeType: "application/pdf")
            }
            if strimageBack == "1"{
                data.appendPart(withFileData: strDataBLSBack, name: "blsback", fileName: "photo12).jpg", mimeType: "image/jpeg")
            }else{
                data.appendPart(withFileData: strDataBLSBack, name: "blsback", fileName: "file.pdf", mimeType: "application/pdf")
            }
            for i in 0...arrayImages.count-1{
                let strData:Data = (arrayImages[i] as AnyObject).value(forKey: "front") as! Data
                let strimage:String = (arrayImages[i] as AnyObject).value(forKey: "image") as! String
                if strimage == "0"{
                    data.appendPart(withFileData: strData, name: "certification_front_file[]", fileName: "file.pdf", mimeType: "application/pdf")
                }else{
                    data.appendPart(withFileData: strData, name: "certification_front_file[]", fileName: "photo\(i).jpg", mimeType: "image/jpeg")
                }
            }
            if arrayImagesBack.count > 0{
                
                for i in 0...arrayImagesBack.count-1{
                    if let strBack:String = (arrayImagesBack[i] as AnyObject).value(forKey: "Document") as? String{
                        if strBack != ""{
                            let strData:Data = (arrayImagesBack[i] as AnyObject).value(forKey: "back") as! Data
                            let strimage:String = (arrayImagesBack[i] as AnyObject).value(forKey: "image") as! String
                            if strimage == "0"{
                                data.appendPart(withFileData: strData, name: "certification_back_file[]", fileName: "file.pdf", mimeType: "application/pdf")
                            }else{
                                data.appendPart(withFileData: strData, name: "certification_back_file[]", fileName: "photo\(i).jpg", mimeType: "image/jpeg")
                            }
                        }
                    }

                }
            }
        }, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            print(responseDictionary)
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                self.stopLoading()
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == statusSuccess{
                    self.stopLoading()
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"CurrentEmploymentViewController") as! CurrentEmploymentViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }else if strStatus == AccessToken{
                    self.callWebserviseAccessToken(params:params, arrayImages:arrayImages,arrayImagesBack:arrayImagesBack,BLSFront:BLSFront,BLSBack:BLSBack)
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
    
    func callWebserviseAccessToken(params:NSMutableDictionary, arrayImages:NSMutableArray,arrayImagesBack:NSMutableArray,BLSFront:NSMutableArray,BLSBack:NSMutableArray){
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
                    self.CallWebserviceReistration(params:params, arrayImages:arrayImages,arrayImagesBack:arrayImagesBack,BLSFront:BLSFront,BLSBack:BLSBack)
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
