//
//  Month.swift
//
//
//  Created by Илья Аникин on 27.03.2024.
//

import Foundation

struct Month: Identifiable {
    let date: Date
    let days: [PresentableDay]

    init?(_ firstDayDate: Date, selectableDates: DateInterval? = nil, calendar: Calendar = .current) {
        guard let monthInterval = firstDayDate.monthInterval(includeLastDay: true) else { return nil }

        let gridDateInterval: DateInterval

        if
            let firstGridDay = calendar.findFirstWeekdayOccurrence(
                from: monthInterval.start,
                weekday: calendar.firstWeekday,
                direction: .backward
            ),
            let lastGridDay = calendar.findFirstWeekdayOccurrence(
                from: monthInterval.end,
                weekday: calendar.lastWeekday,
                direction: .forward
            ) {
            gridDateInterval = .init(start: firstGridDay, end: lastGridDay)
        } else {
            return nil
        }

        self.date = firstDayDate
        self.days = gridDateInterval
            .enumerated(byAdding: .day)
            .map { day in
                guard monthInterval.contains(day) else { return .empty(Day(date: day)) }
                guard let selectableDates else { return .nonselectable(Day(date: day)) }

                if selectableDates.contains(day) { return .regular(Day(date: day)) }

                return .nonselectable(Day(date: day))
            }
    }

    var id: Date { self.date }
}
