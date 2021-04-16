//
//  HapticPattern.swift
//  CoreHapticsApi
//
//  Created by julian on 4/16/21.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import CoreHaptics

/**
 Typescript interface
 export default interface HapticPattern {
   hapticEvents: [HapticEvent]
 }
 */
typealias HapticPattern = [String: AnyHashable]

/**
 iOS-only object interface that represents the Typescript interfaces through lazy interpretation of the values directly in JSON.
 */
class HapticPatternObject {
    class Key {
        // HapticPattern
        static let hapticEvents = "hapticEvents"
        
        // HapticEvent
        static let eventType = "eventType"
        static let parameters = "parameters"
        static let relativeTime = "relativeTime"
        static let duration = "duration"
        
        // HapticEventParameter
        static let parameterID = "parameterID"
        static let value = "value"
        
        // HapticEventEventType, HapticEventParameterID
        static let rawValue = "rawValue"
    }
    
    let json: [String: Any]
    init(_ json: HapticPattern) {
        self.json = json
    }
    
    var hapticEvents: [[String: Any]]? {
        return self.json[Key.hapticEvents] as? [[String: Any]]
    }
    
    func toHapticPattern() -> CHHapticPattern? {
        guard let jsonEvents = hapticEvents else {
            return nil
        }
        
        let events: [CHHapticEvent] = jsonEvents.compactMap { event in
            guard let eventTypeObject = event[Key.eventType] as? [String: Any] else {
                return nil
            }
            
            guard let eventTypeRawValue = eventTypeObject[Key.rawValue] as? String else {
                return nil
            }
            
            let eventType = CHHapticEvent.EventType(rawValue: eventTypeRawValue)
            
            guard let eventParameterObjects = event[Key.parameters] as? [[String: Any]] else {
                return nil
            }
            
            let eventParameters: [CHHapticEventParameter] = eventParameterObjects.compactMap { parameterObject in
                guard let parameterIDObject = parameterObject[Key.parameterID] as? [String: Any] else {
                    return nil
                }
                
                guard let parameterIDRawValue = parameterIDObject[Key.rawValue] as? String else {
                    return nil
                }
                
                let parameterID = CHHapticEvent.ParameterID(rawValue: parameterIDRawValue)
                
                guard let value = parameterObject[Key.value] as? Float else {
                    return nil
                }
                
                let parameter = CHHapticEventParameter(parameterID: parameterID, value: value)
                return parameter
            }
            
            guard let relativeTime = event[Key.relativeTime] as? TimeInterval,
                  let duration = event[Key.duration] as? TimeInterval else {
                return nil
            }
            
            let event = CHHapticEvent(eventType: eventType, parameters: eventParameters, relativeTime: relativeTime, duration: duration)
            return event
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            return pattern
        } catch let _ {
            return nil
        }
    }
}
