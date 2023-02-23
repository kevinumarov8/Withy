//
//  __bngCrypto.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong
import CryptoSwift
import CommonCrypto

class __bngCrypto : _bngCrypto {
    public static func encrypt(key: String, iv: String, target:String) -> String? {
        do {
            let aes = try AES(key: key, iv: iv)
            let cipherArray = try aes.encrypt(Array(target.utf8))
            let data = NSData(bytes: cipherArray, length: cipherArray.count)
            let base64Data = data.base64EncodedData(options: [.endLineWithLineFeed])
            let base64String = String(data: base64Data as Data, encoding: String.Encoding.utf8)
            return base64String
        } catch {
            return nil
        }
    }
    public static func decrypt(key: String, iv: String, base64:String) -> String? {
        do {
            let aes = try AES(key: key, iv: iv)
            let aData = base64.data(using: String.Encoding.utf8)! as Data
            let dData = NSData(base64Encoded: aData, options: [])
            guard let data = dData else {
                return nil
            }
            var aBuffer = Array<UInt8>(repeating: 0, count: data.length)
            data.getBytes(&aBuffer, length: data.length)
            let decrypted = try aes.decrypt(aBuffer)
            let string = String(data: Data(decrypted), encoding: .utf8)
            return string
        } catch {
            return nil
        }
    }
    public static func sha1(data:Data) -> String {
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
