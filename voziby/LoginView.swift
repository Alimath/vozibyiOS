//
//  LoginViewController.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class LoginView: BaseView, UITextFieldDelegate
{
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var leftMenu: UIView!

    let menuWidth: CGFloat = 300.0
    
    func ShowMenu()
    {
        
        var frame = self.view.frame
        frame.origin.x -= frame.size.width
        self.leftMenu = UIView(frame: frame)
        self.leftMenu.backgroundColor = UIColor.redColor()
        self.navigationController?.view.addSubview(leftMenu)
        
        UIView.animateWithDuration(1.0)
        { () -> Void in
            var frame2 = self.leftMenu.frame
            frame2.origin.x += self.menuWidth
            self.leftMenu.frame = frame2
        }
    }
    
    func HideMenu()
    {
        UIView.animateWithDuration(1.0)
        { () -> Void in
            var frame1 = self.view.frame
            var frame2 = self.leftMenu.frame
            
            frame1.origin.x -= self.menuWidth
            frame2.origin.x -= self.menuWidth
            
            self.view.frame = frame1
            self.leftMenu.frame = frame2
        }
    }
    
    func menuFrameInit()
    {
        var frame = self.view.frame
        self.leftMenu.frame = frame
        self.leftMenu.frame.origin.x -= self.leftMenu.frame.width
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = UIColor(RGBA: "40a9f4")
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "40a9f4")]
        }
        self.navigationItem.title = "vozim.by"
    
        self.phoneNumberTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        self.passwordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "textFieldTextChanged:",
            name:UITextFieldTextDidChangeNotification,
            object: nil)
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        let isLogin = userDefaults.boolForKey(kVZIsLoginCompleteKey)
        if(isLogin)
        {
            Server.sharedInstance.SessionUpdate()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        
        var phoneFormat: RMPhoneFormat = RMPhoneFormat()
        var formattedString = phoneFormat.format(phoneNumberTextField.text)
        
        if(textField.tag == 1002)
        {
            if(phoneFormat.isPhoneNumberValid(phoneNumberTextField.text))
            {
                Server.sharedInstance.Authorization(phoneNumberTextField.text.StringWithoutPhoneFormat(), password: self.passwordTextField.text.md5())
            }
            else
            {
                ShowAlertView(self, "Неверный номер", "Пожалуйста, введите корректный номер телефона", "Закрыть")
            }
        }
        
        return true;
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        super.touchesBegan(touches, withEvent: event)
//        phoneNumberTextField.resignFirstResponder()
//        passwordTextField.resignFirstResponder()
        self.ShowMenu()
    }
}


