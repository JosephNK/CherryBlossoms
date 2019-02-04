//
//  BaseView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 30/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class BaseView: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		initialization()
		setupLayout()
	}
	
	convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("This class does not support NSCoding")
	}

	func initialization() {
		
	}
	
	func setupLayout() {
		
	}
	
}
