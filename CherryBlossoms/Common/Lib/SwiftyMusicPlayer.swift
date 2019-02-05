//
//  SwiftySwiftyMusicPlayer.swift
//  CherryBlossoms
//
//  Created by JosephNK on 01/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

public class MusicPlayItem: NSObject {
	var index: Int = 0
	var identifier: String? = nil
	var fileURL: URL? = nil
	var trackName: String? = nil
	var albumName: String? = nil
	var artistName: String? = nil
	var albumImageFileURL: URL? = nil
	
	required init(from decoder: Decoder) throws {
		
	}
	
	public static func == (lhs: MusicPlayItem, rhs: MusicPlayItem) -> Bool {
		return lhs.identifier == rhs.identifier
	}
	
}

public struct SwiftyMusicPlayerNotification {
	static let OnTrackChangedNotification = "OnTrackChangedNotification"
	static let OnPlaybackStateChangedNotification = "OnPlaybackStateChangedNotification"
}

class SwiftyMusicPlayer: NSObject {
	
	var audioPlayer: AVAudioPlayer?
	
	let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
	
	let commandCenter: MPRemoteCommandCenter = MPRemoteCommandCenter.shared()
	
	let nowPlayingInfoCenter: MPNowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
	
	let notificationCenter: NotificationCenter = NotificationCenter.default
	
	var nowPlayingInfo: [String : AnyObject]?
	
	var playItems: [MusicPlayItem]?
	
	var currentPlayItem: MusicPlayItem?
	
	var nextPlayItem: MusicPlayItem? {
		guard let playItems = self.playItems else { return nil }
		
		if self.currentIndex == -1 { return nil }
		
		var nextItemIndex = self.currentIndex + 1
		
		if nextItemIndex >= playItems.count {
			nextItemIndex = 0
		}
		
		return playItems[nextItemIndex]
	}
	
	var previousPlayItem: MusicPlayItem? {
		guard let playItems = self.playItems else { return nil }
		
		if self.currentIndex == -1 { return nil }
		
		var previousItemIndex = self.currentIndex - 1
		
		if previousItemIndex < 0 {
			previousItemIndex = playItems.count - 1
		}
		
		return playItems[previousItemIndex]
	}
	
	var currentIndex: Int {
		guard let playItems = self.playItems, let currentPlayItem = self.currentPlayItem else {
			return -1
		}
		return playItems.firstIndex(of: currentPlayItem) ?? -1
	}
	
	var currentTime: TimeInterval {
		return self.audioPlayer?.currentTime ?? 0.0
	}
	
	var duration: TimeInterval {
		return self.audioPlayer?.duration ?? 0.0
	}
	
	var isPlaying: Bool {
		return self.audioPlayer?.isPlaying ?? false
	}
	
	var isShuffle: Bool = false {
		didSet {
			configureShffles(isOn: isShuffle)
		}
	}
	
	var isRepeat: Bool = false {
		didSet {
			
		}
	}
	
	fileprivate var clonePlayItems: [MusicPlayItem] = []
	
	override init() {
		super.init()
		
		prepareSession()
		prepareCommandCenter()
	}
	
	func isCheckLastPreviousItem() -> Bool {
		if self.currentIndex == -1 { return false }
		
		let previousItemIndex = self.currentIndex - 1
		
		if previousItemIndex < 0 {
			return true
		}
		
		return false
	}
	
	func isCheckLastNextItem() -> Bool {
		guard let playItems = self.playItems else { return false }
		
		if self.currentIndex == -1 { return false }
		
		let nextItemIndex = self.currentIndex + 1
		
		if nextItemIndex >= playItems.count {
			return true
		}
		
		return false
	}
}

// MARK: - Audio Session
extension SwiftyMusicPlayer {
	
	func prepareSession() {
		if #available(iOS 10.0, *) {
			do {
				try self.audioSession.setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
			} catch _ {
				
			}
		} else {
			// Workaround until https://forums.swift.org/t/using-methods-marked-unavailable-in-swift-4-2/14949 isn't fixed
			self.audioSession.perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
		}
		
		do {
			try self.audioSession.setActive(true)
		} catch _ {
			
		}
	}
	
}

// MARK: - Play Commands
extension SwiftyMusicPlayer {
	
	func playItems(_ playItems: [MusicPlayItem], firstItem: MusicPlayItem? = nil) {
		self.playItems = playItems.enumerated().map { (index, element) -> MusicPlayItem in
			element.index = index
			return element
		}
		
		if playItems.count == 0 {
			self.endPlay()
			return
		}
		
		if firstItem == nil {
			return
		}
		
		let playbackItem = firstItem ?? self.playItems!.first!
		
		self.playItem(playbackItem, playStart: true)
	}
	
	func playItem(_ playItem: MusicPlayItem, playStart: Bool) {
		guard let fileURL = playItem.fileURL, let audioPlayer = try? AVAudioPlayer(contentsOf: fileURL) else {
			self.endPlay()
			return
		}
		
		audioPlayer.delegate = self
		audioPlayer.prepareToPlay()
		
		if (playStart) {
			audioPlayer.play()
		}
		
		self.audioPlayer = audioPlayer
		
		self.currentPlayItem = playItem
		
		self.updateNowPlayingInfoForCurrentPlaybackItem()
		self.updateCommandCenter()
		
		self.notifyOnTrackChanged()
	}
	
	func togglePlayPause() {
		if self.isPlaying {
			self.pause()
		} else {
			self.play()
		}
	}
	
