//
//  __bngWebPage.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation

public class __bngWebPage {
    
    public static func getSource(url:String)->String? {
        var source:String?=nil
        let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let main = URL(string: url) else {
            return nil
        }
        do {
            source = try String(contentsOf: main, encoding: .utf8)
        } catch let error {
            print("Error: \(error)")
        }
        return source
    }
}
