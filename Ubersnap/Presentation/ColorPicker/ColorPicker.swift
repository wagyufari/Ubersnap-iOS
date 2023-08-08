//
//  ColorPicker.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 8/8/2023.
//

import Foundation
import SwiftUI

struct ColorPicker: View{
    
    var onPickColor: (String) -> Void
    
    var body: some View{
        VStack{
            Rectangle()
                .foregroundColor(Color.textPrimary.opacity(0.4))
                .frame(width: 32, height: 4)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            ScrollView(.horizontal){
                HStack(spacing: 16){
                    ForEach(Color.NoteColorProvided, id: \.self) { color in
                        Rectangle()
                            .foregroundColor(Color(UIColor(hex: color)))
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            .onTapGesture {
                                onPickColor(color)
                                Sheet.dismiss(self)
                            }
                    }
                }
            }
            .padding(.top, 16)
        }
        .padding(16)
        .padding(.bottom, 48)
    }
    
}
