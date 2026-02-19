//
//  MarkedDayModifier.swift
//  CuteCalendar
//
//  Created by Илья Аникин on 06.06.2025.
//

import SwiftUI

extension View {
    func markedDay(_ isMarked: Bool) -> some View {
        modifier(MarkedDayModifier(isMarked: isMarked))
    }
    
    func markedDay(_ isMarked: () -> Bool) -> some View {
        modifier(MarkedDayModifier(isMarked: isMarked()))
    }
}

struct MarkedDayModifier: ViewModifier {
    let isMarked: Bool
    @Environment(\.cuteCalendar.mark) var mark
    
    func body(content: Content) -> some View {
        if isMarked {
            content
                .background(alignment: .top) {
                    Circle()
                        .fill(mark.color)
                        .frame(height: mark.diameter)
                        .padding(.top, mark.topPadding)
                }
        } else {
            content
        }
    }
}

fileprivate struct ProxyView: View {
    @State var isMarked: Bool = false
    
    var body: some View {
        VStack {
            Text("7")
                .frame(width: 30, height: 40)
                .markedDay(isMarked)
                .border(.gray)
            
            Button("Toggle") {
                withAnimation(.easeInOut) {
                    isMarked.toggle()
                }
            }
        }
    }
}

#Preview {
    ProxyView()
}
