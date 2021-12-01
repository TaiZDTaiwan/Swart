//
//  DatesFormattersViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 25/09/2021.
//

import SwiftUI

class DatesFormattersViewModel {
    
    func userIs18(birthdate: Date) -> Bool {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let today = formatter.string(from: now)
        let birthday = formatter.string(from: birthdate)
        
        let currentYear = convertDateToYear(date: today)
        let birthdayYear = convertDateToYear(date: birthday)
        
        let currentMonth = convertDateToMonth(date: today)
        let birthdayMonth = convertDateToMonth(date: birthday)
        
        let currentDay = convertDateToDay(date: today)
        let birthdayDay = convertDateToDay(date: birthday)
        
        if Int(currentYear)! - Int(birthdayYear)! < 18 {
            return false
        } else if Int(currentYear)! - Int(birthdayYear)! == 18 {
            if Int(currentMonth)! < Int(birthdayMonth)! {
                return false
            } else {
                if Int(currentMonth)! == Int(birthdayMonth)! {
                    if Int(currentDay)! < Int(birthdayDay)! {
                        return false
                    } else {
                        return true
                    }
                } else {
                    return true
                }
            }
        } else {
            return true
        }
    }
    
    private func convertDateToYear(date: String) -> String {
        let startYear = date.index(date.startIndex, offsetBy: 6)
        let endYear = date.index(date.startIndex, offsetBy: 10)
        let year = startYear..<endYear
        return String(date[year])
    }
    
    private func convertDateToMonth(date: String) -> String {
        let startMonth = date.index(date.startIndex, offsetBy: 0)
        let endMonth = date.index(date.startIndex, offsetBy: 2)
        let month = startMonth..<endMonth
        return String(date[month])
    }
    
    private func convertDateToDay(date: String) -> String {
        let startDay = date.index(date.startIndex, offsetBy: 3)
        let endDay = date.index(date.startIndex, offsetBy: 5)
        let day = startDay..<endDay
        return String(date[day])
    }
}
