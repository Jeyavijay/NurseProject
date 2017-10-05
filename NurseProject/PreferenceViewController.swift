import UIKit
import TextFieldEffects
import PopupDialog

class PreferenceViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource  {

    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var textFieldDistance: HoshiTextField!
    var arrayPickerview = NSArray()
    var pickerviewList = UIPickerView()
    var nTextFieldTags = Int()
    var strDate = String()

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }


    
    @IBAction func buttonNext(_ sender: Any)
    {
        if textFieldDistance.text == ""
        {
            
        }else{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"SpecialitiesViewController") as! SpecialitiesViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    
    // Pragma Mark - Textfield Delegates -
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.textFieldDistance{
            arrayPickerview = StaticArrayValues().arrayDistance as NSArray
            pickerviewList.dataSource = self
            pickerviewList.delegate = self
            pickerviewList.showsSelectionIndicator = true
            textField.inputView = pickerviewList
            pickerviewList.reloadAllComponents()
        }

        
        return true
    }

    //MARK:- Picker View Delegate and Datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayPickerview.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        print(arrayPickerview)
        var title = String()
        title = (arrayPickerview[row] as AnyObject)as! String
        return title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var strSelected = String()
        strSelected = (arrayPickerview[row] as AnyObject)as! String
        textFieldDistance.text = strSelected
    }
    
    
    
    //MARK:- Alert PopUps
    
    func popupAlertQuiz(msg:String)
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
