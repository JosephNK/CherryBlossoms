//
//  PlayListItem.swift
//  CherryBlossoms
//
//  Created by JosephNK on 02/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class PlayListItemData: Codable {
	let tracks: [PlayListItem]
}

class PlayListItem: MusicPlayItem, Codable {

	let fileName: String
	let albumImageName: String
	let desc: String
	
	private enum CodingKeys: String, CodingKey {
		case identifier = "identifier"
		case trackName = "trackName"
		case albumName = "albumName"
		case artistName = "artistName"
		case albumImageName = "albumImageName"
		case fileName = "fileName"
		case desc = "description"
	}
	
	required init(from decoder: Decoder) throws {
		// Get our container for this subclass' coding keys
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let identifier = (try? container.decode(String.self, forKey: .identifier)) ?? ""
		let trackName = (try? container.decode(String.self, forKey: .trackName)) ?? ""
		let albumName = (try? container.decode(String.self, forKey: .albumName)) ?? ""
		let artistName = (try? container.decode(String.self, forKey: .artistName)) ?? ""
		let albumImageName = (try? container.decode(String.self, forKey: .albumImageName)) ?? ""
		let fileName = (try? container.decode(String.self, forKey: .fileName)) ?? ""
		let desc = (try? container.decode(String.self, forKey: .desc)) ?? ""
		
		self.fileName = fileName
		self.albumImageName = albumImageName
		self.desc = desc
		
		// https://stackoverflow.com/a/44605696
		// Get superDecoder for superclass and call super.init(from:) with it
		let superDecoder = try container.superDecoder()
		try super.init(from: superDecoder)
		
		self.identifier = identifier
		self.trackName = trackName
		self.albumName = albumName
		self.artistName = artistName
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(self.identifier, forKey: .identifier)
		try self.identifier.encode(to: container.superEncoder(forKey: .identifier))
		
		try container.encode(self.trackName, forKey: .trackName)
		try self.trackName.encode(to: container.superEncoder(forKey: .trackName))
		
		try container.encode(self.albumName, forKey: .albumName)
		try self.albumName.encode(to: container.superEncoder(forKey: .albumName))
		
		try container.encode(self.artistName, forKey: .artistName)
		try self.artistName.encode(to: container.superEncoder(forKey: .artistName))
		
		try container.encode(self.albumImageName, forKey: .albumImageName)
		try self.albumImageName.encode(to: container.superEncoder(forKey: .albumImageName))
	}
	
	func remapping(bundleName: String) -> PlayListItem {
		let convertAlbumImageName = self.albumImageName as NSString
		let convertFileName = self.fileName as NSString
		
		self.albumImageFileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "\(bundleName)/\(convertAlbumImageName.deletingPathExtension)", ofType: convertAlbumImageName.pathExtension)!)
		self.fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "\(bundleName)/\(convertFileName.deletingPathExtension)", ofType: convertFileName.pathExtension)!)
		
		return self
	}
	
}
