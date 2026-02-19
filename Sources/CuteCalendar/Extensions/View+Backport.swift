//
//  View+Backport.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 18.02.2026.
//

import SwiftUI

/// Single entry point for all SwiftUI backports.
///
struct Backport<Wrapped> {
    public let wrapped: Wrapped
    
    public init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
}

extension View {
    var backport: Backport<Self> {
        .init(self)
    }
}

extension Backport where Wrapped: View {
    @ViewBuilder nonisolated func scrollIndicatorsMargins(
        _ edges: Edge.Set = .all,
        _ length: CGFloat?
    ) -> some View {
        if #available(iOS 17, *) {
            wrapped
                .contentMargins(.top, length, for: .scrollIndicators)
        } else {
            wrapped
        }
    }
    
    @ViewBuilder nonisolated func selectionSensoryFeedback<T>(
        _ trigger: T
    ) -> some View where T: Equatable {
        if #available(iOS 17, *) {
            wrapped
                .sensoryFeedback(.selection, trigger: trigger)
        } else {
            wrapped
                .onChange(of: trigger) { _ in
                    Task {
                        await UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.5)
                    }
                }
        }
    }
}
