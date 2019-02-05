//
//  PlayListDataSource.swift
//  CherryBlossoms
//
//  Created by JosephNK on 29/01/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

struct PlayListCellType {
	static let playListCell = "PlayListTableViewCell"
}

class PlayListDataSource: NSObject {
	
	var playlist: [PlayListItem] = []
	
	weak var player: SwiftyMusicPlayer?
	
	func register(for tableView: UITableView) -> PlayListDataSource {
		tableView.register(PlayListTableViewCell.self, forCellReuseIdentifier: PlayListCellType.playListCell)
		return self
	}
	
}

// MARK: - UITableViewDataSource
extension PlayListDataSource: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.playlist.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: PlayListCellType.playListCell) as? PlayListTableViewCell  {
			cell.indexPath = indexPath
			cell.player = self.player
			cell.playItem = self.playlist[indexPath.row]
			return cell
		}
		
		return UITableViewCell()
	}
	
}
