//
//  DatePicker.swift
//  Ubersnap
//
//  Created by Muhammad Ghifari on 7/8/2023.
//

import Foundation
import SwiftUI

struct DatePicker: View {
    
    @StateObject var viewModel: DatePickerViewModel
    @State private var frameHeight: CGFloat?
    var onPickDate: (Date?) -> Void
    
    var body: some View {
        VStack(spacing: 16){
            if let selectedDate = viewModel.selectedDate {
                Text(selectedDate.getMMMMdd())
                    .theme(.body)
                    .foregroundColor(Color.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.backgroundTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            HStack{
                TemplateSelection(isSelected: viewModel.selectedDate?.isDateToday == true, text: "Today")
                    .onTapGesture {
                        viewModel.selectedDate = Date.today
                    }
                TemplateSelection(isSelected: viewModel.selectedDate?.isDateTomorrow == true, text: "Tomorrow")
                    .onTapGesture {
                        viewModel.selectedDate = Date.tomorrow
                    }
                TemplateSelection(isSelected: viewModel.selectedDate?.isDateNextMonday == true, text: "Next Monday")
                    .onTapGesture {
                        viewModel.selectedDate = Date.nextMonday
                    }
            }
            TabView(selection: $viewModel.selectedIndex) {
                ForEach(0..<viewModel.dates.count, id: \.self) { index in
                    if let dateOfMonth = viewModel.dates[safe: index] {
                        DateGrid(selectedDate: $viewModel.selectedDate, dateOfMonth: dateOfMonth)
                            .background(GeometryReader(content: { geometry in
                                Color.clear.onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                        frameHeight = geometry.size.height
                                    }
                                }
                            }))
                    }
                }
            }
            .frame(height: frameHeight)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Text("Done")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.purple)
                .foregroundColor(.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.top, 24)
                .onTapGesture {
                    onPickDate(viewModel.selectedDate)
                    Sheet.dismiss(id: String(describing: type(of: self)))
                }
        }
        .padding(16)
        .background(Color.backgroundSecondary)
        .onAppear{
            viewModel.selectedIndex = viewModel.dates.firstIndex(where: { Calendar.current.isDate($0, equalTo: Date(), toGranularity: .month) }) ?? 0
        }
    }
    
    struct TemplateSelection: View{
        
        var isSelected: Bool
        var text: String
        
        var body: some View{
            Text(text)
                .theme(.body)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .foregroundColor(isSelected ? Color.purple : Color.textSecondary)
                .background(isSelected ? Color.purple.opacity(0.4) : Color.backgroundTertiary)
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
    }
    
}

class DatePickerViewModel: ObservableObject {
    
    var dates: [Date] = [Date()]
    @Published var selectedIndex = 0
    @Published var selectedDate: Date?
    
    init(selectedDate: Date?){
        self.selectedDate = selectedDate
    }
    
    init() {
        let yearsToGoBack = 10
        let yearsToGoForward = 10
        
        var dateComponents = DateComponents()
        dateComponents.month = 1
        
        for _ in 1...yearsToGoBack*12 {
            let newDate = Calendar.current.date(byAdding: dateComponents, to: dates.last!)!
            dates.append(newDate)
        }
        dateComponents.month = -1
        for _ in 1...yearsToGoForward*12 {
            let newDate = Calendar.current.date(byAdding: dateComponents, to: dates.first!)!
            dates.insert(newDate, at: 0)
        }
    }
    
    
}