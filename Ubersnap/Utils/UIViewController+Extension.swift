//
//  UIViewController+Extension.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import UIKit
import SwiftUI


extension UIViewController {
    func useSwiftUI<Content: View>(isClear: Bool? = nil, @ViewBuilder rootView: () -> Content) {
        let hostingController = UIHostingController(rootView: rootView())
        if let isClear, isClear{
            hostingController.view.backgroundColor = .clear
        }
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
}
