import UIKit
import MobileCoreServices
import PopupDialog

class EducationCertificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChangeDocumentProtocol  {

    
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var tableViewCertificate: UITableView!
    var nsectionCount = Int()
    var nsectionValue = Int()
    var strDocument = NSString()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        nsectionCount = 1
        updateUI()
    }
    
    func updateUI()
    {
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
        if nsectionCount == (indexPath as NSIndexPath).section{
            return self.view.frame.height/5.59
        }else{
            return self.view.frame.height/2

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
        if nsectionCount == (indexPath as NSIndexPath).section{
            let lastCell = tableView.dequeueReusableCell(withIdentifier: "lastCell") as! Education2TableViewCell!
            lastCell!.buttonNext.addTarget(self, action: #selector(self.buttonNext), for: .touchUpInside)
    //        lastCell!.buttonUpload.addTarget(self, action: #selector(self.buttonUpload), for: .touchUpInside)
            lastCell!.buttonAddMore.addTarget(self, action: #selector(self.buttonAddMore), for: .touchUpInside)
       
            return lastCell!
            
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "Certificate") as! CertificationTableViewCell!
            Cell!.textFieldName.tag = indexPath.section
            Cell!.textFieldDate.tag = indexPath.section
            Cell!.buttonUpload.tag = indexPath.section
            Cell!.delegate = self

            return Cell!
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
        if ((UserDefaults.standard.value(forKey: "arrayCertificate") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificate")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
            print(arrayEducationalDetails)
        }
        if arrayEducationalDetails.count == nsectionCount{
            let strName:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Name") as! String
            let strDate:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Date") as! String
            let strDocument:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Document") as! String
            if strName == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringCertificate)
            }else if strDate == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringCertificateExpiryDate)
            }else if strDocument == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringUploadFrontCertificate)
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
        if ((UserDefaults.standard.value(forKey: "arrayCertificate") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayCertificate")! as NSArray
            arrayEducationalDetails.addObjects(from: array as! [Any])
            print(arrayEducationalDetails)
        }
        if arrayEducationalDetails.count == nsectionCount{
            let strName:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Name") as! String
            let strDate:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Date") as! String
            let strDocument:String = (arrayEducationalDetails[nsectionCount-1] as AnyObject).value(forKey: "Document") as! String
            if strName == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringCertificate)
            }else if strDate == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringCertificateExpiryDate)
            }else if strDocument == ""{
                self.popupAlert(Title: "Information",msg: stringMessages().stringUploadFrontCertificate)
            }else{
                let nextViewController = storyBoard.instantiateViewController(withIdentifier:"CurrentEmploymentViewController") as! CurrentEmploymentViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
        
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



}
