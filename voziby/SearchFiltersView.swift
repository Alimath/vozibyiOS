//
//  SearchFiltersView.swift
//  voziby
//
//  Created by Fedar Trukhan on 02.04.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class SearchFiltersView: UIViewController, UITextFieldDelegate
{
    let addedHeight: CGFloat = 80
    
    @IBOutlet weak var ContentViewHeightConstraint: NSLayoutConstraint!
    //Cargo Type elements
    @IBOutlet weak var imageCargoIcon: UIImageView!
    @IBOutlet weak var imagePassengersIcon: UIImageView!
    
    @IBOutlet weak var ContentScrollBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var PassengersView: UIView!
    @IBOutlet weak var MoreCriterionCargo: UIButton!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var TariffsTopConstraint: NSLayoutConstraint!
    
    var keyboardIsShowing: Bool = false
    
    @IBOutlet weak var CargoView: UIView!
    @IBOutlet weak var CargoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var CargoPaymentsFormView: UIView!
    
    
    //поля опций поиска для груза
    @IBOutlet weak var cargoLength: TextFieldWithMargin!
    @IBOutlet weak var cargoWidth: TextFieldWithMargin!
    @IBOutlet weak var cargoHeight: TextFieldWithMargin!
    @IBOutlet weak var cargoWeight: TextFieldWithMargin!
    @IBOutlet weak var cargoFrom: TextFieldWithMargin!
    @IBOutlet weak var cargoTo: TextFieldWithMargin!
    @IBOutlet weak var cargo1km: TextFieldWithMargin!
    @IBOutlet weak var cargo1hour: TextFieldWithMargin!
    @IBOutlet weak var cargoLoadUnload: UISwitch!
    @IBOutlet weak var cargoGarbage: UISwitch!
    @IBOutlet weak var cargoGidrolift: UISwitch!
    @IBOutlet weak var cargoZadnjaPogruzka: UISwitch!
    @IBOutlet weak var cargoBokPogruzka: UISwitch!
    @IBOutlet weak var cargoSanpasport: UISwitch!
    @IBOutlet weak var cargoCash: UISwitch!
    @IBOutlet weak var cargoNonCash: UISwitch!
    @IBOutlet weak var cargoTerminal: UISwitch!
    @IBOutlet weak var cargoWebpay: UISwitch!
    @IBOutlet weak var cargoEmoney: UISwitch!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let font = UIFont(name: "HelveticaNeue", size: 21)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        }
        self.navigationItem.title = "Фильтр поиска"
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "textFieldTextChanged:",
            name:UITextFieldTextDidChangeNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        self.CargoViewHeightConstraint.constant = self.MoreCriterionCargo.frame.origin.y + self.MoreCriterionCargo.frame.height + addedHeight
