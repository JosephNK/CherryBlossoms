//
//  ParallaxHeaderView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 23/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class ParallaxHeaderView: UIView {
	
	fileprivate let isActiveBasicBlur: Bool = false
	fileprivate let isActiveBlurEffect: Bool = true
	
	fileprivate var headerImage: UIImage?
	fileprivate var imageScrollView: UIScrollView?
	fileprivate var subView: UIView?
	fileprivate var imageView: UIImageView?
	fileprivate var bluredImageView: UIImageView?
	fileprivate var blurEffectView: UIVisualEffectView?
	
	fileprivate let kParallaxDeltaFactor: CGFloat = 0.9
	fileprivate var kDefaultHeaderFrame: CGRect {
		get {
			return CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
		}
	}
	
	static func parallaxHeaderViewWithImage(_ image: UIImage, forSize headerSize: CGSize) -> ParallaxHeaderView {
		let headerView = ParallaxHeaderView.init(frame: CGRect(x: 0.0, y: 0.0, width: headerSize.width, height: headerSize.height))
		headerView.headerImage = image
		headerView.initialSetupForDefaultHeader()
		return headerView
	}
	
	static func parallaxHeaderViewWithSubView(_ subView: UIView) -> ParallaxHeaderView {
		let headerView = ParallaxHeaderView.init(frame: CGRect(x: 0.0, y: 0.0, width: subView.frame.size.width, height: subView.frame.size.height))
		headerView.initialSetupForCustomSubView(subView)
		return headerView
	}
	
	func layoutHeaderViewForScrollViewOffset(_ offset: CGPoint) {
		guard let imageScrollView = self.imageScrollView else {
			return
		}
		
		var frame = imageScrollView.frame
		
		if offset.y > 0.0 {
			frame.origin.y = max(offset.y * kParallaxDeltaFactor, 0.0)
			imageScrollView.frame = frame
			self.clipsToBounds = true
		} else {
			let delta: CGFloat = abs(min(0.0, offset.y))
			var rect = kDefaultHeaderFrame
			rect.origin.y -= delta
			rect.size.height += delta;
			imageScrollView.frame = rect
			self.clipsToBounds = false
		}
		
		if offset.y > 0.0 {
			if isActiveBasicBlur {
				self.bluredImageView?.alpha = 1 / kDefaultHeaderFrame.size.height * offset.y * 2
			}
			if isActiveBlurEffect {
				self.blurEffectView?.alpha = 1 / kDefaultHeaderFrame.size.height * offset.y
			}
		}
	}
	
	func refreshBlurViewForNewImage() {
		if isActiveBasicBlur {
			let alpha = self.bluredImageView?.alpha ?? 0.0
			
			self.bluredImageView?.alpha = 0.0
			self.bluredImageView?.image = nil
			
			if let screenShot = self.screenShotOfView(self),
				let blueScreenShot = screenShot.appliedBlur(withRadius: 5.0, tintColor: UIColor(white: 0.6, alpha: 0.2), saturationDeltaFactor: 1.0, maskImage: nil) {
				self.bluredImageView?.image = blueScreenShot
				self.bluredImageView?.alpha = alpha
			}
		}
	}
	
}


extension ParallaxHeaderView {
	
	fileprivate func initialSetupForDefaultHeader() {
		let scrollView = UIScrollView.init(frame: self.bounds)
		self.imageScrollView = scrollView
		let imageView = UIImageView.init(frame: scrollView.bounds)
		imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
		imageView.contentMode = .scaleAspectFill
		imageView.image = self.headerImage
		self.imageView = imageView
		self.imageScrollView?.addSubview(imageView)
		
		self.addSubview(self.imageScrollView!)
		
		if isActiveBasicBlur {
			self.initialBluredImageView()
			self.refreshBlurViewForNewImage()
		}
		if isActiveBlurEffect {
			self.initialBlurEffectView()
		}
	}
	
	fileprivate func initialSetupForCustomSubView(_ subView: UIView) {
		let scrollView = UIScrollView.init(frame: self.bounds)
		self.imageScrollView = scrollView
		self.imageScrollView?.backgroundColor = .clear
		self.subView = subView
		subView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
		self.imageScrollView?.addSubview(subView)
		
		self.addSubview(self.imageScrollView!)
		
		if isActiveBasicBlur {
			self.initialBluredImageView()
			self.refreshBlurViewForNewImage()
		}
		if isActiveBlurEffect {
			self.initialBlurEffectView()
		}
	}
	
}

extension ParallaxHeaderView {
	
	fileprivate func initialBluredImageView() {
		guard let imageScrollView = self.imageScrollView else {
			return
		}
		
		self.bluredImageView = UIImageView.init(frame: imageScrollView.frame)
		self.bluredImageView?.autoresizingMask = imageScrollView.autoresizingMask
		self.bluredImageView?.alpha = 0.0
		imageScrollView.addSubview(self.bluredImageView!)
	}
	
	fileprivate func screenShotOfView(_ view: UIView) -> UIImage? {
		guard let imageScrollView = self.imageScrollView else {
			return nil
		}
		
		let drawRect = CGRect(x: imageScrollView.frame.origin.x,
							  y: -imageScrollView.frame.origin.y,
							  width: imageScrollView.frame.size.width,
							  height: imageScrollView.frame.size.height)
		
		if #available(iOS 10.0, *) {
			let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
			let capturedImage = renderer.image {
				(ctx) in
				view.drawHierarchy(in: drawRect, afterScreenUpdates: true)
			}
			return capturedImage
		} else {
			UIGraphicsBeginImageContextWithOptions((view.bounds.size), false, 0.0)
			view.drawHierarchy(in: drawRect, afterScreenUpdates: true)
			let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return capturedImage
		}
	}
	
	fileprivate func initialBlurEffectView() {
		guard let imageScrollView = self.imageScrollView else { return }
		
		let blurEffect = UIBlurEffect(style: .extraLight)
		let blurView = UIVisualEffectView(effect: blurEffect)
		blurView.frame = imageScrollView.bounds
		blurView.alpha = 0.0
		self.blurEffectView  = blurView
		
		imageScrollView.addSubview(blurView)
	}
}

extension ParallaxHeaderView {
	
	static func makeTestSubView(width: CGFloat) -> UIView {
		let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 300.0))
		view.backgroundColor = .red
		let label1 = UILabel.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 50.0))
		label1.textColor = .black
		label1.text = "[Top] Hello World!"
		let label2 = UILabel.init(frame: CGRect(x: 0.0, y: 300.0 - 50.0, width: width, height: 50.0))
		label2.textColor = .black
		label2.text = "[Bottom] Hello World!"
		view.addSubview(label1)
		view.addSubview(label2)
		return view
	}
	
}
