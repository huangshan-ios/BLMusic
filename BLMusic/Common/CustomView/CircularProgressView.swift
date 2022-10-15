//
//  CircularProgressView.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import UIKit

class CircularProgressView: UIView {
    
    private var progressLayer = CAShapeLayer()
        
    var progress: Double = 0.0 {
        didSet {
            progressLayer.strokeEnd = CGFloat(progress)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.height, height: frame.height),
                                        cornerRadius: frame.height / 2)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = frame.height
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.red.cgColor
        layer.addSublayer(progressLayer)
    }
    
}
