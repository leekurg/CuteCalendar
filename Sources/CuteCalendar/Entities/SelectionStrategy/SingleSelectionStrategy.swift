//
//  SingleSelectionStrategy.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 18.02.2026.
//

import Foundation

public struct SingleSelectionStrategy: SelectionStrategy {
    private let behaviour: Behaviour
    
    init(behaviour: Behaviour) {
        self.behaviour = behaviour
    }
    
    public func select(_ date: Date, in selection: DateIntervalSelection) -> DateIntervalSelection {
        DateIntervalSelection(start: date)
    }
    
    public func selectRange(start: Date, end: Date, in selection: DateIntervalSelection) -> DateIntervalSelection {
        DateIntervalSelection(start: start)
    }
    
    public func style(for date: Date, in selection: DateIntervalSelection) -> SelectionStyle {
        if selection.contains(date), behaviour == .explicit {
            return .edgeAlone
        }
        
        return .none
    }
}

public extension SingleSelectionStrategy {
    enum Behaviour {
        /// Selected date will not be styled.
        /// Suitable when there is needed only to pick a date and then close Calendar immediatly.
        case silent
        /// Selected date will be styled
        case explicit
    }
}

public extension SelectionStrategy where Self == SingleSelectionStrategy {
    static var single: Self { Self(behaviour: .explicit) }
    
    static func single(behaviour: SingleSelectionStrategy.Behaviour) -> Self {
        Self(behaviour: behaviour)
    }
}
