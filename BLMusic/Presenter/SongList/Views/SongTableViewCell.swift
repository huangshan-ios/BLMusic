//
//  SongTableViewCell.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var actionButton: DownloadButton!
    
    var onTapActionButton: ((Song.State) -> Void)?
    var songData: Song?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapActionButton = nil
    }
    
    func setupSongView(_ song: Song) {
        self.songData = song
        guard let songData = songData else {
            return
        }
        
        songNameLabel.text = songData.name
        
        switch songData.state {
        case .notDownloaded:
            actionButton.status = .notDownloaded
        case .downloading(let progress):
            if actionButton.progress == 0 {
                actionButton.drawCircle()
            }
            actionButton.status = .downloading
            actionButton.progress = Float(progress)
        case .downloaded, .notPlaying:
            actionButton.status = .paused
        case .playing:
            actionButton.status = .playing
        }
    }
    
    @IBAction func onTapActionButton(_ sender: Any) {
        guard let songData = songData else {
            return
        }
        onTapActionButton?(songData.state)
    }
    
}
