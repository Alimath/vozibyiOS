//
//  OffersInfo.swift
//  voziby
//
//  Created by Fedar Trukhan on 26.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//
import UIKit

enum OffersStatus: Int
{
    case InProgress = 0
    case Decline = 8
}

class OfferInfo : NSObject
{
    var id: Int = 0
    var status: OffersStatus = OffersStatus.InProgress
    var companyID: Int = 0
    var cost: Int = 0
    
    override var description: String
    {
        return "ID: \(id), status: \(status.rawValue), companyID: \(companyID), cost: \(cost)"
    }
    
    func SetInfo(oID: Int, oStatus: OffersStatus, oCompanyID: Int, oCost: Int)
    {
        self.id = oID
        self.status = oStatus
        self.companyID = oCompanyID
        self.cost = oCost
    }
}