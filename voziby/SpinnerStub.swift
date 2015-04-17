//
//  SpinnerStub.swift
//  voziby
//
//  Created by Fedar Trukhan on 05.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

public class SpinnerStub: NSObject
{
    var backImageView: UIImageView
    var spinner: UIActivityIndicatorView
    var image2: UIImageView
    
    override init()
    {
        self.backImageView = UIImageView()
        self.spinner = UIActivityIndicatorView()
        self.image2 = UIImageView()
        super.init()
    }
    
    ///A thread safe singleton object of Server class
    class var sharedInstance: SpinnerStub
    {
        struct Static
        {
            static var instance: SpinnerStub?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)
            {
                Static.instance = SpinnerStub()
        }
        
        return Static.instance!
    }
    
    
    public class func show()
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            if(!self.sharedInstance.spinner.isAnimating())
            {
                let window = UIApplication.sharedApplication().windows.first as! UIWindow
                self.sharedInstance.backImageView = UIImageView(image: self.captureScreen(window).blurredImageWithRadius(2, iterations: 5, tintColor: UIColor.clearColor()))
                
                self.sharedInstance.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
                self.sharedInstance.spinner.color = UIColor.darkGrayColor()
                self.sharedInstance.spinner.center = window.center
                self.sharedInstance.spinner.alpha = 1
            
                self.sharedInstance.spinner.startAnimating()
                
                self.sharedInstance.backImageView.alpha = 1
                
                window.addSubview(self.sharedInstance.backImageView)
                window.addSubview(self.sharedInstance.spinner)
            }
        }
    }
    
    public class func hide()
    {
        if(self.sharedInstance.spinner.isAnimating())
        {
            NSOperationQueue.mainQueue().addOperationWithBlock
            {
                self.sharedInstance.backImageView.alpha = 0
                self.sharedInstance.spinner.alpha = 0
                self.sharedInstance.spinner.stopAnimating()
                self.sharedInstance.spinner.removeFromSuperview()
                self.sharedInstance.backImageView.removeFromSuperview()
            }
        }
    }
    
    private class func captureScreen(window: UIWindow) -> UIImage
    {
        var windowLayer = window.layer
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 1.0)
        windowLayer.renderInContext(UIGraphicsGetCurrentContext())
        var screenImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return screenImage;
    }
}
