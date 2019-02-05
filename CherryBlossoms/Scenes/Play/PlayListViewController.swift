//
//  PlayListViewController.swift
//  CherryBlossoms
//
//  Created by JosephNK on 23/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class PlayListViewController: BaseLayoutViewController {
	
	fileprivate var player = MusicPlayer()
	
	fileprivate var playlist: [PlayListItem] = PlayListStorage.fetch()
	
	fileprivate var notificationCenter: NotificationCenter = NotificationCenter.default
	
	fileprivate	let controlHeight: CGFloat = 110.0
	
	fileprivate lazy var playTableView: PlayListTableView = {
		[unowned self] in
		var view = PlayListTableView(frame: self.view.frame)
		view.player = self.player
		view.playlist = self.playlist
		return view
	}()
	
	fileprivate lazy var controlView: PlayControlView = {
		[unowned self] in
		let view = PlayControlView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.controlHeight))
		view.player = self.player
		return view
	}()
	
	deinit {
		DDLogDebug("deinit")
		self.unregisterNotificationCenter()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.registerNotificationCenter()
		
		// Set Player PlayItems
		player.playItems(self.playlist)
		
		// Set Control Action
		controlViewAction()
		
		// Set First Play Item
		if let firstPlayItem = self.playlist[safe:0] {
			self.playTableView.updateHeaderPlayItem(firstPlayItem)
			self.player.playItem(firstPlayItem, playStart: false)
		}
    }

}

// MARK: - Setup Layout
extension PlayListViewController {
	
	func setupView() {
		self.view.backgroundColor = UIColor.white
		
		self.view.addSubview(playTableView)
		self.view.addSubview(controlView)
	}
	
	func setupLayout() {
		// Update ListView Content Inset
		playTableView.updateContentInset(UIEdgeInsets(top: 0.0, left: 0.0, bottom: controlHeight, right: 0.0))
		
		playTableView.snp.makeConstraints { (make) in
			make.left.right.equalTo(self.view)
			if #available(iOS 11.0, *) {
				make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(0)
				make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(0)
			} else {
				make.top.equalTo(self.topLayoutGuide.snp.bottom).inset(0)
				make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).inset(0)
			}
		}
		
		controlView.snp.makeConstraints { (make) in
			make.left.right.equalTo(self.view)
			make.height.equalTo(controlHeight)
			if #available(iOS 11.0, *) {
				make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(0)
			} else {
				make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).inset(0)
			}
		}
	}
	
}

// MARK: - Notifications
extension PlayListViewController {
	
	func registerNotificationCenter() {
		self.notificationCenter.addObserver(self, selector: #selector(onTrackChanged), name: NSNotification.Name(rawValue: MusicPlayerNotification.OnTrackChangedNotification), object: nil)
		self.notificationCenter.addObserver(self, selector: #selector(onPlaybackStateChanged), name: NSNotification.Name(rawValue: MusicPlayerNotification.OnPlaybackStateChangedNotification), object: nil)
	}
	
	func unregisterNotificationCenter() {
		self.notificationCenter.removeObserver(self)
	}
	
	@objc func onTrackChanged() {
		if self.player.currentPlayItem == nil {
			return
		}
		
		self.playTableView.updateHeaderPlayItem(self.player.currentPlayItem as? PlayListItem)
		
		self.controlView.updateView()
		
		self.playTableView.updateReloadData()
	}
	
	@objc func onPlaybackStateChanged() {
		self.playTableView.updateReloadData()
	}
	
}

// MARK: - Control Action
extension PlayListViewController {
	
	func controlViewAction() {
		controlView.actionButtonClicked { [weak self] (actionType, value) in
			guard let player = self?.player, let controlView = self?.controlView else { return }
			
			switch actionType {
			case .Play:
				if player.currentPlayItem != nil {
					player.play()
				}
				break;
			case .Pause:
				player.pause()
				break;
			case .Prev:
				player.previousTrack()
				break;
			case .Next:
				player.nextTrack()
				break;
			case .SeekDone:
				player.seekTo(Double(value))
				break
			case .Shuffle:
				let isShuffle = controlView.isShuffle
				player.isShuffle = isShuffle
				break;
			case .Repeat:
				let isRepeat = controlView.isRepeat
				player.isRepeat = isRepeat
				break;
			}
			
			if (actionType != .Shuffle && actionType != .Repeat) {
				controlView.isPlaying = player.isPlaying
			}
		}
	}
	
}
