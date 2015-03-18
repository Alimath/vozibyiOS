//
//  LoginViewController.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class LoginView: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        
        notificationCenter.addObserver(
            self,
            selector: "loginComplete:",
            name:kVZLoginCompleteKey,
            object: nil)
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        let isLogin = userDefaults.boolForKey(kVZIsLoginCompleteKey)
        
        if(isLogin)
        {
            Server.sharedInstance.SessionUpdate()
        }
    
        self.phoneNumberTextField.becomeFirstResponder()
//        SwiftSpinner.show("Идет загрузка", animated: true)
//        var userInfo = UserInfo(userName: "a", personName: "a", location: "a", email: "A", notifyByEmail: true, phoneNumber: "A", notifyByPhone: true, logo: true)
//        userInfo.loadUserInfo()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginComplete(sender: AnyObject)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            self.phoneNumberTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
            
            let mainView: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainView") as UIViewController
            self.navigationController?.presentViewController(mainView, animated: true, completion: nil)
        }
    }
    
    func textFieldTextChanged(sender : AnyObject)
    {
        var textField: UITextField = sender.object as UITextField
        if(textField.tag == 1001)
        {
            var tempText = textField.text
            
            var phoneFormat: RMPhoneFormat = RMPhoneFormat()
            phoneNumberTextField.text = phoneFormat.format(phoneNumberTextField.text)
            
            if(tempText+")" == textField.text)
            {
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
                println(phoneNumberTextField.text.StringWithoutPhoneFormat())
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
        phoneNumberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}


