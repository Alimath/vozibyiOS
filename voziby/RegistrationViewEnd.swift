//
//  LoginViewEnd.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class RegistraionViewEnd: BaseView, UITextFieldDelegate
{
    @IBOutlet weak var NameTextField: UITextField!
    
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
        
        let backButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.Plain, target: self, action: "Back")
        navigationItem.leftBarButtonItem = backButton
        
        let nextButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.Plain, target: self, action: "Done")
        navigationItem.rightBarButtonItem = nextButton
        
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "textFieldTextChanged:",
            name:UITextFieldTextDidChangeNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "RegisterSuccesfully:", name:"registersuccesfully", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "RegisterError:", name:"registererror", object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        super.touchesBegan(touches, withEvent: event)
    }
    
    func Done()
    {
        if(self.NameTextField.text != "")
        {
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(self.NameTextField.text, forKey: kVZNameKey)
            userDefaults.setBool(false, forKey: kVZIsRegistrationCompleteKey)
            userDefaults.synchronize()
            
            let name: String = userDefaults.objectForKey(kVZNameKey) as String
            let phone: String = userDefaults.objectForKey(kVZPhoneNumberKey) as String
            let pass: String = userDefaults.objectForKey(kVZPasswordKey) as String
            let location: String = userDefaults.objectForKey(kVZLocationKey) as String
            let smscode: String = userDefaults.objectForKey(kVZSMSCodeKey) as String

            Server.sharedInstance.Register(name, location: location, username: phone, password: pass, smsCode: smscode)
            
//            println("\(userDefaults.objectForKey(kVZNameKey)), \(userDefaults.objectForKey(kVZPhoneNumberKey)), \(userDefaults.objectForKey(kVZLocationKey)), \(userDefaults.objectForKey(kVZPasswordKey)), \(userDefaults.objectForKey(kVZSMSCodeKey))")
//            
//            println("\(name), \(phone), \(location), \(pass), \(smscode)")
        }
    }
    
    func Back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func RegisterSuccesfully(notification: NSNotification)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(true, forKey: kVZIsRegistrationCompleteKey)
            userDefaults.synchronize()
        }
        ShowAlertView(self, "Позравляем!", "Поздравляем, вы успешно зарегестрировались. Теперь перейдите в главное окно и войдите в аккаунт, приятного использования нашего приложения", "Закрыть")
    }
    
    func RegisterError(notification: NSNotification)
    {
        ShowAlertView(self, "Упс!", "Что-то пошло не так, возможно вы неверно указали код из смс сообщения, можете вернуться на предыдущий экран и проверить это", "Закрыть")
    }
    
    
    func textFieldTextChanged(sender : AnyObject)
    {
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
    }
}