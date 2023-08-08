//
//  TaskDetailController.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 8/8/2023.
//

import Foundation
import SwiftUI
import UIKit
import CoreData

class TaskDetailController: UIViewController {
    
    let task: Task
    
    init(task: Task){
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        useSwiftUI {
            ContentView(viewContext: self, viewModel: TaskDetailViewModel(useCases: sl(), taskId: self.task.id))
        }
    }
}

class TaskDetailViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    @Published var task: Task?
    let useCases: TaskUseCases
    let taskId: UUID?
    
    init(useCases: TaskUseCases, taskId: UUID?) {
        self.useCases = useCases
        self.taskId = taskId
    }
    
    private var fetchedResultsController: NSFetchedResultsController<Task>?
    
    func getTaskById(id: UUID?) {
        let fetchedResultsController = useCases.getById.invoke(taskId: id)
        fetchedResultsController.delegate = self
        self.fetchedResultsController = fetchedResultsController
        
        do {
            try fetchedResultsController.performFetch()
            task = fetchedResultsController.fetchedObjects?.first
        } catch {
            task = nil
        }
    }
    
    func toggleTask() {
        if let task {
            withAnimation {
                useCases.toggle.invoke(task: task)
            }
        }
    }
}

extension TaskDetailViewModel {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedItems = controller.fetchedObjects as? [Task] {
            task = fetchedItems.first
        }
    }
}

private struct ContentView: View{
    
    let viewContext: UIViewController
    @StateObject var viewModel: TaskDetailViewModel
    
    var body: some View {
        ZStack {
            if let task = viewModel.task {
                ScrollView{
                    VStack(alignment: .leading){
                        Text(task.title ?? "")
                            .theme(.title2)
                            .foregroundColor(Color.textPrimary)
                            .onTapGesture {
                                openComposer(initialMode: .Title)
                            }
                        HStack(spacing: 24){
                            HStack{
                                Text("wa")
                                    .theme(.caption)
                                    .foregroundColor(Color.backgroundPrimary)
                                    .padding(12)
                                    .background(Color.textPrimary)
                                    .clipShape(Circle())
                                VStack(alignment: .leading){
                                    Text("Assigned to")
                                        .theme(.body2)
                                        .foregroundColor(Color.textSecondary)
                                    Text("wagyufari@gmail.com")
                                        .theme(.body2)
                                        .foregroundColor(Color.textPrimary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            HStack{
                                Image("calendar_today")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(task.due_date != nil ? Color.textPrimary : Color.textSecondary)
                                    .frame(width: 16, height: 16)
                                    .padding(8)
                                    .overlay {
                                        if task.due_date != nil {
                                            Circle()
                                                .stroke(Color.textPrimary, lineWidth: 1)
                                        } else {
                                            Circle()
                                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                                .foregroundColor(Color.textSecondary)
                                        }
                                    }
                                VStack(alignment: .leading){
                                    Text("Due date")
                                        .theme(.body2)
                                        .foregroundColor(Color.textSecondary)
                                    if let dueDate = task.due_date {
                                        Text(dueDate.getMMMMdd())
                                            .theme(.body2)
                                            .foregroundColor(Color.textPrimary)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                openComposer(initialMode: .DueDate)
                            }
                        }
                        if let description = task.desc {
                            Text(description.isEmpty ? "Description" : description)
                                .theme(.body)
                                .foregroundColor(description.isEmpty ? Color.textTertiary : Color.textPrimary)
                                .padding(.top, 16)
                                .onTapGesture {
                                    openComposer(initialMode: .Description)
                                }
                        }
                    }
                    .padding(16)
                }
            }
            VStack{
                Spacer()
                let state = viewModel.task?.taskState
                Text(state == .Completed ? "Completed" : "Mark As Complete")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(state == .Completed ? .green : Color.textPrimary)
                    .foregroundColor(state == .Completed ? .white : Color.backgroundPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        viewModel.toggleTask()
                    }
            }
        }.onAppear{
            viewModel.getTaskById(id: viewModel.taskId)
        }
    }
    
    func openComposer(initialMode: TaskComposerMode) {
        Sheet.showGestured(parentController: viewContext) {
            TaskComposer(viewContext: viewContext, viewModel: TaskComposerViewModel(useCases: sl(), initialMode: initialMode, editingTask: viewModel.task))
        }
    }
}
