//
//  Calendar+.swift
//
//
//  Created by Илья Аникин on 26.03.2024.
//

import Foundation

public extension Calendar {
    /// Calendar with current app locale
    static var localizedCurrent: Calendar {
        var calendar = Self.autoupdatingCurrent
        calendar.locale = Locale(identifier: Locale.preferredLanguages[0])

        return calendar
    }
}

extension Calendar {
    /// Count of days in week.
    static let daysInWeek: Int = 7

    /// Index of last day oh the week, depends on calenadar's type (gregorian ot other)
    var lastWeekday: Int {
        self.firstWeekday > 1 ? self.firstWeekday - 1 : Self.daysInWeek
    }

    /// Returns a date of next weekday(including `from` date) in forward or backward search direction
    func findFirstWeekdayOccurrence(from date: Date, weekday: Int, direction: SearchDirection = .forward) -> Date? {
        if date.get(.weekday) == weekday { return date }

        return nextDate(
            after: date,
            matching: .init(weekday: weekday),
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: direction
        )
    }
}
