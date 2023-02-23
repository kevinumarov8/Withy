//
//  __bngJson.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import SwiftDictionaryCoding

class __bngJson {
    public static func decode<T>(type: T.Type, dic:Dictionary<String,Any>)throws -> T where T : Decodable {
        return try! DictionaryDecoder().decode(type, from: dic)
    }
    public static func encode<T>(value: T) throws -> [String: Any] where T : Encodable {
        return try! DictionaryEncoder().encode(value)
    }
}
