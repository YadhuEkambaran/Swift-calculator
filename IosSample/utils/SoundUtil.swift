//
//  SoundUtil.swift
//  IosSample
//
//  Created by yadhukrishnan E on 05/11/19.
//  Copyright © 2019 AYA. All rights reserved.
//

import AVFoundation

class SoundUtil {
    
    static func error() {
        AudioServicesPlayAlertSound(SystemSoundID(1053))
    }
    
    static func keyPressed() {
        AudioServicesPlayAlertSound(SystemSoundID(1104))
    }
}
