//
//  TextFieldWithMargin.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class TextFieldWithMarginAndShadow: TextFieldWithMargin
{
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        
        if(self.alpha > 0.1)
        {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(RGBA: "dcdcdc").CGColor



        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(RGBA: "dcdcdc").CGColor
        
        var imageShadow: UIImageView = UIImageView(frame: CGRectMake(self.bounds.origin.x + 8, self.bounds.origin.y + self.bounds.height, self.bounds.width - 16, 1))
        imageShadow.backgroundColor = UIColor.darkGrayColor()
        imageShadow.alpha = 0.1
        self.addSubview(imageShadow)
        
//
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        }
//        self.layer.shadowColor = UIColor.grayColor().CGColor
//        self.layer.shadowRadius = 5
//        self.layer.shadowOpacity = 0.7
//        self.layer.shadowOffset = CGSizeMake(0, 2)
//        
//        var path: CGMutablePathRef = CGPathCreateMutable()
//        CGPathAddRect(path, nil, CGRectInset(self.bounds, -42, -42))
//        
//        var someInnerPath: CGPathRef = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10.0).CGPath
//        CGPathAddPath(path, nil, someInnerPath)
//        CGPathCloseSubpath(path)
//        
////        var path = UIBezierPath(rect: self.bounds).CGPath
//        self.layer.shadowPath = path
    }
}

class TextFieldWithMargin: UITextField
{    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5);
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= (padding.top * 2) - padding.bottom
        newBounds.size.width -= (padding.left * 2) - padding.right
        
        
        
        return newBounds
    }
}