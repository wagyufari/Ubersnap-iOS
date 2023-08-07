//
//  GetCalendarByMonthAndYearUseCase.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation

struct GetCalendarByMonthAndYearUseCase {
    
    func invoke(month: Int, year: Int) -> [Date]{
        return generateCalendarDates(for: month, year: year)
    }
    
    
    private func generateCalendarDates(for month: Int, year: Int) -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        let firstDayOfMonth = calendar.date(from: dateComponents)!
        
        let weekdayOfFirstDay = calendar.component(.weekday, from: firstDayOfMonth)
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        
        let numberOfDaysFromPreviousMonth = (weekdayOfFirstDay - calendar.firstWeekday + 7) % 7
        
        let startDate = calendar.date(byAdding: .day, value: -numberOfDaysFromPreviousMonth, to: firstDayOfMonth)!
        
        var calendarDates = [Date]()
        for day in 0..<42 {
            let date = calendar.date(byAdding: .day, value: day, to: startDate)!
            calendarDates.append(date)
        }
        
        return calendarDates
    }
    
}
