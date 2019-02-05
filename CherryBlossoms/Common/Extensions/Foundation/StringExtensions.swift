//
//  StringExtensions.swift
//  JosephNK
//
//  Created by JosephNK on 04/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

extension String {
	
	/**
	바이트를 MB 단위 문자로 변환
	- parameters:
	- bytes: 바이트
	- returns: MB 문자 결과
	*/
	static func convertMBFormatter(_ bytes: Int64) -> String {
		let formatter = ByteCountFormatter()
		formatter.allowedUnits = ByteCountFormatter.Units.useMB
		formatter.countStyle = ByteCountFormatter.CountStyle.decimal
		formatter.includesUnit = false
		
		let result = formatter.string(fromByteCount: bytes) as String
		return "\(result)MB"
	}
	
	/**
	조회수를 M,K 단위 문자로 변환
	- parameters:
	- count: 조회수
	- returns: M,K 문자 결과
	*/
	static func convertCountUnit(_ count: Int64) -> String {
		if count >= 1000000 {
			let n = count / 1000000
			let d = count % 1000000
			
			let numberFormatter = NumberFormatter()
			let number = numberFormatter.number(from: "\(n).\(d)")
			let numberFloatValue = number?.floatValue
			return String(format: "%.1fM", numberFloatValue!)
		} else if count >= 1000 {
			let n = count / 1000
			let d = count % 1000
			
			let numberFormatter = NumberFormatter()
			let number = numberFormatter.number(from: "\(n).\(d)")
			let numberFloatValue = number?.floatValue
			return String(format: "%.1fK", numberFloatValue!)
		}
		return "\(count)"
	}
	
	/**
	현재 디바이스 모델의 호환성 표시 함수
	- parameters:
	- compatibleMinVersion: 최소 IOS 버전
	- returns: 문자열로 반환
	*/
	static func convertCompatibleDisplay(compatibleMinVersion: String) -> String {
		let currentModel = UIDevice.current.model
		return "\(String(format: NSLocalizedString("For %@", comment: ""), "\(currentModel)"))"
	}
	
	/**
	디바이스 목록으로 부터 호환되는 디바이스 표시 함수
	- parameters:
	- compatibleDevices: 디바이스 목록
	- compatibleMinVersion: 최소 IOS 버전
	- returns: 문자열로 반환
	*/
	static func convertDeviceInfo(compatibleDevices: [String], compatibleMinVersion: String) -> String {
		//let systemVersion = UIDevice.current.systemVersion
		//DDLogDebug("systemVersion \(systemVersion)")
		
		var isCompatibleIphone = false; var isCompatibleIPad = false; var isCompatibleIPod = false
		var compatibledevices: [String] = []
		for device in compatibleDevices {
			if device.contains("iPhone") && isCompatibleIphone == false {
				isCompatibleIphone = true
				compatibledevices.append("iPhone")
			}
			if device.contains("iPad") && isCompatibleIPad == false {
				isCompatibleIPad = true
				compatibledevices.append("iPad")
			}
			if device.contains("iPod") && isCompatibleIPod == false {
				isCompatibleIPod = true
				compatibledevices.append("iPod touch")
			}
		}
		
		let device1 = compatibledevices[safe: 0]
		let device2 = compatibledevices[safe: 1]
		let device3 = compatibledevices[safe: 2]
		
		var compatibleDeviceInfo: String = ""
		if device1 != nil && device2 != nil && device3 != nil {
			guard let device1 = device1, let device2 = device2, let device3 = device3 else {
				return ""
			}
			compatibleDeviceInfo = String(format: NSLocalizedString("Compatible %@ %@ %@", comment: ""), "\(String(describing: device1))", "\(String(describing: device2))", "\(String(describing: device3))")
		} else if device1 != nil && device2 != nil {
			guard let device1 = device1, let device2 = device2 else {
				return ""
			}
			compatibleDeviceInfo = String(format: NSLocalizedString("Compatible %@ %@", comment: ""), "\(String(describing: device1))", "\(String(describing: device2))", "\(String(describing: device1))")
		} else if device1 != nil {
			guard let device1 = device1 else {
				return ""
			}
			compatibleDeviceInfo = String(format: NSLocalizedString("Compatible %@", comment: ""), "\(String(describing: device1))")
		}
		
		return "\(String(format: NSLocalizedString("RequiresiOS %@", comment: ""), "\(compatibleMinVersion)")) \(compatibleDeviceInfo)"
	}
	
	/**
	ISO2A 목록으로 부터 지원되는 언어 문자열로 반환하는 함수
	- parameters:
	- keys: ISO2A 목록
	- returns: title - 타이틀, desc - 지원되는 언어 문자열, langCount - 결과 목록 수
	*/
	static func conventLanguageCodesISO2A(keys: [String]) -> (title: String, desc: String, langCount: Int) {
		var titleResult: String = ""
		var descResults: [String] = []
		
		let locale = NSLocale.autoupdatingCurrent
		let localeCode = locale.languageCode!
		for code in keys {
			let language = locale.localizedString(forLanguageCode: code)!
			if localeCode.uppercased() == code {
				titleResult = language
			}
			descResults.append(language)
		}
		
		let descResultsCount: Int = descResults.count
		let title = (descResultsCount == 0)
			? String(format: NSLocalizedString("Lang %@", comment: ""), "\(titleResult)")
			: String(format: NSLocalizedString("Lang %@ %@", comment: ""), "\(titleResult)", "\(descResults.count)")
		
		return (title, descResults.joined(separator: ", "), descResultsCount)
	}
	
	static func conventHumanReadableTimeInterval(_ timeInterval: TimeInterval) -> String {
		let timeInt = Int(round(timeInterval))
		let (hh, mm, ss) = (timeInt / 3600, (timeInt % 3600) / 60, (timeInt % 3600) % 60)
		
		let hhString: String? = hh > 0 ? String(hh) : nil
		let mmString = (hh > 0 && mm < 10 ? "0" : "") + String(mm)
		let ssString = (ss < 10 ? "0" : "") + String(ss)
		
		return (hhString != nil ? (hhString! + ":") : "") + mmString + ":" + ssString
	}
	
}

extension String {
	
	/**
	boundingRec 중 높이 가져오기
	- parameters:
	- width: 가로 사이즈
	- font: 폰트
	- returns: 높이 값
	*/
	func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
		
		return CGFloat(boundingBox.height)
	}
	
	/**
	boundingRec 중 가로 가져오기
	- parameters:
	- height: 세로 사이즈
	- font: 폰트
	- returns: 가로 값
	*/
	func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
		
		return CGFloat(boundingBox.width)
	}
	
}
