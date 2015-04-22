//
//  TransportInfo.swift
//  voziby
//
//  Created by Fedar Trukhan on 22.04.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

class TransportInfo
{
    var id: Int = 0
    var type: Int = 0
    var carType: Int = 0
    var companyID: Int = 0
    var mark: String = ""
    var model: String = ""
    var modelType: String = ""
    var year: String = ""
    var length: Int = 0
    var width: Int = 0
    var height: Int = 0
    var seats: Int = 0
    var baggage: Int = 0
    var payload: Int = 0
    var volume: Float = 0
    var carsCount: Int = 0
    var carsPayload: Int = 0
    var temperatureFrom: Int = 0
    var temperatureTo: Int = 0
    var europalet: Int = 0
    var minimalCost: Int = 0
    var payPerHour: Int = 0
    var payPerKm: Int = 0
    var descr: String = ""
    var images: [UIImage] = []
    
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
}