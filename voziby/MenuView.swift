//
//  MenuView.swift
//  voziby
//
//  Created by Fedar Trukhan on 02.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class MenuView: UIViewController
{
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var WidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var newAdverstsBack: UIImageView!
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if(avatarImage.frame.origin.y < 0)
        {
            var size = HeightConstraint.constant
            size = size + avatarImage.frame.origin.y
            size -= 30
            HeightConstraint.constant = size
            WidthConstraint.constant = size
            
            self.avatarImage.layer.cornerRadius = size / 2
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.newAdverstsBack.backgroundColor = UIColor.blackColor()
        self.newAdverstsBack.alpha = 0.2
        self.newAdverstsBack.layer.cornerRadius = 8
        
        var userInfo: UserInfo = GetUserInfo()
        if(userInfo.logoPath != "")
        {
            let logoFullPath = DocumentsPathForFileName(kVZLogoFileNameKey)
            let logoImageData = NSData(contentsOfFile: logoFullPath)
            let logoImage = UIImage(data: logoImageData!)
            avatarImage.image = logoImage
        }
        nameLabel.text = userInfo.personName
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "AvatarUpdate:",
            name:"avatarUpdated",
            object: nil)
//        nameLabel.text = userDefaults.objectForKey(kVZNameKey) as? String
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AvatarUpdate(notification: NSNotification)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            let logoFullPath = DocumentsPathForFileName(kVZLogoFileNameKey)
            let logoImageData = NSData(contentsOfFile: logoFullPath)
            let logoImage = UIImage(data: logoImageData!)
            self.avatarImage.image = logoImage
        }
    }
    
    @IBAction func addAdvert(sender: AnyObject)
    {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
                case UISwipeGestureRecognizerDirection.Left:
                    NSNotificationCenter.defaultCenter().postNotificationName("menuCLoseSwipe", object: nil)
            default:
                break
            }
        }
    }
    
    @IBAction func avatarTouchUpInside(sender: AnyObject)
    {
        let photoPickView: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AvatarPicker") as UIViewController
        revealViewController().revealToggle(self)
        (self.revealViewController().frontViewController as UINavigationController).pushViewController(photoPickView, animated: true)
    }
    
    @IBAction func settingsTouchUpInside(sender: AnyObject)
    {
        if((self.revealViewController().frontViewController as UINavigationController).viewControllers[0].isKindOfClass(SettingsView))
        {
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            return
        }
        
        let settingsView: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Settings") as UIViewController
        var navC = UINavigationController(rootViewController: settingsView)
        self.revealViewController().pushFrontViewController(navC, animated: true)
    }
    
    @IBAction func baseViewShow(sender: AnyObject)
    {
        if((self.revealViewController().frontViewController as UINavigationController).viewControllers[0].isKindOfClass(BaseView))
        {
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            return
        }
        
        let baseView: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BaseView") as UIViewController
        var navC = UINavigationController(rootViewController: baseView)

        self.revealViewController().pushFrontViewController(navC, animated: true)
    }
    
}
