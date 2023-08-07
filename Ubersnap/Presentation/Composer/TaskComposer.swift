//
//  TaskComposer.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import SwiftUI

struct TaskComposer: View {
    
    let viewContext: UIViewController
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate: Date? = nil
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isDescriptionFocused: Bool
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color.backgroundTertiary)
                .frame(width: 32, height: 4)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            TextField("Task name...", text: $title)
                .focused($isTitleFocused)
                .onSubmit {
                    isDescriptionFocused.toggle()
                }
            TextField("Description", text: $description, axis: .vertical)
                .theme(.body)
                .focused($isDescriptionFocused)
            
            HStack{
                Text("wa")
                    .theme(.caption)
                    .foregroundColor(Color.white)
                    .padding(8)
                    .background(Color.purple)
                    .clipShape(Circle())
                Image("calendar_today")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(dueDate != nil ? Color.purple : Color.textSecondary)
                    .frame(width: 16, height: 16)
                    .padding(8)
                    .overlay {
                        if dueDate != nil {
                            Circle()
                                .stroke(Color.purple, lineWidth: 1)
                        } else {
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                .foregroundColor(Color.textSecondary)
                        }
                    }
                    .onTapGesture {
                        isTitleFocused = false
                        Sheet.show(parentController: viewContext) {
                            DatePicker(viewModel: DatePickerViewModel(selectedDate: dueDate)) { date in
                                self.dueDate = date
                            }
                        }
                    }
                
                Spacer()
                
                Text("Create")
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            .padding(.top, 16)
        }
        .padding()
        .background(Color.backgroundSecondary)
        .onAppear{
            isTitleFocused = true
        }
    }
}




enum ComposerState: Int {
    case Hidden
    case Collapsed
    case Expanded
}

