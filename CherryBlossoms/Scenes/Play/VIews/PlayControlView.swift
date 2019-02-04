//
//  PlayControlView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 30/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

enum PlayControlActionType: String {
	case Play = "Play"
	case Pause = "Pause"
	case Prev = "Prev"
	case Next = "Next"
	case SeekDone = "SeekDone"
	case Shuffle = "Shuffle"
	case Repeat = "Repeat"
}

class PlayControlView: BaseView {
	
	var isPlaying: Bool = false {
		didSet {
			if (isPlaying) {
				playButton.isHidden = true
				pauseButton.isHidden = false
			} else {
				playButton.isHidden = false
				pauseButton.isHidden = true
			}
			playButton.isEnabled = true
			pauseButton.isEnabled = true
		}
	}
	
	var isShuffle: Bool = false {
		didSet {
			shuffleButton.tintColor = (isShuffle) ? enableColor : disableColor
		}
	}
	
	var isRepeat: Bool = false {
		didSet {
			repeatButton.tintColor = (isRepeat) ? enableColor : disableColor
		}
	}
	
	weak var player: MusicPlayer?
	
	private var timer: Timer?
	
	private let disableColor = UIColor.init(hexString: "#888888")
	private let enableColor = UIColor.init(hexString: "#0070c9")
	
	private lazy var playButton: UIButton = {
		[unowned self] in
		var button = UIButton()
		button.setImage(UIImage(named: "btnPlay"), for: UIControl.State.normal)
		button.addAction(for: UIControl.Event.touchUpInside, { [weak self] in
			self?.isPlaying = true
			
			self?.actionControlButtonHandler(PlayControlActionType.Play, value: self?.timeSlider.value ?? 0)
		})
		return button
	}()
	
	private lazy var pauseButton: UIButton = {
		[unowned self] in
		var button = UIButton()
		button.setImage(UIImage(named: "btnPause"), for: UIControl.State.normal)
		button.addAction(for: UIControl.Event.touchUpInside, { [weak self] in
			self?.isPlaying = false
			
			self?.actionControlButtonHandler(PlayControlActionType.Pause, value: self?.timeSlider.value ?? 0)
		})
		return button
	}()
	
	private lazy var shuffleButton: UIButton = {
		[unowned self] in
		var button = UIButton()
		button.setImage(UIImage(named: "btnShuffle")?.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
		button.tintColor = self.disableColor
		button.addAction(for: UIControl.Event.touchUpInside, { [weak self] in
			if let isShuffle = self?.isShuffle {
				self?.isShuffle = !isShuffle
			}
			self?.actionControlButtonHandler(PlayControlActionType.Shuffle, value: self?.timeSlider.value ?? 0)
		})
		return button
	}()
	
	private lazy var repeatButton: UIButton = {
		[unowned self] in
		var button = UIButton()
		button.setImage(UIImage(named: "btnRepeat")?.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
		button.tintColor = self.disableColor
		button.addAction(for: UIControl.Event.touchUpInside, { [weak self] in
			if let isRepeat = self?.isRepeat {
				self?.isRepeat = !isRepeat
			}
			self?.actionControlButtonHandler(PlayControlActionType.Repeat, value: self?.timeSlider.value ?? 0)
		})
		return button
	}()
	
	private lazy var nextButton: UIButton = {
		[unowned self] in
		var button = UIButton()
		button.setImage(UIImage(named: "btnFastforward"), for: UIControl.State.normal)
		button.addAction(for: UIControl.Event.touchUpInside, { [weak self] in
			self?.actionControlButtonHandler(PlayControlActionType.Next, value: 0)
		})
		return button
	}()
	
	private lazy var prevButton: UIButton = {
		[unowned self] in
		var button = UIButton()
		button.setImage(UIImage(named: "btnRewind"), for: UIControl.State.normal)
		button.addAction(for: UIControl.Event.touchUpInside, { [weak self] in
			self?.actionControlButtonHandler(PlayControlActionType.Prev, value: 0)
		})
		return button
	}()
	
	private lazy var startTimeLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.init(hexString: "#262628")
		label.font = UIFont.systemFont(ofSize: 12.0)
		label.text = "00:00"
		label.textAlignment = NSTextAlignment.right
		return label
	}()
	
	private lazy var endTimeLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.init(hexString: "#262628", alpha: 0.5)
		label.font = UIFont.systemFont(ofSize: 12.0)
		label.text = "00:00"
		label.textAlignment = NSTextAlignment.left
		return label
	}()
	
	private lazy var timeSlider: UISlider = {
		[unowned self] in
		let slider = UISlider()
		slider.minimumTrackTintColor = UIColor.init(hexString: "#262628")
		slider.thumbTintColor = UIColor.init(hexString: "#262628")
		slider.addAction(for: UIControl.Event.valueChanged, { [weak self] in
			let currentTime = Double(slider.value)
			if let duration = self?.player?.duration {
				self?.startTimeLabel.text = String.conventHumanReadableTimeInterval(currentTime)
				self?.endTimeLabel.text = "-" + String.conventHumanReadableTimeInterval(duration - currentTime)
			}
			self?.unregisterTimer()
		})
		slider.addAction(for: UIControl.Event.touchUpInside, { [weak self] in
			self?.actionControlButtonHandler(PlayControlActionType.SeekDone, value: slider.value)
		})
		return slider
	}()
	
	deinit {
		self.unregisterTimer()
	}

