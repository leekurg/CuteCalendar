//
//  ContentView.swift
//  CuteCalendarExample
//
//  Created by Илья Аникин on 19.02.2026.
//

import CuteCalendar
import OrderedCollections
import SwiftUI

struct ContentView: View {
    @State var startDate: Date? = .now.firstDayOfMonth()
    @State var endDate: Date? = nil
    @State var markedDates: OrderedSet<Date> = []
    
    @State var isCalendarShowing: CalendarSelectMode?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack {
                VStack(alignment: .leading) {
                    Text("Selected dates:").font(.title2)
                    Text("Start: \(startDate?.formatted(date: .numeric, time: .standard) ?? "-")")
                    Text("End: \(endDate?.formatted(date: .numeric, time: .standard) ?? "-")")
                }
                
            }
            Button("Select") {
                isCalendarShowing = .select
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Marked dates:").font(.title2)
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(markedDates, id: \.humanString) { date in
                            Text("- \(date.formatted(date: .numeric, time: .standard))")
                        }
                    }
                    .frame(maxHeight: 100)
                }
                
            }
            
            Button("Mark") {
                isCalendarShowing = .mark
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .sheet(item: $isCalendarShowing) { mode in
            NavigationStack {
                CuteCalendarView(
                    presentableDates: Date.now.yearInterval()!,
                    selectableDates: Date.now.monthInterval(),
                    selectionStrategy: mode == .select ? .range : .single(behaviour: .silent),
                    selectionStart: $startDate,
                    selectionEnd: $endDate,
                    markedDates: markedDates,
                    calendar: .localizedCurrent
                )
                .navigationTitle(mode == .select ? "Select dates" : "Mark dates")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") {
                            isCalendarShowing = nil
                        }
                    }
                }
            }
            .onChange(of: startDate) { date in
                if mode == .mark, let date {
                    handleSelectedMark(date)
                }
            }
        }
    }
    
    private func handleSelectedMark(_ date: Date) {
        if markedDates.contains(date) {
            markedDates.remove(date)
        } else {
            markedDates.append(date)
        }
    }
}

enum CalendarSelectMode: String, Identifiable {
    case select
    case mark
    
    var id: String { rawValue }
}

#Preview {
    ContentView()
}
