//
//  ViewController.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class BaseView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.revealViewController() != nil
        {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.revealViewController().rearViewRevealWidth = 300
        if let font = UIFont(name: "Roboto-Regular", size: 16)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        }
        self.navigationItem.title = "Мои объявления"
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "OrdersLoaded:",
            name:"OrdersLoaded",
            object: nil)
        
//        Server.sharedInstance.BecomeUserInfo()
        Server.sharedInstance.ActivityOrders()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func OrdersLoaded(notification: NSNotification)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            self.tableView.reloadData()
        }
    }
    
    //MARK: Table view delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        println(Server.sharedInstance.loadedOrders.count)
        return Server.sharedInstance.loadedOrders.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("infoCell") as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = Server.sharedInstance.loadedOrders[row].goodName
        cell.backgroundColor = UIColor.orangeColor()
        
        if(cell.textLabel?.text == "")
        {
            cell.textLabel?.text = "Без названия"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        let orderView: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VZMap") as UIViewController
        let orderView: OrderView = self.storyboard?.instantiateViewControllerWithIdentifier("OrderView") as! OrderView
        orderView.currentOrder = Server.sharedInstance.loadedOrders[indexPath.row]
        self.navigationController?.pushViewController(orderView, animated: true)
    }
}

