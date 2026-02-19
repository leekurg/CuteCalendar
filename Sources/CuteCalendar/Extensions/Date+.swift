//
//  Date+.swift
//  
//
//  Created by Илья Аникин on 27.03.2024.
//

import Foundation

extension Date {
    init?(_ string: String) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd MM yyyy HH:mm"
        if let date = formatter.date(from: string) {
            self = date
            return
        }
        
        formatter.dateFormat = "dd MM yyyy"
        if let date = formatter.date(from: string) {
            self = date
            return
        }
        
        return nil
    }
    
    var monthId: String {
        "\(get(.month))-\(get(.year))"
    }
}

public extension Date {
    var humanString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy',' HH:mm"

        return formatter.string(from: self)
    }

    var localizedMonthName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        formatter.dateFormat = "LLLL"

        return formatter.string(from: self)
    }

    var yearName: String {
        "\(self.get(.year))"
    }

    var localized: String {
        DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
}

public extension Date {
    /// Returns specified component of this date.
    func get(_ component: Calendar.Component, calendar: Calendar = .current) -> Int {
        calendar.component(component, from: self)
    }

    /// Returns an optional **DateInterval** for given month which is including this date..
    /// - Parameters:
    ///     - includeLastDay: Result includes last day of the month up to 23:59:59.
    ///     - calendar: **Calendar** instance to work on.
    func monthInterval(includeLastDay: Bool = false, calendar: Calendar = .current) -> DateInterval? {
        guard let start = self.firstDayOfMonth(calendar: calendar) else { return nil }

        let components: DateComponents = includeLastDay ? .init(month: 1, second: -1) : .init(month: 1, day: -1)
        guard let end = calendar.date(byAdding: components, to: start) else { return nil }

        return DateInterval(start: start, end: end)
    }

    /// Returns an optional **DateInterval** for given year which is including this date.
    /// - Parameters:
    ///     - includeLastDay: Result includes last day of the year up to 23:59:59.
    ///     - calendar: **Calendar** instance to work on.
    func yearInterval(includeLastDay: Bool = false, calendar: Calendar = .current) -> DateInterval? {
        guard let start = calendar.dateComponents([.calendar, .year], from: self).date else { return nil }

        let components: DateComponents = includeLastDay ? .init(year: 1, second: -1) : .init(year: 1, day: -1)
        guard let end = calendar.date(byAdding: components, to: start) else { return nil }

        return DateInterval(start: start, end: end)
    }

    /// Returns a date of first day of the month which is including this date.
    func firstDayOfMonth(calendar: Calendar = .current) -> Date? {
        calendar.dateComponents([.calendar, .year, .month], from: self).date
    }

    /// Returns a date of last day of the month which is including this date.
    func lastDayOfMonth(calendar: Calendar = .current) -> Date? {
        guard let start = self.firstDayOfMonth(calendar: calendar) else {
            return nil
        }
        return calendar.date(byAdding: .init(month: 1, day: -1), to: start)
    }

    /// Returns **true** when this date's weekday is the first day of the week.
    func isFirstWeekday(calendar: Calendar = .current) -> Bool {
        calendar.component(.weekday, from: self) == calendar.firstWeekday
    }

    /// Returns **true** when current date's weekday is the last day of the week.
    func isLastWeekday(calendar: Calendar = .current) -> Bool {
        calendar.component(.weekday, from: self) == calendar.lastWeekday
    }

    /// Returns this date with time set to **00:00:00**.
    func dayStart(calendar: Calendar = .current) -> Self? {
        calendar.dateComponents([.calendar, .year, .month, .day], from: self).date
    }

    /// Returns this date with time set to **23:59:59**.
    func dayEnd(calendar: Calendar = .current) -> Self? {
        calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)
    }

    func isToday(calendar: Calendar = .current) -> Bool {
        calendar.isDateInToday(self)
    }
}
