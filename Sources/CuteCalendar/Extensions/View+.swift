//
//  View+.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 19.09.2025.
//

import SwiftUI

extension View {
    /// Apply to this `View` a transformation defined within **transform** block.
    @ViewBuilder func apply<Content: View>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
}
