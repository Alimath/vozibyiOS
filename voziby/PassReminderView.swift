//
//  PassReminderView.swift
//  voziby
//
//  Created by Fedar Trukhan on 02.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class PassReminderView: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var SMSTextField: UITextField!
    @IBOutlet weak var GetSMSButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(RGBA: "f5f5f5")
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "40a9f4")]
        }
        self.navigationItem.title = "vozim.by"
        
        let backButton = UIBarButtonItem(title: "Отмена", style: UIBarButtonItemStyle.Plain, target: self, action: "Cancel")
        navigationItem.leftBarButtonItem = backButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldTextChanged:", name:UITextFieldTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SMSSuccesfullySend:", name:"smssend", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SMSSendError:", name:"smssenderror", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        super.touchesBegan(touches, withEvent: event)
        phoneNumberTextField.resignFirstResponder()
        SMSTextField.resignFirstResponder()
    }

    func Cancel()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func SMSSendTouch(sender: AnyObject)
    {
        
        if(!RMPhoneFormat().isPhoneNumberValid(self.phoneNumberTextField.text))
        {
            ShowAlertView(self, "Неверный номер", "Пожалуйста, введите корректный номер телефона", "Закрыть")
        }
        else
        {
            Server.sharedInstance.SendSMS(self.phoneNumberTextField.text.StringWithoutPhoneFormat())
        }
    }
    
    func textFieldTextChanged(sender : AnyObject)
    {
        var textField: UITextField = sender.object as UITextField
        var tempText = textField.text
        if(textField.tag == 1001)
        {
            var phoneFormat: RMPhoneFormat = RMPhoneFormat()
            phoneNumberTextField.text = phoneFormat.format(phoneNumberTextField.text)
            
            if(tempText+")" == textField.text)
            {
                let stringLength = textField.text.length()
                
                
                var substringIndex: Int = 1
                if(textField.text.hasSuffix(")"))
                {
                    substringIndex = 2
                }
                if(textField.text.hasSuffix(" )"))
                {
                    substringIndex = 3
                }
                if(textField.text.hasSuffix("  )"))
                {
                    substringIndex = 4
                }
                textField.text = textField.text.removeCharsFromEnd(substringIndex)
                phoneNumberTextField.text = phoneFormat.format(phoneNumberTextField.text)
            }
            
            if(textField.text.utf16Count < 1)
            {
                textField.text = "+"
            }
            
            if(!phoneFormat.isPhoneNumberValid(phoneNumberTextField.text))
            {
                textField.textColor = UIColor.redColor()
            }
            else
            {
                textField.textColor = UIColor.blackColor()
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if(textField.text.utf16Count < 1 && textField.tag == 1001)
        {
            textField.text = "+"
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if(textField.tag == 1001)
        {
            var phoneFormat: RMPhoneFormat = RMPhoneFormat()
            phoneNumberTextField.text = phoneFormat.format(phoneNumberTextField.text)
            if(!phoneFormat.isPhoneNumberValid(phoneNumberTextField.text))
            {
                textField.textColor = UIColor.redColor()
            }
            else
            {
                textField.textColor = UIColor.blackColor()
            }
            
            if(textField.text.utf16Count == 1 && textField.tag == 1001)
            {
                textField.text = ""
            }
        }
    }

    func SMSSuccesfullySend(notification: NSNotification)
    {
        self.SMSTextField.backgroundColor = UIColor.whiteColor()
        self.SMSTextField.placeholder = "SMS код"
        self.SMSTextField.userInteractionEnabled = true
        self.SMSTextField.alpha = 0
        
        NSOperationQueue.mainQueue().addOperationWithBlock
            {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    self.GetSMSButton.alpha = 0
                }, completion: { (complete) -> Void in
                    if(complete)
                    {
                        NSOperationQueue.mainQueue().addOperationWithBlock
                            {
                                UIView.animateWithDuration(0.5, animations: { () -> Void in
                                    self.SMSTextField.alpha = 1
                                    self.SMSTextField.placeholder = "SMS код"
                                }, completion: { (complete) -> Void in
                                    if(complete)
                                    {
                                        self.SMSTextField.becomeFirstResponder()
                                    }
                                })
                        }
                    }
                })
                
        }
//        ShowAlertView(self, "СМС с кодом", "Вам направлено смс с кодом, который необходимо ввести для продолжения регистрации", "Закрыть")
    }
    
    func SMSSendError(notification: NSNotification)
    {
        ShowAlertView(self, "Что-то не так", "Запрос на сервер не дошел, возможно у вас не работает интернет", "Закрыть")
    }
}
