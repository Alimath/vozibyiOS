//
//  CompanieDetailView.swift
//  voziby
//
//  Created by Fedar Trukhan on 20.04.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class CompanyDetailView: UIViewController
{
    var companieInfo: CompanyInfo?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var DetailScrollHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var DetailViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var DetailView: UIView!
    @IBOutlet weak var DescriptionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var GarageView: UIView!
    @IBOutlet weak var GarageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var price1kmLabel: UILabel!
    @IBOutlet weak var price1kmWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var price1hLabel: UILabel!
    @IBOutlet weak var price1hWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var descrtImage: UIImageView!
    @IBOutlet weak var autosLabel: UILabel!
    @IBOutlet weak var autosImage: UIImageView!
    @IBOutlet weak var contactsLabel: UILabel!
    @IBOutlet weak var contactsImage: UIImageView!
    
    @IBOutlet weak var detailInfoScroll: UIScrollView!
    
    var SelectedPage: Int = 0
    let selectedColor: UIColor = UIColor(RGBA: "40A9F4")
    let unSelectedColor: UIColor = UIColor(RGBA: "373737")
    var arrowBackImage: UIImageView = UIImageView()
    
    
    //типы перевозок в описании
    @IBOutlet weak var transportTypesView: UIView!
    @IBOutlet weak var transportTypeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cargoTypeView: UIView!
    @IBOutlet weak var helpLoadUnload: UILabel!
    @IBOutlet weak var cargoTypeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cargoLabelAlightYCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var passengersTypeView: UIView!
    @IBOutlet weak var passengersTypeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var carTypeView: UIView!
    @IBOutlet weak var carTypeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var furnitureTypeView: UIView!
    @IBOutlet weak var furnitureTypeTopConstraint: NSLayoutConstraint!
    
    //блок с возможными странами перевозки
    @IBOutlet weak var GeographyView: UIView!
    @IBOutlet weak var GeographyViewHeightConstraint: NSLayoutConstraint!
    
    //блок с вариантами оплаты
    @IBOutlet weak var moneysView: UIView!
    @IBOutlet weak var moneysViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cashIcon: UIImageView!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var nonCashIcon: UIImageView!
    @IBOutlet weak var nonCashLabel: UILabel!
    @IBOutlet weak var nonCashHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardIcon: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eMoneyIcon: UIImageView!
    @IBOutlet weak var eMoneyLabel: UILabel!
    @IBOutlet weak var eMoneyHeightConstraint: NSLayoutConstraint!
    
    //блок с описанием компании и акциями
    @IBOutlet weak var AboutView: UIView!
    @IBOutlet weak var AboutViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutLabelHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let font = UIFont(name: "Roboto-Regular", size: 16)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        }
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "TransportLoadComplete:",
            name:"TransportLoadComplete",
            object: nil)
        
        if let info = self.companieInfo
        {
            Server.sharedInstance.LoadTransportWithCompanyID(info.id)
            
            if(info.uoCleanRoom == true)
            {
//                println("Clean ROom")
            }
            
            var numberFormatter: NSNumberFormatter = NSNumberFormatter()
            numberFormatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            numberFormatter.groupingSeparator = "."
            
            self.nameLabel.text = info.ownershipAndName
            if let logo = info.logoImage
            {
                self.avatar.image = logo
            }
            
            var helpLabel: UILabel = UILabel()
            self.price1kmLabel.text = "\(numberFormatter.stringFromNumber(self.companieInfo!.ratePerKM)!) BYR"
            helpLabel.frame = CGRectMake(0,0,2000,2000)
            helpLabel.font = self.price1kmLabel.font
            helpLabel.text = self.price1kmLabel.text
            helpLabel.sizeToFit()
            self.price1kmWidthConstraint.constant = max(helpLabel.frame.width, 70)
            
            self.price1hLabel.text = "\(numberFormatter.stringFromNumber(self.companieInfo!.ratePerHour)!) BYR"
            helpLabel.frame = CGRectMake(0,0,2000,2000)
            helpLabel.font = self.price1hLabel.font
            helpLabel.text = self.price1hLabel.text
            helpLabel.sizeToFit()
            self.price1hWidthConstraint.constant = max(helpLabel.frame.width, 70)
            
            
            if(info.uoLoadUnload == false)
            {
                self.helpLoadUnload.hidden = true
                self.cargoTypeHeightConstraint.constant = 25
                self.cargoLabelAlightYCenterConstraint.constant = 0
                self.passengersTypeTopConstraint.constant = 30
                self.view.layoutIfNeeded()
            }
            
            var specialityCount: Int = 4
            if(info.specialityCargo == false)
            {
                specialityCount--
                self.cargoTypeView.hidden = true
                self.passengersTypeTopConstraint.constant = 0
            }
            if(info.specialityPassager == false)
            {
                specialityCount--
                self.passengersTypeView.hidden = true
                self.carTypeTopConstraint.constant = 0
            }
            if(info.spcialityCars == false)
            {
                specialityCount--
                self.carTypeView.hidden = true
                self.furnitureTypeTopConstraint.constant = 0
            }
            if(info.spcialityFurniture == false)
            {
                specialityCount--
                self.furnitureTypeView.hidden = true
            }
            
            self.view.layoutIfNeeded()
            if(specialityCount != 0)
            {
                if(info.uoLoadUnload == true)
                {
                    self.transportTypeHeightConstraint.constant = CGFloat(70 + specialityCount*30)
                }
                else
                {
                    self.transportTypeHeightConstraint.constant = CGFloat(60 + specialityCount*30)
                }
            }
            else
            {
                self.transportTypesView.hidden = true
                self.transportTypeHeightConstraint.constant = 0
            }
            
            var startYPos: CGFloat = 50
            for country in info.countries
            {
                var countriView: CountryView = CountryView()
                countriView.frame = CGRectMake(0, startYPos, self.GeographyView.frame.width, 25)
                countriView.countryLabel.text = country
                countriView.backgroundColor = UIColor.whiteColor()
                self.GeographyView.addSubview(countriView)
                startYPos += 25
            }
            self.GeographyViewHeightConstraint.constant = CGFloat(60 + 25 * info.countries.count)
//            self.DescriptionView.layoutIfNeeded()
           
            
            var paymentsCount: Int = 4
            if(info.cashPayment == false)
            {
                paymentsCount--
                self.cashIcon.hidden = true
                self.cashLabel.hidden = true
                
                self.nonCashHeightConstraint.constant = 0
            }
            if(info.nocashPayment == false)
            {
                paymentsCount--
                self.nonCashIcon.hidden = true
                self.nonCashLabel.hidden = true
                
                self.cardHeightConstraint.constant = 0
            }
            if(info.cardPayment == false)
            {
                paymentsCount--
                self.cardIcon.hidden = true
                self.cardLabel.hidden = true
                
                self.eMoneyHeightConstraint.constant = 0
            }
            if(info.onlinePayment == false)
            {
                paymentsCount--
                self.eMoneyIcon.hidden = true
                self.eMoneyLabel.hidden = true
            }
            
            if(paymentsCount == 0)
            {
                self.moneysViewHeightConstraint.constant = 0
            }
            else
            {
                self.moneysViewHeightConstraint.constant = self.cashIcon.frame.origin.y + CGFloat(paymentsCount)*CGFloat(30) + CGFloat(15)
            }
            
            self.aboutLabel.text = info.descr
            self.aboutLabel.sizeToFit()
            
            self.aboutLabelHeightConstraint.constant = self.aboutLabel.frame.height
        
            self.AboutViewHeightConstraint.constant = CGFloat(50) + aboutLabel.frame.height
            
            self.DescriptionView.layoutIfNeeded()
            
            self.updateMainScrollContentSize()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonSelectNewCategoryBegin(sender: UIButton)
    {
        sender.backgroundColor = UIColor.whiteColor()
        sender.alpha = 0.5
        
        self.descrLabel.textColor = self.unSelectedColor
        self.descrtImage.image = UIImage(named: "descriptionUnselected")
        
        self.autosLabel.textColor = self.unSelectedColor
        self.autosImage.image = UIImage(named: "autosUnselected")
        
        self.contactsLabel.textColor = self.unSelectedColor
        self.contactsImage.image = UIImage(named: "contactsUnselected")
        
        if(sender.tag == 1)
        {
            descrLabel.textColor = self.selectedColor
            descrtImage.image = UIImage(named: "descriptionSelected")
        }
        else if(sender.tag == 2)
        {
            self.autosLabel.textColor = self.selectedColor
            self.autosImage.image = UIImage(named: "autosSelected")
        }
        else if(sender.tag == 3)
        {
            self.contactsLabel.textColor = self.selectedColor
            self.contactsImage.image = UIImage(named: "contactsSelected")
        }
    }
    
    @IBAction func ButtonSelectNewCategoryNotConfirmed(sender: UIButton)
    {
        sender.backgroundColor = UIColor.clearColor()
        sender.alpha = 0.5
        
        self.descrLabel.textColor = self.unSelectedColor
        self.descrtImage.image = UIImage(named: "descriptionUnselected")
        
        self.autosLabel.textColor = self.unSelectedColor
        self.autosImage.image = UIImage(named: "autosUnselected")
        
        self.contactsLabel.textColor = self.unSelectedColor
        self.contactsImage.image = UIImage(named: "contactsUnselected")
        
        if(self.SelectedPage == 0)
        {
            descrLabel.textColor = self.selectedColor
            descrtImage.image = UIImage(named: "descriptionSelected")
        }
        else if(self.SelectedPage == 1)
        {
            self.autosLabel.textColor = self.selectedColor
            self.autosImage.image = UIImage(named: "autosSelected")
        }
        else if(self.SelectedPage == 2)
        {
            self.contactsLabel.textColor = self.selectedColor
            self.contactsImage.image = UIImage(named: "contactsSelected")
        }
    }
    
    
    @IBAction func ButtonSelectNewCategoryConfirmed(sender: UIButton)
    {
        sender.backgroundColor = UIColor.clearColor()
        sender.alpha = 0.5
        self.SelectedPage = sender.tag-1
        self.updateMainScrollContentSize()

        self.detailInfoScroll.setContentOffset(CGPoint(x: self.detailInfoScroll.frame.width * CGFloat(self.SelectedPage), y: 0), animated: true)
    }

    func updateMainScrollContentSize()
    {
        if(SelectedPage == 0)
        {
            self.DescriptionViewHeightConstraint.constant = self.AboutView.frame.origin.y + self.AboutView.frame.height
            self.DetailView.layoutIfNeeded()
            
            self.DetailViewHeightConstraint.constant = self.DescriptionView.frame.origin.y + self.DescriptionView.frame.height
            self.detailInfoScroll.layoutIfNeeded()
        }
        if(SelectedPage == 1)
        {
            self.DetailViewHeightConstraint.constant = self.GarageView.frame.origin.y + self.GarageView.frame.size.height
            self.detailInfoScroll.layoutIfNeeded()
        }
        
        self.DetailScrollHeightConstraint.constant = self.DetailView.frame.height
        self.ContentView.layoutIfNeeded()
        
        self.ContentViewHeightConstraint.constant = self.detailInfoScroll.frame.origin.y + detailInfoScroll.frame.height
        self.view.layoutIfNeeded()
    }
    
    func TransportLoadComplete(notification: NSNotification)
    {
        var lastYPos: CGFloat = 0
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            self.tableView.reloadData()
            self.GarageViewHeightConstraint.constant = CGFloat(Server.sharedInstance.companyTransport.count * 120)
            self.GarageView.layoutIfNeeded()
            
            self.updateMainScrollContentSize()
        }
    }
    
    //MARK: Table view delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 120
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Server.sharedInstance.companyTransport.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("autoCell") as! AutoCell
        
        var numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.groupingSeparator = "."
        numberFormatter.decimalSeparator = ","
        
        let row = indexPath.row
        cell.AutoLogo.image = Server.sharedInstance.companyTransport[row].images[0]
        cell.ModelLabel.text = "\(Server.sharedInstance.companyTransport[row].mark) \(Server.sharedInstance.companyTransport[row].model) \(Server.sharedInstance.companyTransport[row].year)"
        if(Server.sharedInstance.companyTransport[row].type == 3 || Server.sharedInstance.companyTransport[row].type == 1)
        {
            cell.FirstOptionIcon.image = UIImage(named:"autoCellVolume")
            cell.FirstOptionLabel.text = "\(numberFormatter.stringFromNumber(Server.sharedInstance.companyTransport[row].volume)!) м"
            
            cell.SecondOptionIcon.image = UIImage(named:"autoCellWeight")
            cell.SecondOptionLabel.text = "\(numberFormatter.stringFromNumber(Server.sharedInstance.companyTransport[row].payload)!) кг"
        }
        else if(Server.sharedInstance.companyTransport[row].type == 2)
        {
            cell.FirstOptionIcon.image = UIImage(named:"autoCellPassengers")
            cell.FirstOptionLabel.text = "\(Server.sharedInstance.companyTransport[row].seats) мест"
            
            cell.FirstOptionHelpLabel.hidden = true
            
            cell.SecondOptionIcon.image = UIImage(named:"autoCellBaggage")
            cell.SecondOptionLabel.text = "\(numberFormatter.stringFromNumber(Server.sharedInstance.companyTransport[row].baggage)!) л"
        }
        else if(Server.sharedInstance.companyTransport[row].type == 4)
        {
            cell.FirstOptionIcon.image = UIImage(named:"autoCellCar")
            cell.FirstOptionLabel.text = "\(Server.sharedInstance.companyTransport[row].carsCount) авто"
            
            cell.FirstOptionHelpLabel.hidden = true
            
            cell.SecondOptionIcon.image = UIImage(named:"autoCellWeight")
            cell.SecondOptionLabel.text = "\(numberFormatter.stringFromNumber(Server.sharedInstance.companyTransport[row].carsPayload)!) кг"
        }
        
        if(Server.sharedInstance.companyTransport[row].payPerKm != 0)
        {
            cell.ratePerkmLabel.text = "\(numberFormatter.stringFromNumber(Server.sharedInstance.companyTransport[row].payPerKm)!) BYR"
            cell.ratePerkmLabel.sizeToFit()
            
            if(cell.ratePerkmLabel.frame.width < 50)
            {
                cell.ratePerkmLabel.frame.size.width = 50
            }
        }
        else
        {
            cell.ratePerkmView.hidden = true
        }
        if(Server.sharedInstance.companyTransport[row].payPerHour != 0)
        {
            cell.ratePerHLabel.text = "\(numberFormatter.stringFromNumber(Server.sharedInstance.companyTransport[row].payPerHour)!) BYR"
            cell.ratePerHLabel.sizeToFit()
            if(cell.ratePerHLabel.frame.width < 50)
            {
               cell.ratePerHLabel.frame.size.width = 50
            }
        }
        else
        {
            cell.ratePerHView.hidden = true
        }
//        cell..text = "Надёжность \(Server.sharedInstance.companyTransport[row].reliability)%"
//        
//        let percent = CGFloat(Server.sharedInstance.loadedCompanies[row].reliability)/CGFloat(100)
//        cell.reliabilityImageWidthConstraint.constant = cell.reliabilityBack.frame.width * percent - cell.reliabilityBack.frame.width
        self.view.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let companyView: CompanyDetailView = self.storyboard?.instantiateViewControllerWithIdentifier("companyDetailView") as! CompanyDetailView
        companyView.companieInfo = Server.sharedInstance.loadedCompanies[indexPath.row]
        self.navigationController?.pushViewController(companyView, animated: true)
    }
}
