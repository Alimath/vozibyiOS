//
//  SettingsView.swift
//  voziby
//
//  Created by Fedar Trukhan on 19.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class SettingsView: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: TextFieldWithMargin!
    @IBOutlet weak var LocationTextField: TextFieldWithMargin!
    @IBOutlet weak var PhoneTextField: TextFieldWithMargin!
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var PhoneNotify: UISwitch!
    @IBOutlet weak var MailTextField: TextFieldWithMargin!
    @IBOutlet weak var MailNotify: UISwitch!
    
    @IBOutlet weak var OldPassTextField: TextFieldWithMargin!
    @IBOutlet weak var NewPassTextField: TextFieldWithMargin!
    @IBOutlet weak var NewPassRepeatTextField: TextFieldWithMargin!
    @IBOutlet weak var SaveChangeButton: UIBarButtonItem!
    @IBOutlet weak var SMSTextField: TextFieldWithMargin!
    @IBOutlet weak var GetSMSButton: UIButton!
    
    
    var userInfo = GetUserInfo()
    var startPhone: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        
        SaveChangeButton.target = self
        SaveChangeButton.action = "ChangeTouch:"
        
        if let font = UIFont(name: "HelveticaNeue", size: 25)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        }
        self.navigationItem.title = "Настройки"
        
        
        var revealController = self.revealViewController()
        self.view.addGestureRecognizer(revealController.panGestureRecognizer())
        var revealButtonItem = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: UIBarButtonItemStyle.Bordered, target: revealController, action: Selector("revealToggle:"))
        self.navigationItem.leftBarButtonItem = revealButtonItem
        
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "serverLogout:",
            name:"serverLogout",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldTextChanged:", name:UITextFieldTextDidChangeNotification, object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: "textFieldTextChanged:",
            name:UITextFieldTextDidChangeNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SMSSuccesfullySend:", name:"smssend", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SMSSendError:", name:"smssenderror", object: nil)
        
        self.SMSTextField.delegate = self
        self.SMSTextField.tag = 777
        
        startPhone = userInfo.phoneNumber
        self.FillFieldWithUserInfo()
    }
    
    func FillFieldWithUserInfo()
    {
        self.nameTextField.text = userInfo.personName
        self.LocationTextField.text = userInfo.location
        self.PhoneTextField.text = userInfo.phoneNumber
        self.PhoneLabel.text = userInfo.phoneNumber
        self.PhoneNotify.setOn(userInfo.notifyByPhone, animated: false)
        self.MailTextField.text = userInfo.email
        self.MailNotify.setOn(userInfo.notifyByEmail, animated: false)
        
        self.PhoneTextField.text = "+" + self.PhoneTextField.text
        self.PhoneTextField.text = RMPhoneFormat().format(self.PhoneTextField.text)
        self.PhoneLabel.text = self.PhoneTextField.text
    }
    
    
    func textFieldTextChanged(sender : AnyObject)
    {
        var textField: UITextField = sender.object as UITextField
        var tempText = textField.text
        if(textField.tag == 1001)
        {
            var phoneFormat: RMPhoneFormat = RMPhoneFormat()
            self.PhoneTextField.text = phoneFormat.format(self.PhoneTextField.text)
            
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
                self.PhoneTextField.text = phoneFormat.format(self.PhoneTextField.text)
            }
            
            if(textField.text.utf16Count < 1)
            {
                textField.text = "+"
            }
            
            if(!phoneFormat.isPhoneNumberValid(self.PhoneTextField.text))
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
            self.PhoneTextField.text = phoneFormat.format(self.PhoneTextField.text)
            if(!phoneFormat.isPhoneNumberValid(self.PhoneTextField.text))
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
    
    @IBAction func SendSMS(sender: AnyObject)
    {
        if(startPhone != self.PhoneTextField.text)
        {
            if(!RMPhoneFormat().isPhoneNumberValid(self.PhoneTextField.text))
            {
                ShowAlertView(self, "Неверный номер", "Пожалуйста, введите корректный номер телефона", "Закрыть")
            }
            else
            {
                nameTextField.resignFirstResponder()
                LocationTextField.resignFirstResponder()
                PhoneTextField.resignFirstResponder()
                MailTextField.resignFirstResponder()
                Server.sharedInstance.SendSMS(self.PhoneTextField.text.StringWithoutPhoneFormat())
            }
        }
        else
        {
            NSOperationQueue.mainQueue().addOperationWithBlock
            {
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 2
                animation.autoreverses = true
                animation.fromValue = NSValue(CGPoint: CGPointMake(self.PhoneTextField.center.x - 5, self.PhoneTextField.center.y))
                animation.toValue = NSValue(CGPoint: CGPointMake(self.PhoneTextField.center.x + 5, self.PhoneTextField.center.y))
                self.PhoneTextField.layer.addAnimation(animation, forKey: "position")
            }
        }
    }
    
    @IBAction func ChangeTouch(sender: AnyObject)
    {
        self.userInfo.personName = self.nameTextField.text
        self.userInfo.location = self.LocationTextField.text
        self.userInfo.phoneNumber = self.PhoneTextField.text
        self.userInfo.notifyByPhone = self.PhoneNotify.on
        self.userInfo.email = self.MailTextField.text
        self.userInfo.notifyByEmail = self.MailNotify.on
        
        SaveUserInfo(userInfo)
        
        
        Server.sharedInstance.UpdateUserInfo(userInfo)
    }
    
    
    @IBAction func Logout(sender: AnyObject)
    {
        Server.sharedInstance.ServerLogout()
    }
    
    func serverLogout(sender: AnyObject)
    {
        println("server logout")
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            
            let loginView: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView") as UIViewController
            
            let startNavC = self.storyboard?.instantiateViewControllerWithIdentifier("startNavController") as UINavigationController
            
//            var navC = UINavigationController(rootViewController: loginView)
            
            self.navigationController?.presentViewController(startNavC, animated: true, completion: nil)
        }
    }

    func PhoneChangeComplete()
    {
        self.PhoneLabel.text = self.PhoneTextField.text
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
                        self.SMSTextField.layer.borderWidth = 1
                        self.SMSTextField.layer.borderColor = UIColor(RGBA: "dcdcdc").CGColor
                }
        }
        //        ShowAlertView(self, "СМС с кодом", "Вам направлено смс с кодом, который необходимо ввести для продолжения регистрации", "Закрыть")
    }
    
    func SMSSendError(notification: NSNotification)
    {
        ShowAlertView(self, "Что-то не так", "Запрос на сервер не дошел, возможно у вас не работает интернет", "Закрыть")
    }
}
