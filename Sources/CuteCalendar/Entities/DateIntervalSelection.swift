//
//  DateIntervalSelection.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 18.02.2026.
//

import Foundation

public struct DateIntervalSelection: Equatable {
    public let start: Date?
    public let end: Date?
    
    public let interval: DateInterval?
    
    public init(start: Date? = nil, end: Date? = nil) {
        guard let start, let end else {
            self.start = start
            self.end = end
            interval = nil
            return
        }
        
        if start > end {
            self.start = end
            self.end = start
            self.interval = DateInterval(start: end, end: start)
        } else {
            self.start = start
            self.end = end
            self.interval = DateInterval(start: start, end: end)
        }
    }
    
    public func contains(_ date: Date) -> Bool {
        interval?.contains(date) ?? (start == date || end == date)
    }
}

extension DateIntervalSelection: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(start: \(start?.humanString ?? "-"), end: \(end?.humanString ?? "-"))"
    }
}