	func play() {
		self.audioPlayer?.play()
		
		self.updateNowPlayingInfoElapsedTime()
		self.notifyOnPlaybackStateChanged()
	}
	
	func pause() {
		self.audioPlayer?.pause()
		
		self.updateNowPlayingInfoElapsedTime()
		self.notifyOnPlaybackStateChanged()
	}
	
	func endPlay() {
		self.currentPlayItem = nil
		self.audioPlayer = nil
		
		self.updateNowPlayingInfoForCurrentPlaybackItem()
		self.notifyOnTrackChanged()
	}
	
	func nextTrack() {
		guard let nextPlayItem = self.nextPlayItem else { return }
		
		let playStart = self.isCheckLastNextItem() && self.isRepeat ? false : true
		
		self.playItem(nextPlayItem, playStart: playStart)
		self.updateCommandCenter()
	}
	
	func previousTrack() {
		guard let previousPlayItem = self.previousPlayItem else { return }
		
		let playStart = true
		
		self.playItem(previousPlayItem, playStart: playStart)
		self.updateCommandCenter()
	}
	
	func seekTo(_ timeInterval: TimeInterval) {
		self.audioPlayer?.currentTime = timeInterval
		self.updateNowPlayingInfoElapsedTime()
	}
	
}

// MARK: - Shuffle
extension SwiftyMusicPlayer {
	
	func configureShffles(isOn: Bool) {
		if isOn {
			self.playItems = self.playItems?.shuffled()
		} else {
			self.playItems = self.playItems?.sorted(by: { (item1, item2) -> Bool in
				return item1.index < item2.index
			})
		}
	}
	
}

// MARK: - AVAudioPlayerDelegate
extension SwiftyMusicPlayer: AVAudioPlayerDelegate {
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		if self.nextPlayItem == nil {
			self.endPlay()
		} else {
			self.nextTrack()
		}
	}
	
	func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
		self.notifyOnPlaybackStateChanged()
	}
	
	func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
		if AVAudioSession.InterruptionOptions(rawValue: UInt(flags)) == .shouldResume {
			self.play()
		}
	}
}

// MARK: - Command Center
extension SwiftyMusicPlayer {
	
	func prepareCommandCenter() {
		self.commandCenter.playCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
			guard let __self = self else { return .commandFailed }
			__self.play()
			return .success
		})
		
		self.commandCenter.pauseCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
			guard let __self = self else { return .commandFailed }
			__self.pause()
			return .success
		})
		
		self.commandCenter.nextTrackCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
			guard let __self = self else { return .commandFailed }
			__self.nextTrack()
			return .success
		})
		
		self.commandCenter.previousTrackCommand.addTarget (handler: { [weak self] event -> MPRemoteCommandHandlerStatus in
			guard let __self = self else { return .commandFailed }
			__self.previousTrack()
			return .success
		})
		
		self.commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(SwiftyMusicPlayer.handleChangePlaybackPositionCommandEvent(event:)))
	}
	
	@objc func handleChangePlaybackPositionCommandEvent(event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
		let __self = self
		__self.seekTo(event.positionTime)
		return .success
	}
	
	func updateCommandCenter() {
		guard let playItems = self.playItems, let currentPlayItem = self.currentPlayItem else { return }
		
		self.commandCenter.previousTrackCommand.isEnabled = currentPlayItem != playItems.first!
		self.commandCenter.nextTrackCommand.isEnabled = currentPlayItem != playItems.last!
	}

}

// MARK: - Notification Center
extension SwiftyMusicPlayer {
	
	func notifyOnPlaybackStateChanged() {
		self.notificationCenter.post(name: Notification.Name(rawValue: SwiftyMusicPlayerNotification.OnPlaybackStateChangedNotification), object: self)
	}
	
	func notifyOnTrackChanged() {
		self.notificationCenter.post(name: Notification.Name(rawValue: SwiftyMusicPlayerNotification.OnTrackChangedNotification), object: self)
	}
	
}

// MARK: - Now Playing Info
extension SwiftyMusicPlayer {

	func configureNowPlayingInfo(_ nowPlayingInfo: [String: AnyObject]?) {
		self.nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
		self.nowPlayingInfo = nowPlayingInfo
	}
	
	func updateNowPlayingInfoForCurrentPlaybackItem() {
		guard let audioPlayer = self.audioPlayer, let currentPlayItem = self.currentPlayItem else {
			self.configureNowPlayingInfo(nil)
			return
		}
		
		var nowPlayingInfo = [MPMediaItemPropertyTitle: currentPlayItem.trackName ?? "",
							  MPMediaItemPropertyAlbumTitle: currentPlayItem.albumName ?? "",
							  MPMediaItemPropertyArtist: currentPlayItem.artistName ?? "",
							  MPMediaItemPropertyPlaybackDuration: audioPlayer.duration,
							  MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1.0 as Float)] as [String : Any]
		
		if let albumImageFileURL = currentPlayItem.albumImageFileURL, let image = UIImage(contentsOfFile: albumImageFileURL.path) {
			nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
		}
		
		self.configureNowPlayingInfo(nowPlayingInfo as [String : AnyObject]?)
		
		self.updateNowPlayingInfoElapsedTime()
	}
	
	func updateNowPlayingInfoElapsedTime() {
		guard var nowPlayingInfo = self.nowPlayingInfo, let audioPlayer = self.audioPlayer else { return }
		
		nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: audioPlayer.currentTime as Double);
		
		self.configureNowPlayingInfo(nowPlayingInfo)
	}
	
}
