//
//  RegistraionView.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class RegistraionView: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var SMSTextField: UITextField!
    @IBOutlet weak var GetSMSButton: UIButton!
    @IBOutlet var registrationView: UIView!
    @IBOutlet weak var NameTextField: TextFieldWithMargin!
    
    
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
        
        let nextButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.Plain, target: self, action: "Done")
        navigationItem.rightBarButtonItem = nextButton
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldTextChanged:", name:UITextFieldTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SMSSuccesfullySend:", name:"smssend", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SMSSendError:", name:"smssenderror", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "AddressSelected:", name:"addressselected", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "RegisterSuccesfully:", name:"registersuccesfully", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "RegisterError:", name:"registererror", object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
//        SMSTextField.resignFirstResponder()
//        CityTextField.resignFirstResponder()
//        phoneNumberTextField.resignFirstResponder()
//        NameTextField.resignFirstResponder()
    }
    
    func Done()
    {
        if(self.NameTextField.text == "")
        {
            ShowAlertView(self, "Ошибка", "Введите ваше имя", "Закрыть")
        }
        else if(self.CityTextField.text == "")
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
        else
        {
            let name: String = self.NameTextField.text
            let phone: String = self.phoneNumberTextField.text.StringWithoutPhoneFormat()
            let pass: String = self.SMSTextField.text.md5()
            let location: String = self.CityTextField.text
            let smscode: String = self.SMSTextField.text
            
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(location, forKey: kVZLocationKey)
            userDefaults.setValue(phone, forKey: kVZPhoneNumberKey)
            userDefaults.setValue(smscode, forKey: kVZSMSCodeKey)
            userDefaults.setValue(pass, forKey: kVZPasswordKey)
            userDefaults.setValue(name, forKey: kVZNameKey)
            userDefaults.setBool(false, forKey: kVZIsLoginCompleteKey)
            userDefaults.synchronize()
            
            Server.sharedInstance.Register(name, location: location, username: phone, password: pass, smsCode: smscode)
        }
    }
    
    func Cancel()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func SMSSendTouch(sender: AnyObject)
    {
//        let RegistraionViewEnd: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VZMap") as UIViewController
//        self.navigationController?.pushViewController(RegistraionViewEnd, animated: true)
        
        
        if(!RMPhoneFormat().isPhoneNumberValid(self.phoneNumberTextField.text))
        {
            ShowAlertView(self, "Неверный номер", "Пожалуйста, введите корректный номер телефона", "Закрыть")
        }
        else
        {
            self.view.endEditing(true)
//            SMSTextField.resignFirstResponder()
//            CityTextField.resignFirstResponder()
//            phoneNumberTextField.resignFirstResponder()
//            NameTextField.resignFirstResponder()
            Server.sharedInstance.SendSMS(self.phoneNumberTextField.text.StringWithoutPhoneFormat())
        }
    }
    
    
    func textFieldTextChanged(sender : AnyObject)
    {
        var textField: UITextField = sender.object as! UITextField
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
            
            if(textField.text.length() < 1)
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
        if(textField.text.length() < 1 && textField.tag == 1001)
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
            
            if(textField.text.length() == 1 && textField.tag == 1001)
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
                self.SMSTextField.becomeFirstResponder()
            }
        }
//        ShowAlertView(self, "СМС с кодом", "Вам направлено смс с кодом, который необходимо ввести для продолжения регистрации", "Закрыть")
    }
    
    func SMSSendError(notification: NSNotification)
    {
        ShowAlertView(self, "Что-то не так", "Запрос на сервер не дошел, возможно у вас не работает интернет", "Закрыть")
    }
    
    func AddressSelected(notification: NSNotification)
    {
        println(notification)
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var address: String = userDefaults.objectForKey(kVZTempLocationKey) as! String
        self.CityTextField.text = address
    }
    
    func RegisterSuccesfully(notification: NSNotification)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(true, forKey: kVZIsLoginCompleteKey)
            userDefaults.synchronize()
                        
            let mainView: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainView") as! UIViewController
            self.navigationController?.presentViewController(mainView, animated: true, completion: nil)
        }
//        ShowAlertView(self, "Позравляем!", "Поздравляем, вы успешно зарегестрировались. Теперь перейдите в главное окно и войдите в аккаунт, приятного использования нашего приложения", "Закрыть")
    }
    
    func RegisterError(notification: NSNotification)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(CGPoint: CGPointMake(self.SMSTextField.center.x - 5, self.SMSTextField.center.y))
            animation.toValue = NSValue(CGPoint: CGPointMake(self.SMSTextField.center.x + 5, self.SMSTextField.center.y))
            self.SMSTextField.layer.addAnimation(animation, forKey: "position")
        }
//        ShowAlertView(self, "Упс!", "Что-то пошло не так, возможно вы неверно указали код из смс сообщения, можете вернуться на предыдущий экран и проверить это", "Закрыть")
    }
}