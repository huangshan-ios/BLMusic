//
//  NSObject+Extensions.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

extension NSObject {
    @nonobjc class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return type(of: self).className
    }
}
