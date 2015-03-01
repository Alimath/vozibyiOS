//
//  RegistraionView.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class RegistraionView: BaseView, UITextFieldDelegate
{
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var SMSTextField: UITextField!
    @IBOutlet weak var GetSMSButton: UIButton!
    @IBOutlet var registrationView: UIView!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(RGBA: "f5f5f5")
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "40a9f4")]
        }
        self.navigationItem.title = "vozim.by"
        
        let backButton = UIBarButtonItem(title: "Отмена", style: UIBarButtonItemStyle.Plain, target: self, action: "Cancel")
        navigationItem.leftBarButtonItem = backButton
        
        let nextButton = UIBarButtonItem(title: "Далее", style: UIBarButtonItemStyle.Plain, target: self, action: "GoNext")
        navigationItem.rightBarButtonItem = nextButton
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "textFieldTextChanged:",
            name:UITextFieldTextDidChangeNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SMSSuccesfullySend:", name:"smssend", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SMSSendError:", name:"smssenderror", object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        super.touchesBegan(touches, withEvent: event)
        SMSTextField.resignFirstResponder()
        CityTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
    }
    
    func GoNext()
    {
        if(self.CityTextField.text == "")
        {
            ShowAlertView(self, "Ошибка", "Поле ввода города - обязательно для заполнения", "Закрыть")
        }
        else if(!RMPhoneFormat().isPhoneNumberValid(self.phoneNumberTextField.text))
        {
            ShowAlertView(self, "Неверный номер", "Пожалуйста, введите корректный номер телефона", "Закрыть")
        }
        else if(self.SMSTextField.text == "")
        {
            ShowAlertView(self, "Ошибка", "Введите код, полученный по смс", "Закрыть")
        }
        else if(self.PasswordTextField.text == "")
        {
            ShowAlertView(self, "Ошибка", "Поле ввода пароля - обязательно для заполнения", "Закрыть")
        }
        else
        {
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(self.CityTextField.text, forKey: kVZLocationKey)
            userDefaults.setValue(self.phoneNumberTextField.text.StringWithoutPhoneFormat(), forKey: kVZPhoneNumberKey)
            userDefaults.setValue(self.SMSTextField.text, forKey: kVZSMSCodeKey)
            userDefaults.setValue(self.PasswordTextField.text.md5(), forKey: kVZPasswordKey)
            userDefaults.synchronize()
        
        let RegistraionViewEnd: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RegistraionViewEnd") as UIViewController
            self.navigationController?.pushViewController(RegistraionViewEnd, animated: true)
        }
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
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            UIView.animateWithDuration(1)
            { () -> Void in
                self.GetSMSButton.alpha = 0
                self.SMSTextField.backgroundColor = UIColor.whiteColor()
                self.SMSTextField.placeholder = "SMS код"
                self.SMSTextField.userInteractionEnabled = true
            }
        }
        ShowAlertView(self, "СМС с кодом", "Вам направлено смс с кодом, который необходимо ввести для продолжения регистрации", "Закрыть")
    }
    
    func SMSSendError(notification: NSNotification)
    {
        ShowAlertView(self, "Что-то не так", "Запрос на сервер не дошел, возможно у вас не работает интернет", "Закрыть")
    }
}