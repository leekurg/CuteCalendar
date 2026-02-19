//
//  SelectionStyleModifier.swift
//
//
//  Created by Илья Аникин on 28.03.2024.
//

import SwiftUI

fileprivate struct SelectionStyleModifier: ViewModifier {
    let style: SelectionStyle

    private let edgePadding: CGFloat = 2

    @Environment(\.cuteCalendar.tintColor) var tintColor
    @Environment(\.cuteCalendar.selection.colors) var colors

    func body(content: Content) -> some View {
        content
            .background {
                switch style {
                case .none:
                    Color.clear
                case .edgeAlone:
                    Circle().fill(colors.primary)
                        .padding(edgePadding)
                case .edgeLeft:
                    Circle().fill(colors.primary)
                        .padding(edgePadding)
                        .background(
                            CapShape().fill(colors.secondary)
                                .aspectRatio(1, contentMode: .fit)
                                .rotationEffect(.degrees(180))
                        )
                case .edgeRight:
                    Circle().fill(colors.primary)
                        .padding(edgePadding)
                        .background(
                            CapShape().fill(colors.secondary)
                                .aspectRatio(1, contentMode: .fit)
                        )
                case .aloneUnit:
                    Circle().fill(colors.secondary)
                case .middleUnit:
                    Rectangle()
                        .fill(colors.secondary)
                        .aspectRatio(1, contentMode: .fit)
                case .leftUnit:
                    CapShape()
                        .fill(colors.secondary)
                        .aspectRatio(1, contentMode: .fit)
                        .rotationEffect(.degrees(180))
                case .rightUnit:
                    CapShape()
                        .fill(colors.secondary)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .foregroundStyle(style.isEdge ? colors.text : tintColor)
            .fontWeight(style.isEdge ? .bold : nil)
    }
}

extension View {
    func selectionStyle(_ style: SelectionStyle) -> some View {
        self.modifier(SelectionStyleModifier(style: style))
    }
}
