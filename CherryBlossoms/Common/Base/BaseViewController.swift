//
//  BaseViewController.swift
//  CherryBlossoms
//
//  Created by JosephNK on 2018. 10. 26..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

typealias BaseLayoutViewController = BaseViewController & BaseLayout

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setup()
    }
	
	func setup() {
		guard let layoutView = self as? BaseLayoutViewController else {
			return
		}
		
		layoutView.setupView()
		layoutView.setupLayout()
	}

}
