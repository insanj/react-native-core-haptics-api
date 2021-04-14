/**
*   Welcome to CoreHapticsApi.swift
*   Created by Julian Weiss for Gamebytes Apr 2021
*   
*   All classes are meant to be exposed to React Native, and are simply the unprefixed, non-namespaced CoreHaptics types.
*   All extensions are intenal functions that are not exposed, and primarily are used to build the underlying CoreHaptics objects.
*/

import CoreHaptics

// MARK: - HapticDeviceCapabilty

@objc(HapticDeviceCapabilty)
class HapticDeviceCapabilty: NSObject {
    var supportsHaptics: Bool?
    var supportsAudio: Bool?
}

extension HapticDeviceCapabilty {
    @objc(createWithCapabilities:)
    func create(_ capabilities: CoreHaptics.CHHapticDeviceCapability) -> HapticDeviceCapabilty {
        self.supportsHaptics = capabilities.supportsHaptics
        self.supportsAudio = capabilities.supportsAudio
        return self
    }
}

// MARK: - HapticEventParameterID

@objc(HapticEventParameterID)
class HapticEventParameterID: NSObject {
    var rawValue: String?
    
    @objc(create:)
    func create(_ rawValue: String) -> HapticEventParameterID {
        self.rawValue = rawValue
        return self
    }
}

extension HapticEventParameterID {
    func parameterID() -> CoreHaptics.CHHapticEvent.ParameterID? {
        guard let rawValue = rawValue else {
            return nil
        }
        
        return CoreHaptics.CHHapticEvent.ParameterID(rawValue: rawValue)
    }
}

// MARK: - HapticEventParameter

@objc(HapticEventParameter)
class HapticEventParameter: NSObject {
    var parameterID: HapticEventParameterID?
    var value: Float?
    
    @objc(create:value:)
    func create(_ parameterID: HapticEventParameterID, _ value: Float) -> HapticEventParameter {
        self.parameterID = parameterID
        self.value = value
        return self
    }
}

extension HapticEventParameter {
    func eventParameter() -> CoreHaptics.CHHapticEventParameter? {
        guard let param = parameterID?.parameterID(), let value = value else {
            return nil
        }
        
        return CoreHaptics.CHHapticEventParameter(parameterID: param, value: value)
    }
}

// MARK: - HapticEventEventType

@objc(HapticEventEventType)
class HapticEventEventType: NSObject {
    var rawValue: String?
    
    @objc(create:)
    func create(_ rawValue: String) -> HapticEventEventType {
        self.rawValue = rawValue
        return self
    }
}


extension HapticEventEventType {
    func eventType() -> CoreHaptics.CHHapticEvent.EventType? {
        guard let rawValue = rawValue else {
            return nil
        }
        
        return CoreHaptics.CHHapticEvent.EventType(rawValue: rawValue)
    }
}

// MARK: - HapticEvent

@objc(HapticEvent)
class HapticEvent: NSObject {
    var eventType: HapticEventEventType?
    var parameters: [HapticEventParameter]?
    var relativeTime: TimeInterval?
    var duration: TimeInterval?
    
    @objc(create:parameters:relativeTime:duration:)
    func create(_ eventType: HapticEventEventType,
                _ parameters: [HapticEventParameter],
                _ relativeTime: TimeInterval,
                _ duration: TimeInterval) -> HapticEvent {
        self.eventType = eventType
        self.parameters = parameters
        self.relativeTime = relativeTime
        self.duration = duration
        return self
    }
}

extension HapticEvent {
    func hapticEvent() -> CoreHaptics.CHHapticEvent? {
        guard let hapticsEventType = eventType?.eventType() else {
            return nil
        }
        
        guard let parameters = parameters, let relativeTime = relativeTime, let duration = duration else {
            return nil
        }
        
        let eventParameters = parameters.compactMap() { $0.eventParameter() }
        return CoreHaptics.CHHapticEvent(eventType: hapticsEventType,
                             parameters: eventParameters,
                             relativeTime: relativeTime,
                             duration: duration)
    }
}

