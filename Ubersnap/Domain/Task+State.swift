//
//  Task+State.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 8/8/2023.
//

import Foundation

enum TaskState: String {
    case Completed = "completed"
    case Running = "running"
}

extension Task {
    var taskState: TaskState {
        return TaskState(rawValue: state ?? "") ?? .Running
    }
}
