//
//  DownloadButton.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import UIKit

enum DownloadStatus {
    case notDownloaded
    case downloading
    case paused
    case playing
}

class DownloadButton: UIButton {
    var progress: Float = 0 {
        didSet {
            circleShape.strokeEnd = CGFloat(self.progress)
        }
    }
    
    var circleShape = CAShapeLayer()
    
    public func drawCircle() {
        let x: CGFloat = 0.0
        let y: CGFloat = 0.0
        let circlePath = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: self.frame.height, height: self.frame.height), cornerRadius: self.frame.height / 2).cgPath
        circleShape.path = circlePath
        circleShape.lineWidth = 3
        circleShape.strokeColor = UIColor.white.cgColor
        circleShape.strokeStart = 0
        circleShape.strokeEnd = 0
        circleShape.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(circleShape)
    }

    var status: DownloadStatus = .notDownloaded {
        didSet {
            var buttonImageName = ""
            switch self.status {
            case .notDownloaded:
                buttonImageName = "ic_download"
            case .downloading:
                break
            case .paused:
                buttonImageName = "ic_play"
            case .playing:
                buttonImageName = "ic_pause"
            }
            self.setImage(UIImage(named: buttonImageName), for: .normal)
        }
    }
}
