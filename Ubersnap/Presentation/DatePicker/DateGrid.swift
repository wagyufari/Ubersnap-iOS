//
//  DateGrid.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import SwiftUI

struct DateGrid: View{
    
    @Binding var selectedDate: Date?
    let dateOfMonth: Date
    @State var dates: [[Date]] = []
    var daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View{
        VStack(spacing: 8){
            HStack{
                ForEach(0..<daysOfWeek.count, id: \.self){ index in
                    Text("\(daysOfWeek[index])")
                        .theme(.body2)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.textTertiary)
                }
            }
            ForEach(0..<dates.count, id: \.self) { index in
                if let dateColumn = dates[safe: index] {
                    HStack{
                        ForEach(0..<dateColumn.count, id: \.self) { index in
                            let date = dateColumn[index]
                            let isSameMonth = date.hasMatchingMonthAndYear(with: dateOfMonth)
                            VStack(spacing: 0){
                                if date.dayOfMonth() == 1 {
                                    Text("\(date.getMMM())")
                                        .foregroundColor(isSameMonth ? Color.textSecondary : Color.textTertiary)
                                        .theme(.caption)
                                }
                                Text("\(date.dayOfMonth().description)")
                                    .theme(.body2)
                                    .foregroundColor(isSameMonth ? Color.textPrimary : Color.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(6)
                                    .background(selectedDate == date ? Color.purple : nil)
                                    .clipShape(Circle())
                                    .overlay {
                                        if date.isDateToday {
                                            Circle()
                                                .stroke(Color.purple, lineWidth: 1)
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation{
                                            if selectedDate == date {
                                                selectedDate = nil
                                            } else {
                                                selectedDate = date
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .onAppear{
            dates = getDateByMonth(date: dateOfMonth)
        }
    }
    
    func getDateByMonth(date: Date) -> [[Date]] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return convertTo2DArray(dates: GetCalendarByMonthAndYearUseCase().invoke(month: month, year: year))
    }
    
    func convertTo2DArray(dates: [Date]) -> [[Date]] {
        var resultArray: [[Date]] = []
        var subArray: [Date] = []
        
        for item in dates {
            subArray.append(item)
            
            if subArray.count == 7 {
                resultArray.append(subArray)
                subArray = []
            }
        }
        
        if !subArray.isEmpty {
            resultArray.append(subArray)
        }
        
        return resultArray
    }
}
