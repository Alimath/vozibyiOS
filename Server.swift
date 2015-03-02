//
//  Server.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import Foundation

let net = Net(baseUrlString: "http://x9.sandbox.hcbogdan.com/")
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
        
        net.GET(url, params: params, successHandler:
            { responseData in
                let jsonDic: NSDictionary = responseData.json(error: nil)!
                
//                println(jsonDic)
                var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
                println(string1)
                
                self.saveCookies()
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
                if(jsonDic.objectForKey("status") as String == "ok")
                {
                    println(jsonDic)
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
        
        net.GET(url, params: params, successHandler:
        { (responseData) -> () in
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
        }
    }
    
    func SessionUpdate()
    {
        let url = "api/personalInfo"
        self.loadCookies()
        net.GET(url, params: nil, successHandler:
            { (responseData) -> () in
                let jsonDic: NSDictionary = responseData.json(error: nil)!
                var string1 = NSString(data: responseData.data, encoding: NSUTF8StringEncoding)
                println(string1)
                if(jsonDic.objectForKey("status") as String == "fail")
                {
                    println("Relogin")
                }
                
            }) { (error) -> () in
                println("error: \(error)")
        }
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