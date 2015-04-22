//
//  CountryView.swift
//  voziby
//
//  Created by Fedar Trukhan on 22.04.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class CountryView: UIView
{
    let countryArrow: UIImageView! = UIImageView(image: UIImage(named: "countriesArrow"))
    var countryLabel: UILabel! = UILabel()
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        // Drawing code
        self.backgroundColor = UIColor.whiteColor()
        self.countryArrow.frame = CGRectMake(24,6,15,14)
        self.countryLabel.frame = CGRectMake(47,3,273,19)
        
        if let font = UIFont(name: "Roboto-Regular", size: 16)
        {
            self.countryLabel.font = font
        }
        self.countryLabel.textColor = UIColor(RGBA: "373737")

        self.addSubview(self.countryArrow)
        self.addSubview(self.countryLabel)
    }

    

}
