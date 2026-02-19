//
//  CapShape.swift
//
//
//  Created by Илья Аникин on 28.03.2024.
//

import SwiftUI

/// A shape with left rectangle side and right circle side.
struct CapShape: Shape {
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width / 2, rect.height / 2)
        let center = CGPoint(x: rect.width - radius, y: rect.height / 2)

        var path = Path()

        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: .init(x: 0, y: center.y + radius))
        path.addLine(to: .init(x: 0, y: center.y - radius))
        path.closeSubpath()

        return path
    }
}

#Preview {
    CapShape()
        .fill(.red)
        .frame(width: 300, height: 400)
        .border(.cyan)
}
