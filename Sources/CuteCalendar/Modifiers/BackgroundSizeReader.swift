//
//  BackgroundSizeReader.swift
//
//
//  Created by Илья Аникин on 02.06.2024.
//

import SwiftUI

/// Attaches a transparent background to the view and sends its size changes to the size binding.
struct BackgroundSizeReader: ViewModifier {
    @Binding var size: CGSize

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: SizePreferenceKey.self,
                        value: geometry.size
                    )
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { size in
                self.size = size
            }
    }
}

struct SizePreferenceKey: SwiftUI.PreferenceKey {
    static var defaultValue: CGSize { .zero }

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

extension View {
    /// Attaches a transparent background to the view and sends its size changes to the size binding.
    func backgroundSizeReader(size: Binding<CGSize>) -> some View {
        self.modifier(BackgroundSizeReader(size: size))
    }
}
