//
//  Server.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import Foundation
import UIKit

let net = Net(baseUrlString: "http://api.x9.sandbox.hcbogdan.com/")
var instance: Server?

class Server
{
    var loadedOrders: [OrderInfo] = []
    var loadedCompanies: [CompanyInfo] = []
    var companyTransport: [TransportInfo] = []
    
    ///A thread safe singleton object of Server class
    class var sharedInstance: Server
    {
        struct Static
        {
            static var instance: Server?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)
            {
                Static.instance = Server()
        }
        
        return Static.instance!
    }
    
    
    func Authorization(username: String, password: String)
    {
        let url = "api/login"
        let params = ["username": username, "password": password]
        
        SpinnerStub.show()
        
        
        
        net.GET(url, params: params, successHandler:
            { responseData in
                let jsonDic: NSDictionary = responseData.json(error: nil)!
                
//                var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
//                println(string1)
                
                
                
                if(jsonDic.objectForKey("status") as! String == "ok")
                {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: kVZIsLoginCompleteKey)
                    var userInfo: UserInfo = self.GetUserInfoFromServerData(jsonDic.objectForKey("data") as! NSDictionary)
                    userInfo.passwordMD5 = password
                    SaveUserInfo(userInfo)
                    self.saveCookies()
                    Server.sharedInstance.GetAvatar(userInfo.logoPath)
                }
                else
                {
                    
                }
            })
            { (error) -> () in
                println("error: \(error)")
        }
    }
    
    func ServerLogout()
    {
        let url = "api/logout"
        self.loadCookies()
        net.GET(url, params: nil, successHandler:
        { (responseData) -> () in
            var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
//            println(string1)
            
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(false, forKey: kVZIsLoginCompleteKey)
            
            NSNotificationCenter.defaultCenter().postNotificationName("serverLogout", object: nil)
        }) { (error) -> () in
            println("error: \(error)")
        }
    }
    
    func Register(personName: String, location: String, username: String, password: String, smsCode: String)
    {
        let url = "api/register"
        let params = ["personname": personName, "location": location, "username": username, "password": password, "sms": smsCode]
        
        SpinnerStub.show()        
        net.POST(url, params: params, successHandler:
            { (responseData) -> () in
                let jsonDic: NSDictionary = responseData.json(error: nil)!
                var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
//                println(string1)
                self.saveCookies()
                if(jsonDic.objectForKey("status") as! String == "ok")
                {
                    var userInfo: UserInfo = UserInfo(userName: username, personName: personName, location: location, email: "", notifyByEmail: false, phoneNumber: username, notifyByPhone: false, logoPath: "", passwordMD5: password)
                    SaveUserInfo(userInfo)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("registersuccesfully", object: nil)
                    SpinnerStub.hide()
                }
                else
                {
                    SpinnerStub.hide()
                    NSNotificationCenter.defaultCenter().postNotificationName("registererror", object: nil)
                }
                
            }) { (error) -> () in
                println("error: \(error)")
        }
    }
    
    func SendSMS(phoneNumber: String)
    {
        let url = "api/verify"
        let params = ["phone": phoneNumber, "need" : "register"]
        
        SpinnerStub.show()
        
        net.GET(url, params: params, successHandler:
        { (responseData) -> () in
            SpinnerStub.hide()
            let jsonDic: NSDictionary = responseData.json(error: nil)!
            if(jsonDic.objectForKey("status") as! String == "ok")
            {
                println(jsonDic)
                NSNotificationCenter.defaultCenter().postNotificationName("smssend", object: nil)
            }
            else
            {
                NSNotificationCenter.defaultCenter().postNotificationName("smssenderror", object: nil)
            }
        })
        { (error) -> () in
            NSNotificationCenter.defaultCenter().postNotificationName("smssenderror", object: nil)
            SpinnerStub.hide()
        }
    }
    
    func SessionUpdate()
    {
        let url = "api/personalInfo"
        self.loadCookies()
        var userInfo = GetUserInfo()
        println("+" + userInfo.userName)
        self.Authorization(userInfo.userName, password: userInfo.passwordMD5)
    }
    
    func SetAvatar(image: UIImage)
    {
        SpinnerStub.show()
        
        VZisMultiPart = true
        let imageString = UIImagePNGRepresentation(image).base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        
        let url = "api/avatar"
        let params = ["upload": imageString]
        self.loadCookies()
        
        
        
        net.POST(url, params: params, successHandler:
            { (responseData) -> () in
                let jsonDic: NSDictionary = responseData.json(error: nil)!
                var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
//                println(string1)
                if(jsonDic.objectForKey("status") as! String == "ok")
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("avatarUpdated", object: nil)
//                    println("123")
//                    NSNotificationCenter.defaultCenter().postNotificationName("registersuccesfully", object: nil)
                }
                else
                {
//                    println("312")
//                    NSNotificationCenter.defaultCenter().postNotificationName("registererror", object: nil)
                }
                VZisMultiPart = false
                SpinnerStub.hide()
            })
            { (error) -> () in
                VZisMultiPart = false
                SpinnerStub.hide()
                println("error: \(error)")
        }
    }
    
