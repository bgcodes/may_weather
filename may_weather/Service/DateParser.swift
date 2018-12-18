//
//  DateParser.swift
//  may_weather
//
//  Created by Grzegorz Bogdan on 18/12/2018.
//  Copyright © 2018 Grzegorz Bogdan. All rights reserved.
//

import Foundation

class DateParser {
    
    static func parseDate(unixTimestamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: Double(unixTimestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
