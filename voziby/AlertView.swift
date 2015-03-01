//
//  AlertView.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

func ShowAlertView(delegate: UIViewController, title: String, message: String, closeButtonTitle: String)
{
    NSOperationQueue.mainQueue().addOperationWithBlock
    {
        if(GetSystemVersion() >= 8)
        {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: closeButtonTitle, style: UIAlertActionStyle.Default,handler: nil))
            
            delegate.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            var alertView = UIAlertView()
            alertView.title = title
            alertView.message = message
            alertView.addButtonWithTitle(closeButtonTitle)
            
            alertView.show()
        }
    }
}