//
//  ParallaxHeaderView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 23/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class ParallaxHeaderView: UIView {
	
	lazy var headerTitleLabel: UILabel = {
		let o = UILabel()
		return o
	}()
	
	var headerImage: UIImage?
	
	lazy var imageScrollView: UIScrollView = {
		let o = UIScrollView()
		return o
	}()
	
	lazy var imageView: UIImageView = {
		let o = UIImageView()
		return o
	}()
	
	lazy var subView: UIView = {
		let o = UIView()
		return o
	}()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