	override func initialization() {
		super.initialization()
		
		self.registerTimer()
	}
	
	override func setupLayout() {
		super.setupLayout()
		
		self.backgroundColor = UIColor.init(hexString: "#FFFFFF")
		
		self.addSubview(startTimeLabel)
		self.addSubview(endTimeLabel)
		
		self.addSubview(timeSlider)
		
		self.addSubview(playButton)
		self.addSubview(pauseButton)
		self.addSubview(prevButton)
		self.addSubview(nextButton)
		self.addSubview(shuffleButton)
		self.addSubview(repeatButton)
		
		startTimeLabel.snp.makeConstraints { (make) in
			make.top.equalTo(self).offset(18.0)
			make.left.equalTo(self).offset(0.0)
			make.width.equalTo(45.0)
		}
		
		endTimeLabel.snp.makeConstraints { (make) in
			make.top.equalTo(self.startTimeLabel)
			make.right.equalTo(self).offset(0.0)
			make.width.equalTo(55.0)
		}
		
		timeSlider.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.startTimeLabel)
			make.left.equalTo(self.startTimeLabel.snp.right).offset(5.0)
			make.right.equalTo(self.endTimeLabel.snp.left).offset(-5.0)
		}
		
		let offset = self.frame.size.width / 4 - 20.0
		
		playButton.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self).offset(-20.0)
		}
		
		pauseButton.snp.makeConstraints { (make) in
			make.centerX.equalTo(self.playButton)
			make.bottom.equalTo(self.playButton)
		}
		
		prevButton.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.playButton)
			make.centerX.equalTo(self.playButton).offset(-offset)
		}
		
		nextButton.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.playButton)
			make.centerX.equalTo(self.playButton).offset(offset)
		}
		
		repeatButton.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.playButton)
			make.left.equalTo(self).offset(20.0)
		}
		
		shuffleButton.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.playButton)
			make.right.equalTo(self).offset(-20.0)
		}
		
		self.isPlaying = false
		
		self.updateSlider()
		self.updateTimeLabels()
		self.updateNextButton()
		self.updatePrevButton()
	}
	
	// MARK: - Handler
	typealias PlayControlButtonHandler = (_ actionType: PlayControlActionType, _ value: Float) -> Void
	private var playControlButtonHandler: PlayControlButtonHandler?
	
	func actionButtonClicked(handler: (PlayControlButtonHandler)? = nil) {
		playControlButtonHandler = handler
	}
	
	// MARK: -
	func sendAction(_ actionType: PlayControlActionType) {
		switch actionType {
		case .Play:
			self.playButton.sendActions(for: UIControl.Event.touchUpInside)
			break;
		case .Pause:
			self.playButton.sendActions(for: UIControl.Event.touchUpInside)
			break;
		case .Prev:
			self.prevButton.sendActions(for: UIControl.Event.touchUpInside)
			break;
		case .Next:
			self.nextButton.sendActions(for: UIControl.Event.touchUpInside)
			break;
		case .SeekDone:
			break;
		case .Shuffle:
			self.shuffleButton.sendActions(for: UIControl.Event.touchUpInside)
			break;
		case .Repeat:
			self.repeatButton.sendActions(for: UIControl.Event.touchUpInside)
			break;
		}
	}
	
	private func actionControlButtonHandler(_ actionType: PlayControlActionType, value: Float) {
		self.timeSlider.value = value
		
		self.unregisterTimer()
		
		if (actionType != .Pause) {
			self.registerTimer()
		}
		
		if let h = self.playControlButtonHandler {
			h(actionType, value)
		}
	}
	
	// MARK: - Update
	func updateView() {
		self.timeSlider.value = 0
		
		self.unregisterTimer()
		
		self.updateSlider()
		self.updateTimeLabels()
		self.updateNextButton()
		self.updatePrevButton()
		
		self.registerTimer()
	}
	
	func updateSlider() {
		self.timeSlider.minimumValue = 0
		self.timeSlider.maximumValue = Float(self.player?.duration ?? 0)
	}
	
	func updateTimeLabels() {
		if let currentTime = self.player?.currentTime, let duration = self.player?.duration {
			self.startTimeLabel.text = String.conventHumanReadableTimeInterval(currentTime)
			self.endTimeLabel.text = "-" + String.conventHumanReadableTimeInterval(duration - currentTime)
		} else {
			self.startTimeLabel.text = "0:00"
			self.endTimeLabel.text = "-0:00"
		}
	}
	
	func updateNextButton() {
		guard let player = self.player else {
			self.nextButton.isEnabled = false
			return
		}
		
		self.isPlaying = player.isPlaying
		
		//self.nextButton.isEnabled = player.nextPlayItem != nil
		self.nextButton.isEnabled = true
	}
	
	func updatePrevButton() {
		guard let player = self.player else {
			self.prevButton.isEnabled = false
			return
		}
		
		self.isPlaying = player.isPlaying
		
		//self.prevButton.isEnabled = player.previousPlayItem != nil
		self.prevButton.isEnabled = true
	}
}

extension PlayControlView {
	
	func registerTimer() {
		self.timer = Timer.every(1.0.seconds) { [weak self] in
			guard let __self = self else { return }
			
			if !__self.timeSlider.isTracking {
				let value = __self.player?.currentTime ?? 0
				__self.timeSlider.value = Float(value)
			}
			
			__self.updateTimeLabels()
		}
	}
	
	func unregisterTimer() {
		self.timer?.invalidate()
	}
	
}
