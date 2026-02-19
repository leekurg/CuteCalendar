//
//  DayView.swift
//
//
//  Created by Илья Аникин on 27.03.2024.
//

import SwiftUI

struct DayView: View {
    let presentableDay: PresentableDay
    let fontSize: CGFloat
    let action: (Date) -> Void

    @Environment(\.cuteCalendar.selection.colors.primary) var selectionColor

    init(day presentebleDay: PresentableDay, fontSize: CGFloat, action: @escaping (Date) -> Void) {
        self.presentableDay = presentebleDay
        self.fontSize = fontSize
        self.action = action
    }
    
    var body: some View {
        Group {
            switch presentableDay {
            case .regular(let day):
                Text("\(day.date.get(.day))")

            case .nonselectable(let day):
                Text("\(day.date.get(.day))")
                    .opacity(0.5)

            case .empty:
                Text("00").hidden()
            }
        }
        .lineLimit(1)
        .onTapGesture {
            guard presentableDay.isSelectable else { return }
            action(presentableDay.date)
        }
        .padding(.vertical, 5)
        .background {
            ZStack {
                if presentableDay.isMarkedToday {
                    Capsule()
                        .fill(selectionColor)
                        .frame(height: 3)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    DayView(day: .regular(Day(date: .now)), fontSize: 16) { _ in }
        .border(.red)
}
