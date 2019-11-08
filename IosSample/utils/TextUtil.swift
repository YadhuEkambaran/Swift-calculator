//
//  TextUtil.swift
//  IosSample
//
//  Created by yadhukrishnan E on 05/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import Foundation

class TextUtil {
    
    static func isOnlyDot(text: String) -> Bool {
        if text.count == 1 && text.contains(".") {
            return true
        }
        
        return false
    }
    
    static func isNumber(text: String) -> Bool {
        return Int(text) != nil || Double(text) != nil
    }
}
