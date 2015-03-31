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
                
                
                
                if(jsonDic.objectForKey("status") as String == "ok")
                {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: kVZIsLoginCompleteKey)
                    var userInfo: UserInfo = self.GetUserInfoFromServerData(jsonDic.objectForKey("data") as NSDictionary)
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
            println(string1)
            
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
                println(string1)
                self.saveCookies()
                if(jsonDic.objectForKey("status") as String == "ok")
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
            if(jsonDic.objectForKey("status") as String == "ok")
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
                if(jsonDic.objectForKey("status") as String == "ok")
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
//        println(userInfo.description)
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
                
            if((jsonDic.objectForKey("status") as String) == "ok")
            {
                Server.sharedInstance.loadedOrders = self.GetOrdersArrayFromServerData(jsonDic.objectForKey("data") as [NSDictionary])
                
                NSNotificationCenter.defaultCenter().postNotificationName("OrdersLoaded", object: nil)
            }
            else
            {
            }
                
            var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
//            println("\(jsonDic)")
        }) { (error) -> () in
                println("error: \(error)")
        }
    }
    
    
    /// parse user data from server to UserInfo struct
    ///
    /// :param: serverData NSDictionary data with userInfo from Server
    ///
    /// :returns: Object of UserInfo class with userInfo
    func GetUserInfoFromServerData(serverData: NSDictionary) -> UserInfo
    {
        var retUserInfo: UserInfo = GetUserInfo()
        
        var userName: String = serverData.objectForKey("username") as String
        var personName: String = serverData.objectForKey("personname") as String
        var location: String = serverData.objectForKey("location") as String
        var email: String = ""
        if let emailTemp: String = serverData.objectForKey("email") as? String
        {
            email = emailTemp
        }
        var notifyByEmail: Bool = ((serverData.objectForKey("notify_by_email") as String).toInt() == 0) ? false : true
        var phoneNumber: String = serverData.objectForKey("phone") as String
        var notifyByPhone: Bool = ((serverData.objectForKey("notify_by_phone") as String).toInt() == 0) ? false : true
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
                    logos.append(path as String)
                }
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
                gFromAddress: order.objectForKey("from_address")! as String,
                gFromStreet: order.objectForKey("from_street")! as String,
                gFromHouse: order.objectForKey("from_house")! as String,
                gToAddress: order.objectForKey("to_address")! as String,
                gToStreet: order.objectForKey("to_street")! as String,
                gToHouse: order.objectForKey("to_house")! as String,
                gFromDate: order.objectForKey("from_date")! as String,
                gToDate: order.objectForKey("to_date")! as String,
                gHelpLoad: helpLoad,
                gHelpUload: helpUnLoad,
                gGoodName: order.objectForKey("good_name")! as String,
                gWeight: weight,
                gLength: length,
                gHeight: height,
                gWidth: width,
                gBaggage: baggage,
                gPassagersCount: passagersCount,
                gStatViews: statViews,
                gLogos: logos,
                gOffers: [OfferInfo()])
            
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
            var cookiesDataUnarchived: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(cookiesData as NSData)
            if((cookiesDataUnarchived) != nil)
            {
                var cookies: NSArray! = cookiesDataUnarchived as NSArray
                var cookieStorage: NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
                for cookie in cookies
                {
                    cookieStorage.setCookie(cookie as NSHTTPCookie)
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