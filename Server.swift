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
                    Server.sharedInstance.GetAvatar(userInfo.logoPath)
                    
                    self.saveCookies()
                }
                else
                {
                    
                }
            })
            { (error) -> () in
                println("error: \(error)")
        }
    }
    
    func Logout()
    {
        let url = "api/logout"
        self.loadCookies()
        net.GET(url, params: nil, successHandler:
            { (responseData) -> () in
            
        }) { (error) -> () in
            println("error: \(error)")
        }
    }
    
    func Register(personName: String, location: String, username: String, password: String, smsCode: String)
    {
        let url = "api/register"
        let params = ["personname": personName, "location": location, "username": username, "password": password, "sms": smsCode]
        net.POST(url, params: params, successHandler:
            { (responseData) -> () in
                let jsonDic: NSDictionary = responseData.json(error: nil)!
                var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
                println(string1)
                self.saveCookies()
                if(jsonDic.objectForKey("status") as String == "ok")
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("registersuccesfully", object: nil)
                }
                else
                {
                    NSNotificationCenter.defaultCenter().postNotificationName("registererror", object: nil)
                }
                
            }) { (error) -> () in
                println("error: \(error)")
        }
    }
    
    func SendSMS(phoneNumber: String)
    {
        let url = "api/smsCode"
        let params = ["phone": phoneNumber]
        
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
//        let url = "api/аvatar"
        
//        let base64String = UIImagePNGRepresentation(image).base64EncodedStringWithOptions(.allZeros)
//        let params = ["upload": UIImagePNGRepresentation(image)]
//        let imgUrl = "http://api.x9.sandbox.hcbogdan.com/api/аvatar"
        
        self.loadCookies()
        
//        let image = UIImage(named: "image_file")
//        let imageData = UIImagePNGRepresentation(image)
        let imageString = UIImagePNGRepresentation(image).base64EncodedStringWithOptions(.allZeros)
        var userInfo = GetUserInfo()
        

//        let params = ["upload": "imageString"]
        
//        net.POST(absoluteUrl: imgUrl, params: params, successHandler:
//        { (responceData) -> () in
//            println("данные ушли: ")
//        }) { (error) -> () in
//            println("ошибка передачи аватара: \(error)")
//        }
        
        let url = "api/аvatar"
        let params = ["upload": imageString]
        
        println(params)
        
        net.POST(url, params: params, successHandler:
            { (responseData) -> () in
                let jsonDic: NSDictionary = responseData.json(error: nil)!
                var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
                println(string1)
                self.saveCookies()
                if(jsonDic.objectForKey("status") as String == "ok")
                {
                    println("123")
//                    NSNotificationCenter.defaultCenter().postNotificationName("registersuccesfully", object: nil)
                }
                else
                {
                    println("312")
//                    NSNotificationCenter.defaultCenter().postNotificationName("registererror", object: nil)
                }
                
            }) { (error) -> () in
                println("error: \(error)")
        }
        
//        let task = net.upload(absoluteUrl: imgUrl, params: params, progressHandler: { progress in
//            NSLog("progress: \(progress)")
////            self.setProgress(self.imgProgressView, progress: progress)
//            }, completionHandler: { error in
//                NSLog("Upload completed")
//        })
//        if(task == nil)
//        {
//            println("123")
//        }
//        self.imgUploadTask = task
    }
    
    func LoadOrders()
    {
        let url = "/api/orders"
        self.loadCookies()
        
        
        net.GET(url, params: nil, successHandler:
        { (responseData) -> () in
            
            let jsonDic: NSDictionary = responseData.json(error: nil)!
            
            var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
            println(string1)
            println("orders load")
            }) { (error) -> () in
                println("error")
        }
    }
    
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
    
    /// parse user data from server to UserInfo class
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