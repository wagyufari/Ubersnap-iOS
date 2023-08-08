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
            ScrollView{
                VStack{
                    ForEach(0..<viewModel.items.count, id: \.self){ index in
                        if let task = viewModel.items[safe: index]{
                            VStack(spacing: 16){
                                HStack{
                                    Text(task.title ?? "")
                                        .theme(.title2)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                            }
                            .padding(16)
                            .background(task.color == nil ? Color.textTertiary.opacity(0.5) : Color(UIColor(hex: task.color!)))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
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
