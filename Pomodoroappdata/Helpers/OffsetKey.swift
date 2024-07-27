//
//  OffsetKey.swift
//  daily-planner-ios
//
//  Created by Ali Siddique on 26/06/2024.
//


import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
