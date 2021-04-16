//
//  HapticDeviceCapability.swift
//  CoreHapticsApi
//
//  Created by julian on 4/16/21.
//  Copyright © 2021 Gamebytes. All rights reserved.
//

import Foundation
import CoreHaptics

struct HapticDeviceCapability {
    class Key {
        // HapticDeviceCapability type
        static let supportsHaptics = "supportsHaptics"
        static let supportsAudio = "supportsAudio"
    }
    
    let supportsAudio: Bool
    let supportsHaptics: Bool
    
    init(_ capabilities: CoreHaptics.CHHapticDeviceCapability) {
        self.supportsHaptics = capabilities.supportsHaptics
        self.supportsAudio = capabilities.supportsAudio
    }
    
    func toJSON() -> [String: Any] {
        let json: [String: Bool] = [
            Key.supportsAudio: supportsAudio,
            Key.supportsHaptics: supportsHaptics
        ]
        
        return json
    }
}
