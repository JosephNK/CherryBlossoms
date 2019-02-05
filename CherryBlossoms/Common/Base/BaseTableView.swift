//
//  BaseTableView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 06/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

typealias BaseLayoutTableView = BaseTableView & BaseLayout

class BaseTableView: UITableView {

	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)
		
		setup()
		initialization()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		guard let layoutView = self as? BaseLayoutTableView else {
			return
		}
		
		layoutView.setupView()
		layoutView.setupLayout()
	}
	
	func initialization() {
		
	}
	
}
