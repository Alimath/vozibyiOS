//
//  CompaniesView.swift
//  voziby
//
//  Created by Fedar Trukhan on 17.04.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class CompaniesView: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var findingParams: [String:String] = [String: String]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var currentPage: Int = 0
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let font = UIFont(name: "Roboto-Regular", size: 16)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        }
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "CompaniesLoad:",
            name:"CompaniesLoad",
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: "LastPageReached:",
            name:"LastPageReached",
            object: nil)
//        self.tableView.tableFooterView?.
        
        var tableViewController: UITableViewController = UITableViewController()
        tableViewController.tableView = self.tableView
        
        refreshControl.addTarget(self, action: "Refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        

        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, activityIndicator.frame.height))
        self.tableView.tableFooterView?.addSubview(activityIndicator)
        self.activityIndicator.center.x = self.tableView.frame.width/2
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        
        Server.sharedInstance.LoadCompaniesWithFilters(findingParams, page: self.currentPage)
    }
    
    func CompaniesLoad(notification: NSNotification)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func LastPageReached(notification: NSNotification)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            self.activityIndicator.stopAnimating()
            self.currentPage = max(0, self.currentPage-1)
        }
    }
    
    
    func Refresh(notification: NSNotification)
    {
        Server.sharedInstance.loadedCompanies = []
        self.tableView.reloadData()
        self.currentPage = 0
        Server.sharedInstance.LoadCompaniesWithFilters(findingParams, page: self.currentPage)
    }
    
    //MARK: Table view delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 170
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Server.sharedInstance.loadedCompanies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(indexPath.row == Server.sharedInstance.loadedCompanies.count-1 && self.activityIndicator.isAnimating())
        {
            self.currentPage += 1
            Server.sharedInstance.LoadCompaniesWithFilters(findingParams, page: self.currentPage)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("companyCell") as! CompanyCell

        let row = indexPath.row
        cell.logo.image = Server.sharedInstance.loadedCompanies[row].logoImage
        cell.name.text = Server.sharedInstance.loadedCompanies[row].ownershipAndName
        cell.reliabilityLabel.text = "Надёжность \(Server.sharedInstance.loadedCompanies[row].reliability)%"
        
        let percent = CGFloat(Server.sharedInstance.loadedCompanies[row].reliability)/CGFloat(100)
        cell.reliabilityImageWidthConstraint.constant = cell.reliabilityBack.frame.width * percent - cell.reliabilityBack.frame.width
        self.view.layoutIfNeeded()
        
        
        var numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.groupingSeparator = "."
        
        
        var helpLabel = UILabel()
        cell.minZakaz.text = "\(numberFormatter.stringFromNumber(Server.sharedInstance.loadedCompanies[row].minimalBudget)!) BYR"
        helpLabel.frame = CGRectMake(0,0,2000,2000)
        helpLabel.font = cell.minZakaz.font
        helpLabel.text = cell.minZakaz.text
        helpLabel.sizeToFit()
        cell.minZakazWidthConstraint.constant = max(helpLabel.frame.width, 70)
        
        cell.za1kmLabel.text = "\(numberFormatter.stringFromNumber(Server.sharedInstance.loadedCompanies[row].ratePerKM)!) BYR"
        helpLabel.frame = CGRectMake(0,0,2000,2000)
        helpLabel.font = cell.za1kmLabel.font
        helpLabel.text = cell.za1kmLabel.text
        helpLabel.sizeToFit()
        cell.za1kmWidthConstraint.constant = max(helpLabel.frame.width, 55)
        
        cell.za1hLabel.text = "\(numberFormatter.stringFromNumber(Server.sharedInstance.loadedCompanies[row].ratePerHour)!) BYR"
        helpLabel.frame = CGRectMake(0,0,2000,2000)
        helpLabel.font = cell.za1hLabel.font
        helpLabel.text = cell.za1hLabel.text
        helpLabel.sizeToFit()
        cell.za1hWidthConstraint.constant = max(helpLabel.frame.width, 55)
        
        if(Server.sharedInstance.loadedCompanies[row].ratePerHour == 0)
        {
            cell.za1hBackground.hidden = true
            cell.za1hHelpLabel.hidden = true
            cell.za1hLabel.hidden = true
        }
        
        if(Server.sharedInstance.loadedCompanies[row].ratePerKM == 0)
        {
            cell.za1kmBackground.hidden = true
            cell.za1kmHelpLabel.hidden = true
            cell.za1kmLabel.hidden = true
        }
        
        if(Server.sharedInstance.loadedCompanies[row].minimalBudget == 0)
        {
            cell.minZakazBackground.hidden = true
            cell.minZakazHelpLabel.hidden = true
            cell.minZakaz.hidden = true
        }
        
        cell.descriptionLabel.text = Server.sharedInstance.loadedCompanies[row].descr
        cell.addressLabel.text = Server.sharedInstance.loadedCompanies[row].location
        
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






