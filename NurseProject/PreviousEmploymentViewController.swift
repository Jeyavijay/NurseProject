import UIKit
import PopupDialog

class PreviousEmploymentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var tableViewEmployment: UITableView!
    var nsectionCount = Int()
    var nsectionValue = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        nsectionCount = 1
        updateUI()

    }
    
    func updateUI()
    {
        self.tableViewEmployment.register(UINib(nibName: "PreviousEmploymentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PECell")
        self.tableViewEmployment.register(UINib(nibName: "PreviousEmployment2TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PECell2")
        tableViewEmployment.reloadData()
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if nsectionCount == (indexPath as NSIndexPath).section{
            return 100
        }else{
            return 350
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.clear
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if nsectionCount == (indexPath as NSIndexPath).section{
            let lastCell = tableView.dequeueReusableCell(withIdentifier: "PECell2") as! PreviousEmployment2TableViewCell!
            lastCell!.buttonNext.addTarget(self, action: #selector(self.buttonNext), for: .touchUpInside)
            lastCell!.buttonAddMore.addTarget(self, action: #selector(self.buttonAddMore), for: .touchUpInside)
            return lastCell!
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "PECell") as! PreviousEmploymentTableViewCell!
            Cell!.textFieldName.tag = indexPath.section
            Cell!.textFieldTitle.tag = indexPath.section
            Cell!.textFieldDepartment.tag = indexPath.section
            Cell!.textFieldHospitalName.tag = indexPath.section
            Cell!.textFieldStartDate.tag = indexPath.section
            Cell!.textFieldEndDate.tag = indexPath.section
            return Cell!
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableViewEmployment.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let arrayEmpDetails = NSMutableArray()
            if ((UserDefaults.standard.value(forKey: "arrayEmp") != nil)){
                if arrayEmpDetails.count > 1{
                    let array:NSArray = UserDefaults.standard.array(forKey: "arrayEmp")! as NSArray
                    arrayEmpDetails.addObjects(from: array as! [Any])
                    arrayEmpDetails.removeObject(at: indexPath.section)
                    print(arrayEmpDetails)
                    UserDefaults.standard.set(arrayEmpDetails, forKey: "arrayEmp")
                    nsectionCount = nsectionCount - 1
                    self.tableViewEmployment.reloadData()
                }else{
                    nsectionCount = nsectionCount - 1
                    self.tableViewEmployment.reloadData()
                }
            }
        }
    }
    
    
    func buttonAddMore()
    {
        let arrayEmpDetails = NSMutableArray()
        if ((UserDefaults.standard.value(forKey: "arrayEmp") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayEmp")! as NSArray
            arrayEmpDetails.addObjects(from: array as! [Any])
            print(arrayEmpDetails)
        }
        if arrayEmpDetails.count == nsectionCount{
            let strSName:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "SName") as! String
            let strSTitle:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "STitle") as! String
            let strHName:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "HName") as! String
            let strHDepartment:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "HDepartment") as! String
            let strSDate:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "SDate") as! String
            let strEDate:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "EDate") as! String
            if strSName == ""{
                popupAlertQuiz(msg: "Please Enter Your Supervisor Name", buttonColor: UIColor.red)
            }else if strSTitle == ""{
                popupAlertQuiz(msg: "Please Enter Your Supervisor Title", buttonColor: UIColor.red)
            }else if strHName == ""{
                popupAlertQuiz(msg: "Please Enter Your Hospital Name", buttonColor: UIColor.red)
            }else if strHDepartment == ""{
                popupAlertQuiz(msg: "Please Enter Your Department Name", buttonColor: UIColor.red)
            }else if strSDate == ""{
                popupAlertQuiz(msg: "Choose Your Date of Join in this hospital", buttonColor: UIColor.red)
            }else if strEDate == ""{
                popupAlertQuiz(msg: "Choose Your Relieving date in this hospital", buttonColor: UIColor.red)
            }else{
                nsectionCount = nsectionCount + 1
                tableViewEmployment.reloadData()
            }
        }else{
            popupAlertQuiz(msg: "Please fill the details Completely to add more", buttonColor: UIColor.red)
        }
        
    }
    
    
    func buttonNext()
    {
        let arrayEmpDetails = NSMutableArray()
        if ((UserDefaults.standard.value(forKey: "arrayEmp") != nil)){
            let array:NSArray = UserDefaults.standard.array(forKey: "arrayEmp")! as NSArray
            arrayEmpDetails.addObjects(from: array as! [Any])
            print(arrayEmpDetails)
        }
        if arrayEmpDetails.count > 0{
            let strSName:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "SName") as! String
            let strSTitle:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "STitle") as! String
            let strHName:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "HName") as! String
            let strHDepartment:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "HDepartment") as! String
            let strSDate:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "SDate") as! String
            let strEDate:String = (arrayEmpDetails[nsectionCount-1] as AnyObject).value(forKey: "EDate") as! String
            if strSName == ""{
                popupAlertQuiz(msg: "Please Enter Your Supervisor Name", buttonColor: UIColor.red)
            }else if strSTitle == ""{
                popupAlertQuiz(msg: "Please Enter Your Supervisor Title", buttonColor: UIColor.red)
            }else if strHName == ""{
                popupAlertQuiz(msg: "Please Enter Your Hospital Name", buttonColor: UIColor.red)
            }else if strHDepartment == ""{
                popupAlertQuiz(msg: "Please Enter Your Department Name", buttonColor: UIColor.red)
            }else if strSDate == ""{
                popupAlertQuiz(msg: "Choose Your Date of Join in this hospital", buttonColor: UIColor.red)
            }else if strEDate == ""{
                popupAlertQuiz(msg: "Choose Your Relieving date in this hospital", buttonColor: UIColor.red)
            }else{
                let nextViewController = storyBoard.instantiateViewController(withIdentifier:"ReferenceViewController") as! ReferenceViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
        
    }

    //MARK- Popup Alert
    
    func popupAlertQuiz(msg:String, buttonColor:UIColor)
    {
        let title = "Information"
        let message = msg
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonTwo = DefaultButton(title: "OK")
        {
        }
        buttonTwo.buttonColor = UIColor.red
        buttonTwo.titleColor = UIColor.white
        popup.addButtons([buttonTwo])
        self.present(popup, animated: true, completion: nil)
    }
    
    
    
}
