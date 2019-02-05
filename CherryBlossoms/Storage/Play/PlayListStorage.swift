//
//  PlayListStorage.swift
//  CherryBlossoms
//
//  Created by JosephNK on 02/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class PlayListStorage {

	static func fetch() -> [PlayListItem] {
		let bundleFileName = "Tracks.bundle"
		let bundleFilePath = Bundle.main.path(forResource: "\(bundleFileName)/datas", ofType: "json")

		guard bundleFilePath != nil else {
			DDLogDebug("The path could not be created.")
			return []
		}
		
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: bundleFilePath!), options: .mappedIfSafe)

			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .useDefaultKeys
			
			let models = try decoder.decode(PlayListItemData.self, from: data)
			let tracks = models.tracks.map { (item) -> PlayListItem in
				return item.remapping(bundleName: bundleFileName)
			}
			return tracks
		} catch {
			DDLogDebug("error")
		}

		return []
	}
	
}
