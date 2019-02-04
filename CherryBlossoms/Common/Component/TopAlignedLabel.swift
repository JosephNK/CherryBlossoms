//
//  TopAlignedLabel.swift
//  CherryBlossoms
//
//  Created by JosephNK on 01/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

@IBDesignable class TopAlignedLabel: UILabel {

	override func drawText(in rect: CGRect) {
		if let stringText = text {
			let stringTextAsNSString = stringText as NSString
			var labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude),
																	options: NSStringDrawingOptions.usesLineFragmentOrigin,
																	attributes: [NSAttributedString.Key.font: font],
																	context: nil).size
			if (labelStringSize.height > self.frame.size.height) {
				let pointSize = self.font.pointSize
				let maxLineHeight = pointSize * (floor(self.frame.size.height / pointSize) - 1)
				//labelStringSize.height = self.frame.size.height
				labelStringSize.height = maxLineHeight
			}
			super.drawText(in: CGRect(x: 0, y: 0, width: self.frame.width, height: ceil(labelStringSize.height)))
		} else {
			super.drawText(in: rect)
		}
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		layer.borderWidth = 1
		layer.borderColor = UIColor.black.cgColor
	}

}
