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
    
    @StateObject var viewModel: TaskComposerViewModel
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isDescriptionFocused: Bool
    
    @State private var isDeleteConfirmation = false
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color.backgroundTertiary)
                .frame(width: 32, height: 4)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            TextField("Task name...", text: $viewModel.title)
                .focused($isTitleFocused)
                .onSubmit {
                    isDescriptionFocused.toggle()
                }
            TextField("Description", text: $viewModel.description, axis: .vertical)
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
                    .foregroundColor(viewModel.dueDate != nil ? Color.purple : Color.textSecondary)
                    .frame(width: 16, height: 16)
                    .padding(8)
                    .overlay {
                        if viewModel.dueDate != nil {
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
                        isDescriptionFocused = false
                        Sheet.show(parentController: viewContext) {
                            DatePicker(viewModel: DatePickerViewModel(selectedDate: viewModel.dueDate)) { date in
                                self.viewModel.dueDate = date
                            }
                        }
                    }
                
                if viewModel.editingTask != nil {
                    Image("delete")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.red)
                        .frame(width: 16, height: 16)
                        .padding(8)
                        .overlay {
                            Circle()
                                .stroke(Color.red, lineWidth: 1)
                        }
                        .onTapGesture {
                            isDeleteConfirmation.toggle()
                        }
                }
                
                Spacer()
                
                Text(viewModel.editingTask == nil ? "Create" : "Update")
                    .foregroundColor(viewModel.title.isEmpty ? Color.textSecondary : Color.purple)
                    .onTapGesture {
                        if viewModel.title.isNotEmpty {
                            viewModel.putTask()
                            Sheet.dismiss(self)
                        }
                    }
            }
            .padding(.top, 16)
        }
        .padding()
        .background(Color.backgroundSecondary)
        .onAppear{
            isTitleFocused = true
        }
        .alert(isPresented: $isDeleteConfirmation) {
                    Alert(
                        title: Text("Delete Task"),
                        message: Text("Are you sure you want to delete this task?"),
                        primaryButton: .destructive(Text("Delete")) {
                            viewModel.deleteTask()
                            Sheet.dismiss(self)
                        },
                        secondaryButton: .cancel()
                    )
                }
    }
}

class TaskComposerViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var description = ""
    @Published var dueDate: Date? = nil
    
    var editingTask: Task?
    
    let useCases: TaskUseCases
    
    init(useCases: TaskUseCases, editingTask: Task? = nil) {
        self.useCases = useCases
        self.editingTask = editingTask
        if let editingTask {
            title = editingTask.title ?? ""
            description = editingTask.desc ?? ""
            dueDate = editingTask.due_date
        }
    }
    
    func putTask() {
        if let editingTask {
            editingTask.title = title
            editingTask.desc = description
            editingTask.due_date = dueDate
            useCases.update.invoke(editedTask: editingTask)
        } else {
            useCases.put.invoke(title: title, description: description, dueDate: dueDate)
        }
    }
    
    func deleteTask() {
        if let editingTask {
            useCases.delete.invoke(id: editingTask.id)
        }
    }
}
