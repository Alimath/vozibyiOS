//
//  UserInfo.swift
//  voziby
//
//  Created by Fedar Trukhan on 02.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

struct UserInfo
{
    var userName: String
    var personName: String
    var location: String
    var email: String
    var notifyByEmail: Bool
    var phoneNumber: String
    var notifyByPhone: Bool
    var logoPath: String
    var passwordMD5: String
    
    var description: String
    {
        var descr: String = "username: \(userName), personname: \(personName), location: \(location), email: \(email), notifyEmail: \(notifyByEmail), phoneNumber: \(phoneNumber), notifyPhone: \(notifyByPhone), logo: \(logoPath)"
        
        return descr
    }
}

func SaveUserInfo(userinfo: UserInfo)
{
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    userDefaults.setObject(userinfo.userName, forKey: kVZUsernameKey)
    userDefaults.setObject(userinfo.personName, forKey: kVZNameKey)
    userDefaults.setObject(userinfo.location, forKey: kVZLocationKey)
    userDefaults.setObject(userinfo.email, forKey: kVZEmailKey)
    userDefaults.setBool(userinfo.notifyByEmail, forKey: kVZNotifyByEmailKey)
    userDefaults.setObject(userinfo.phoneNumber, forKey: kVZPhoneNumberKey)
    userDefaults.setBool(userinfo.notifyByPhone, forKey: kVZNotifyByPhoneKey)
    userDefaults.setObject(userinfo.logoPath, forKey: kVZLogoPath)
    userDefaults.setObject(userinfo.passwordMD5, forKey: kVZPasswordKey)
    
    userDefaults.synchronize()
}

func GetUserInfo() -> UserInfo
{
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    if let username = userDefaults.objectForKey(kVZUsernameKey) as? String
    {
        let userName = userDefaults.objectForKey(kVZUsernameKey) as String
        let personName = userDefaults.objectForKey(kVZNameKey) as String
        let location = userDefaults.objectForKey(kVZLocationKey) as String
        let email = userDefaults.objectForKey(kVZEmailKey) as String
        let notifyByEmail = userDefaults.boolForKey(kVZNotifyByEmailKey)
        let phoneNumber = userDefaults.objectForKey(kVZPhoneNumberKey) as String
        let notifyByPhone = userDefaults.boolForKey(kVZNotifyByPhoneKey)
        let logoPath = userDefaults.objectForKey(kVZLogoPath) as String
        let password = userDefaults.objectForKey(kVZPasswordKey) as String
        
        var userInfo: UserInfo = UserInfo(userName: userName, personName: personName, location: location, email: email, notifyByEmail: notifyByEmail, phoneNumber: phoneNumber, notifyByPhone: notifyByPhone, logoPath: logoPath, passwordMD5: password)
        return userInfo
    }
    
    return UserInfo(userName: "", personName: "", location: "", email: "", notifyByEmail: false, phoneNumber: "", notifyByPhone: false, logoPath: "", passwordMD5: "")
}