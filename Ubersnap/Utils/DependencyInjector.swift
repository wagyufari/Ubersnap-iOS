//
//  DependencyInjector.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import Swinject
import UIKit

func resolveContainer() -> Container {
    let container = Container()
    let persistence = PersistenceController.shared.container
    
    container.register(TaskUseCases.self){_ in
        TaskUseCases(managedObjectContext: persistence.viewContext)
    }
    
    return container
}

func sl<T>() -> T {
    return (UIApplication.shared.delegate as! AppDelegate).container.resolve(T.self)!
}

