//
//  MainViewController.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController, UIGestureRecognizerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        useSwiftUI {
            ContentView(viewContext: self, viewModel: MainViewModel(useCase: TaskUseCases(managedObjectContext: PersistenceController.shared.container.viewContext)))
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


private struct ContentView: View{
    
    let viewContext: UIViewController
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            List(viewModel.items, id: \.self) { task in
                HStack(spacing: 16){
                    ZStack{
                        if TaskState(rawValue: task.state ?? "") == .Completed {
                            Image("done")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(Color.textPrimary)
                                .frame(width: 16, height: 16)
                                .padding(4)
                                .background(Color.backgroundPrimary)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .stroke(Color.backgroundPrimary, lineWidth: 2)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(24)
                    .background(task.color == nil ? Color.textPrimary : Color(UIColor(hex: task.color!)))
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        viewModel.toggleTask(task: task)
                    }
                    
                    VStack(alignment: .leading){
                        Text(task.title ?? "")
                            .theme(.title2)
                            .strikethrough(task.taskState == .Completed)
                            .foregroundColor(Color.backgroundPrimary)
                        if let dueDate = task.due_date {
                            Text("Due in \(dueDate.getMMMMdd())")
                                .theme(.title4)
                                .foregroundColor(dueDate.isOverdue() ? Color.red : Color.backgroundSecondary)
                        }
                    }
                    .padding(.leading, -16)
                    
                    Spacer()
                    Image("edit_filled")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(Color.textPrimary)
                        .frame(width: 16, height: 16)
                        .padding(4)
                        .background(Color.backgroundPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            Sheet.showGestured(parentController: viewContext) {
                                TaskComposer(viewContext: viewContext, viewModel: TaskComposerViewModel(useCases: sl(), editingTask: task))
                            }
                        }
                }
                .padding(.trailing, 16)
                .background(task.color == nil ? Color.textPrimary : Color(UIColor(hex: task.color!)))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .onTapGesture {
                    if let description = task.desc, description.isNotEmpty {
                        Sheet.show(parentController: viewContext, backgroundColor: Color.backgroundSecondary) {
                            VStack(alignment: .leading){
                                Text(description)
                                    .theme(.body)
                                    .foregroundColor(Color.textPrimary)
                            }
                            .padding(16)
                        }
                    } else {
                        SnackBar.show(message: "Task does not have a description")
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            HStack{
                Spacer()
                Image("add")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.backgroundPrimary)
                    .padding(16)
                    .background(Color.textPrimary)
                    .clipShape(Circle())
                    .onTapGesture {
                        Sheet.showGestured(parentController: viewContext) {
                            TaskComposer(viewContext: viewContext, viewModel: TaskComposerViewModel(useCases: sl()))
                        }
                    }
            }
            .padding(16)
        }
        .onAppear{
            viewModel.getTask()
        }
    }
}
