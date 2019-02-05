//
//  BaseCollectionViewCell.swift
//  CherryBlossoms
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

typealias BaseLayoutCollectionViewCell = BaseCollectionViewCell & BaseLayout

class BaseCollectionViewCell: UICollectionViewCell {
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
		setup()
		initialization()
    }
    
	func setup() {
		guard let layoutView = self as? BaseLayoutCollectionViewCell else {
			return
		}
		
		layoutView.setupView()
		layoutView.setupLayout()
	}
	
	func initialization() {
		
	}
    
}
