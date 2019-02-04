//
//  BaseTableViewCell.swift
//  CherryBlossoms
//
//  Created by JosephNK on 2018. 10. 23..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		initialization()
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		initialization()
		setupLayout()
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialization()
		setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initialization() {
        self.selectionStyle = .none
    }
	
	func setupLayout() {
		
	}
    
}
