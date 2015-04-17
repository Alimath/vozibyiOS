//
//  OrderInfo.swift
//  voziby
//
//  Created by Fedar Trukhan on 26.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

enum TransportType: Int
{
    case Goods = 1
    case Passangers = 2
    case Furniture = 3
    case Evacuator = 4
}

enum OrderStatus: Int
{
    case Created = 1
    case InProgress = 2
    case Closed = 3
}

class OrderInfo : NSObject
{
    var id: Int = 0
    var transportType: TransportType = .Goods
    var status: OrderStatus = .Created
    var budgetBYR: Int = 0
    var cashPayment: Bool = false
    var nocashPayment: Bool = false
    var cardPayment: Bool = false
    var onlinePayment: Bool = false
    var webpayPayment: Bool = false
    var distance: Float = 0
    var fromAddress: String = ""
    var fromStreet: String = ""
    var fromHouse: String = ""
    var toAddress: String = ""
    var toStreet: String = ""
    var toHouse: String = ""
    var fromDate: [NSDate] = []
    var toDate: [NSDate] = []
    var helpLoad: Bool = false
    var helpUnload: Bool = false
    var goodName: String = ""
    var weight: Float = 0
    var length: Float = 0
    var height: Float = 0
    var width: Float = 0
    var baggage: Float = 0
    var passagersCount: Int = 0
    var statViews: Int = 0
    var logos:[String] = []
    var offers: [OfferInfo] = []
    
    var autoDescription: String = ""
    
    //важно наличие груз
    var gidrolift: Bool = false
    var backLoading: Bool = false
    var sideLoading: Bool = false
    var gidroCart: Bool = false
    
    //важно наличие пассажиры
    var tv: Bool = false
    var table: Bool = false
    var cooler: Bool = false
    var miniBar: Bool = false
    var adjustableSeats: Bool = false
    
    //примечание авто
    var divorcedWheel: Bool = false
    var blockTheWheel: Bool = false
    var inCuvette: Bool = false
    var blockControl: Bool = false
    var emergencyState: Bool = false
    var damagedSuspension: Bool = false
    //важно наличие авто
    var winch: Bool = false
    var gidroManipulator: Bool = false
    var slidingPlatform: Bool = false
    
    //для мебели
    var furnitureUtilization: Bool = false
    
    var autoDataList: [AutoData] = []
    
//    override var description: String
//    {
//        let descr: String = ("ID: \(id), name: \(goodName) \ntype: \(transportType), status: \(status), budget: \(budgetBYR), cash: \(cashPayment), nocash: \(nocashPayment), card: \(cardPayment), online: \(onlinePayment), webpay: \(webpayPayment), distance: \(distance), \nfrom: \(fromAddress), \(fromStreet), \(fromHouse) - \(fromDate), \nto: \(toAddress), \(toStreet), \(toHouse) - \(toDate), \nhelpLoad: \(helpLoad), helpUnload: \(helpUnload), \nweight: \(weight), length: \(length), heigth: \(height), width: \(width), baggage: \(baggage), passengers: \(passagersCount), views: \(statViews)\nLogos: \(logos)")
//        
//        return descr
//    }
    
    func SetInfo(gID: Int, gTransportType: TransportType, gStatus: OrderStatus, gBudget: Int, gCashPayment: Bool, gNocashPayment: Bool, gCardPayment: Bool, gOnlinePayment: Bool, gWebpayPayment: Bool, gDistance: Float, gFromAddress: String, gFromStreet: String, gFromHouse: String, gToAddress: String, gToStreet: String, gToHouse: String, gFromDate: [NSDate], gToDate: [NSDate], gHelpLoad: Bool, gHelpUload: Bool, gGoodName: String, gWeight: Float, gLength: Float, gHeight: Float, gWidth: Float, gBaggage: Float, gPassagersCount: Int, gStatViews: Int, gLogos: [String], gOffers: [OfferInfo], gAutoDescription: String, gGidroLift: Bool, gBackLoading: Bool, gSideLoading: Bool, gGidrocart: Bool, gTV: Bool, gTable: Bool, gCooler: Bool, gMiniBar: Bool, gAdjustableSeats: Bool, gDivorcedWheel: Bool, gBlockTheWheel: Bool, gInCuvette: Bool, gBlockControll: Bool, gEmergencyState: Bool, gDamagedSuspension: Bool, gWinch: Bool, gGidroManipulator: Bool, gSlidingPlatform: Bool, gFurnitureUtilization: Bool, gAutoDataList: [AutoData])
    {
        self.id = gID
        self.transportType = gTransportType
        self.status = gStatus
        self.budgetBYR = gBudget
        self.cashPayment = gCashPayment
        self.nocashPayment = gNocashPayment
        self.cardPayment = gCardPayment
        self.onlinePayment = gOnlinePayment
        self.webpayPayment = gWebpayPayment
        self.distance = gDistance
        self.fromAddress = gFromAddress
        self.fromStreet = gFromStreet
        self.fromHouse = gFromHouse
        self.toAddress = gToAddress
        self.toStreet = gToStreet
        self.toHouse = gToHouse
        self.fromDate = gFromDate
        self.toDate = gToDate
        self.helpLoad = gHelpLoad
        self.helpUnload = gHelpUload
        self.goodName = gGoodName
        self.weight = gWeight
        self.length = gLength
        self.height = gHeight
        self.width = gWidth
        self.baggage = gBaggage
        self.passagersCount = gPassagersCount
        self.statViews = gStatViews
        self.logos = gLogos
        self.offers = gOffers
        self.autoDescription = gAutoDescription
        
        //важно наличие груз
        self.gidrolift = gGidroLift
        self.backLoading = gBackLoading
        self.sideLoading = gSideLoading
        self.gidroCart = gGidrocart
        
        //важно наличие пассажиры
        self.tv = gTV
        self.table = gTable
        self.cooler = gCooler
        self.miniBar = gMiniBar
        self.adjustableSeats = gAdjustableSeats
        
        //примечание авто
        self.divorcedWheel = gDivorcedWheel
        self.blockTheWheel = gBlockTheWheel
        self.inCuvette = gInCuvette
        self.blockControl = gBlockControll
        self.emergencyState = gEmergencyState
        self.damagedSuspension = gDamagedSuspension
        self.winch = gWinch
        self.gidroManipulator = gGidroManipulator
        self.slidingPlatform = gSlidingPlatform
        
        //мебель
        self.furnitureUtilization = gFurnitureUtilization
        
        self.autoDataList = gAutoDataList
    }
    
}