//
//  Color+Extension.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    static var textPrimary = Color(UIColor.label)
    static var textSecondary = Color(UIColor.secondaryLabel)
    static var textTertiary = Color(UIColor.tertiaryLabel)
    static var backgroundPrimary = Color(UIColor.systemBackground)
    static var backgroundSecondary = Color(UIColor.secondarySystemBackground)
    static var backgroundTertiary = Color(UIColor.tertiarySystemBackground)
}

extension Color {
    static var NoteColorProvided = [
        "#007AFF", // Blue
        "#34C759", // Green
        "#FF9500", // Orange
        "#FF2D55", // Red
        "#5856D6", // Purple
        "#5AC8FA", // Light Blue
        "#FFCC00", // Yellow
        "#FF3B30"]

}

extension UIColor {
    convenience init(hex: String) {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formattedHex.count == 6 {
            formattedHex = "FF" + formattedHex
        }
        var hexInt: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&hexInt)
        let red = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexInt & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
