//
//  CompanyInfo.swift
//  voziby
//
//  Created by Fedar Trukhan on 31.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

class CompanyInfo
{
    var id: Int = 0
    var organizationType: String = ""
    var name: String = ""
    var ownershipAndName: String = ""
    var logo: String = ""
    var ratePerHour: Int = 0
    var ratePerKM: Int = 0
    var minimalBudget: Int = 0
    var email: [String] = []
    var phones: [String] = []
    var skype: [String] = []
    var website: String = ""
    var slug: String = ""
    var worktimeList: Bool = false
    var descr: String = ""
    var reliability: Int = 0
    var urAddress: String = ""
    var location: String = ""
    
    var specialityPassager: Bool = false
    var specialityCargo: Bool = false
    var spcialityCars: Bool = false
    var spcialityFurniture: Bool = false

    /// o1
    var uoGidrolift:Bool = false
    /// o11
    var uoTable:Bool = false
    /// o12
    var uoRegSidenija:Bool = false
    /// o13
    var uoCooler:Bool = false
    /// o14
    var uoWC:Bool = false
    /// o15
    var uoWiFi:Bool = false
    /// o16 c3
    var uoFurnitureUtil:Bool = false
    /// o17 c4
    var uoFurniturePack:Bool = false
    /// o18 c5
    var uoFurnitureAssembly:Bool = false
    /// o19 c6
    var uoCleanRoom:Bool = false
    /// o2
    var uoTV:Bool = false
    /// o20
    var uoLebedka:Bool = false
    /// o21
    var uoSdvigPlatform:Bool = false
    /// o22
    var uoGidromanipulator:Bool = false
    /// o27
    var uoSanpasport:Bool = false
    /// o29
    var uoTopZagruzka: Bool = false
    /// o4
    var uoMiniBar:Bool = false
    /// o6
    var uoZadZagruzka:Bool = false
    /// o7
    var uoBokZagruzka:Bool = false
    /// c1
    var uoLoadUnload:Bool = false
    /// c2
    var uoGarbageExport:Bool = false
    
    
    
//    var specialityCargoLoad: Bool = false
//    var specialityCargoUnload: Bool = false
    
    var cashPayment: Bool = false
    var nocashPayment: Bool = false
    var cardPayment: Bool = false
    var onlinePayment: Bool = false
    
    var logoImage: UIImage? = nil
    var countries: [String] = []
}