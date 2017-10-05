//
//  AccountDetailStatementViewController.swift
//  NurseProject
//
//  Created by Jeyavijay on 17/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import PopupDialog


class AccountDetailStatementViewController: UIViewController {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

    @IBOutlet var button1No: UIButton!
    @IBOutlet var button1Yes: UIButton!
    @IBOutlet var button2Yes: UIButton!
    @IBOutlet var button2No: UIButton!
    @IBOutlet var button3Yes: UIButton!
    @IBOutlet var button3No: UIButton!
    @IBOutlet var button4Yes: UIButton!
    @IBOutlet var button4No: UIButton!
    @IBOutlet var button5Yes: UIButton!
    @IBOutlet var button5No: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.loadButtonImages()
        
    }
    
    func loadButtonImages(){
        let DSImage:UIImage = UIImage(named: "unchecked")!
        let SImage:UIImage = UIImage(named: "checked")!
        button1No.setImage(DSImage, for: .normal)
        button1No.setImage(SImage, for: .selected)
        button1Yes.setImage(DSImage, for: .normal)
        button1Yes.setImage(SImage, for: .selected)
        button2No.setImage(DSImage, for: .normal)
        button2No.setImage(SImage, for: .selected)
        button2Yes.setImage(DSImage, for: .normal)
        button2Yes.setImage(SImage, for: .selected)
        button3No.setImage(DSImage, for: .normal)
        button3No.setImage(SImage, for: .selected)
        button3Yes.setImage(DSImage, for: .normal)
        button3Yes.setImage(SImage, for: .selected)
        button4No.setImage(DSImage, for: .normal)
        button4No.setImage(SImage, for: .selected)
        button4Yes.setImage(DSImage, for: .normal)
        button4Yes.setImage(SImage, for: .selected)
        button5No.setImage(DSImage, for: .normal)
        button5No.setImage(SImage, for: .selected)
        button5Yes.setImage(DSImage, for: .normal)
        button5Yes.setImage(SImage, for: .selected)


    }

    //MARK:- Button Actions
    
    @IBAction func buttonBack(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonNext(_ sender: Any)
    {
        if (button1Yes.isSelected || button1No.isSelected) == false{
            self.popupAlertQuiz(msg: "Please Select about your license/certification ever been investigated/suspended")
        }else if (button2Yes.isSelected || button2No.isSelected) == false{
            self.popupAlertQuiz(msg: "Please Select about your convicted crime")
            
        }else if (button3Yes.isSelected || button3No.isSelected) == false{
            self.popupAlertQuiz(msg: "Please Select about your pending misdemeanor or felony criminal charges")
            
        }else if (button4Yes.isSelected || button4No.isSelected) == false{
            self.popupAlertQuiz(msg: "Please Select about your defedant in a professional liability action")
            
        }else if (button5Yes.isSelected || button5No.isSelected) == false{
            self.popupAlertQuiz(msg: "Please Select about verification of your legal right to work in the US")
            
        }else{
            let nextViewController = storyBoard.instantiateViewController(withIdentifier:"AccountDetailsEducationViewController") as! AccountDetailsEducationViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)

        }
        
    }
    
    @IBAction func button1(_ sender: Any)
    {
        if (sender as AnyObject).tag == 1{
            if button1Yes.isSelected == true{
                button1Yes.isSelected = false
            }else{
                button1Yes.isSelected = true
                button1No.isSelected = false
            }
        }else if (sender as AnyObject).tag == 2{
            if button1No.isSelected == true{
                button1No.isSelected = false
            }else{
                button1No.isSelected = true
                button1Yes.isSelected = false
            }
        }
    }
    @IBAction func button2(_ sender: Any)
    {
        if (sender as AnyObject).tag == 3{
            if button2Yes.isSelected == true{
                button2Yes.isSelected = false
            }else{
                button2Yes.isSelected = true
                button2No.isSelected = false
            }
        }else if (sender as AnyObject).tag == 4{
            if button2No.isSelected == true{
                button2No.isSelected = false
            }else{
                button2No.isSelected = true
                button2Yes.isSelected = false
            }
        }
    }
    @IBAction func button3(_ sender: Any)
    {
        if (sender as AnyObject).tag == 5{
            if button3Yes.isSelected == true{
                button3Yes.isSelected = false
            }else{
                button3Yes.isSelected = true
                button3No.isSelected = false
            }
        }else if (sender as AnyObject).tag == 6{
            if button3No.isSelected == true{
                button3No.isSelected = false
            }else{
                button3No.isSelected = true
                button3Yes.isSelected = false
            }
        }
    }
    @IBAction func button4(_ sender: Any)
    {
        if (sender as AnyObject).tag == 7{
            if button4Yes.isSelected == true{
                button4Yes.isSelected = false
            }else{
                button4Yes.isSelected = true
                button4No.isSelected = false
            }
        }else if (sender as AnyObject).tag == 8{
            if button4No.isSelected == true{
                button4No.isSelected = false
            }else{
                button4No.isSelected = true
                button4Yes.isSelected = false
            }
        }
    }
    @IBAction func button5(_ sender: Any)
    {
        if (sender as AnyObject).tag == 9{
            if button5Yes.isSelected == true{
                button5Yes.isSelected = false
            }else{
                button5Yes.isSelected = true
                button5No.isSelected = false
            }
        }else if (sender as AnyObject).tag == 10{
            if button5No.isSelected == true{
                button5No.isSelected = false
            }else{
                button5No.isSelected = true
                button5Yes.isSelected = false
            }
        }
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
