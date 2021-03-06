//
//  PlayListHeaderView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 30/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

typealias PlayListHeaderInfoButtonAction = () -> Void

class PlayListHeaderView: BaseLayoutView {
	
	let disposeBag = DisposeBag()
	
	var playItem: PlayListItem? {
		didSet {
			var image: UIImage? = nil
			if let albumImageFileURL = playItem?.albumImageFileURL {
				image = UIImage(contentsOfFile: albumImageFileURL.path)
			}
			self.coverImgView.image = image
			
			let albumName = playItem?.albumName ?? ""
			self.titleLabel.text = albumName
			
			let artistName = playItem?.artistName ?? ""
			self.artistNameLabel.text = artistName
			
			let desc = playItem?.desc ?? ""
			self.descLabel.text = desc
		}
	}
	
	private var infoButtonActionHandler: PlayListHeaderInfoButtonAction?
	
	private lazy var coverImgView: UIImageView = {
		let imgView = UIImageView()
		imgView.backgroundColor = UIColor(hexString: "#f5a623")
		return imgView
	}()
	
	private lazy var shadowView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
		//view.layer.shadowRadius = 20
		view.layer.shadowOpacity = 0.2
		return view
	}()
	
	private lazy var circleView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(hexString: "#d8d8d8")
		return view
	}()
	
	public lazy var infoButton: UIButton = {
		var button = UIButton()
		button.setImage(UIImage(named: "iconInfo"), for: UIControl.State.normal)
		return button
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hexString: "#000000")
		label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.bold)
		label.text = "Title"
		label.textAlignment = NSTextAlignment.center
		return label
	}()
	
	private lazy var artistNameLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hexString: "#444444")
		label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
		label.text = "Name"
		label.textAlignment = NSTextAlignment.center
		return label
	}()
	
	private lazy var descLabel: TopAlignedLabel = {
		let label = TopAlignedLabel()
		label.textColor = UIColor(hexString: "#666666")
		label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
		label.numberOfLines = 0
		label.textAlignment = NSTextAlignment.center
		return label
	}()
	
	private lazy var bottomLineView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(hexString: "#e6e6e6")
		return view
	}()
	
	deinit {
		DDLogDebug("deinit")
	}
	
	override func initialization() {
		super.initialization()
		
		self.bindRxEvent()
	}
	
}

// MARK: - Setup Layout
extension PlayListHeaderView {
	
	func setupView() {
		self.backgroundColor = UIColor.white
		
		self.addSubview(shadowView)
		self.addSubview(circleView)
		self.addSubview(coverImgView)
		self.addSubview(infoButton)
		self.addSubview(titleLabel)
		self.addSubview(artistNameLabel)
		self.addSubview(descLabel)
		self.addSubview(bottomLineView)
	}
	
	func setupLayout() {
		coverImgView.snp.makeConstraints { (make) in
			make.top.equalTo(self).offset(30.0)
			make.centerX.equalTo(self).offset(-22.0)
			make.width.height.equalTo(100.0)
		}
		
		shadowView.snp.makeConstraints { (make) in
			make.top.equalTo(self.coverImgView)
			make.centerX.equalTo(self.coverImgView)
			make.width.height.equalTo(self.coverImgView)
		}
		
		circleView.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.coverImgView)
			make.centerX.equalTo(self).offset(22.0)
			make.width.height.equalTo(80.0)
			self.circleView.layer.cornerRadius = 80.0 / 2
		}
		
		infoButton.snp.makeConstraints { (make) in
			make.top.equalTo(self).offset(10.0)
			make.right.equalTo(self).offset(-20.0)
		}
		
		titleLabel.snp.makeConstraints { (make) in
			make.top.equalTo(self.coverImgView.snp.bottom).offset(15.0)
			make.left.equalTo(self).offset(20.0)
			make.right.equalTo(self).offset(-20.0)
			make.centerX.equalTo(self)
		}
		
		artistNameLabel.snp.makeConstraints { (make) in
			make.top.equalTo(self.titleLabel.snp.bottom).offset(4.0)
			make.left.equalTo(self).offset(20.0)
			make.right.equalTo(self).offset(-20.0)
			make.centerX.equalTo(self)
		}
		
		descLabel.snp.makeConstraints { (make) in
			make.top.equalTo(self.artistNameLabel.snp.bottom).offset(10.0)
			make.left.equalTo(self).offset(20.0)
			make.right.equalTo(self).offset(-20.0)
			make.height.equalTo(100.0)
		}
		
		bottomLineView.snp.makeConstraints { (make) in
			make.left.right.bottom.equalTo(self)
			make.height.equalTo(1.0)
		}
	}
	
}

// MARK: - Rx Binding
extension PlayListHeaderView {
	
	func bindRxEvent() {
		infoButton.rx.tap
			.bind(onNext: { [unowned self] _ in
				self.executeInfoButtonAction()
			}).disposed(by: disposeBag)
	}
}

// MARK: - Button Action Handler
extension PlayListHeaderView {
	
	func bindButtonAction(handler: (PlayListHeaderInfoButtonAction)? = nil) {
		infoButtonActionHandler = handler
	}
	
	private func executeInfoButtonAction() {
		if let h = self.infoButtonActionHandler {
			h()
		}
	}
	
}
