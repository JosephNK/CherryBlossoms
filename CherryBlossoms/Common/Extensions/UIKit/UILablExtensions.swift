//
//  UILablExtensions.swift
//  JosephNK
//
//  Created by JosephNK on 04/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

extension UILabel {
    
    /**
     라벨에 실제 보여지는 라인 수 구하기
     - returns: 라인 수
     */
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
	
	/**
	라벨의 텍스트 중 부분 black bold 변경 함수
	- parameters:
	- fullText: 전체 텍스트
	- changeText: 부분 텍스트
	*/
	func changePartColor(fullText: String , changeText: String) {
		let size = self.font.pointSize
		let strNumber: NSString = fullText as NSString
		let range = (strNumber).range(of: changeText)
		let attribute = NSMutableAttributedString.init(string: fullText)
		attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
		attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold) , range: range)
		self.attributedText = attribute
	}
	
}


