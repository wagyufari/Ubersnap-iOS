//
//  SafeArea+Utils.swift
//  kci
//
//  Created by Muhammad Ghifari on 28/6/2023.
//

import Foundation
import UIKit

struct SafeArea {
    static var safeAreaInsets: UIEdgeInsets? = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets
}