//        self.view.layoutIfNeeded()
        
        self.ContentViewHeightConstraint.constant = self.CargoView.frame.origin.y + self.MoreCriterionCargo.frame.origin.y + self.MoreCriterionCargo.frame.height + addedHeight
        self.view.layoutIfNeeded()
    }
    
    // MARK:
    // MARK: UI Actions
    @IBAction func SelectCargo(sender: AnyObject)
    {
        self.view.endEditing(true)
        imageCargoIcon.image = UIImage(named: "searchCargoTypeIconSelected")
        imagePassengersIcon.image = UIImage(named: "searchPassangerTypeUnselected")

        UIView.animateWithDuration(0.2,
        animations:{
            self.CargoView.alpha = 1
            self.PassengersView.alpha = 0
        },
        completion: { (value: Bool) in
            self.CargoView.hidden = false
            self.PassengersView.hidden = true
        })
    }
    
    @IBAction func SelectPassangers(sender: AnyObject)
    {
        self.view.endEditing(true)
        imageCargoIcon.image = UIImage(named: "searchCargoTypeIconUnselected")
        imagePassengersIcon.image = UIImage(named: "searchPassangerTypeSelected")
        
        UIView.animateWithDuration(0.2,
        animations:{
            self.CargoView.alpha = 0
            self.PassengersView.alpha = 1
        },
        completion: { (value: Bool) in
            self.CargoView.hidden = true
            self.PassengersView.hidden = false
        })
    }
    
    // MARK: TextFields delegates
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if(textField.keyboardType == UIKeyboardType.NumberPad)
        {
            let keyboardToolbar = UIToolbar()
            keyboardToolbar.sizeToFit()
            let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("textFieldEndEditing:"))
            keyboardToolbar.items = [flexBarButton, doneBarButton]
            textField.inputAccessoryView = keyboardToolbar
        }
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height
            {
                if(self.keyboardIsShowing == false)
                {
                    self.ContentViewHeightConstraint.constant -= 45
                }
                self.ContentScrollBottomConstraint.constant = keyboardHeight
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
        self.keyboardIsShowing = true
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if(self.keyboardIsShowing == true)
        {
            self.ContentViewHeightConstraint.constant += 45
        }
        self.ContentScrollBottomConstraint.constant = 0
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        self.keyboardIsShowing = false
    }
    
    func textFieldEndEditing(sender: UIBarButtonItem)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {   
            self.view.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldTextChanged(sender: NSNotification)
    {
        if let textField: UITextField = sender.object as? UITextField
        {
            if(textField.tag == 99)
            {
                if(textField.text.floatValue > 5000)
                {
                    textField.text = "5000"
                }
                else if (textField.text.floatValue < 0)
                {
                    textField.text = "0"
                }
                self.weightSlider.value = self.cargoWeight.text.floatValue
            }
        }
    }
    
    // MARK: cargoView delegates
    @IBAction func MoreCriterionCargoViewTouch(sender: AnyObject)
    {
        self.MoreCriterionCargo.hidden = true
        self.TariffsTopConstraint.constant = 0
        self.view.layoutIfNeeded()
        
        self.CargoViewHeightConstraint.constant = self.CargoPaymentsFormView.frame.origin.y + self.CargoPaymentsFormView.frame.height + addedHeight
        self.view.layoutIfNeeded()
        
        self.ContentViewHeightConstraint.constant = self.CargoView.frame.origin.y + self.CargoView.frame.height
        self.view.layoutIfNeeded()
    }
    
    
    
    // MARK: Slider delegates
    @IBAction func changeWeight(sender: UISlider)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            self.view.endEditing(true)
        }
        self.cargoWeight.text = "\(Int(sender.value))"
    }
    
    
    // MARK: Search buttons
    
    @IBAction func searchCompanies(sender: AnyObject)
    {
        Server.sharedInstance.LoadCompaniesWithFilters(self.ParseParameters("Company"), page: 0)
    }
    

    // MARK: парсеры параметров
    func ParseParameters(prefix: String) -> [String:String]
    {
        var params:[String: String] = [String: String]()
        var options: String = ""
        
        if(self.CargoView.hidden == false)
        {
            params.updateValue("1", forKey: "\(prefix)[spciality_cargo]")
            if(self.cargoLength.text != "")
            {
                
            }
            if(self.cargoWidth.text != "")
            {
                
            }
            if(self.cargoHeight.text != "")
            {
            }
            if(self.cargoWeight.text != "")
            {
            }
            if(self.cargoFrom.text != "")
            {
            }
            if(self.cargoTo.text != "")
            {
            }
            if(self.cargo1km.text != "")
            {
                params.updateValue("<\(self.cargo1km.text)", forKey: "\(prefix)[rate_per_km]")
            }
            params.updateValue("rate_per_km", forKey: "sort.asc")
            if(self.cargo1hour.text != "")
            {
                params.updateValue("<\(self.cargo1hour.text)", forKey: "\(prefix)[rate_per_hour]")
            }
            params.updateValue("rate_per_km", forKey: "sort.asc")
            if(self.cargoLoadUnload.on == true)
            {
                params.updateValue("1", forKey: "\(prefix)[spciality_cargo_unload]")
            }
            if(self.cargoGarbage.on == true)
            {
                
            }
            if(self.cargoGidrolift.on == true)
            {
                
            }
            if(self.cargoZadnjaPogruzka.on == true)
            {
                
            }
            if(self.cargoBokPogruzka.on == true)
            {
                
            }
            if(self.cargoSanpasport.on == true)
            {
                
            }
            if(self.cargoCash.on == true)
            {
                params.updateValue("1", forKey: "\(prefix)[cash_payment]")
            }
            if(self.cargoNonCash.on == true)
            {
                params.updateValue("1", forKey: "\(prefix)[nocash_payment]")
            }
            if(self.cargoTerminal.on == true)
            {
                params.updateValue("1", forKey: "\(prefix)[card_payment]")
            }
            if(self.cargoWebpay.on == true)
            {
                params.updateValue("1", forKey: "\(prefix)[webpay_payment]")
            }
            if(self.cargoEmoney.on == true)
            {
                params.updateValue("1", forKey: "\(prefix)[online_payment]")
            }
        }
//        Company[spciality_cargo]
        
        return params
    }
    
    
}





