// MARK: - HapticPattern

@objc(HapticPattern)
class HapticPattern: NSObject {
    var hapticEvents: [HapticEvent]?
    
    @objc(create:)
    func create(_ hapticEvents: [HapticEvent]) -> HapticPattern {
        self.hapticEvents = hapticEvents
        return self
    }
}

extension HapticPattern {
    func hapticPattern() throws -> CoreHaptics.CHHapticPattern? {
        guard let hapticEvents = hapticEvents else {
            return nil
        }
        
        let events = hapticEvents.compactMap() { $0.hapticEvent() }
        return try CoreHaptics.CHHapticPattern(events: events, parameters: [])
    }
}

// MARK: - HapticPatternPlayer

@objc(HapticPatternPlayer)
class HapticPatternPlayer: NSObject {
    var player: CoreHaptics.CHHapticPatternPlayer?
    
    @objc(start:resolve:reject:)
    func start(startTime: TimeInterval,
               resolve: RCTPromiseResolveBlock,
               reject: RCTPromiseRejectBlock) {
        guard let player = self.player else {
            reject("Unable to start player", "No player has been created", nil);
            return
        }
        
        do {
            try player.start(atTime: startTime)
            resolve(nil)
        } catch let e {
            reject("Unable to start player", e.localizedDescription, e)
        }
    }
}

extension HapticPatternPlayer {
    func create(_ player: CoreHaptics.CHHapticPatternPlayer) -> HapticPatternPlayer {
        self.player = player
        return self
    }
}

// MARK: - HapticEngine

@objc(HapticEngine)
class HapticEngine: NSObject {
    var engine: CoreHaptics.CHHapticEngine?
    
    @objc(capabilitiesForHardware)
    func capabilitiesForHardware() -> HapticDeviceCapabilty {
        var capability = HapticDeviceCapabilty()
        capability = capability.create(CoreHaptics.CHHapticEngine.capabilitiesForHardware())
        return capability
    }
    
    @objc(create:reject:)
    func create(resolve: RCTPromiseResolveBlock,
         reject: RCTPromiseRejectBlock) {
        do {
            self.engine = try CoreHaptics.CHHapticEngine()
            resolve(self)
        } catch let e {
            reject("Unable to create engine", e.localizedDescription, e)
        }
    }
    
    @objc(makePlayer:resolve:reject:)
    func makePlayer(pattern: HapticPattern,
                    resolve: RCTPromiseResolveBlock,
                    reject: RCTPromiseRejectBlock) {
        do {
            guard let hapticPattern = try pattern.hapticPattern() else {
                reject("Unable to make haptic pattern", "Unknown error", nil)
                return
            }
            
            guard let engine = self.engine else {
                reject("No engine found", "Unknown error", nil)
                return
            }
            
            guard let player = try? engine.makePlayer(with: hapticPattern) else {
                reject("Unable to make player from engine", "Unknown error", nil)
                return
            }
            
            var patternPlayer = HapticPatternPlayer()
            patternPlayer = patternPlayer.create(player)
            resolve(patternPlayer)
        } catch let e {
            reject("Unable to make player", e.localizedDescription, e)
        }
    }

    @objc(start:reject:)
    func start(resolve: @escaping RCTPromiseResolveBlock,
               reject: @escaping RCTPromiseRejectBlock) {
        guard let engine = engine else {
            reject("No engine found", "Unknown error", nil)
            return
        }
        
        engine.start(completionHandler: { (err) in
            if let err = err {
                reject("Unable to start engine", err.localizedDescription, err)
            } else {
                resolve(nil)
            }
        })
    }

    @objc(stop:reject:)
    func stop(resolve: @escaping RCTPromiseResolveBlock,
               reject: @escaping RCTPromiseRejectBlock) {
        guard let engine = engine else {
            reject("No engine found", "Unknown error", nil)
            return
        }
        
        engine.stop(completionHandler: { (err) in
            if let err = err {
                reject("Unable to stop engine", err.localizedDescription, err)
            } else {
                resolve(nil)
            }
        })
    }
}
