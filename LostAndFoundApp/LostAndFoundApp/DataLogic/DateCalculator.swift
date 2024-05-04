//
//  DateCalculator.swift
//  LostAndFoundApp
//
//  Created by Raman Khanal on 5/2/24.
//

import Foundation

func parseDate(from dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(identifier: "America/New_York")
    return dateFormatter.date(from: dateString)
}

func timeAgo(from date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: date, to: now)

    if let year = components.year, year > 0 {
        return year == 1 ? "1 year ago" : "\(year) years ago"
    } else if let month = components.month, month > 0 {
        return month == 1 ? "1 month ago" : "\(month) months ago"
    } else if let weekOfYear = components.weekOfYear, weekOfYear > 0 {
        return weekOfYear == 1 ? "1 week ago" : "\(weekOfYear) weeks ago"
    } else if let day = components.day, day > 0 {
        return day == 1 ? "1 day ago" : "\(day) days ago"
    } else if let hour = components.hour, hour > 0 {
        return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
    } else if let minute = components.minute, minute > 0 {
        return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
    } else {
        return "Just now"
    }
}


