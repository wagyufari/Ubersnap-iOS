//
//  Sheet.swift
//
//  Created by Muhammad Ghifari on 28/6/2023.
//

import Foundation
import UIKit
import SwiftUI


struct Sheet{
    
    static func show<Content: View>(parentController: UIViewController, @ViewBuilder rootView: () -> Content){
        let controller = UIViewController()
        controller.useSwiftUI(isClear: true){
            SheetSwiftUIView(content: rootView) {
                controller.view.removeFromSuperview()
            }
        }
        controller.view.backgroundColor = .clear
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.addSubview(controller.view)
    }
    
    
}

private struct SheetSwiftUIView<Content: View>: View{
    @ViewBuilder let content: Content
    @State var isShown = false
    let onDismiss: ()->Void
    
    var observable: NSObjectProtocol?
    
    var body: some View{
        content
            .modifier(BottomSheetWrapModifier(isShown: $isShown, onDismiss: {
                NotificationCenter.default.removeObserver(observable)
                onDismiss()
            }))
            .background(.clear)
            .onAppear{
                Notification.getSheetObserver {
                    isShown = false
                }
                isShown = true
            }
    }
    
}
