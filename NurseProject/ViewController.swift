import UIKit
import TextFieldEffects
import PopupDialog


class ViewController: UIViewController {


    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var textFieldPassword: HoshiTextField!
    @IBOutlet var textFieldEmail: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = GradientColor(UIGradientStyle.radial, frame: view.frame, colors: [AppColors().appBlueColor,AppColors().appSkyBlueColor])
        self.textFieldUI()
    }
    
    func textFieldUI(){
        
        textFieldEmail.borderActiveColor = AppColors().appBlueColor
        textFieldEmail.placeholderColor = UIColor.darkGray
        textFieldEmail.borderInactiveColor = UIColor.gray
        textFieldPassword.borderActiveColor = AppColors().appBlueColor
        textFieldPassword.borderInactiveColor = UIColor.gray
        textFieldPassword.placeholderColor = UIColor.darkGray
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
            self.popupAlertQuiz(msg: "Please Enter Vaild E-Mail ID")
        }else if (textFieldPassword.text?.characters.count)! <= 5
        {
          self.popupAlertQuiz(msg: "Password Must Contain atleast 6 Characters")
        }else{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"AccountDetailStatementViewController") as! AccountDetailStatementViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)

        }
        
    }
    
    @IBAction func buttonSignUp(_ sender: Any)
    {
        let nextViewController = storyBoard.instantiateViewController(withIdentifier:"FirstSignUpViewController") as! FirstSignUpViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
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

