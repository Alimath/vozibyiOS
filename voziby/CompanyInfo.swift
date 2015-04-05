//
//  CompanyInfo.swift
//  voziby
//
//  Created by Fedar Trukhan on 31.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class CompanyInfo : NSObject
{
    var id: Int = 0
    var name: String = ""
    var rateBYR: Int = 0
    var ratePerHour: Int = 0
    var ratePerKM: Int = 0
    var minimalBudget: Int = 0
    var email: [String] = []
    var phones: [String] = []
    var skype: [String] = []
    var logo: String = ""
    var organizationType: String = ""
    var descr: String = ""
    var reliability: Int = 0
    var urAddress: String = ""
    var specialityPassager: Bool = false
    var specialityCargo: Bool = false
    var specialityCargoLoad: Bool = false
    var specialityCargoUnload: Bool = false
    var cashPayment: Bool = false
    var nocashPayment: Bool = false
    var cardPayment: Bool = false
    var onlinePayment: Bool = false
    var webpayPayment: Bool = false
    var slug: String = ""
    var website: [String] = []
    var worktimeFrom: String = ""
    var worktimeTo: String = ""
    var day1: Bool = false
    var day2: Bool = false
    var day3: Bool = false
    var day4: Bool = false
    var day5: Bool = false
    var day6: Bool = false
    var day7: Bool = false
}