//    func LoadOrders()
//    {
//        let url = "/api/orders"
//        self.loadCookies()
//        
//        
//        net.GET(url, params: nil, successHandler:
//        { (responseData) -> () in
//            
//            let jsonDic: NSDictionary = responseData.json(error: nil)!
//            
//            var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
//            println(jsonDic)
//            println("orders load")
//            }) { (error) -> () in
//                println("error")
//        }
//    }
    
    func GetAvatar(logoPath: String)
    {
        var logo: UIImage = UIImage()
        let url = logoPath
        
        self.loadCookies()
        if(GetUserInfo().logoPath != "")
        {
            net.GET(url, params: nil, successHandler: { (responseData) -> () in
                var error: NSErrorPointer = nil
                var logo = responseData.image(error: error)
                
                let relativePath = kVZLogoFileNameKey
                let path = DocumentsPathForFileName(relativePath)
                responseData.data.writeToFile(path, atomically: true)
    
                SpinnerStub.hide()
                NSNotificationCenter.defaultCenter().postNotificationName(kVZLoginCompleteKey, object: nil)
                
                }) { (error) -> () in
                    println("error")
            }
        }
        else
        {
            println("no logo")
            SpinnerStub.hide()
            NSNotificationCenter.defaultCenter().postNotificationName(kVZLoginCompleteKey, object: nil)
        }
    }
    
    func LoadOrderImageWithPath(path: String)
    {
        var image: UIImage = UIImage()
        
        self.loadCookies()
        
        net.GET(path, params: nil, successHandler: { (responseData) -> () in
            var error: NSErrorPointer = nil
            var image = responseData.image(error: error)
            
            NSNotificationCenter.defaultCenter().postNotificationName(kVZOrderImageLoaded, object: image)
        }) { (error) -> () in
            println("error: \(error)")
        }
    }
    
    func BecomeUserInfo()
    {
        var url = "api/personalinfo"
        var params = ["action":"view"]
        
        self.loadCookies()
        
        net.POST(url, params: params, successHandler:
        { (responseData) -> () in
            
            var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
            println("\(string1)")
        }) { (error) -> () in
            println("error: \(error)")
        }
    }
    
    func UpdateUserInfo(userInfo:UserInfo)
    {
        SpinnerStub.show()
        
        var url = "api/personalinfo"
        
        var nMail: String = "0"
        var nPhone: String = "0"
        
        if(userInfo.notifyByEmail == false)
        {
            nMail = "0"
        }
        else
        {
            nMail = "1"
        }
        if(userInfo.notifyByPhone == false)
        {
            nPhone = "0"
        }
        else
        {
            nPhone = "1"
        }
        
        var params = ["action" : "update", "data": ["username":userInfo.userName, "personname":userInfo.personName, "location":userInfo.location, "email":userInfo.email, "notify_by_email":nMail, "phone":userInfo.phoneNumber, "notify_by_phone":nPhone]]
        
        println("params: \(params)")
        net.POST(url, params: params, successHandler:
            { (responseData) -> () in
                SpinnerStub.hide()
                var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
                println("done update: \(string1)")
                
            })
            { (error) -> () in
                SpinnerStub.hide()
                println("error: \(error)")
            }
        
        Server.sharedInstance.BecomeUserInfo()
    }
    
    func ActivityOrders()
    {
        var url = "/api/orders"
        
        self.loadCookies()
        net.POST(url, params: nil, successHandler:
            { (responseData) -> () in
            let jsonDic: NSDictionary = responseData.json(error: nil)!
            if((jsonDic.objectForKey("status") as! String) == "ok")
            {
                Server.sharedInstance.loadedOrders = self.GetOrdersArrayFromServerData(jsonDic.objectForKey("data") as! [NSDictionary])
                
                NSNotificationCenter.defaultCenter().postNotificationName("OrdersLoaded", object: nil)
            }
            else
            {
            }
                
            var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
//            println("\(string1)")
        }) { (error) -> () in
                println("error: \(error)")
        }
    }
    
    func LoadTransportWithCompanyID(companyID: Int)
    {
        var params: [String:String] = [String:String]()
        params.updateValue("\(companyID)", forKey: "CompanyTransport[company_id]")
        params.updateValue("id.asc", forKey: "sort")
        
        var url = "/api/transport"
        
        net.POST(url, params: params, successHandler:
            { (responseData) -> () in
            let jsonDic: NSDictionary = responseData.json(error: nil)!
            if((jsonDic.objectForKey("status") as! String) == "ok")
            {
                
//                let string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
//                println("\(string1)")
                
                
                self.companyTransport = self.GetTranportArrayFromServerData(jsonDic.objectForKey("data") as! [NSDictionary])
                NSNotificationCenter.defaultCenter().postNotificationName("TransportLoadComplete", object: nil)
            }
            else
            {
            }
            
            }) { (error) -> () in
                println("error: \(error)")
        }
    }
    
    func LoadCompaniesWithFilters(filters: [String:String], page: Int)
    {
        if(page == 0)
        {
            Server.sharedInstance.loadedCompanies = []
        }
        var params: [String:String] =  filters
        params.updateValue("\(page)", forKey: "page")
        var url = "/api/companies"//transport?CompanyTransport[id]=63"
//        println(filters)
        net.POST(url, params: params, successHandler:
            { (responseData) -> () in
                let jsonDic: NSDictionary = responseData.json(error: nil)!
                if((jsonDic.objectForKey("status") as! String) == "ok")
                {
                    
                    let string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
//                    println("\(string1)")   

                    
                    var companiesArray = self.GetCompaniesArrayFromServerData(jsonDic.objectForKey("data") as! [NSDictionary])

                    if(companiesArray.count > 0)
                    {
                        for item in companiesArray
                        {
                            Server.sharedInstance.loadedCompanies.append(item)
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName("CompaniesLoad", object: nil)
                    }
                    else
                    {
                        NSNotificationCenter.defaultCenter().postNotificationName("LastPageReached", object: nil)
                    }
                    

                }
                else
                {
                }
                
            }) { (error) -> () in
                println("error: \(error)")
        }
    }
    
    // MARK: Parsers
    
    /// parse user data from server to UserInfo struct
    ///
    /// :param: serverData NSDictionary data with userInfo from Server
    ///
    /// :returns: Object of UserInfo class with userInfo
    func GetUserInfoFromServerData(serverData: NSDictionary) -> UserInfo
    {
        var retUserInfo: UserInfo = GetUserInfo()
        
        var userName: String = serverData.objectForKey("username") as! String
        var personName: String = serverData.objectForKey("personname") as! String
        var location: String = serverData.objectForKey("location") as! String
        var email: String = ""
        if let emailTemp: String = serverData.objectForKey("email") as? String
        {
            email = emailTemp
        }
        var notifyByEmail: Bool = ((serverData.objectForKey("notify_by_email") as! String).toInt() == 0) ? false : true
        var phoneNumber: String = serverData.objectForKey("phone") as! String
        var notifyByPhone: Bool = ((serverData.objectForKey("notify_by_phone") as! String).toInt() == 0) ? false : true
        var logo: String = ""
        if let logoTemp: String =  serverData.objectForKey("logo") as? String
        {
            logo = logoTemp
        }
        
        retUserInfo.userName = userName
        retUserInfo.personName = personName
        retUserInfo.location = location
        retUserInfo.email = email
        retUserInfo.notifyByEmail = notifyByEmail
        retUserInfo.phoneNumber = phoneNumber
        retUserInfo.notifyByPhone = notifyByPhone
        retUserInfo.logoPath = logo
        
        return retUserInfo
    }
    
    func GetTranportArrayFromServerData(serverData: [NSDictionary]) -> [TransportInfo]
    {
        var arrayWithTransport: [TransportInfo] = []
        
        for transport in serverData
        {
            var transportInfo: TransportInfo = TransportInfo()
            
            if let id = transport.objectForKey("id")!.integerValue
            {
                transportInfo.id = id
            }
            if let type = transport.objectForKey("type")!.integerValue
            {
                transportInfo.type = type
            }
            if let carType = transport.objectForKey("car_type")!.integerValue
            {
                transportInfo.carType = carType
            }
            if let companyID = transport.objectForKey("company_id")!.integerValue
            {
                transportInfo.companyID = companyID
            }
            if let mark = transport.objectForKey("mark") as? String
            {
                transportInfo.mark = mark
            }
            if let model = transport.objectForKey("model") as? String
            {
                transportInfo.model = model
            }
            if let modelType = transport.objectForKey("modeltype") as? String
            {
                transportInfo.modelType = modelType
            }
            if let year = transport.objectForKey("year") as? String
            {
                transportInfo.year = year
            }
            if let length = transport.objectForKey("length")!.integerValue
            {
                transportInfo.length = length
            }
            if let width = transport.objectForKey("width")!.integerValue
            {
                transportInfo.width = width
            }
            if let height = transport.objectForKey("height")!.integerValue
            {
                transportInfo.height = height
            }
            if let seats = transport.objectForKey("seats")!.integerValue
            {
                transportInfo.seats = seats
            }
            if let baggage = transport.objectForKey("baggage")!.integerValue
            {
                transportInfo.baggage = baggage
            }
            if let payload = transport.objectForKey("payload")!.integerValue
            {
                transportInfo.payload = payload
            }
            if let volume = transport.objectForKey("volume")!.floatValue
            {
                transportInfo.volume = volume
            }
            if let carsCount = transport.objectForKey("cars_count")!.integerValue
            {
                transportInfo.carsCount = carsCount
            }
            if let carsPayload = transport.objectForKey("cars_payload")!.integerValue
            {
                transportInfo.carsPayload = carsPayload
            }
            if let temperatureFrom = transport.objectForKey("temperature_from")!.integerValue
            {
                transportInfo.temperatureFrom = temperatureFrom
            }
            if let temperatureTo = transport.objectForKey("temperature_to")!.integerValue
            {
                transportInfo.temperatureTo = temperatureTo
            }
            if let europalet = transport.objectForKey("europalet")!.integerValue
            {
                transportInfo.europalet = europalet
            }
            if let minimalCost = transport.objectForKey("minimal_cost")!.integerValue
            {
                transportInfo.minimalCost = minimalCost
            }
            if let payPerHour = transport.objectForKey("payPerHour")!.integerValue
            {
                transportInfo.payPerHour = payPerHour
            }
            if let payPerKm = transport.objectForKey("payPerKm")!.integerValue
            {
                transportInfo.payPerKm = payPerKm
            }
            if let description = transport.objectForKey("description") as? String
            {
                transportInfo.descr = description
            }
            
            if let uniqueOptions = transport.objectForKey("unique_options") as? [[String:String]]
            {
                for item in uniqueOptions
                {
                    switch (item[item.indexForKey("id")!].1)
                    {
                    case "o1":
                        transportInfo.uoGidrolift = true
                    case "o11":
                        transportInfo.uoTable = true
                    case "o12":
                        transportInfo.uoRegSidenija = true
                    case "o13":
                        transportInfo.uoCooler = true
                    case "o14":
                        transportInfo.uoWC = true
                    case "o15":
                        transportInfo.uoWiFi = true
                        
                    case "o16":
                        transportInfo.uoFurnitureUtil = true
                    case "c3":
                        transportInfo.uoFurnitureUtil = true
                        
                    case "o17":
                        transportInfo.uoFurniturePack = true
                    case "c4":
                        transportInfo.uoFurniturePack = true
                        
                    case "o18":
                        transportInfo.uoFurnitureAssembly = true
                    case "c5":
                        transportInfo.uoFurnitureAssembly = true
                        
                    case "o19":
                        transportInfo.uoCleanRoom = true
                    case "c6":
                        transportInfo.uoCleanRoom = true
                        
                    case "o2":
                        transportInfo.uoTV = true
                    case "o20":
                        transportInfo.uoLebedka = true
                    case "o21":
                        transportInfo.uoSdvigPlatform = true
                    case "o22":
                        transportInfo.uoGidromanipulator = true
                    case "o27":
                        transportInfo.uoSanpasport = true
                    case "o29":
                        transportInfo.uoTopZagruzka = true
                    case "o4":
                        transportInfo.uoMiniBar = true
                    case "o6":
                        transportInfo.uoZadZagruzka = true
                    case "o7":
                        transportInfo.uoBokZagruzka = true
                    case "c1":
                        transportInfo.uoLoadUnload = true
                    case "c2":
                        transportInfo.uoGarbageExport = true
                    default:
                        println(item[item.indexForKey("id")!].1)
                    }
                }
            }
            
            if let logoData = transport.objectForKey("images_content") as? [String]
            {
                for logo in logoData
                {
                    if let imageData = NSData(base64EncodedString: logo, options: NSDataBase64DecodingOptions.allZeros)
                    {
                        if let image = UIImage(data: imageData)
                        {
                            transportInfo.images.append(image)
                        }
                    }
                }
            }
            
            arrayWithTransport.append(transportInfo)
            
        }
        
        return arrayWithTransport
    }
    
    func GetCompaniesArrayFromServerData(serverData: [NSDictionary]) -> [CompanyInfo]
    {
        var arrayWithCompanies: [CompanyInfo] = []
        
        for company in serverData
        {
            var companyInfo: CompanyInfo = CompanyInfo()
            
            if let id = company.objectForKey("id")!.integerValue
            {
                companyInfo.id = id
            }
            if let organizationType = company.objectForKey("organization_type") as? String
            {
                companyInfo.organizationType = organizationType
            }
            if let name = company.objectForKey("name") as? String
            {
                companyInfo.name = name
            }
            if let ownershipAndName = company.objectForKey("ownership_and_name") as? String
            {
                companyInfo.ownershipAndName = ownershipAndName
            }
            if let logo = company.objectForKey("logo") as? String
            {
                companyInfo.logo = logo
            }
            if let perh = company.objectForKey("rate_per_hour")!.integerValue
            {
                companyInfo.ratePerHour = perh
            }
            if let perkm = company.objectForKey("rate_per_km")!.integerValue
            {
                companyInfo.ratePerKM = perkm
            }
            if let minb = company.objectForKey("minmal_budget")!.integerValue
            {
                companyInfo.minimalBudget = minb
            }
            if let emails = company.objectForKey("email") as? [String]
            {
                companyInfo.email = emails
            }
            if let phones = company.objectForKey("phones") as? [String]
            {
                companyInfo.phones = phones
            }
            if let skypes = company.objectForKey("skype") as? [String]
            {
                companyInfo.skype = skypes
            }
            if let webs = company.objectForKey("website") as? String
            {
                companyInfo.website = webs
            }
            if let slug = company.objectForKey("slug") as? String
            {
                companyInfo.slug = slug
            }
            if let location = company.objectForKey("location") as? String
            {
                companyInfo.location = location
            }
            if let workTimeList = company.objectForKey("worktimeList")!.boolValue
            {
                companyInfo.worktimeList = workTimeList
            }
            if let description = company.objectForKey("description") as? String
            {
                companyInfo.descr = description
            }
//            if let reliability = company.objectForKey("reliability")!.integerValue
//            {
//                companyInfo.reliability = reliability
//            }
            if let urAddress = company.objectForKey("ur_address") as? String
            {
                companyInfo.urAddress = urAddress
            }
            if let spcialityPassager = company.objectForKey("spciality_passager")!.boolValue
            {
                companyInfo.specialityPassager = spcialityPassager
            }
            if let spcialityCargo = company.objectForKey("spciality_cargo")!.boolValue
            {
                companyInfo.specialityCargo = spcialityCargo
            }
            if let spcialityCars = company.objectForKey("spciality_cars")!.boolValue
            {
                companyInfo.spcialityCars = spcialityCars
            }
            if let spcialityFurniture = company.objectForKey("spciality_furniture")!.boolValue
            {
                companyInfo.spcialityFurniture = spcialityFurniture
            }
//            if let spcialityCargoLoad = company.objectForKey("spciality_cargo_load")!.boolValue
//            {
//                companyInfo.specialityCargoLoad = spcialityCargoLoad
//            }
//            if let spcialityCargoUnload = company.objectForKey("spciality_cargo_unload")!.boolValue
//            {
//                companyInfo.specialityCargoUnload = spcialityCargoUnload
//            }
            if let cashPayment = company.objectForKey("cash_payment")!.boolValue
            {
                companyInfo.cashPayment = cashPayment
            }
            if let noCashPayment = company.objectForKey("nocash_payment")!.boolValue
            {
                companyInfo.nocashPayment = noCashPayment
            }
            if let cardPayment = company.objectForKey("card_payment")!.boolValue
            {
                companyInfo.cardPayment = cardPayment
            }
            if let onlinePayment = company.objectForKey("online_payment")!.boolValue
            {
                companyInfo.onlinePayment = onlinePayment
            }
            if let logoData = company.objectForKey("logo_content") as? String
            {
                companyInfo.logoImage = UIImage(data: NSData(base64EncodedString: logoData, options: NSDataBase64DecodingOptions.allZeros)!)
            }
            if let countries = company.objectForKey("countries") as? [[String:String]]
            {
                for item in countries
                {
                    companyInfo.countries.append(item[item.indexForKey("name")!].1)
                }
            }
            if let uniqueOptions = company.objectForKey("unique_options") as? [[String:String]]
            {
                for item in uniqueOptions
                {
                    switch (item[item.indexForKey("id")!].1)
                    {
                    case "o1":
                        companyInfo.uoGidrolift = true
                    case "o11":
                        companyInfo.uoTable = true
                    case "o12":
                        companyInfo.uoRegSidenija = true
                    case "o13":
                        companyInfo.uoCooler = true
                    case "o14":
                        companyInfo.uoWC = true
                    case "o15":
                        companyInfo.uoWiFi = true
                        
                    case "o16":
                        companyInfo.uoFurnitureUtil = true
                    case "c3":
                        companyInfo.uoFurnitureUtil = true
                        
                    case "o17":
                        companyInfo.uoFurniturePack = true
                    case "c4":
                        companyInfo.uoFurniturePack = true
                        
                    case "o18":
                        companyInfo.uoFurnitureAssembly = true
                    case "c5":
                        companyInfo.uoFurnitureAssembly = true
                        
                    case "o19":
                        companyInfo.uoCleanRoom = true
                    case "c6":
                        companyInfo.uoCleanRoom = true
                        
                    case "o2":
                        companyInfo.uoTV = true
                    case "o20":
                        companyInfo.uoLebedka = true
                    case "o21":
                        companyInfo.uoSdvigPlatform = true
                    case "o22":
                        companyInfo.uoGidromanipulator = true
                    case "o27":
                        companyInfo.uoSanpasport = true
                    case "o29":
                        companyInfo.uoTopZagruzka = true
                    case "o4":
                        companyInfo.uoMiniBar = true
                    case "o6":
                        companyInfo.uoZadZagruzka = true
                    case "o7":
                        companyInfo.uoBokZagruzka = true
                    case "c1":
                        companyInfo.uoLoadUnload = true
                    case "c2":
                        companyInfo.uoGarbageExport = true
                    default:
                        println(item[item.indexForKey("id")!].1)
                    }
                }
            }
        
            arrayWithCompanies.append(companyInfo)
        }
        
        return arrayWithCompanies
    }
    
    /// parse array of order infos from server to array of OrderInfo ojbects
    ///
    /// :param: serverData NSArray data with orders info from Server
    ///
    /// :returns: Array of OrderInfos classes
    func GetOrdersArrayFromServerData(serverData: [NSDictionary]) -> [OrderInfo]
    {
        var arrayWithOrders: [OrderInfo] = []
        
        for order in serverData
        {
            var orderInfo: OrderInfo = OrderInfo()
            
            var transportType: TransportType = TransportType.Goods
            if let test = order.objectForKey("transport_type")!.integerValue
            {
                switch test
                {
                case 1:
                    transportType = TransportType.Goods
                case 2:
                    transportType = TransportType.Passangers
                case 3:
                    transportType = TransportType.Furniture
                case 4:
                    transportType = TransportType.Evacuator
                default:
                    transportType = TransportType.Goods
                }
            }
            
            var ID: Int = 0
            if let test = order.objectForKey("id")!.integerValue
            {
                ID = test
            }
            
            var status: OrderStatus = OrderStatus.Closed
            if let test = order.objectForKey("status")!.integerValue
            {
                switch test
                {
                    case 1:
                    status = OrderStatus.Created
                    case 2:
                    status = OrderStatus.InProgress
                    case 3:
                    status = OrderStatus.Closed
                    default:
                    status = OrderStatus.Closed
                }
            }
            
            var budget: Int = 0
            if let test = order.objectForKey("budget_byr")!.integerValue
            {
                budget = test
            }
            
            var cashPayment: Bool = false
            if let test = order.objectForKey("cash_payment")!.integerValue
            {
                if(test == 1)
                {
                    cashPayment = true
                }
            }
            
            var noCashPayment: Bool = false
            if let test = order.objectForKey("nocash_payment")!.integerValue
            {
                if(test == 1)
                {
                    noCashPayment = true
                }
            }
            
            var cardPayment: Bool = false
            if let test = order.objectForKey("card_payment")!.integerValue
            {
                if(test == 1)
                {
                    cardPayment = true
                }
            }
            
            var onlinePayment: Bool = false
            if let test = order.objectForKey("online_payment")!.integerValue
            {
                if(test == 1)
                {
                    onlinePayment = true
                }
            }
            
            var webPayment: Bool = false
            if let test = order.objectForKey("webpay_payment")!.integerValue
            {
                if(test == 1)
                {
                    webPayment = true
                }
            }
            
            var distance: Float = 0
            if let test = order.objectForKey("distance")!.floatValue
            {
                distance = test
            }
            
            var helpLoad: Bool = false
            if let test = order.objectForKey("help_load")!.integerValue
            {
                if(test == 1)
                {
                    helpLoad = true
                }
            }
            
            var helpUnLoad: Bool = false
            if let test = order.objectForKey("help_unload")!.integerValue
            {
                if(test == 1)
                {
                    helpUnLoad = true
                }
            }
            
            var weight: Float = 0
            if let test = order.objectForKey("weight")!.floatValue
            {
                weight = test
            }
            
            var length: Float = 0
            if let test = order.objectForKey("length")!.floatValue
            {
                length = test
            }
            
            var height: Float = 0
            if let test = order.objectForKey("height")!.floatValue
            {
                height = test
            }
            
            var width: Float = 0
            if let test = order.objectForKey("width")!.floatValue
            {
                width = test
            }
            
            var statViews: Int = 0
            if let test = order.objectForKey("stat_views")!.integerValue
            {
                statViews = test
            }
            
            var baggage: Float = 0
            if let test = order.objectForKey("baggage")!.floatValue
            {
                baggage = test
            }
            
            var passagersCount: Int = 0
            if let test = order.objectForKey("passagers_count")!.integerValue
            {
                passagersCount = test
            }
            
            var logos: [String] = []
            if let ass: NSDictionary = order.objectForKey("logos") as? NSDictionary
            {
                for (name, path) in ass
                {
                    logos.append(path as! String)
                }
            }
            
            
            var offers: [OfferInfo] = []
            if let offersArray: NSArray = order.objectForKey("offers") as? NSArray
            {
                if(offersArray.count > 0)
                {
                    for i in 0...(offersArray.count-1)
                    {
                        if let offerDic: NSDictionary = offersArray.objectAtIndex(i) as? NSDictionary
                        {
                            let offer: OfferInfo = OfferInfo()
                            var companyID: Int = offerDic.objectForKey("company_id")!.integerValue
                            var offercost: Int = offerDic.objectForKey("cost")!.integerValue
                            var offerID: Int = offerDic.objectForKey("id")!.integerValue
                            var offerStatus: OffersStatus
                            
                            if let status:OffersStatus = OffersStatus(rawValue: offerDic.objectForKey("status")!.integerValue)
                            {
                                offerStatus = status
                            }
                            else
                            {
                                offerStatus = OffersStatus.InProgress
                            }
                            
                            offer.SetInfo(offerID, oStatus: offerStatus, oCompanyID: companyID, oCost: offercost)
                            offers.append(offer)
                        }
                    }
                }
            }
            
            
            var datesFromArray: [NSDate] = []
            var fromDateString: String = order.objectForKey("from_date")! as! String
            if(fromDateString != "")
            {
                var datesStringArray = split(fromDateString) {$0 == ","}
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                for oneDateString in datesStringArray
                {
                    var oneDate = dateFormatter.dateFromString(oneDateString)
                    datesFromArray.append(oneDate!)
                }
            }
            
            
            var datesToArray: [NSDate] = []
            var toDate: String = order.objectForKey("to_date")! as! String
            if(toDate != "")
            {
                var datesStringArray = split(toDate) {$0 == ","}
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                var datesArray: [NSDate] = []
                for oneDateString in datesStringArray
                {
                    var oneDate = dateFormatter.dateFromString(oneDateString)
                    datesToArray.append(oneDate!)
                }
            }
            
            //дополнительные опции
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
            
            var furnitureUtilization: Bool = false
            
            if let options: [NSDictionary] = order.objectForKey("options") as? [NSDictionary]
            {
                
                for option in options
                {
                    if let id = option.objectForKey("id")!.integerValue
                    {
                        switch id
                        {
                        case 2: tv = true
                        case 4: miniBar = true
                        case 11: table = true
                        case 12: adjustableSeats = true
                        case 13: cooler = true
                        case 1: gidrolift = true
                        case 6: backLoading = true
                        case 7: sideLoading = true
                        case 26: gidroCart = true
                        case 20: winch = true
                        case 21: slidingPlatform = true
                        case 22: gidroManipulator = true
                        case 16: furnitureUtilization = true
                        default: println("no found ID in options: \(id)")
                        }
                    }
                }
            }
            
            if let cardeliverys: [NSDictionary] = order.objectForKey("cardelivery") as? [NSDictionary]
            {
                for cardelivery in cardeliverys
                {
                    if let id = cardelivery.objectForKey("id")!.integerValue
                    {
                        switch id
                        {
                        case 1: blockTheWheel = true
                        case 2: inCuvette = true
                        case 3: blockControl = true
                        case 4: divorcedWheel = true
                        case 5: emergencyState = true
                        case 6: damagedSuspension = true
                        default: println("no found ID in cardelivery: \(id)")
                        }
                    }
                }
            }
            
            var carDatasList: [AutoData] = []
            if let carDataList: [NSDictionary] = order.objectForKey("autoDatalist") as? [NSDictionary]
            {
                var carCategory: AutoType = AutoType.Passenger
                var carCost: Int = 0
                var carCurrency: String = "USD"
                
                for carData in carDataList
                {
                    
                    var numberFormatter: NSNumberFormatter = NSNumberFormatter()
                    numberFormatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
                    numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                    numberFormatter.groupingSeparator = "."
                    
                    if let category = carData.objectForKey("category")!.integerValue
                    {
                        if let autoTypeCategory = AutoType(rawValue: category)
                        {
                            carCategory = autoTypeCategory
                        }
                    }
                    if let cost = carData.objectForKey("cost")! as? String
                    {
                        carCost = numberFormatter.numberFromString(cost)!.integerValue
                    }
                    
                    carCurrency = carData.objectForKey("currency")! as! String
                    
                    var autoData: AutoData = AutoData(aCategory: carCategory, aCost: carCost, aCurrency: carCurrency)
                    carDatasList.append(autoData)
                }
            }
            
            var autoDescription: String = ""
            if let autoDescriptionTest = order.objectForKey("auto_description")! as? String
            {
                autoDescription = autoDescriptionTest
            }
            
            orderInfo.SetInfo(
                ID,
                gTransportType: transportType,
                gStatus: status,
                gBudget: budget,
                gCashPayment: cashPayment,
                gNocashPayment: noCashPayment,
                gCardPayment: cardPayment,
                gOnlinePayment: onlinePayment,
                gWebpayPayment: webPayment,
                gDistance: distance,
                gFromAddress: order.objectForKey("from_address")! as! String,
                gFromStreet: order.objectForKey("from_street")! as! String,
                gFromHouse: order.objectForKey("from_house")! as! String,
                gToAddress: order.objectForKey("to_address")! as! String,
                gToStreet: order.objectForKey("to_street")! as! String,
                gToHouse: order.objectForKey("to_house")! as! String,
                gFromDate: datesFromArray,
                gToDate: datesToArray,
                gHelpLoad: helpLoad,
                gHelpUload: helpUnLoad,
                gGoodName: order.objectForKey("good_name")! as! String,
                gWeight: weight,
                gLength: length,
                gHeight: height,
                gWidth: width,
                gBaggage: baggage,
                gPassagersCount: passagersCount,
                gStatViews: statViews,
                gLogos: logos,
                gOffers: offers,
                gAutoDescription: autoDescription,
                gGidroLift: gidrolift,
                gBackLoading: backLoading,
                gSideLoading: sideLoading,
                gGidrocart: gidroCart,
                gTV: tv,
                gTable: table,
                gCooler: cooler,
                gMiniBar: miniBar,
                gAdjustableSeats: adjustableSeats,
                gDivorcedWheel: divorcedWheel,
                gBlockTheWheel: blockTheWheel,
                gInCuvette: inCuvette,
                gBlockControll: blockControl,
                gEmergencyState: emergencyState,
                gDamagedSuspension: damagedSuspension,
                gWinch: winch,
                gGidroManipulator: gidroManipulator,
                gSlidingPlatform: slidingPlatform,
                gFurnitureUtilization: furnitureUtilization,
                gAutoDataList: carDatasList
            )
            
            arrayWithOrders.append(orderInfo)
        }
        
        return arrayWithOrders
    }
    
    //MARK: -
    //MARK: work with cookies
    
    ///save current cookies with NSKeyedArchiver to standrt user defaults
    func saveCookies()
    {
        var cookiesData = NSKeyedArchiver.archivedDataWithRootObject(NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!)
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(cookiesData, forKey: "sessionCookies")
        defaults.synchronize()
    }
    
    ///load saved cookies with NSKeyedArchiver from standrt user defaults
    func loadCookies()
    {
        var defaults = NSUserDefaults.standardUserDefaults()
        var cookiesData: AnyObject? = defaults.objectForKey("sessionCookies")
        if(cookiesData != nil)
        {
            var cookiesDataUnarchived: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(cookiesData as! NSData)
            if((cookiesDataUnarchived) != nil)
            {
                var cookies: NSArray! = cookiesDataUnarchived as! NSArray
                var cookieStorage: NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
                for cookie in cookies
                {
                    cookieStorage.setCookie(cookie as! NSHTTPCookie)
                }
            }
        }
    }
}


extension NSMutableData {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// :param: string       The string to be added to the `NSMutableData`.
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}