//
//  __bngDefaultProperties.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong

public class __bngDefaultProperties : _bngTable {
    override public func onCreate(sql:String?)->Bool {
        return super.onCreate(sql: "CREATE TABLE IF NOT EXISTS TBL_DEFAULT_PROPERTIES (pid INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT UNIQUE ON CONFLICT REPLACE, value TEXT)")
    }
    @discardableResult static func set(key:String, value:String)->Bool{
        
        let sql = String(format: "INSERT INTO TBL_DEFAULT_PROPERTIES (key, value) VALUES (\"%@\", \"%@\")", key, value)
        return __bngDefaultProperties().set(sql: sql)
    }
    static func get(key:String, defaultValue:String?="") ->String? {
        let sql = String(format: "SELECT value FROM TBL_DEFAULT_PROPERTIES WHERE key='%@'", key)
        let result:String? = __bngDefaultProperties().get(sql: sql)
        return (result == nil || result!.isEmpty ) ? defaultValue : result
    }
}
