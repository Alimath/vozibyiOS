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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var userInfo: UserInfo = GetUserInfo()
        if(userInfo.logoPath != "")
        {
            println("change logo")
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
//        nameLabel.text = userDefaults.objectForKey(kVZNameKey) as? String
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        NSNotificationCenter.defaultCenter().postNotificationName("AvatarViewOpen", object: nil)
    }
}
