//
//  MainViewController.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        useSwiftUI {
            ContentView(viewContext: self, viewModel: MainViewModel(useCase: TaskUseCases(managedObjectContext: PersistenceController.shared.container.viewContext)))
        }
    }
}


private struct ContentView: View{
    
    let viewContext: UIViewController
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            ScrollView{
                VStack{
                    ForEach(0..<viewModel.items.count, id: \.self){ index in
                        if let task = viewModel.items[safe: index]{
                            VStack(spacing: 0){
                                Text(task.title ?? "")
                                    .theme(.body)
                                    .padding(.vertical, 16)
                                Divider()
                            }
                            .background(Color.backgroundSecondary)
                            .onTapGesture {
                                Sheet.showGestured(parentController: viewContext) {
                                    TaskComposer(viewContext: viewContext, viewModel: TaskComposerViewModel(useCases: sl(), editingTask: task))
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            HStack{
                Spacer()
                Image("add")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.white)
                    .padding(16)
                    .background(Color.purple)
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
