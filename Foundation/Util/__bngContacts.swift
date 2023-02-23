//
//  __bngContacts.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong

class __bngContacts : _bngContacts {
    /*
     __bngContacts.insertDummyContacts(count: 100, completion: {() -> () in
     self.alert(vc:self, message: "insert contacts complete!", ok:"ok", completion:{ completion in })
     })
     */
    
    public static func getFamilyname()->String {
        let familyname = ["김", "이", "박", "최", "정", "강", "조", "윤", "장", "임", "한", "오", "서", "신", "권", "황", "안", "송", "전", "홍", "유", "고", "문",
                        "양", "손", "배", "백", "허", "유", "남", "심", "노", "하", "곽", "성", "차", "주", "우", "구", "민", "류", "나", "엄", "지", "천", "변", "방", "표", "탁"]
        return familyname[Int(_bngNumber.getRandValue(max: familyname.count-1))]
    }
    public static func getGivenname()->String {
        
        let givenname = ["민준", "서준", "예준", "도윤", "주원", "시우", "지후", "지호", "준서", "하준", "현우", "준우", "지훈", "도현", "건우", "우진", "현준", "민재", "선우", "서진", "연우", "정우", "승현",
                         "준혁", "유준", "승우", "지환", "승민", "시윤", "민성", "지우", "유찬", "준영", "진우", "시후", "지원", "은우", "수현", "윤우", "동현", "재윤", "민규", "시현", "태윤", "재원", "민우",
                         "재민", "은찬", "한결", "윤호", "민찬", "시원", "성민", "성현", "준호", "승준", "수호", "현서", "재현", "지성", "태민", "시온", "태현", "민혁", "예성", "민호", "하율", "성준", "우빈", "지안",
                         "서연", "서윤", "지우", "서현", "민서", "하은", "하윤", "윤서", "지민", "지유", "채원", "지윤", "은서", "수아", "다은", "예은", "수빈", "예원", "지아", "소율", "지원", "예린", "소윤", "유진",
                         "시은", "가은", "채은", "서영", "민지", "지안", "윤아", "하린", "예진", "수민", "유나", "수연", "연우", "시연", "예서", "혜원", "지수", "은채", "주하", "서하", "승아", "나은", "서희", "나현", "민아",
                         "아윤", "세은", "채린"]
        return givenname[Int(_bngNumber.getRandValue(max: givenname.count-1))]
    }
    public static func getName()->String {
        return getFamilyname()+getGivenname()
    }
    public static func getPhoneNumber()->String {
        return String("010" + String(_bngNumber.getRandValue(start: 1000, end: 9999)) + String(_bngNumber.getRandValue(start: 1000, end: 9999)))
    }
    public static func insertDummyContacts(count:Int, completion:(() -> ())?=nil) {
        var familynames = [String]()
        var givennames = [String]()
        var phones = [String]()
        for _ in 1...count {
            familynames.append(getFamilyname())
            givennames.append(getGivenname())
            phones.append(getPhoneNumber())
        }
        _bngContacts.asyncMakeContacts(givenname: givennames, familyname: familynames, phones: phones,
                                       priority: .userInteractive, callback: completion)
        //2019.09.05 edit by bong
        /*
        _bngContacts.makeContact(givenname: getName(), phone: getPhoneNumber())
        if completion != nil {
            completion!()
        }
        */
    }
    
}
