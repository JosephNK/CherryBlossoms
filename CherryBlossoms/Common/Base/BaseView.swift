//
//  BaseView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 30/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

typealias BaseLayoutView = BaseView & BaseLayout

class BaseView: UIView {
	
	var parameter: Any?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setup()
		initialization()
	}
	
	convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	convenience init(frame: CGRect, parameter: Any) {
		self.init(frame: frame)
		
		self.parameter = parameter
	}
	
	convenience init(parameter: Any) {
		self.init(frame: CGRect.zero)
		
		self.parameter = parameter
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("This class does not support NSCoding")
	}
	
	func setup() {
		guard let layoutView = self as? BaseLayoutView else {
			return
		}
		
		layoutView.setupView()
		layoutView.setupLayout()
	}
	
	func initialization() {
		
	}
	
}
