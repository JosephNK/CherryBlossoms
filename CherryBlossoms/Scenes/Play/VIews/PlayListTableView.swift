//
//  PlayListTableView.swift
//  CherryBlossoms
//
//  Created by JosephNK on 06/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class PlayListTableView: BaseLayoutView {
	
	weak var player: MusicPlayer? {
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
	
	fileprivate var dataSource: PlayListDataSource!
	
	fileprivate lazy var tableView: UITableView = {
		[unowned self] in
		let tableView = UITableView.init(frame: self.frame, style: UITableView.Style.grouped)
		tableView.dataSource = self.dataSource.register(for: tableView)
		tableView.delegate = self
		tableView.separatorColor = UIColor.white
		tableView.backgroundColor = UIColor.white
		tableView.bounces = false
		return tableView
	}()
	
	fileprivate lazy var headerView: PlayListHeaderView = {
		[unowned self] in
		var headerView = PlayListHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 300.0))
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
		dataSource = PlayListDataSource()
		
		tableView.tableHeaderView = headerView
		self.addSubview(tableView)
		
	}

	func setupLayout() {
		tableView.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalTo(self)
		}
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

// MARK: - Update
extension PlayListTableView {
	
	func updateContentInset(_ contentInset: UIEdgeInsets) {
		//tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 110.0, right: 0.0)
		tableView.contentInset = contentInset
	}
	
	func updateDataSource() {
		dataSource.player = self.player
		dataSource.playlist = self.playlist
	}
	
	func updateReloadData() {
		tableView.reloadData()
	}
	
	func updateHeaderPlayItem(_ playItem: PlayListItem?) {
		self.headerView.playItem = playItem
	}
	
}
