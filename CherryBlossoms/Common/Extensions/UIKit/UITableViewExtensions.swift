//
//  UITableViewExtensions.swift
//  JosephNK
//
//  Created by JosephNK on 04/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

extension UITableView {
	
	/**
	테이블 뷰 reloadSections 애니메이션 설정 함수
	- parameters:
	- sections: sections
	- animated: 애니메이션 여부
	*/
	func reloadSections(_ sections: IndexSet, animated: Bool) {
		if animated {
			self.reloadSections(sections, with: .automatic)
		} else {
			UIView.setAnimationsEnabled(false)
			self.reloadSections(sections, with: .none)
			UIView.setAnimationsEnabled(true)
		}
	}
	
}
