//
//  __bngNumber.swift
//  ChocspoApp
//
//  Created by 김봉희 on 2020/01/01.
//  Copyright © 2020 김봉희. All rights reserved.
//

import Foundation

class __bngNumber {
    
    public static func percentage(percentage:Float, total:Float)->Float {
        if total == 0 {
            return 0
        }
        return (percentage * total) / 100.0
    }
    public static func percentage(value:Float, total:Float)->Float {
        if total == 0 {
            return 0
        }
        return value / total * 100.0
    }
    
}
