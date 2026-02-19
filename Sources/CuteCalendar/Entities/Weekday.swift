//
//  Weekday.swift
//
//
//  Created by Илья Аникин on 27.03.2024.
//

import Foundation

struct Weekday: Identifiable {
    let id: UUID
    let localizedTitle: String

    init(localizedTitle: String) {
        self.id = UUID()
        self.localizedTitle = localizedTitle
    }
}
