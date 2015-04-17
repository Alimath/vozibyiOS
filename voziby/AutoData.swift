//
//  AutoData.swift
//  voziby
//
//  Created by Fedar Trukhan on 08.04.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//
import UIKit

enum AutoType: Int
{
    case Passenger = 1
    case Minivan = 2
    case Jeep = 3
    case Special = 4
    case Microbus = 5
    case Limousine = 6
    case Moto = 7
}

class AutoData : NSObject
{
    var category: AutoType = AutoType.Passenger
    var cost: Int = 0
    var currency: String = "USD"
    
    func SetData(aCategory: AutoType, aCost: Int, aCurrency: String)
    {
        self.category = aCategory
        self.cost = aCost
        self.currency = aCurrency
    }
    
    init(aCategory: AutoType, aCost: Int, aCurrency: String)
    {
        self.category = aCategory
        self.cost = aCost
        self.currency = aCurrency
    }
}

func AutoTypeToStringWithCount(autoType: AutoType, categoryCount: Int) -> String
{
    var categoryName: String = ""
    switch autoType
    {
    case AutoType.Passenger:
        if(categoryCount > 1)
        {
            categoryName = "\(categoryCount) легковых"
        }
        else
        {
            categoryName = "легковой"
        }
    case AutoType.Special:
        if(categoryCount > 1)
        {
            categoryName = "\(categoryCount) спец. транспорта"
        }
        else
        {
            categoryName = "спец. транспорт"
        }
    case AutoType.Jeep:
        if(categoryCount > 1)
        {
            categoryName = "\(categoryCount) джипа"
        }
        else
        {
            categoryName = "джип"
        }
    case AutoType.Limousine:
        if(categoryCount > 1)
        {
            categoryName = "\(categoryCount) лимузина"
        }
        else
        {
            categoryName = "лимузин"
        }
    case AutoType.Microbus:
        if(categoryCount > 1)
        {
            categoryName = "\(categoryCount) микроавтобуса"
        }
        else
        {
            categoryName = "микроавтобус"
        }
    case AutoType.Minivan:
        if(categoryCount > 1)
        {
            categoryName = "\(categoryCount) минивэна"
        }
        else
        {
            categoryName = "минивэн"
        }
    case AutoType.Moto:
        if(categoryCount > 1)
        {
            categoryName = "\(categoryCount) мотоцикла"
        }
        else
        {
            categoryName = "мотоцикл"
        }
        
    default: println("undefined category \(autoType.rawValue)")
    }
    
    return categoryName
}