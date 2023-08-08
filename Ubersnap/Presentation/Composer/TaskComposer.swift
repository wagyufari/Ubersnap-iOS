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
                .foregroundColor(Color.textPrimary.opacity(0.4))
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
                    .foregroundColor(Color.backgroundPrimary)
                    .padding(8)
                    .background(Color.textPrimary)
                    .clipShape(Circle())
                Image("calendar_today")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(viewModel.dueDate != nil ? Color.textPrimary : Color.textSecondary)
                    .frame(width: 16, height: 16)
                    .padding(8)
                    .overlay {
                        if viewModel.dueDate != nil {
                            Circle()
                                .stroke(Color.textPrimary, lineWidth: 1)
                        } else {
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                .foregroundColor(Color.textSecondary)
                        }
                    }
                    .onTapGesture {
                        isTitleFocused = false
                        isDescriptionFocused = false
                        Sheet.show(parentController: viewContext, backgroundColor: Color.backgroundTertiary) {
                            DatePicker(viewModel: DatePickerViewModel(selectedDate: viewModel.dueDate)) { date in
                                self.viewModel.dueDate = date
                            }
                        }
                    }
                
                ZStack{
                    if let color = viewModel.colorHex {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(UIColor(hex: color)))
                    } else {
                        Image("colors_circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .onTapGesture {
                    isTitleFocused = false
                    isDescriptionFocused = false
                    Sheet.show(parentController: viewContext, backgroundColor: Color.backgroundTertiary) {
                        ColorPicker { colorHex in
                            viewModel.colorHex = colorHex
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
                    .foregroundColor(viewModel.title.isEmpty ? Color.textSecondary : Color.textPrimary)
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
        .background(Color.backgroundPrimary)
        .onAppear{
            switch viewModel.initialMode {
            case .Title:
                isTitleFocused = true
            case .Description:
                isDescriptionFocused = true
            case .DueDate:
                Sheet.show(parentController: viewContext, backgroundColor: Color.backgroundTertiary) {
                    DatePicker(viewModel: DatePickerViewModel(selectedDate: viewModel.dueDate)) { date in
                        self.viewModel.dueDate = date
                    }
                }
            case .Color:
                Sheet.show(parentController: viewContext, backgroundColor: Color.backgroundTertiary) {
                    ColorPicker { colorHex in
                        viewModel.colorHex = colorHex
                    }
                }
            case .none:
                break;
            }
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

enum TaskComposerMode {
    case Title
    case Description
    case Color
    case DueDate
}

class TaskComposerViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var description = ""
    @Published var dueDate: Date? = nil
    @Published var colorHex: String? = nil
    
    var editingTask: Task?
    
    let useCases: TaskUseCases
    let initialMode: TaskComposerMode?
    
    init(useCases: TaskUseCases, initialMode: TaskComposerMode? = nil, editingTask: Task? = nil) {
        self.useCases = useCases
        self.editingTask = editingTask
        self.initialMode = initialMode
        if let editingTask {
            title = editingTask.title ?? ""
            description = editingTask.desc ?? ""
            dueDate = editingTask.due_date
            colorHex = editingTask.color
        }
    }
    
    func putTask() {
        if let editingTask {
            editingTask.title = title
            editingTask.desc = description
            editingTask.due_date = dueDate
            editingTask.color = colorHex
            useCases.update.invoke(editedTask: editingTask)
            SnackBar.show(message: "Task successfully updated")
        } else {
            useCases.put.invoke(title: title, description: description, dueDate: dueDate, colorHex: colorHex)
            SnackBar.show(message: "Task created successfully")
        }
    }
    
    func deleteTask() {
        if let editingTask {
            useCases.delete.invoke(id: editingTask.id)
            SnackBar.show(message: "Task deleted")
        }
    }
}
