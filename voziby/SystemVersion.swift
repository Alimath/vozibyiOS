//
//  SystemVersion.swift
//  voziby
//
//  Created by Fedar Trukhan on 01.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

func GetSystemVersion() -> Int
{
    switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
    case .OrderedSame, .OrderedDescending:
        return 8
    case .OrderedAscending:
        return 7
    }
}

func DocumentsPathForFileName(name: String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
    let path = paths[0] as String;
    let fullPath = path.stringByAppendingPathComponent(name)
    
    return fullPath
}