//
//  Server.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import Foundation

let net = Net(baseUrlString: "http://taxi5.by/")
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
    
    func getAddress(text: String)
    {
        let url = "api/locator/search"
        let params = ["q": "воло"]
        
        net.GET(url, params: params, successHandler:
            { responseData in
                let result = responseData.data
                var string1 = NSString(data: result, encoding: NSUTF8StringEncoding)
                var JSONArray: NSArray = NSJSONSerialization.JSONObjectWithData(responseData.data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                
                //            FoundPlaceObjects.sharedInstance.parsePlaceObjects(JSONArray)
                
                NSNotificationCenter.defaultCenter().postNotificationName("loadStreets", object: nil, userInfo: ["info" : "\(string1)"])
                //            println(JSONArray)
            })
            { (error) -> () in
                //            println(error)
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
        var cookies: NSArray! = NSKeyedUnarchiver.unarchiveObjectWithData(cookiesData as NSData) as? NSArray
        var cookieStorage: NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in cookies
        {
            cookieStorage.setCookie(cookie as NSHTTPCookie)
        }
    }
}