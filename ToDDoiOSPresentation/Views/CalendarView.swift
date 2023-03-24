//
//  CalendarView.swift
//  ToDDoiOSPresentation
//
//  Created by Min-Yang Huang on 2023/3/24.
//

import SwiftUI

struct CalendarView: View {
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            // Month and year header
            HStack {
                Button(action: {
                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)!
                }) {
                    Image(systemName: "chevron.left")
                }
                Text(calendar.monthHeader(date: selectedDate))
                    .font(.headline)
                Button(action: {
                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate)!
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // Weekday header
            HStack {
                ForEach(calendar.weekdaySymbols, id: \.self) { weekday in
                    Text(weekday.prefix(1))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Days grid
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach(calendar.daysInMonth(date: selectedDate), id: \.self) { date in
                    Button(action: {
                        selectedDate = date
                    }) {
                        Text(dateFormatter.string(from: date))
                            .foregroundColor(calendar.isDate(date, equalTo: selectedDate, toGranularity: .month) ? .white : .primary)
                            .padding()
                            .background(
                                Circle()
                                    .fill(calendar.isDate(date, equalTo: selectedDate, toGranularity: .month) ? Color.blue : Color.clear)
                            )
                    }
                }
            }
        }
    }
}

extension Calendar {
    func monthHeader(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> [Date] {
            let startOfMonth = self.startOfMonth(for: date)
            let range = self.range(of: .day, in: .month, for: startOfMonth)!
            let weekdayOfFirstDayOfMonth = self.component(.weekday, from: startOfMonth)
            let daysToAdd = 1 - weekdayOfFirstDayOfMonth
            let startDate = self.date(byAdding: .day, value: daysToAdd, to: startOfMonth)!
            return (0..<range.count).compactMap { day in
                self.date(byAdding: .day, value: day, to: startDate)
            }
        }
        
    private func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .previewLayout(.sizeThatFits)
    }
}
