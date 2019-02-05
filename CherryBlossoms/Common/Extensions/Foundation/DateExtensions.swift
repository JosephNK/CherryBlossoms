//
//  DateExtensions.swift
//  JosephNK
//
//  Created by JosephNK on 04/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

extension Date {
	
	/**
	애플 날짜 형식 문자로 부터 Date 타입으로 변환 함수
	- parameters:
	- dateString: 날짜 문자열
	- returns: 날짜
	*/
	static func convertAppleStringToDate(_ dateString: String?) -> Date? {
		guard let dateString = dateString else {
			return nil
		}
		if dateString.isEmpty {
			return nil
		}
		return convertStringToDate(dateString, dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
	}
	
	/**
	애플 날짜 형식 문자로 부터 Date 타입으로 변환 함수
	- parameters:
	- dateString: 날짜 문자열
	- dateFormat: Date Format
	- returns: 날짜
	*/
	static func convertStringToDate(_ dateString: String, dateFormat: String) -> Date? {
		let dateFormatter = DateFormatter()
		//dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.dateFormat = dateFormat
		return dateFormatter.date(from: dateString)
	}
	
	/**
	날짜를 간소화해서 이전 형식으로 표시
	- parameters:
	- date: 날짜
	- returns: X 년 전 등등으로 반환
	*/
	static func timeAgoSince(_ date: Date?) -> String {
		guard let date = date else {
			return ""
		}
		
		let calendar = Calendar.current
		let now = Date()
		let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
		let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
		
		if let year = components.year, year >= 1 {
			return "\(year)\(NSLocalizedString("YearAgo", comment: ""))"
		}
		
		if let month = components.month, month >= 1 {
			return "\(month)\(NSLocalizedString("MonthAgo", comment: ""))"
		}
		
		if let week = components.weekOfYear, week >= 1 {
			return "\(week)\(NSLocalizedString("WeekAgo", comment: ""))"
		}
		
		if let day = components.day, day >= 1 {
			return "\(day)\(NSLocalizedString("DayAgo", comment: ""))"
		}
		
		if let hour = components.hour, hour >= 1 {
			return "\(hour)\(NSLocalizedString("HourAgo", comment: ""))"
		}
		
		if let minute = components.minute, minute >= 1 {
			return "\(minute)\(NSLocalizedString("MinutesAgo", comment: ""))"
		}
		
		if let second = components.second, second >= 3 {
			return "\(second)\(NSLocalizedString("SecondAgo", comment: ""))"
		}
		
		return NSLocalizedString("JustNow", comment: "")
		
	}
	
}

