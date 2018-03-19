//
//  UIView+frame.swift
//  MZRefreshView
//
//  Created by Michael_Zuo on 2018/3/18.
//  Copyright © 2018年 Michael_Zuo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // top
    var mz_top:CGFloat {
        get {
            return frame.minY
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    // bottom
    var mz_bottom:CGFloat {
        get {
            return frame.maxY
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    // left
    var mz_left:CGFloat {
        get {
            return frame.minX
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    // right
    var mz_right:CGFloat {
        get {
            return frame.maxX
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    // CenterX
    var mz_centerX:CGFloat {
        get {
            return frame.midX
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.x = newValue - frame.size.width/2
            frame = tempFrame
        }
    }
    
    // CenterY
    var mz_centerY:CGFloat {
        get {
            return frame.minY
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.origin.y = newValue - frame.size.height/2
            frame = tempFrame
        }
    }
    
    // Width
    var mz_width:CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var mz_height:CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame:CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }

}
