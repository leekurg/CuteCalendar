//
//  SelectionStrategy.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 18.02.2026.
//

import Foundation

public protocol SelectionStrategy {
    func select(_ date: Date, in selection: DateIntervalSelection) -> DateIntervalSelection
    func selectRange(start: Date, end: Date, in selection: DateIntervalSelection) -> DateIntervalSelection
    func style(for date: Date, in selection: DateIntervalSelection) -> SelectionStyle
    
    var isBarRequired: Bool { get }
}

public extension SelectionStrategy {
    var isBarRequired: Bool { false }
}
