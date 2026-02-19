//
//  NoneSelectionStrategy.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 18.02.2026.
//

import Foundation

public struct NoneSelectionStrategy: SelectionStrategy {
    public func select(_ date: Date, in selection: DateIntervalSelection) -> DateIntervalSelection {
        DateIntervalSelection()
    }
    
    public func selectRange(start: Date, end: Date, in selection: DateIntervalSelection) -> DateIntervalSelection {
        DateIntervalSelection()
    }
    
    public func style(for date: Date, in selection: DateIntervalSelection) -> SelectionStyle {
        .none
    }
}

public extension SelectionStrategy where Self == NoneSelectionStrategy {
    static var none: Self { Self() }
}
