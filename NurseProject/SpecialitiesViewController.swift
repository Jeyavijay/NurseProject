import UIKit
import PopupDialog
import NVActivityIndicatorView
import AFNetworking

class SpecialitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableViewSpecialities:UITableView!

    var arrayCompetencies = NSMutableArray()
    var arraySubCompetencies = NSMutableArray()
    var arraySectionTag = NSMutableArray()
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var bIsAccessTokenForGetSpecialities:Bool = true
    
    var bIsSpecialitySelected:Bool = false
    
    override func viewDidLoad() {
        
        setLoadingIndicator()
        tableViewSpecialities.register(UINib(nibName: "SpecialitiesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SpecialitiesTableViewCell")
        tableViewSpecialities.register(UINib(nibName: "PreviousEmployment2TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PECell2")
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GetCompetencyDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Tableview Delegate Methods -
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrayCompetencies.count + 1
    }
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section != arrayCompetencies.count{
            var nReturnCount:Int = 0
            if let arraySubCompotency:NSArray = (arrayCompetencies[section] as AnyObject).value(forKey: "sub_competency") as? NSArray{
                nReturnCount = arraySubCompotency.count
            }
            return nReturnCount
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != arrayCompetencies.count{
            return 50
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != arrayCompetencies.count{
            return 43.5
        }else{
            return self.view.frame.height / 5.6
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if arrayCompetencies.count != section{
            let viewHeader = UIView()
            viewHeader.backgroundColor = UIColor.white
            let labelHeading = UILabel()
            labelHeading.frame = CGRect(x: 10, y: 0, width: 250, height: 50)
            labelHeading.text = ""
            if let sCompotency:String = (arrayCompetencies[section] as AnyObject).value(forKey: "competency") as? String{
                labelHeading.text = sCompotency
            }
            let buttonTick = UIButton()
            buttonTick.frame = CGRect(x: self.view.frame.width - 35, y: 13, width: 24, height: 24)
            if arraySectionTag[section] as? String == "0"{
                buttonTick.setBackgroundImage(UIImage(named: "checkboxwithoutTick"), for: .normal)
            }else{
                buttonTick.setBackgroundImage(UIImage(named: "checkboxtick"), for: .normal)
            }
            buttonTick.addTarget(self, action: #selector(self.clickHeaderCheckBox), for: .touchUpInside)
            buttonTick.tag = section
            viewHeader.addSubview(labelHeading)
            viewHeader.addSubview(buttonTick)
            return viewHeader
        }else{
            let viewHeader = UIView()
            viewHeader.backgroundColor = UIColor.clear
            return viewHeader
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.white
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if arrayCompetencies.count != indexPath.section{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialitiesTableViewCell") as! SpecialitiesTableViewCell!
            
            if let arraySubCompotency:NSArray = (arraySubCompetencies[indexPath.section]  as? NSArray){
                if let sSubCompotency:String = (arraySubCompotency[indexPath.row] as AnyObject).value(forKey: "sub_competency_name") as? String{
                    cell?.labelTitle.text = sSubCompotency
                }
                if let nSelected:Int = (arraySubCompotency[indexPath.row] as AnyObject).value(forKey: "selected") as? Int{
                    if nSelected == 0{
                        cell?.buttonCheckBox.setBackgroundImage(UIImage(named: "checkboxwithoutTick"), for: .normal)
                    }else{
                        cell?.buttonCheckBox.setBackgroundImage(UIImage(named: "checkboxtick"), for: .normal)
                    }
                }
            }
            
            cell!.buttonCheckBox.addTarget(self, action: #selector(self.clickRowCheckBox), for: .touchUpInside)
            cell?.buttonCheckBox.row = indexPath.row
            cell?.buttonCheckBox.section = indexPath.section
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PECell2") as! PreviousEmployment2TableViewCell!
            cell?.buttonNext.addTarget(self, action: #selector(self.clickNext), for: .touchUpInside)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    @IBAction func clickNext(sender:UIButton){
        for i in 0 ... arrayCompetencies.count - 1{
            if let arraySubCompo:NSArray = arraySubCompetencies[i] as? NSArray{
                for i in 0 ... arraySubCompo.count - 1{
                    let dictOld:NSDictionary = (arraySubCompo[i] as? NSDictionary)!
                    if let nSelected:Int = dictOld.value(forKey: "selected") as? Int{
                        if nSelected == 1{
                            bIsSpecialitySelected = true
                            self.CallWebserviceRegistration()
                            break
                        }
                    }
                }
            }
        }
        if (!bIsSpecialitySelected){
            popupAlert(Title: "Information", msg: "Please choose atleast one of your specialities", bIsSuccess: false)
        }
    }
    
    @IBAction func clickRowCheckBox(sender:ButtonIndexPath){
        if let arraySubCompo:NSArray = arraySubCompetencies[sender.section!] as? NSArray{
            let arrayNew = NSMutableArray()
            for i in 0 ... arraySubCompo.count - 1{
                let dictOld:NSDictionary = (arraySubCompo[i] as? NSDictionary)!
                let dictNew = NSMutableDictionary(dictionary: dictOld)
                if i == sender.row{
                    if let nSelected:Int = dictNew.value(forKey: "selected") as? Int{
                        if nSelected == 0{
                            dictNew.removeObject(forKey: "selected")
                            dictNew.setValue(1, forKey: "selected")
                        }else{
                            dictNew.removeObject(forKey: "selected")
                            dictNew.setValue(0, forKey: "selected")
                        }
                    }
                }
                arrayNew.add(dictNew)
            }
            arraySubCompetencies.replaceObject(at: sender.section!, with: arrayNew)
            if let arraySubCompoNew:NSArray = arraySubCompetencies[sender.section!] as? NSArray{
                var bIsSelected:Bool = true
                for i in 0 ... arraySubCompoNew.count - 1{
                    let dictOld:NSDictionary = (arraySubCompoNew[i] as? NSDictionary)!
                    if let nSelected:Int = dictOld.value(forKey: "selected") as? Int{
                        if nSelected == 0{
                            bIsSelected = false
                        }
                    }
                    if bIsSelected{
                        arraySectionTag.replaceObject(at: sender.section!, with: "1")
                    }else{
                        arraySectionTag.replaceObject(at: sender.section!, with: "0")
                    }
                }
            }
            tableViewSpecialities.reloadData()
        }
    }
    @IBAction func clickHeaderCheckBox(sender:UIButton){
        if let arraySubCompo:NSArray = arraySubCompetencies[sender.tag] as? NSArray{
            let arrayNew = NSMutableArray()
            var bIsSelected:Bool = false
            if arraySectionTag[sender.tag] as? String == "0"{
                bIsSelected = true
                arraySectionTag.replaceObject(at: sender.tag, with: "1")
            }else{
                arraySectionTag.replaceObject(at: sender.tag, with: "0")
            }
            for i in 0 ... arraySubCompo.count - 1{
                let dictOld:NSDictionary = (arraySubCompo[i] as? NSDictionary)!
                let dictNew = NSMutableDictionary(dictionary: dictOld)
                if bIsSelected{
                    dictNew.removeObject(forKey: "selected")
                    dictNew.setValue(1, forKey: "selected")
                }else{
                    dictNew.removeObject(forKey: "selected")
                    dictNew.setValue(0, forKey: "selected")
                }
                arrayNew.add(dictNew)
            }
            arraySubCompetencies.replaceObject(at: sender.tag, with: arrayNew)
            tableViewSpecialities.reloadData()
        }
    }
    
    func setDetails(dictValue:NSDictionary){
        if let arrayCompotency:NSArray = dictValue.value(forKey: "competency") as? NSArray{
            arrayCompetencies.removeAllObjects()
            arrayCompetencies.addObjects(from: arrayCompotency as! [Any])
            arraySubCompetencies.removeAllObjects()
            arraySectionTag.removeAllObjects()
            for i in 0 ... arrayCompetencies.count - 1{
                if let arraySubCompotency:NSArray = (arrayCompetencies[i] as AnyObject).value(forKey: "sub_competency") as? NSArray{
                    arraySubCompetencies.add(arraySubCompotency)
                    
                    var bIsSelected:Bool = true
                    for i in 0 ... arraySubCompotency.count - 1{
                        let dictOld:NSDictionary = (arraySubCompotency[i] as? NSDictionary)!
                        if let nSelected:Int = dictOld.value(forKey: "selected") as? Int{
                            if nSelected == 0{
                                bIsSelected = false
                            }
                        }
                    }
                    if bIsSelected{
                        arraySectionTag.add("1")
                    }else{
                        arraySectionTag.add("0")
                    }
                    
                }
            }
            tableViewSpecialities.reloadData()
        }
    }

    //MARK:- Web service -
    func GetCompetencyDetails()
    {
        startLoading()
        bIsAccessTokenForGetSpecialities = true
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().getCompetencyDetailsUrl) as NSString
        let strAuth:String = UserDefaults.standard.value(forKey: "Authentication") as! String
         let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
        let parameter = NSMutableDictionary()
        parameter.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
        manager.requestSerializer.setValue(strAuth, forHTTPHeaderField: "Authorization")
        manager.post(stringURL as String, parameters: parameter, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == statusSuccess{
                    self.stopLoading()
                    self.setDetails(dictValue: responseDictionary)
                }else if strStatus == AccessToken{
                    self.callWebserviseAccessToken()
                }else{
                    self.stopLoading()
                    if let Msg:String = (responseDictionary).value(forKey: "msg") as? String{
                        self.popupAlert(Title: "Information", msg: Msg, bIsSuccess: false)
                    }
                }
            }
        }, failure: {(operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription, bIsSuccess: false)
        })
    }
    
    func CallWebserviceRegistration()
    {
        startLoading()
        bIsAccessTokenForGetSpecialities = false
        let manager = AFHTTPSessionManager()
        let parameter = NSMutableDictionary()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().completeRegistrationUrl) as NSString
        let strAuth:String = UserDefaults.standard.value(forKey: "Authentication") as! String
        manager.requestSerializer.setValue(strAuth, forHTTPHeaderField: "Authorization")
        
        let strNurseID:String = UserDefaults.standard.value(forKey: "nurse_ID") as! String
        parameter.setObject(strNurseID, forKey: "nurse_id" as NSCopying)
        parameter.setObject("11", forKey: "stepid" as NSCopying)
        do {
            let arrayPassValues = NSMutableArray()
            for i in 0 ... arrayCompetencies.count - 1{
                let dict = NSMutableDictionary()
                if let sComp:String = (arrayCompetencies[i] as AnyObject).value(forKey: "competency") as? String{
                    dict.setValue(sComp, forKey: "competency")
                }
                if let nId:Int = (arrayCompetencies[i] as AnyObject).value(forKey: "id") as? Int{
                    dict.setValue(nId, forKey: "id")
                }
                dict.setValue(arraySubCompetencies[i], forKey: "sub_competency")
                arrayPassValues.add(dict)
            }
            let jsonData = try JSONSerialization.data(withJSONObject: arrayPassValues, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                parameter.setObject(JSONString, forKey: "competency_details" as NSCopying)
            }
        }catch
        {
        }
        manager.post(stringURL as String, parameters: parameter, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == statusSuccess{
                    if let Msg:String = (responseDictionary).value(forKey: "msg") as? String{
                        self.popupAlert(Title: "Information", msg: Msg, bIsSuccess: true)
                    }
                    self.stopLoading()
                }else if strStatus == AccessToken{
                    
                    self.callWebserviseAccessToken()
                }else{
                    self.stopLoading()
                    if let Msg:String = (responseDictionary).value(forKey: "msg") as? String{
                        self.popupAlert(Title: "Information", msg: Msg, bIsSuccess: true)
                    }
                }
            }
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription, bIsSuccess: false)
        })
    }
    
    func callWebserviseAccessToken(){
        let parameter = NSMutableDictionary()
        let strNurseID:String = UserDefaults.standard.value(forKey: "EMAIL_ID") as! String
        let strPassword:String = UserDefaults.standard.value(forKey: "password") as! String
        parameter.setObject(strNurseID, forKey: "username" as NSCopying)
        parameter.setObject(strPassword, forKey: "password" as NSCopying)
        let manager = AFHTTPSessionManager()
        let stringURL:NSString = String(format: "%@%@", ApiString().baseUrl,ApiString().getAccessTokenUrl) as NSString
        
        manager.post(stringURL as String, parameters: parameter, progress: nil, success: { (operation, responseObject) -> Void in
            let responseDictionary:NSDictionary = responseObject as! NSDictionary
            if let Status:Any = (responseDictionary).value(forKey: "status")
            {
                let strStatus:NSString = ConvertToString().anyToStr(convert: Status)
                if strStatus == "1"
                {
                    if let AccessToken:String = (responseDictionary).value(forKey: "access_token") as? String{
                        let strToken:String = String(format: "Bearer %@",AccessToken)
                        UserDefaults.standard.set(strToken, forKey:"Authentication" )
                    }
                    self.stopLoading()
                    if self.bIsAccessTokenForGetSpecialities{
                        self.GetCompetencyDetails()
                    }else{
                        self.CallWebserviceRegistration()
                    }
                }else{
                   self.stopLoading()
                }
            }
        }, failure: { (operation, error) -> Void in
            self.stopLoading()
            self.popupAlert(Title: "Information", msg: error.localizedDescription, bIsSuccess: false)
        })
    }
    //MARK:- Alert PopUps
    func popupAlert(Title:String,msg:String,bIsSuccess:Bool)
    {
        let title = Title
        let message = msg
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonOk = DefaultButton(title: "OK")
        {
            if bIsSuccess == true{
                let nextViewController = self.storyBoard.instantiateViewController(withIdentifier:"ViewController") as! ViewController
                self.navigationController?.pushViewController(nextViewController, animated: false)
            }
        }
        buttonOk.buttonColor = UIColor.red
        buttonOk.titleColor = UIColor.white
        popup.addButtons([buttonOk])
        self.present(popup, animated: true, completion: nil)
    }
    
    //MARK:- Activity Indicator View
    var activity:NVActivityIndicatorView!
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
