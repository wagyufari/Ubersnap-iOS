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
            ContentView(viewContext: self)
        }
    }
}

private struct ContentView: View{
    
    let viewContext: UIViewController
    
    var body: some View {
        ZStack{
            Text("ASD")
        }
        .onTapGesture {
            Sheet.showGestured(parentController: viewContext) {
                TaskComposer(viewContext: viewContext)
            }
        }
        .background(Color.backgroundPrimary)
    }
}
