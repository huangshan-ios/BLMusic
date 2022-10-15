//
//  SongTableViewCell.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songStateImageView: UIImageView!
    
    var onTapActionButton: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onTapActionButton = nil
    }
    
    func setupSongView(_ song: Song) {
        songNameLabel.text = song.name
        
        var image: UIImage?
        switch song.state {
        case .notDownloaded:
            image = UIImage(named: "ic_not_downloaded")
        default:
            break
        }
        songStateImageView.image = image
    }
    
    @IBAction func onTapActionButton(_ sender: Any) {
        onTapActionButton?()
    }
    
}
