//
//  CalendarHeader.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 17.02.2026.
//

import SwiftUI

struct CalendarHeader: View {
    let isSelectionBarVisible: Bool
    let selection: DateIntervalSelection
    let weekdays: [Weekday]
    let columns: [GridItem]
    
    @Environment(\.cuteCalendar.labels) var labels
    
    private let transition: AnyTransition  = {
        if #available(iOS 17, *) {
            AnyTransition(
                BlurReplaceTransition(configuration: .downUp)
            )
        } else {
            .opacity.combined(with: .offset(x: 0, y: 3))
        }
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            if isSelectionBarVisible {
                HStack(spacing: 0) {
                    VStack {
                        if let start = selection.start {
                            Text(start.localized)
                                .font(.system(size: 15, weight: .semibold))
                                .fixedSize(horizontal: true, vertical: false)
                                .transition(transition.animation(.spring(duration: 0.2)))
                                .id(start)
                        } else {
                            Text(labels.start)
                                .textCase(.uppercase)
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(.secondary)
                                .transition(.identity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .padding(5)
                    
                    VStack {
                        if let end = selection.end {
                            Text(end.localized)
                                .font(.system(size: 15, weight: .semibold))
                                .fixedSize(horizontal: true, vertical: false)
                                .transition(transition.animation(.spring(duration: 0.2)))
                                .id(end)
                        } else {
                            Text(labels.end)
                                .textCase(.uppercase)
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(.secondary)
                                .transition(.opacity.animation(.spring(duration: 0.2)))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 40)
                .apply { view in
                    if #available(iOS 26, *) {
                        view
                            .glassEffect(.regular)
                    } else {
                        view
                    }
                }
                .padding(.vertical, 5)
            }
            
            WeekdaysBar(weekdays: weekdays, columns: columns)
        }
        .padding(.horizontal)
        .padding(.bottom, 3)
        .apply { view in
            if #available(iOS 26, *) {
                view
            } else {
                view.background(.bar)
            }
        }
    }
}

fileprivate struct WeekdaysBar: View {
    let weekdays: [Weekday]
    let columns: [GridItem]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(weekdays) { weekday in
                WeekdayView(title: weekday.localizedTitle)
                    .fontWeight(.thin)
            }
        }
        .apply { view in
            if #available(iOS 26, *) {
                view
                    .glassEffect(.regular)
            } else {
                view
            }
        }
    }
}

// swiftlint: disable force_unwrapping
fileprivate struct ProxyView: View {
    let columns: [GridItem] = .init(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: Calendar.daysInWeek
    )
    
    let month: Month = Month(
        Date("02 02 2026")!,
        selectableDates: DateInterval(
            start: Date("01 02 2026 00:00")!, end: Date("28 02 2026 23:59")!
        )
    )!
    
    @State var selection: DateIntervalSelection = .init()
    let strategy: SelectionStrategy = .range
    
    var body: some View {
        VStack {
            CalendarHeader(
                isSelectionBarVisible: strategy.isBarRequired,
                selection: selection,
                weekdays: CalendarController.makeWeekdays(.short, calendar: .localizedCurrent),
                columns: columns
            )
            
            MonthView(
                month: month,
                selection: selection,
                selectionStrategy: strategy,
                markedDates: [],
                columns: columns,
                selectDay: { date in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = strategy.select(date, in: selection)
                    }
                    
                    print("selection: \(selection)")
                },
                selectMonth: { print("selected month: \($0.humanString)") },
                selectYear: { print("selected year: \($0.humanString)") }
            )
        }
        .cuteLabels(start: "Start date", end: "End date")
    }
}

#Preview {
    ProxyView()
        .preferredColorScheme(.dark)
}
