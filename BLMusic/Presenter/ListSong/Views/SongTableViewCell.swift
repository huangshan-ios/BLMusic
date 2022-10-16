//
//  SongTableViewCell.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var songStateImageView: UIImageView!
    @IBOutlet weak var downloadProgressView: CircularProgressView!
    
    var onTapActionButton: ((Song.State) -> Void)?
    var songData: Song?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapActionButton = nil
        downloadProgressView.progress = 0
        downloadProgressView.isHidden = true
        songStateImageView.isHidden = false
        songStateImageView.image = nil
    }
    
    func setupSongView(_ song: Song) {
        self.songData = song
        guard let songData = songData else {
            return
        }
        
        songNameLabel.text = songData.name
        
        // TODO: Enhance this one by custom a button class to switching state and also change the progress
        switch songData.state {
        case .onCloud:
            downloadProgressView.progress = 0
            downloadProgressView.isHidden = true
            songStateImageView.isHidden = false
            songStateImageView.image = UIImage(named: "ic_download")
        case .downloading(let progress):
            songStateImageView.isHidden = true
            songStateImageView.image = nil
            downloadProgressView.isHidden = false
            downloadProgressView.progress = progress
        case .ready:
            downloadProgressView.progress = 0
            downloadProgressView.isHidden = true
            songStateImageView.isHidden = false
            songStateImageView.image = UIImage(named: "ic_play")
        case .playing:
            downloadProgressView.progress = 0
            downloadProgressView.isHidden = true
            songStateImageView.isHidden = false
            songStateImageView.image = UIImage(named: "ic_pause")
        }

    }
    
    @IBAction func onTapActionButton(_ sender: Any) {
        guard let songData = songData else {
            return
        }
        
        onTapActionButton?(songData.state)
    }
    
}
