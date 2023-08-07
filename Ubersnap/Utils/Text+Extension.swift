//
//  Text+Extension.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import SwiftUI

enum LabelTheme{
    case title1
    case title2
    case title3
    case title4
    case title5
    case title6
    case body
    case body2
    case caption
}

extension Text{
    func theme(_ theme: LabelTheme) -> some View {
            var font: Font
            switch theme {
            case .title1:
                font = .system(size: 28, weight: .bold)
            case .title2:
                font = .system(size: 24, weight: .medium)
            case .title3:
                font = .system(size: 20, weight: .medium)
            case .title4:
                font = .system(size: 16, weight: .medium)
            case .title5:
                font = .system(size: 14, weight: .medium)
            case .title6:
                font = .system(size: 12, weight: .medium)
            case .body:
                font = .system(size: 16, weight: .regular)
            case .body2:
                font = .system(size: 14, weight: .regular)
            case .caption:
                font = .system(size: 12, weight: .regular)
            }

            return self.font(font)
        }
}

extension TextField{
    func theme(_ theme: LabelTheme) -> some View {
            var font: Font
            switch theme {
            case .title1:
                font = .system(size: 28, weight: .bold)
            case .title2:
                font = .system(size: 24, weight: .medium)
            case .title3:
                font = .system(size: 20, weight: .medium)
            case .title4:
                font = .system(size: 16, weight: .medium)
            case .title5:
                font = .system(size: 14, weight: .medium)
            case .title6:
                font = .system(size: 12, weight: .medium)
            case .body:
                font = .system(size: 16, weight: .regular)
            case .body2:
                font = .system(size: 14, weight: .regular)
            case .caption:
                font = .system(size: 12, weight: .regular)
            }

            return self.font(font)
        }
}
