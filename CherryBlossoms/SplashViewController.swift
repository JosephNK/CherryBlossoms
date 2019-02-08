//
//  SplashViewController.swift
//  CherryBlossoms
//
//  Created by JosephNK on 08/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

	lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = UIView.ContentMode.scaleAspectFill
		return view
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.white
		
		guard let image = UIImage(named: "splash") else {
			return
		}
		
		imageView.image = image

        self.view.addSubview(imageView)
		
		imageView.snp.makeConstraints { (make) in
			make.left.right.equalTo(self.view)
			if #available(iOS 11.0, *) {
				make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(0)
				make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(0)
			} else {
				make.top.equalTo(self.topLayoutGuide.snp.bottom).inset(0)
				make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).inset(0)
			}
		}
    }
    

}
