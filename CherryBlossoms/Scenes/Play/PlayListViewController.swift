//
//  PlayListViewController.swift
//  CherryBlossoms
//
//  Created by JosephNK on 23/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class PlayListViewController: BaseViewController {

	fileprivate var dataSource: PlayListDataSource!
	
	fileprivate var tableView: UITableView!
	fileprivate var controlView: PlayControlView!
	fileprivate var headerView: PlayListHeaderView!
	
	fileprivate var player = MusicPlayer()
	fileprivate var notificationCenter: NotificationCenter = NotificationCenter.default
	
	fileprivate var playlist: [PlayListItem] = PlayListStorage.fetch()
	
	deinit {
		self.unregisterNotificationCenter()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let controlHeight: CGFloat = 110.0
		
		self.view.backgroundColor = UIColor.white
		
		self.registerNotificationCenter()
		
		player.playItems(self.playlist)
		
		dataSource = PlayListDataSource()
		dataSource.player = self.player
		dataSource.playlist = self.playlist

		tableView = UITableView.init(frame: self.view.frame, style: UITableView.Style.grouped)
		tableView.dataSource = dataSource.register(for: tableView)
		tableView.delegate = self
		tableView.separatorColor = UIColor.white
		tableView.backgroundColor = UIColor.white
		tableView.bounces = false
		tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: controlHeight, right: 0.0)
		
		self.headerView = PlayListHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 300.0))
		tableView.tableHeaderView = self.headerView
		
		controlView = PlayControlView.init(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: controlHeight))
		controlView.player = self.player
		
		self.view.addSubview(tableView)
		self.view.addSubview(controlView)
		
		tableView.snp.makeConstraints { (make) in
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
		
		//
		controlViewAction()
		
		//
		if let firstPlayItem = self.playlist[safe:0] {
			self.headerView.playItem = firstPlayItem
			self.player.playItem(firstPlayItem, playStart: false)
		}
    }

}

// MARK: - UITableViewDelegate
extension PlayListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 55.0
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return nil
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.player.playItem(self.playlist[indexPath.row], playStart: true)
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
		
		self.headerView.playItem = self.player.currentPlayItem as? PlayListItem
		
		self.controlView.updateView()
		
		self.tableView.reloadData()
	}
	
	@objc func onPlaybackStateChanged() {
		self.tableView.reloadData()
	}
	
}

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
