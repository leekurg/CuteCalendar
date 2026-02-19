//
//  CalendarController.swift
//
//
//  Created by Илья Аникин on 27.03.2024.
//

import Foundation
import SwiftUI

@MainActor
final class CalendarController: ObservableObject {
    @Published var months: [Month] = []
    @Published var selection: DateIntervalSelection = .init()
    
    let weekdays: [Weekday]
    let selectionStrategy: SelectionStrategy

    private let selectableDates: DateInterval?
    private let calendar: Calendar
    private var selectionAnimation: Animation?

    init(
        selectableDates: DateInterval?,
        selectionStrategy: SelectionStrategy,
        weekdayFormat: WeekdaySymbolFormat = .short,
        calendar: Calendar = .localizedCurrent
    ) {
        self.selectionStrategy = selectionStrategy
        self.calendar = calendar
        self.selectableDates = selectableDates?.resetTimeComponent()
        self.weekdays = Self.makeWeekdays(weekdayFormat, calendar: calendar)
    }
    
    func setup(
        presenting interval: DateInterval,
        initialStartDate startDate: Date?,
        initialEndDate endDate: Date?,
        selectionAnimation: Animation?
    ) async {
        self.selectionAnimation = selectionAnimation
        
        self.months =  interval
            .enumerated(byAdding: .month, calendar: calendar)
            .compactMap { [selectable = self.selectableDates] in
                Month($0, selectableDates: selectable)
            }
        
        initSelection(start: startDate, end: endDate)
    }

    func selectDate(_ date: Date) {
        withAnimation(selectionAnimation) {
            selection = selectionStrategy.select(date, in: selection)
        }
    }

    func selectMonth(_ date: Date) {
        if
            let selectableDates,
            let intersection = date.monthInterval()?.intersection(with: selectableDates) {
            withAnimation(selectionAnimation) {
                selection = selectionStrategy.selectRange(
                    start: intersection.start,
                    end: intersection.end,
                    in: selection
                )
            }
        }
    }

    func selectYear(_ date: Date) {
        if
            let selectableDates,
            let intersection = date.yearInterval()?.intersection(with: selectableDates) {
            withAnimation(selectionAnimation) {
                selection = selectionStrategy.selectRange(
                    start: intersection.start,
                    end: intersection.end,
                    in: selection
                )
            }
        }
    }

    /// Initialize selection from given dates.
    private func initSelection(start: Date?, end: Date?) {
        var selection = DateIntervalSelection()
        
        if let start, selectableDates?.contains(start) == true {
            selection = selectionStrategy.select(start, in: selection)
        }
        
        if let end, selectableDates?.contains(end) == true {
            selection = selectionStrategy.select(end, in: selection)
        }
        
        self.selection = selection
    }
}

extension CalendarController {
    static func makeWeekdays(_ format: WeekdaySymbolFormat, calendar: Calendar) -> [Weekday] {
        let weekdaySymbols: [String]

        switch format {
        case .empty:
            weekdaySymbols = []
        case .veryShort:
            weekdaySymbols = calendar.veryShortStandaloneWeekdaySymbols
        case .short:
            weekdaySymbols = calendar.shortStandaloneWeekdaySymbols
        case .standart:
            weekdaySymbols = calendar.standaloneWeekdaySymbols
        }

        return weekdaySymbols.swapFirstLast(when: calendar.firstWeekday == 2)
            .map { symbol in
                Weekday(localizedTitle: symbol)
            }
    }
}

fileprivate extension Array where Element == String {
    func swapFirstLast(when: Bool = true) -> Self {
        guard when, !self.isEmpty else { return self }

        return Array(self[1..<count] + [self[0]] )
    }
}
