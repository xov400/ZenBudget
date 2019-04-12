//
//  DateFormatter+Additions.swift
//  ZenBudget
//
//  Created by Александр on 12.03.2019.
//  Copyright © 2019 Александр. All rights reserved.
//

import Foundation

enum DateFormat {
    case iso8601
    case iso8601Full
    case simpleDate
    case headerDate
    case custom(String)

    var raw: String {
        switch self {
        case .iso8601:
            return "yyyy-MM-dd HH:mm:ss"
        case .iso8601Full:
            return "yyyy-MM-dd'T'HH:mm:ss.SSS"
        case .simpleDate:
            return "dd.MM.yyyy"
        case .headerDate:
            return "dd MMMM yyyy"
        case .custom(let format):
            return format
        }
    }

    var locale: Locale? {
        switch self {
        case .iso8601, .iso8601Full:
            return Locale(identifier: "en_US_POSIX")
        default:
            return nil
        }
    }
}

extension DateFormatter {

    static var iso8601: DateFormatter {
        return .init(format: .iso8601)
    }

    static var iso8601Full: DateFormatter {
        return .init(format: .iso8601Full)
    }

    static var simpleDate: DateFormatter {
        return .init(format: .simpleDate)
    }

    static var headerDate: DateFormatter {
        return .init(format: .headerDate)
    }

    var orderedWeekdaySymbols: [String] {
        var weekdaySymbols = self.weekdaySymbols!
        var calendar = Calendar.current
        calendar.locale = locale
        if calendar.firstWeekday == 2 {
            let sunday = weekdaySymbols.remove(at: 0)
            weekdaySymbols.append(sunday)
        }
        return weekdaySymbols
    }

    convenience init(locale: Locale) {
        self.init()
        self.locale = locale
    }

    convenience init(format: DateFormat) {
        self.init()
        dateFormat = format.raw
        locale = format.locale
    }

    func weekdayName(forWeekday weekday: Int) -> String? {
        return orderedWeekdaySymbols[safe: weekday - 1]
    }
}
