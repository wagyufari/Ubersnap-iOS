//
//  Date+Extension.swift
//  Calendar
//
//  Created by Muhammad Ghifari on 1/5/2023.
//

import Foundation

extension Date {
    
    func dayOfMonth() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 0
    }
    
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    func weekday() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday ?? 1
    }
    
    func addDays(_ days: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func daysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        return range.count
    }
    
    func endOfWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        let startOfWeek = calendar.date(from: components)!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        return endOfWeek
    }
    
    func advancedBy(days: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = days
        return calendar.date(byAdding: dateComponents, to: self)!
    }
    
    func hasMatchingMonthAndYear(with otherDate: Date) -> Bool {
        let calendar = Calendar.current
        let componentsSelf = calendar.dateComponents([.year, .month], from: self)
        let componentsOther = calendar.dateComponents([.year, .month], from: otherDate)
        
        return componentsSelf.year == componentsOther.year && componentsSelf.month == componentsOther.month
    }
    
    
    
    var isDateToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var isDateTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    var isDateNextMonday: Bool {
        return self == Date.nextMonday
    }
    
    func getMMM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    func getMMMMdd() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter.string(from: self)
    }
    
    func isOverdue() -> Bool {
           return self < Date()
       }
}

extension Date {
    func next(_ weekday: Weekday) -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let components = DateComponents(weekday: weekday.rawValue)
        return calendar.nextDate(after: self, matching: components, matchingPolicy: .nextTime, direction: .forward)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().startOfDay)!
    }
    
    static var today: Date {
        return Date().startOfDay
    }
    
    static var nextMonday: Date {
        return Date().next(.monday).startOfDay
    }
}

enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}


extension String {
    func getDateFromSimpleFormat() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.date(from: self) ?? Date()
    }
}
