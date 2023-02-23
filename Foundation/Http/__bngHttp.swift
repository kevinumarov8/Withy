//
//  __bngHttp.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Alamofire

public class __bngHttp {
    
    static let shared : __bngHttp = {
        let instance = __bngHttp()
        return instance
    }()
    
    public static let Ok = 1
    public static let Error = 0
    public static let Code = "code"
    public static let Description = "description"
    public static let ErrorCode = "error_code"
    public static let LocalizedError = -8080
    
    private var server_address:String? = nil
    private var callback:((Int, String, NSDictionary) -> ())? = nil
    
    public func initialize(url:String) { __bngHttp.shared.server_address = url }
    public func reqeustx(url:String, method:HTTPMethod, body:String, headers:HTTPHeaders?=nil, callback:((Int, String, NSDictionary) -> ())?) {
        guard __bngHttp.shared.server_address != nil else {
            return
        }
        self.callback = callback
        let fullUrl = URL(string: (__bngHttp.shared.server_address! + url).addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!
        print("\(fullUrl)")
        
        var request = URLRequest(url: fullUrl)
        request.httpMethod = method.rawValue
        //request.httpBody = try! JSONSerialization.data(withJSONObject: "{" + body + "}")
        let parameter = body.data(using: String.Encoding.utf8, allowLossyConversion: false)
        request.httpBody = parameter
        request.allHTTPHeaderFields = headers
        
        //Alamofire.request(request).responseJSON {
        Alamofire.request(fullUrl, method:method ,parameters: [:], encoding: body, headers:headers).responseJSON {
            response in
            switch response.result{
            case .success(_):
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    var raw:String = ""
                    if response.data != nil {
                        raw = response.data!.prettyPrintedJSONString! as String
                    }
                    self.callback?(__bngHttp.Ok, raw, json)
                }
            case .failure(let error):
                print("\n\n===========Error===========")
                print("Error Code: \(error._code)")
                print("Error Messsage: \(error.localizedDescription)")
                if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                    print("Server Error: " + str)
                }
                debugPrint(error as Any)
                print("===========================\n\n")
                if let status = response.response?.statusCode {
                    print("\(response.result.value)")
                    if status == 200 {
                        self.callback?(__bngHttp.Ok, "empty", [:])
                    }
                    else {
                        self.callback?(status, "", [__bngHttp.Code:String(__bngHttp.LocalizedError),
                            __bngHttp.ErrorCode:String(error._code),
                        __bngHttp.Description:response.result.error!.localizedDescription])
                    }
                }
                else {
                    self.callback?(__bngHttp.Error, "", [__bngHttp.Code:String(__bngHttp.LocalizedError),
                        __bngHttp.ErrorCode:String(error._code),
                    __bngHttp.Description:response.result.error!.localizedDescription])
                }
            }
        }
    }
    
    public func reqeustx(url:String, method:HTTPMethod, parameters:Parameters?=nil, headers:HTTPHeaders?=nil, callback:((Int, String, NSDictionary) -> ())?) {
        guard __bngHttp.shared.server_address != nil else {
            return
        }
        self.callback = callback
        let fullUrl = URL(string: (__bngHttp.shared.server_address! + url).addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!
        print("\(fullUrl)")
        Alamofire.request(fullUrl, method:method ,parameters: parameters, encoding: JSONEncoding.default, headers:headers).responseJSON {
            response in
            switch response.result{
            case .success(_):
                var origin:String? = nil
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    origin = utf8Text
                }
                if let result = response.result.value {
                    if JSONSerialization.isValidJSONObject(result) {
                        let json = result as! NSDictionary
                        var raw:String = ""
                        if response.data != nil {
                            raw = response.data!.prettyPrintedJSONString! as String
                        }
                        self.callback?(__bngHttp.Ok, origin ?? raw, json)
                    }
                    else {
                        self.callback?(__bngHttp.Ok, "empty", [:])
                    }
                }
            case .failure(let error):
                print("\n\n===========Error===========")
                print("Error Code: \(error._code)")
                print("Error Messsage: \(error.localizedDescription)")
                if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                    print("Server Error: " + str)
                }
                debugPrint(error as Any)
                print("===========================\n\n")
                if let status = response.response?.statusCode {
                    if status == 200 {
                        self.callback?(__bngHttp.Ok, "empty", [:])
                    }
                    else {
                        self.callback?(status, "", [__bngHttp.Code:String(__bngHttp.LocalizedError),
                            __bngHttp.ErrorCode:String(error._code),
                        __bngHttp.Description:response.result.error!.localizedDescription])
                    }
                }
                else {
                    self.callback?(__bngHttp.Error, "", [__bngHttp.Code:String(__bngHttp.LocalizedError),
                                                         __bngHttp.ErrorCode:String(error._code),
                                                     __bngHttp.Description:response.result.error!.localizedDescription])
                }
            }
        }
    }
    
    public func reqeust(url:String, method:HTTPMethod, parameters:Parameters?=nil, headers:HTTPHeaders?=nil, callback:((Int, String, NSDictionary) -> ())?) {
        guard __bngHttp.shared.server_address != nil else {
            return
        }
        self.callback = callback
        let fullUrl = URL(string: (__bngHttp.shared.server_address! + url).addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!
        print("\(fullUrl)")
        Alamofire.request(fullUrl, method:method ,parameters: parameters, headers:headers).responseJSON {
            response in
            switch response.result{
            case .success(_):
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    var raw:String = ""
                    if response.data != nil {
                        //raw = String(decoding: response.data!, as: UTF8.self)
                        raw = response.data!.prettyPrintedJSONString! as String
                    }
                    self.callback?(__bngHttp.Ok, raw, json)
                }
            case .failure(_):
                self.callback?(__bngHttp.Error, "", [__bngHttp.Code:String(__bngHttp.LocalizedError),
                                                 __bngHttp.Description:response.result.error!.localizedDescription])
                
            }
        }
    }
    public func reqeust(url:String, method:HTTPMethod, parameters:String?=nil, datas:Array<Data>?=nil, names:Array<String>?=nil, headers:HTTPHeaders?=nil, callback:((Int, String, NSDictionary) -> ())?) {
        guard __bngHttp.shared.server_address != nil else {
            return
        }
        self.callback = callback
        let fullUrl = URL(string: (__bngHttp.shared.server_address! + url).addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)!
        print("\(fullUrl)")
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if datas != nil {
                for (index, data) in datas!.enumerated() {
                    //let data = URL(fileURLWithPath: file)
                    var filename = "image.jpeg"
                    if names != nil {
                        filename = names![index]
                    }
                    multipartFormData.append(data, withName: filename, fileName: filename+".jpg", mimeType: "image/jpeg")
                }
            }
            if parameters != nil {
                multipartFormData.append(parameters!.data(using: .utf8)!, withName: "meta-data", mimeType: "application/json;charset=utf-8")
            }
            /*
            if parameters != nil {
                for (key,value) in parameters! {
                    let s =  value as? String ?? ""
                    //if s.length > 0 {
                    //application/json;charset=utf-8
                    //text/plain
                        multipartFormData.append(s.data(using: .utf8)!, withName: "meta-data", mimeType: "application/json;charset=utf-8")
                    //}
                    
                }
            }
            */
            
        }, usingThreshold: UInt64.init(), to: fullUrl, 
           method: .post,
           headers:headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if !response.result.isSuccess {
                        self.callback?(__bngHttp.Error, "", [__bngHttp.Code:String(__bngHttp.LocalizedError),
                                                         __bngHttp.Description:response.result.error!.localizedDescription])
                    } else {
                        if let result = response.result.value {
                            let json = result as! NSDictionary
                            var raw:String = ""
                            if response.data != nil {
                                //raw = String(decoding: response.data!, as: UTF8.self)
                                raw = response.data!.prettyPrintedJSONString! as String
                            }
                            self.callback?(__bngHttp.Ok, raw, json)
                        }
                    }
                }
            case .failure(let encodingError):
                self.callback?(__bngHttp.Error, "", [__bngHttp.Code:String(__bngHttp.LocalizedError),
                                                 __bngHttp.Description:encodingError])
            }
        }
    }
    
}
extension String: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }

}
