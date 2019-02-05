//
//  BaseTableViewHeaderFooterView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

typealias BaseLayoutTableViewHeaderFooterView = BaseTableViewHeaderFooterView & BaseLayout

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
		
		setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		
		setup()
    }
	
	func setup() {
		guard let layoutView = self as? BaseLayoutTableViewHeaderFooterView else {
			return
		}
		
		layoutView.setupView()
		layoutView.setupLayout()
	}

}
