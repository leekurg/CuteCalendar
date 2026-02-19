//
//  SelectionStyle.swift
//
//
//  Created by Илья Аникин on 28.03.2024.
//

public enum SelectionStyle {
    /// Single selected date.
    case edgeAlone
    /// Selected date on right edge of interval.
    case edgeRight
    /// Selected date on left edge of interval.
    case edgeLeft
    /// Selected date when month's start(end) & end(start) of week is matched.
    case aloneUnit
    /// Selected date between other selected dates.
    case middleUnit
    /// Selected date is the end of week or month.
    case rightUnit
    /// Selected date is the start of week or month.
    case leftUnit
    /// Not selected.
    case none

    var isEdge: Bool {
        switch self {
        case .edgeAlone, .edgeLeft, .edgeRight: true
        default: false
        }
    }
}
