//
//  TaskDetailController.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 8/8/2023.
//

import Foundation
import SwiftUI
import UIKit

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
            ContentView(viewContext: self, viewModel: TaskDetailViewModel(task: task))
        }
    }
}

class TaskDetailViewModel: ObservableObject {
    
    @Published var task: Task
    init(task: Task) {
        self.task = task
    }
    
}

private struct ContentView: View{
    
    let viewContext: UIViewController
    let viewModel: TaskDetailViewModel
    
    var body: some View{
        VStack{
            Text(viewModel.task.title ?? "")
                .foregroundColor(Color.textPrimary)
        }
    }
}
