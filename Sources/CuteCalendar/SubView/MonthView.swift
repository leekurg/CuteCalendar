//
//  MonthView.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 17.02.2026.
//

import OrderedCollections
import SwiftUI

struct MonthView: View {
    let month: Month
    let selection: DateIntervalSelection
    let selectionStrategy: SelectionStrategy
    let markedDates: OrderedSet<Date>
    let columns: [GridItem]
    let selectDay: (Date) -> Void
    let selectMonth: (Date) -> Void
    let selectYear: (Date) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Header(
                month: month,
                onMonthTap: selectMonth,
                onYearTap: selectYear
            )
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(month.days) { day in
                    DayView(day: day, fontSize: 1, action: selectDay)
                        .markedDay {
                            !day.isEmpty && markedDates.contains(day.date)
                        }
                        .padding(.bottom, 1)
                        .selectionStyle(
                            day.isSelectable
                                ? selectionStrategy.style(for: day.date, in: selection)
                                : .none
                        )
                }
            }
            .padding(.horizontal)
        }
    }
}

fileprivate struct Header: View {
    let month: Month
    let onMonthTap: (Date) -> Void
    let onYearTap: (Date) -> Void
    
    var body: some View {
        HStack(spacing: 5) {
            Text("\(month.date.localizedMonthName.capitalizedFirst),")
                .onTapGesture {
                    onMonthTap(month.date)
                }

            Text(month.date.yearName)
                .onTapGesture {
                    onYearTap(month.date)
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.system(size: 20, weight: .semibold))
        .padding(.leading)
    }
}

fileprivate extension String {
    var capitalizedFirst: String {
        self.prefix(1).capitalized + self.dropFirst()
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
    let strategy: SelectionStrategy = .none
    
    var body: some View {
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
}

#Preview {
    ProxyView()
        .preferredColorScheme(.dark)
}
