

import UIKit

final class CalendarHelper {
    
    let calendar = Calendar.current
    
    func plusMonth(date: Date) -> Date {
        guard let calendarDate = calendar.date(byAdding: .month, value: 1, to: date) else { return date }
        return calendarDate
    }
    
    func minusMonth(date: Date) -> Date {
        guard let calendarDate = calendar.date(byAdding: .month, value: -1, to: date) else { return date }
        return calendarDate
    }
    
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func yearsString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    func dayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day ?? 0
    }
    
    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
    
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 2
    }
}
