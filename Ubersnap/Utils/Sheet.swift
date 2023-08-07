//
//  Sheet.swift
//
//  Created by Muhammad Ghifari on 28/6/2023.
//

import Foundation
import UIKit
import SwiftUI


struct Sheet{
    
    static func show<Content: View>(parentController: UIViewController, @ViewBuilder rootView: () -> Content, onDismiss: (()->Void)? = nil){
        let controller = UIViewController()
        controller.useSwiftUI(isClear: true){
            SheetSwiftUIView(content: rootView) {
                controller.view.removeFromSuperview()
                onDismiss?()
            }
        }
        controller.view.backgroundColor = .clear
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.addSubview(controller.view)
    }
    static func showGestured<Content: View>(parentController: UIViewController, @ViewBuilder rootView: () -> Content){
        let controller = UIViewController()
        controller.useSwiftUI(isClear: true){
            SheetSwiftUIViewGestured(content: rootView) {
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
    
    @State var observable: NSObjectProtocol?
    
    var body: some View{
        content
            .modifier(BottomSheetWrapModifier(isShown: $isShown, onDismiss: {
                NotificationCenter.default.removeObserver(observable)
                onDismiss()
            }))
            .background(.clear)
            .onAppear{
                observable = Notification.getSheetObserver(id: String(describing: type(of: content))){
                    isShown = false
                }
                isShown = true
            }
    }
    
}


private struct SheetSwiftUIViewGestured<Content: View>: View{
    @ViewBuilder let content: Content
    @State var isShown = false
    @GestureState private var translation: CGFloat = 0
    let onDismiss: ()->Void
    
    var body: some View{
        ZStack{
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Color.textPrimary.opacity(0.2))
                .onTapGesture {
                    isShown.toggle()
                    onDismiss()
                }
            VStack{
                Spacer()
                content
            }
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let velocity = CGSize(
                        width:  value.predictedEndLocation.x - value.location.x,
                        height: value.predictedEndLocation.y - value.location.y
                    ).height
                    
                    if velocity > 200 {
                        isShown.toggle()
                        onDismiss()
                    }
                }
            )
        }
    }
    
}
