//
//  Date+Extensions.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 12/11/24.
//
import Foundation


extension Date {
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }

    var startOfLastWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: -6, to: sunday)
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }
        
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    var time: String {
        
        var timestamp = ""

        let today = Date.now
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, "

        var first = ""
        
        if Calendar.current.isDateInToday(self) {
            let future = Calendar.current.date(byAdding: .minute, value: 5, to: self)
            if future! > today {
                timestamp += "just now "
            } else {
                timestamp += "today "
            }
        } else if Calendar.current.isDateInYesterday(self) {
            timestamp += "yesterday "
        }
        
        timestamp += formatter.string(from: self)

        formatter.dateFormat = "h:mm a"
        first = formatter.string(from: self)
        timestamp += first
        
        return timestamp
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)) ~= self
    }
}
