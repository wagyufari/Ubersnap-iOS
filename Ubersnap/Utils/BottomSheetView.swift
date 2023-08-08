//
//  BottomSheetView.swift
//
//  Created by Muhammad Ghifari on 09/04/22.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    let onDismiss: ()->Void
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    var backgroundColor: Color? = nil
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, backgroundColor: Color? = nil, onDismiss: @escaping ()->Void, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self.onDismiss = onDismiss
        self.backgroundColor = backgroundColor
        self._isOpen = isOpen
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(backgroundColor ?? Color.backgroundSecondary)
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            ).onChange(of: isOpen) { newValue in
                if !isOpen{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        self.onDismiss()
                    }
                }
            }
        }
    }
}

struct BottomSheetWrapModifier:ViewModifier{
    
    @Binding var isShown: Bool
    @State private var frame: CGFloat = 0
    @State var bottomSafeArea: CGFloat? = nil
    var backgroundColor: Color? = nil
    var onDismiss: ()->Void
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack{
                Rectangle().foregroundColor(Color.backgroundSecondary).opacity(isShown ? 0.4 : 0).onTapGesture {
                    isShown.toggle()
                }
                BottomSheetView(
                    isOpen: $isShown,
                    maxHeight: frame == 0 ? geometry.size.height * 0.9 : frame,
                    backgroundColor: backgroundColor,
                    onDismiss: onDismiss
                ) {
                    VStack{
                        content
                            .onAppear{
                                if bottomSafeArea == nil {
                                    bottomSafeArea = SafeArea.safeAreaInsets?.bottom
                                }
                            }
                        Spacer()
                            .frame(height: bottomSafeArea)
                    }.background(ViewGeometry()).onPreferenceChange(ViewHeightKey.self){
                        frame = $0 > geometry.size.height * 0.9 ? geometry.size.height * 0.9 : $0
                    }
                }.foregroundColor(Color.backgroundSecondary)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct BottomSheetModifier:ViewModifier{
    
    @Binding var isShown: Bool
    var onDismiss: ()->Void
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack{
                Rectangle().foregroundColor(.black).opacity(isShown ? 0.4 : 0).onTapGesture {
                    isShown.toggle()
                }
                BottomSheetView(
                    isOpen: $isShown,
                    maxHeight: geometry.size.height * 0.9,
                    onDismiss: onDismiss
                ) {
                    content
                }.foregroundColor(.backgroundSecondary)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}


struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ViewGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ViewHeightKey.self, value: geometry.size.height)
        }
    }
}
