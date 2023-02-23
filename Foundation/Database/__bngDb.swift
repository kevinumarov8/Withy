//
//  __bngDb.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong

public class __bngDb : _bngDb {
    
    @discardableResult public static func configure(dbname:String)->Bool {
        return _bngDb().initialize(dbname:dbname)
    }
    public static func end() { _bngDb().destroy() }
}
