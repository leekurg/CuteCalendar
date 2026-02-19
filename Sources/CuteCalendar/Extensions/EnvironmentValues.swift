//
//  EnvironmentValues.swift
//  
//
//  Created by Илья Аникин on 27.03.2024.
//

import SwiftUI

public extension View {
    /// Overrides ``CuteCalendar`` config.
    func cuteCalendarConfig(
        _ mutation: @escaping (inout CuteCalendarConfig) -> Void
    ) -> some View {
        transformEnvironment(\.cuteCalendar) { config in
            mutation(&config)
        }
    }
    
    /// Overrides text `foregroundColor` for underling **CuteCalendar**.
    func cuteTintColor(_ color: Color?) -> some View {
        environment(\.cuteCalendar.tintColor, color ?? .primary)
    }
    
    /// Overrides color of selection marks for underling **CuteCalendar**.
    func cuteSelectionColors(
        primary: Color? = nil,
        secondary: Color? = nil,
        text: Color? = nil
    ) -> some View {
        environment(
            \.cuteCalendar.selection.colors,
             .init(
                primary: primary ?? CuteCalendarConfig.Selection.Colors.default.primary,
                secondary: secondary ?? CuteCalendarConfig.Selection.Colors.default.secondary,
                text: text ?? CuteCalendarConfig.Selection.Colors.default.text
             )
        )
    }
    
    /// Overrides color of selection marks for underling **CuteCalendar**.
    func cuteSelectionAnimation(_ animation: Animation?) -> some View {
        environment(\.cuteCalendar.selection.animation, animation)
    }

    /// Overrides labels for **CuteCalendar** sections `Start date` and `End date`.
    func cuteLabels(start: LocalizedStringKey, end: LocalizedStringKey) -> some View {
        environment(\.cuteCalendar.labels, .init(start: start, end: end))
    }
    
    /// Overrides mark style for **CuteCalendar**.
    func cuteMarksStyle(_ style: CuteCalendarConfig.Mark) -> some View {
        environment(\.cuteCalendar.mark, style)
    }
}

extension EnvironmentValues {
    @Entry var cuteCalendar: CuteCalendarConfig = .default
}

public struct CuteCalendarConfig {
    public var tintColor: Color
    public var selection: Selection
    public var labels: Labels
    public var mark: Mark
    
    static var `default`: Self {
        Self(
            tintColor: .primary,
            selection: .default,
            labels: .default,
            mark: .default
        )
    }
    
    public struct Selection {
        public var colors: Colors
        public var animation: Animation?
        
        static var `default`: Self {
            Self(colors: .default, animation: nil)
        }
        
        public struct Colors {
            public let primary: Color
            public let secondary: Color
            public let text: Color
            
            static var `default`: Self {
                Self(
                    primary: .blue,
                    secondary: .gray.opacity(0.3),
                    text: .white
                )
            }
        }
    }
    
    public struct Labels {
        public var start: LocalizedStringKey
        public var end: LocalizedStringKey
        
        static var `default`: Self {
            Self(start: "-", end: "-")
        }
    }
    
    public struct Mark {
        public var color: Color
        public var diameter: Double
        public var topPadding: Double
        
        static var `default`: Self {
            Self(color: .red, diameter: 5, topPadding: 5)
        }
    }
}
