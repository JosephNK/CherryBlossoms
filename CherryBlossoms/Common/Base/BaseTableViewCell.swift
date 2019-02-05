//
//  BaseTableViewCell.swift
//  CherryBlossoms
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

typealias BaseLayoutTableViewCell = BaseTableViewCell & BaseLayout

class BaseTableViewCell: UITableViewCell {

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setup()
		initialization()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setup()
		initialization()
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		setup()
        initialization()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setup() {
		guard let layoutView = self as? BaseLayoutTableViewCell else {
			return
		}
		
		layoutView.setupView()
		layoutView.setupLayout()
	}
	
	func initialization() {
		self.selectionStyle = .none
	}
    
}
