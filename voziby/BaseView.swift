//
//  ViewController.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class BaseView: UIViewController
{
    @IBOutlet weak var menuButton: UIBarButtonItem!
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
        
//        Server.sharedInstance.LoadOrders()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "AvatarViewShouldShow:",
            name:"AvatarViewOpen",
            object: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AvatarViewShouldShow(notification: AnyObject)
    {
        let photoPickView: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AvatarPicker") as UIViewController
        self.navigationController?.pushViewController(photoPickView, animated: true)
        revealViewController().revealToggle(self)
    }
}

