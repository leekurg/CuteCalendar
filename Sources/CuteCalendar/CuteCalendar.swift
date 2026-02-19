// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import OrderedCollections
import SwiftUI

// MARK: - View
public struct CuteCalendarView: View {
    @Binding var selectionStart: Date?
    @Binding var selectionEnd: Date?

    @StateObject private var controller: CalendarController
    @State private var headerSize: CGSize = .zero

    private let presentableDates: DateInterval
    private let markedDates: OrderedSet<Date>

    @Environment(\.cuteCalendar.selection.animation) var selectionAnimation

    public init(
        presentableDates: DateInterval,
        selectableDates: DateInterval?,
        selectionStrategy: SelectionStrategy = .range,
        selectionStart: Binding<Date?>,
        selectionEnd: Binding<Date?> = .constant(nil),
        markedDates: OrderedSet<Date> = [],
        calendar: Calendar = .localizedCurrent
    ) {
        self._controller = StateObject(
            wrappedValue: CalendarController(
                selectableDates: selectableDates,
                selectionStrategy: selectionStrategy,
                calendar: calendar
            )
        )
        
        self.presentableDates = presentableDates
        self.markedDates = markedDates
        self._selectionStart = selectionStart
        self._selectionEnd = selectionEnd
    }

    private let columns: [GridItem] = .init(
        repeating: GridItem(
            .flexible(),
            spacing: 0
        ),
        count: Calendar.daysInWeek
    )
    
    public var body: some View {
        ScrollView(.vertical) {
            ScrollViewReader { proxy in
                LazyVStack(spacing: 30, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(controller.months) { month in
                            MonthView(
                                month: month,
                                selection: controller.selection,
                                selectionStrategy: controller.selectionStrategy,
                                markedDates: markedDates,
                                columns: columns,
                                selectDay: controller.selectDate,
                                selectMonth: controller.selectMonth,
                                selectYear: controller.selectYear
                            )
                            .id(month.date.monthId)
                        }
                    } header: {
                        CalendarHeader(
                            isSelectionBarVisible: controller.selectionStrategy.isBarRequired,
                            selection: controller.selection,
                            weekdays: controller.weekdays,
                            columns: columns
                        )
                        .backgroundSizeReader(size: $headerSize)
                    }
                    .animation(.default, value: controller.months.isEmpty)
                }
                .onChange(of: controller.months.isEmpty) { _ in
                    let date = controller.selection.start?.firstDayOfMonth()
                    ?? (presentableDates.contains(.now) ? Date() : nil)
                    ?? presentableDates.start.firstDayOfMonth()
                    
                    scrollTo(date, in: proxy)
                }
            }
        }
        .backport.scrollIndicatorsMargins(.top, headerSize.height)
        .backport.selectionSensoryFeedback(controller.selection)
        .onChange(of: controller.selection) { selection in
            selectionStart = selection.start
            selectionEnd = selection.end
        }
        .task {
            await controller.setup(
                presenting: presentableDates,
                initialStartDate: selectionStart,
                initialEndDate: selectionEnd,
                selectionAnimation: selectionAnimation
            )
        }
    }
    
    private func scrollTo(_ date: Date?, in proxy: ScrollViewProxy) {
        let yFraction: CGFloat = [controller.selectionStrategy.isBarRequired]
            .map { $0 ? 0.22 : 0.12 }
            .map { $0 * 874.0 / UIScreen.main.bounds.height }
            .first
            .unsafelyUnwrapped
        
        proxy.scrollTo(
            date?.monthId,
            anchor: UnitPoint(
                x: 0,
                y: yFraction
            )
        )
    }
}

//swiftlint: disable force_unwrapping
fileprivate struct ProxyView: View {
    let presentableDates = DateInterval(
        start: Date("01 01 2024")!,
        end: Date("26 05 2024")!
    )
    let selectableDates = DateInterval(
        start: Date("03 01 2024")!,
        end: Date("20 03 2024 22:23")!
    )
    @State var marked: OrderedSet<Date> = [
        Date("01 03 2024")!,
        Date("04 03 2024")!,
        Date("06 03 2024")!,
        Date("07 03 2024")!,
        Date("09 03 2024")!
    ]

    @State var selectionStart: Date? = Date("13 03 2024")!
    @State var selectionEnd: Date? = Date("20 03 2024")!

    var body: some View {
        NavigationStack {
            CuteCalendarView(
                presentableDates: presentableDates,
                selectableDates: selectableDates,
                selectionStrategy: .range,
                selectionStart: $selectionStart,
                selectionEnd: $selectionEnd,
                markedDates: marked
            )
            .cuteCalendarConfig { config in
                config.selection.colors = .init(
                    primary: .green,
                    secondary: .mint.opacity(0.2),
                    text: .indigo
                )
            }
            .navigationTitle("Choose date")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: selectionStart) { value in
            print("start: \(value?.humanString ?? "-")")
        }
        .onChange(of: selectionEnd) { value in
            print("end: \(value?.humanString ?? "-")")
        }
    }
}

#Preview {
    ProxyView()
        .preferredColorScheme(.dark)
}
