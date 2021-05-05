
import Foundation

class DateConverter {
    
    static let shared = DateConverter()
    
    private init() {}
    
    let dateFormatter = DateFormatter()
    
    func getTaskHour(unixCode: Double) -> String {
        
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        
        let dateTimeInterval = Date(timeIntervalSince1970: unixCode)
        let dateString = dateFormatter.string(from: dateTimeInterval)
        
        return dateString
    }
    
    func getTaskDay(unixCode: Double) -> String {
        
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d"
        
        let dateTimeInterval = Date(timeIntervalSince1970: unixCode)
        let dateString = dateFormatter.string(from: dateTimeInterval)
        
        return dateString
    }
}
