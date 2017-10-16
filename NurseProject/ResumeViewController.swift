import UIKit
import TextFieldEffects
import PopupDialog
import MobileCoreServices
import NADocumentPicker
import AFNetworking
import NVActivityIndicatorView

class ResumeViewController: UIViewController, UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var labelDocName: UILabel!
    @IBOutlet var viewUpload: UIView!
    var activity:NVActivityIndicatorView!
    var fileData = Data()
    var fileName = String()
    let dictParameters = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingIndicator()
        viewUpload.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonNext(_ sender: Any)
    {
        if labelDocName.text == ""{
            self.popupAlert(Title: "Information",msg: "Please Upload Your Resume")
        }else{
            let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
            dictParameters.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
            dictParameters.setObject("10", forKey: "stepid" as NSCopying)

            CallWebserviceReistration(params: dictParameters, fileData: self.fileData)
        }
    }

    @IBAction func buttonUpload(_ sender: Any)
    {
        self.DocLibrary()
    }

    func DocLibrary(){
        var types: [Any]? = [(kUTTypePDF as? String),(kUTTypeXML as? String),(kUTTypeData as? String)]
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: types as! [String], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    //MARK:- DocumentMenu Delegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController,didPickDocumentAt url: URL) {
        print(url)
        labelDocName.text = String(format: "%@", url.lastPathComponent)
        fileName = url.lastPathComponent
        let dataFile = try! Data(contentsOf: url)
        fileData = dataFile
        viewUpload.isHidden = false
    }
    

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }

    //MARK:- Webservices

    func CallWebserviceReistration(params:NSMutableDictionary, fileData:Data)
    {
        startLoading()
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().completeRegistrationUrl) as NSString
        let strAuth:String = UserDefaults.standard.value(forKey: "Authentication") as! String
        manager.requestSerializer.setValue(strAuth, forHTTPHeaderField: "Authorization")
        manager.post(stringURL as String, parameters: params, constructingBodyWith: {
            (data: AFMultipartFormData!) in
          
            if self.fileName.lowercased().range(of:".pdf") != nil {
                data.appendPart(withFileData: self.fileData, name: "upload_resume", fileName: self.fileName, mimeType: "application/pdf")
            }else if self.fileName.lowercased().range(of:".doc") != nil {
                data.appendPart(withFileData: self.fileData, name: "upload_resume", fileName: self.fileName, mimeType: "application/msword")
            }else if self.fileName.lowercased().range(of:".docx") != nil {
                data.appendPart(withFileData: self.fileData, name: "upload_resume", fileName: self.fileName, mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
            }


            

        }, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            print(responseDictionary)
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == statusSuccess{
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"RNDetailsViewController") as! RNDetailsViewController
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }else if strStatus == AccessToken{
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
                        self.CallWebserviceReistration(params: self.dictParameters, fileData: self.fileData)
                    }
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


}
