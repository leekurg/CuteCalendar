//
//  MarkSelectionStrategy.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 19.02.2026.
//

import Foundation

public struct MarkSelectionStrategy: SelectionStrategy {
    public func select(_ date: Date, in selection: DateIntervalSelection) -> DateIntervalSelection {
        DateIntervalSelection(start: date)
    }
    
    public func selectRange(start: Date, end: Date, in selection: DateIntervalSelection) -> DateIntervalSelection {
        DateIntervalSelection(start: start)
    }
    
    public func style(for date: Date, in selection: DateIntervalSelection) -> SelectionStyle {
        return .none
    }
}

public extension SelectionStrategy where Self == MarkSelectionStrategy {
    static var mark: Self { Self() }
}
