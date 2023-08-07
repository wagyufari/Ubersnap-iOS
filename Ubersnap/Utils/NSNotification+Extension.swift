//
//  NSNotification+Extension.swift
//
//  Created by Muhammad Ghifari on 28/6/2023.
//

import Foundation
import UIKit

extension NSNotification.Name {
    static let DEFAULT = NSNotification.Name("com.wagyufari.ubersnap.default")
    static let SHEET_HIDE = NotificationKey.Sheet.Hide.toNSNotificationName()
}

struct NotificationKey{
    struct Sheet {
        static let Hide = "com.wagyufari.ubersnap.sheet.hide"
    }
}

extension Notification{
    static func send(_ name:NSNotification.Name? = nil, object: Any? = nil){
        NotificationCenter.default.post(name: name ?? .DEFAULT, object: object)
    }
    
    static func observe(name: NSNotification.Name? = nil, handler: @escaping (Any?)->Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: name ?? .DEFAULT, object: nil, queue: nil) { Notification in
            handler(Notification.object)
        }
    }
    
    static func getObserver(name: NSNotification.Name? = nil, handler: @escaping (Any?)->Void) -> NSObjectProtocol {
        let name: NSNotification.Name = name ?? .DEFAULT
        return NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { Notification in
            handler(Notification.object)
        }
    }
    
    static func getSheetObserver(handler: @escaping () -> Void) -> NSObjectProtocol {
        return getObserver(name: .SHEET_HIDE){ obj in
            handler()
        }
    }
    
    static func hideSheet(){
        Notification.send(.SHEET_HIDE)
    }
    
    static func onResume(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            callback()
        }
    }
}

extension Sheet {
    static func dismiss(){
        Notification.send(.SHEET_HIDE)
    }
}

extension String{
    func toNSNotificationName() -> NSNotification.Name{
        return NSNotification.Name(rawValue: self)
    }
}

extension NSObjectProtocol {
    func disposed(by: inout [NSObjectProtocol]) {
        by.append(self)
    }
}

extension Array where Element: NSObjectProtocol {
    func dispose() {
        for element in self {
            if let observer = element as? NSObjectProtocol {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
}
