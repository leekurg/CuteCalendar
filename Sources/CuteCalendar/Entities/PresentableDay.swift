//
//  PresentableDay.swift
//
//
//  Created by Илья Аникин on 27.03.2024.
//

import Foundation

enum PresentableDay: Identifiable {
    case regular(_ day: Day)
    case empty(_ day: Day)
    case nonselectable(_ day: Day)

    var value: Day {
        switch self {
        case .regular(let day): day
        case .empty(let day): day
        case .nonselectable(let day): day
        }
    }

    var date: Date {
        switch self {
        case .regular(let day): day.date
        case .empty(let day): day.date
        case .nonselectable(let day): day.date
        }
    }

    var id: Day.ID {
        switch self {
        case .regular(let day): day.id
        case .empty(let day): day.id
        case .nonselectable(let day): day.id
        }
    }

    var isSelectable: Bool {
        switch self {
        case .regular: true
        default: false
        }
    }
    var isEmpty: Bool {
        switch self {
        case .empty: true
        default: false
        }
    }
    var isMarkedToday: Bool {
        switch self {
        case .empty: false
        case .regular, .nonselectable:
            self.date.isToday()
        }
    }
}
