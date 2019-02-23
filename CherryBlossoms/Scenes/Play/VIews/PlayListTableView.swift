//
//  PlayListTableView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 06/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class PlayListTableView: BaseLayoutTableView {
	
	weak var player: SwiftyMusicPlayer? {
		didSet {
			updateDataSource()
			updateReloadData()
		}
	}
	
	var playlist: [PlayListItem] = [] {
		didSet {
			updateDataSource()
			updateReloadData()
		}
	}
	
	fileprivate var playListDataSource: PlayListDataSource!
	
	fileprivate lazy var headerView: PlayListHeaderView = {
		var headerView = PlayListHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 300.0))
		return headerView
	}()
	
	fileprivate lazy var parallaxHeaderView: ParallaxHeaderView = {
		let subView = self.headerView
		var headerView = ParallaxHeaderView.parallaxHeaderViewWithSubView(subView)
		return headerView
	}()
	
	deinit {
		DDLogDebug("init")
	}
	
	override func initialization() {
		super.initialization()
	}
	
}

extension PlayListTableView {
	
	func setupView() {
		playListDataSource = PlayListDataSource()
		
		self.tableHeaderView = parallaxHeaderView
		self.dataSource = playListDataSource.register(for: self)
		self.delegate = self
		self.separatorColor = UIColor.white
		self.backgroundColor = UIColor.white
		self.bounces = false
	}

	func setupLayout() {
		
	}
	
}

// MARK: - UITableViewDelegate
extension PlayListTableView: UITableViewDelegate {
	
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
		self.player?.playItem(self.playlist[indexPath.row], playStart: true)
	}
}

// MARK: - ScollView Delegate
extension PlayListTableView {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if let header = self.tableHeaderView as? ParallaxHeaderView {
			header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
		}
	}
	
}

// MARK: - Update
extension PlayListTableView {
	
	func updateContentInset(_ contentInset: UIEdgeInsets) {
		self.contentInset = contentInset
	}
	
	func updateDataSource() {
		playListDataSource.player = self.player
		playListDataSource.playlist = self.playlist
	}
	
	func updateReloadData() {
		self.reloadData()
	}
	
	func updateHeaderPlayItem(_ playItem: PlayListItem?) {
		self.headerView.playItem = playItem
	}
	
}
