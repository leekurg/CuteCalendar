//
//  DateInterval+.swift
//
//
//  Created by Илья Аникин on 27.03.2024.
//

import Foundation

extension DateInterval {
    /// Creates a sequence of dates separated by specified **byAdding** component and **value**.
    func enumerated(byAdding: Calendar.Component, value: Int = 1, calendar: Calendar = .current) -> [Date] {
        let dateFrom = calendar.startOfDay(for: self.start)
        let dateTo = calendar.startOfDay(for: self.end)
        guard dateFrom < dateTo else { return [] }

        var dates = [Date]()
        var date = dateFrom

        while date <= dateTo {
            dates.append(date)

            guard let nextDate = calendar.date(byAdding: byAdding, value: value, to: date) else { break }
            date = nextDate
        }

        return dates
    }

    /// Returns this interval with start date's and end date's time component reset to **00:00:00**.
    func resetTimeComponent() -> DateInterval? {
        if let start = self.start.dayStart(), let end = self.end.dayStart() {
            return DateInterval(start: start, end: end)
        }

        return nil
    }
}
