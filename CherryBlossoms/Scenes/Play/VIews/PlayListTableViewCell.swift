//
//  PlayListTableViewCell.swift
//  CherryBlossoms
//
//  Created by JosephNK on 29/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit
import AVFoundation

class PlayListTableViewCell: BaseLayoutTableViewCell {
	
	var indexPath: IndexPath = IndexPath(row: 0, section: 0) {
		didSet {
			self.numberLabel.text = "\(indexPath.row + 1)"
		}
	}
	
	var playItem: PlayListItem? {
		didSet {
			let trackName = playItem?.trackName ?? ""
			self.titleLabel.text = trackName
			
			if let url = playItem?.fileURL {
				let asset = AVURLAsset(url: url)
				let duration = CMTimeGetSeconds(asset.duration)
				self.timeLabel.text = String.conventHumanReadableTimeInterval(duration)
			}
		}
	}

	weak var player: SwiftyMusicPlayer?

	private lazy var numberLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hexString: "#9b9b9b")
		label.font = UIFont.systemFont(ofSize: 18.0)
		label.text = "1"
		label.textAlignment = NSTextAlignment.center
		return label
	}()
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hexString: "#444444")
		label.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)
		label.text = "Title"
		label.textAlignment = NSTextAlignment.left
		return label
	}()
	
	private lazy var timeLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor(hexString: "#444444")
		label.font = UIFont.systemFont(ofSize: 12.0)
		label.text = "00:00"
		label.textAlignment = NSTextAlignment.right
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
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		self.updateAccessory()
	}
	
}

// MARK: - Setup Layout
extension PlayListTableViewCell {
	
	func setupView() {
		self.contentView.backgroundColor = UIColor(hexString: "#F7F7F7")
		
		self.contentView.addSubview(numberLabel)
		self.contentView.addSubview(titleLabel)
		self.contentView.addSubview(timeLabel)
		self.contentView.addSubview(bottomLineView)
	}
	
	func setupLayout() {
		numberLabel.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.contentView)
			make.left.equalTo(self.contentView).offset(20.0)
			make.width.height.equalTo(24.0)
		}
		
		titleLabel.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.numberLabel)
			make.left.equalTo(self.numberLabel.snp.right).offset(12.0)
			make.right.equalTo(self.timeLabel.snp.left).offset(-12.0)
		}
		
		timeLabel.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.numberLabel)
			make.right.equalTo(self.contentView).offset(-20.0)
			make.width.equalTo(35.0)
		}
		
		bottomLineView.snp.makeConstraints { (make) in
			make.left.equalTo(self.contentView).offset(20.0)
			make.right.equalTo(self.contentView).offset(-20.0)
			make.bottom.equalTo(self.contentView)
			make.height.equalTo(1.0)
		}
	}
	
}

// MARK: - Update
extension PlayListTableViewCell {
	
	func updateAccessory() {
		guard let player = self.player else { return }
		
		let fontSize = self.titleLabel.font.pointSize
		
		//if player.isPlaying && self.playItem == player.currentPlayItem {
		if self.playItem == player.currentPlayItem {
			self.titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.bold)
		} else {
			self.titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
		}
	}
	
}
