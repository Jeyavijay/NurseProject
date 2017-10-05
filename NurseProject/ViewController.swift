import UIKit
import TextFieldEffects
import PopupDialog


class ViewController: UIViewController {


    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var textFieldPassword: HoshiTextField!
    @IBOutlet var textFieldEmail: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

