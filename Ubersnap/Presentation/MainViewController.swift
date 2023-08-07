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
            ContentView()
        }
    }
}

private struct ContentView: View{
    var body: some View {
        ZStack{
            Text("ASD")
        }
        .background(Color.backgroundPrimary)
    }
}
