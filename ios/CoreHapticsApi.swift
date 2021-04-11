import CoreHaptics

// MARK: - HapticDeviceCapabilty

@objc(HapticDeviceCapabilty)
class HapticDeviceCapabilty: NSObject {
    let supportsHaptics: Bool
    let supportsAudio: Bool

    @objc
    init(_ capabilities: HapticDeviceCapabilty) {
        self.supportsHaptics = capabilities.supportsHaptics
        self.supportsAudio = capabilities.supportsAudio
    }
}

// MARK: - HapticEventParameterID

@objc(HapticEventParameterID)
class HapticEventParameterID: NSObject {
    let rawValue: String
    
    @objc
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension HapticEventParameterID {
    func parameterID() -> CHHapticEvent.ParameterID {
        return CHHapticEvent.ParameterID(rawValue: rawValue)
    }
}

// MARK: - HapticEventParameter

@objc(HapticEventParameter)
class HapticEventParameter: NSObject {
    let parameterID: HapticEventParameterID
    let value: Float
    
    @objc
    init(_ parameterID: HapticEventParameterID, value: Float) {
        self.parameterID = parameterID
        self.value = value
    }
}

extension HapticEventParameter {
    func eventParameter() -> CHHapticEventParameter {
        return CHHapticEventParameter(parameterID: parameterID, value: value)
    }
}

// MARK: - HapticEventEventType

@objc(HapticEventEventType)
class HapticEventEventType: NSObject {
    let rawValue: String
    
    @objc
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension HapticEventEventType {
    func eventType() -> CHHapticEvent.EventType {
        return CHHapticEvent.EventType(rawValue: rawValue)
    }
}

// MARK: - HapticEvent

@objc(HapticEvent)
class HapticEvent: NSObject {
    let eventType: HapticEventEventType
    let parameters: [HapticEventParameter]
    let relativeTime: TimeInterval
    let duration: TimeInterval
    
    @objc
    init(_ eventType: HapticEventEventType,
         _ parameters: [HapticEventParameter],
         _ relativeTime: TimeInterval,
         _ duration: TimeInterval) {
        self.eventType = eventType
        self.parameters = parameters
        self.relativeTime = relativeTime
        self.duration = duration
    }
}

extension HapticEvent {
    func hapticEvent() -> CHHapticEvent {
        let eventParameters = parameters.map() { $0.eventParameter() }
        return CHHapticEvent(eventType: eventType.eventType(),
                             parameters: eventParameters,
                             relativeTime: relativeTime,
                             duration: duration)
    }
}

// MARK: - HapticPattern

@objc(HapticPattern)
class HapticPattern: NSObject {
    let hapticEvents: [HapticEvent]
    
    @objc
    init(_ hapticEvents: [HapticEvent]) {
        self.hapticEvents = hapticEvents
    }
}

extension HapticPattern {
    func hapticPattern() -> CHHapticPattern {
        let events = hapticEvents.map() { $0.hapticEvent() }
        return CHHapticPattern(events: events, parameters: [])
    }
}

// MARK: - HapticPatternPlayer

@objc(HapticPatternPlayer)
class HapticPatternPlayer: NSObject {
    let player: CHHapticPatternPlayer
    
    init(_ player: CHHapticPatternPlayer) {
        self.player = player
    }
    
    @objc(play:resolve:reject:)
    func start(_ startTime: TimeInterval,
               resolve: RCTPromiseResolveBlock,
               reject: RCTPromiseRejectBlock) {
        do {
            try self.player.start(atTime: startTime)
            resolve()
        } catch let e {
            reject(e)
        }
    }
}

// MARK: - HapticEngine

@objc(HapticEngine)
class HapticEngine: NSObject {
    let engine: CHHapticEngine
    init(_ engine: CHHapticEngine) {
        self.engine = engine
    }
    
    @objc(capabilitiesForHardware)
    func capabilitiesForHardware() -> HapticDeviceCapabilty {
        let capability = HapticDeviceCapabilty(CHHapticEngine.capabilitiesForHardware())
        return capability
    }
    
    @objc(create:reject:)
    func create(resolve: RCTPromiseResolveBlock,
         reject: RCTPromiseRejectBlock) {
        do {
            let engine = try? CHHapticEngine()
            let hapticEngine = HapticEngine(engine)
            resolve(hapticEngine)
        } catch let e {
            reject(e)
        }
    }
    
    @objc(makePlayer:)
    func makePlayer(_ pattern: HapticPattern,
                    resolve: RCTPromiseResolveBlock,
                    reject: RCTPromiseRejectBlock) {
        
        let hapticPattern = pattern.hapticPattern()
        
        do {
            let player = try? self.engine.makePlayer(with: hapticPattern)
            let patternPlayer = HapticPatternPlayer(player)
            resolve(patternPlayer)
        } catch let e {
            reject(e)
        }
    }

    @objc(start)
    func start(resolve: RCTPromiseResolveBlock,
               reject: RCTPromiseRejectBlock) {
        do {
            self.engine.start()
        } catch let e {
            reject(e)
        }
    }
}
