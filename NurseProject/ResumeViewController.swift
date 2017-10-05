import UIKit
import TextFieldEffects
import PopupDialog
import MobileCoreServices

class ResumeViewController: UIViewController, UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate {

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    @IBOutlet var labelDocName: UILabel!
    @IBOutlet var viewUpload: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"PreferenceViewController") as! PreferenceViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)

        }
    }

    @IBAction func buttonUpload(_ sender: Any)
    {
        self.DocLibrary()
    }

    func DocLibrary(){
        var types: [Any]? = [(kUTTypeData as? String),(kUTTypeBMP as? String),(kUTTypeXML as? String),(kUTTypeItem as? String),(kUTTypeRTF as? String),(kUTTypeText as? String),(kUTTypeRTFD as? String),(kUTTypeInkText as? String),(kUTTypeContent as? String),(kUTTypeDelimitedText as? String),(kUTTypePlainText as? String), (kUTTypePresentation as? String),(kUTTypeFolder as? String),(kUTTypePDF as? String)]
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: types as! [String], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(documentPicker, animated: true, completion: nil)
        
    }
    
    //MARK:- DocumentMenu Delegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController,didPickDocumentAt url: URL) {
        print(url)
       // self.doc(asd: url)
        labelDocName.text = String(format: "%@", url.lastPathComponent)
        viewUpload.isHidden = false

        if controller.documentPickerMode == UIDocumentPickerMode.import {
            
        }
    }
    
    func doc(asd:URL)
    {
        var documentInteractionController = UIDocumentInteractionController()
        documentInteractionController = UIDocumentInteractionController(url: asd)
        // Configure Document Interaction Controller
        documentInteractionController.delegate = self
        // Preview PDF
        documentInteractionController.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
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
