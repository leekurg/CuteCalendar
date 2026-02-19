//
//  RangeSelectionStrategy.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 18.02.2026.
//

import Foundation

public struct RangeSelectionStrategy: SelectionStrategy {
    public func select(_ date: Date, in selection: DateIntervalSelection) -> DateIntervalSelection {
        guard let start = selection.start else {
            return DateIntervalSelection(start: date)
        }

        if selection.end != nil {
            return DateIntervalSelection(start: date)
        }

        if date >= start {
            return DateIntervalSelection(start: start, end: date)
        }
        
        return DateIntervalSelection(start: date, end: start)
    }
    
    public func selectRange(start: Date, end: Date, in selection: DateIntervalSelection) -> DateIntervalSelection {
        DateIntervalSelection(start: start, end: end)
    }
    
    public func style(for date: Date, in selection: DateIntervalSelection) -> SelectionStyle {
        guard selection.contains(date) else { return .none }

        if
            date == selection.start && selection.end == nil
            || selection.start == selection.end
            || date == selection.start && date == date.lastDayOfMonth()
            || date == selection.end && date == date.firstDayOfMonth()
            || date == selection.start && date.isLastWeekday()
            || date == selection.end && date.isFirstWeekday() {
            return .edgeAlone
        }

        if date == selection.start { return .edgeLeft }
        if date == selection.end { return .edgeRight }

        if
            date == date.firstDayOfMonth() && date.isLastWeekday()
            || date == date.lastDayOfMonth() && date.isFirstWeekday() {
            return .aloneUnit
        }

        if date == date.lastDayOfMonth() || date.isLastWeekday() { return .rightUnit }
        if date == date.firstDayOfMonth() || date.isFirstWeekday() { return .leftUnit }

        return .middleUnit
    }
    
    public var isBarRequired: Bool { true }
}

public extension SelectionStrategy where Self == RangeSelectionStrategy {
    static var range: Self { Self() }
}
