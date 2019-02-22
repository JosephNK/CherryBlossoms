//
//  EqualizerView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 21/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

enum EqualizerDirection {
	case leftToRight
	case bottomToTop
}

class EqualizerView: UIView {
	var timer: Timer?
	var barArray: [UIImageView] = []
	var numberOfBars: Int = 0
	let barPadding: CGFloat = 2.0
	let barWidth: CGFloat = 7.0
	let barHeight: CGFloat = 20.0
	
	deinit {
		self.stop()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	convenience init(numberOfBars: NSInteger) {
		self.init(frame: CGRect.zero)
		
		self.numberOfBars = numberOfBars
		
		for i in 0 ... self.numberOfBars - 1 {
			let bar = UIImageView.init(frame: CGRect(x: CGFloat(i) * barWidth + CGFloat(i) * barPadding, y: 0.0, width: barWidth, height: 1))
			bar.backgroundColor = UIColor.lightGray
			self.addSubview(bar)
			self.barArray.append(bar)
		}
		
		let rotate = CGAffineTransform(rotationAngle: CGFloat(Double.pi) / 2.0 * 2.0)
		self.transform = rotate
		//NotificationCenter.default.addObserver(self, selector: #selector(EqualizerView.stop), name: NSNotification.Name(rawValue: "StopTimer"), object: nil)
	}
	
	func barSize() -> CGSize {
		return CGSize(width: barPadding * CGFloat(self.numberOfBars) + barWidth * CGFloat(self.numberOfBars), height: barHeight)
	}
	
	func stop() {
		self.timer?.invalidate()
		self.timer = nil
	}
	
	func start() {
		if self.timer != nil {
			self.stop()
		}
		self.timer = Timer.scheduledTimer(timeInterval: 0.35,
										  target: self,
										  selector: #selector(EqualizerView.animation),
										  userInfo: nil,
										  repeats: true)
		RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
	}
	
	@objc func animation() {
		let h = UInt32(self.barHeight)
		UIView.animate(withDuration: 0.35) {
			for bar in self.barArray {
				var rect = bar.frame
				rect.size.height = CGFloat((arc4random() % h) + 1)
				bar.frame = rect
			}
		}
	}
	
}

