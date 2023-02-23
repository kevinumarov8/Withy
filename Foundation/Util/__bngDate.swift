//
//  __bngDate.swift
//  ChocspoApp
//
//  Copyright © 2019 김봉희. All rights reserved.
//

import Foundation
class __bngDate {
    public static func timestampToDate(timestamp:Int64) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp/1000))
    }
    /*
     print(String((seconds / 86400)) + " days")
     print(String((seconds % 86400) / 3600) + " hours")
     print(String((seconds % 3600) / 60) + " minutes")
     print(String((seconds % 3600) % 60) + " seconds")
     */
    public static func secondsToDayHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int, Int) {
      return (seconds / 86400,  (seconds % 86400) / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension Date {
    public func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)

        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec

        return cal.date(from: components)
    }
}
