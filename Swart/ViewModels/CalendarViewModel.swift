//
//  CalendarViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 31/12/2021.
//

import SwiftUI

final class CalendarViewModel: ObservableObject {
 
    @Published var blockedDates: [String] = []
    @Published var days: [DateValue] = []
    @Published var todaysMonth = 0
    @Published var currentMonth = 0
    @Published var todaysDate = 0
    
    static let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    static let months = ["January": "01", "February": "02", "March": "03", "April": "04", "May": "05", "June": "06", "July": "07", "August": "08", "September": "09", "October": "10", "November": "11", "December": "12"]
    static let monthsNumber = ["01": "January", "02": "February", "03": "March", "04": "April", "05": "May", "06": "June", "07": "July", "08": "August", "09": "September", "10": "October", "11": "November", "12": "December"]
    
    static let collectionPath = "artist"
    private let calendarRepository = CalendarRepository()
    
    func uploadBlockedDates(documentId: String, dates: [String], completion: @escaping (() -> Void)) {
        calendarRepository.uploadBlockedDates(collectionPath: CalendarViewModel.collectionPath, documentId: documentId, dates: dates, completion: completion)
    }
    
    func deleteBlockedDates(documentId: String, dates: [String], completion: @escaping (() -> Void)) {
        calendarRepository.deleteBlockedDates(collectionPath: CalendarViewModel.collectionPath, documentId: documentId, dates: dates, completion: completion)
    }
    
    func getBlockedDates(documentId: String, completion: (() -> Void)? = nil) {
        calendarRepository.getBlockedDates(collectionPath: CalendarViewModel.collectionPath, documentId: documentId) { dates in
            self.blockedDates = dates
            completion?()
        }
    }
    
    func getCurrentMonth(currentIndexMonth: Int) -> Date {
   
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: currentIndexMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate(currentIndexMonth: Int) {
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth(currentIndexMonth: currentIndexMonth)
        
        days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
    }
    
    func extractTodaysDate(_ currentDate: Date) -> [String] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let date = formatter.string(from: currentDate)

        return date.components(separatedBy: " ")
        
    }
    
    func determineTodaysDate(_ currentDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        let todaysDate = formatter.string(from: currentDate)
        let array = todaysDate.components(separatedBy: "/")
        
        if let month = Int(array[0]) {
            self.todaysMonth = month
            self.currentMonth = month
        }
        
        if let day = Int(array[1]) {
            self.todaysDate = day
        }
    }
    
    func convertDateForPresentArtistView(selectedDate: String, completion: @escaping (String) -> Void) {
        
        var selectedDateConverted = selectedDate
        
        let digit = selectedDateConverted.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        if selectedDateConverted != "" {
            if String(digit).count > 5 {
                selectedDateConverted.removeLast(4)
                selectedDateConverted.insert(" ", at: selectedDate.index(selectedDate.startIndex, offsetBy: 2))
            } else {
                selectedDateConverted.removeLast(4)
                selectedDateConverted.insert(" ", at: selectedDate.index(selectedDate.startIndex, offsetBy: 1))
            }
        } else {
            selectedDateConverted = ""
        }
        completion(selectedDateConverted)
    }

    func convertDateForCheckArtistAvailabilityView(date: String) -> String {
        
        var selectedDate = date
        let digit = selectedDate.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        if String(digit).count > 5 {
            selectedDate.removeLast(4)
            selectedDate.insert(" ", at: selectedDate.index(selectedDate.startIndex, offsetBy: 2))
            return selectedDate
        } else {
            selectedDate.removeLast(4)
            selectedDate.insert(" ", at: selectedDate.index(selectedDate.startIndex, offsetBy: 1))
            return selectedDate
        }
    }
    
    func displaySelectedDates(dates: [String]) -> String {
        if dates.count > 1 {
            return "\(String(dates.count))" + " " + "dates"
        } else {
            let drop = String(dates[0].dropLast(4))
            let digits = drop.digits
            
            if digits.count > 1 {
                let month = String(drop.dropFirst(2))
                return "\(digits)" + " " + "\(month)"
            } else {
                let month = String(drop.dropFirst(1))
                return "\(digits)" + " " + "\(month)"
            }
        }
    }
}
