//
//  HapticEngine.swift
//  CoreHapticsApi
//
//  Created by julian on 4/16/21.
//  Copyright © 2021 Gamebytes. All rights reserved.
//

import Foundation
import CoreHaptics

@objc(HapticEngine)
class HapticEngine: NSObject {
    // MARK: - Private API
    private let shared = HapticEngine()
    
    private class Key {
        static let defaultEngine: NSString = "default_engine"
    }
    
    private var engines: [NSString: CHHapticEngine] = [:]
    private var players: [HapticPattern: CHHapticPatternPlayer] = [:]
    
    // MARK: - Public API
    /**
     * Get JSON representation of HapticDeviceCapabilty. Currently supported keys:
     * - supportsHaptics
     * - supportsAudio
     */
    @objc(getDeviceCapabilities:reject:)
    func getDeviceCapabilities(resolve: RCTPromiseResolveBlock,
                               reject: RCTPromiseRejectBlock) {
        let hapticCapabilities = CoreHaptics.CHHapticEngine.capabilitiesForHardware()
        let capabilities = HapticDeviceCapability(hapticCapabilities)
        let capabilitiesJSON = capabilities.toJSON()
        resolve(capabilitiesJSON)
    }
    
    /**
     * Starts the HapticEngine. Provide UUID to create multiple engines, otherwise, a default UUID is used which only supports 1 HapticEngine instance at a time.
     * If needed, this also creates the CHHapticEngine underlying instance. Required step before playing any HapticPatternPlayer, but does not initiate a HapticPatternPlayer session itself. Use -makePlayer and/or -startPlayerAtTime.
     * There is no way to get a reference to the HapticEngine itself in JS, so we hold onto it as a singleton value. We assume that, unless a UUID is given, we only need to retain one reference to one engine.
     * @param uuid Optional UUID to associate with the HapticEngine if more than one is needed
     * @returns Resolving Promise with boolean indicating if it was possible to create/start the engine
     */
    @objc(start:resolve:reject:)
    func start(uuid: NSString?,
               resolve: @escaping RCTPromiseResolveBlock,
               reject: @escaping  RCTPromiseRejectBlock) {
        var engine: CHHapticEngine
        
        if let existingEngine = shared.engines[uuid ?? Key.defaultEngine] {
            engine = existingEngine
        }
        
        else {
            do {
                let newEngine = try CHHapticEngine()
                shared.engines[uuid ?? Key.defaultEngine] = newEngine
                engine = newEngine
            } catch let e {
                reject("Unable to create engine", e.localizedDescription, e)
                return
            }
        }
        
        engine.start { (err) in
            if let err = err {
                reject("Unable to start engine", err.localizedDescription, err)
            } else {
                resolve(true)
            }
        }
    }
    
    /**
     * Creates a new HapticPatternPlayer with given HapticPattern. Will create an engine before making a player if does not exist, although you will still have to use -start to start the engine. This player is stored in the HapticEngine singleton. Once the engine is started, this player may also be started at a given time using -startPlayerAtTime. The correct player is chosen by matching the HapticPattern given here (a simple equality check using parameterID and value). A HapticPattern is a type which consists of:
     * - parameterID (HapticEventParameterID, a string-based type with only rawValue)
     * - value (number)
     * @param uuid Optional Engine UUID
     * @param pattern Pattern to use when creating a new player
     * @returns Resolving Promise with boolean indicating if it was possible to create the player
     */
    @objc(makePlayer:pattern:resolve:reject:)
    func makePlayer(uuid: NSString?,
                    pattern: HapticPattern,
                    resolve: RCTPromiseResolveBlock,
                    reject: RCTPromiseRejectBlock) {
        var engine: CHHapticEngine
        
        if let existingEngine = shared.engines[uuid ?? Key.defaultEngine] {
            engine = existingEngine
        }
        
        else {
            do {
                let newEngine = try CHHapticEngine()
                shared.engines[uuid ?? Key.defaultEngine] = newEngine
                engine = newEngine
            } catch let e {
                reject("Unable to create engine", e.localizedDescription, e)
                return
            }
        }
        
        do {
            let patternObject = HapticPatternObject(pattern)
            guard let hapticPattern = patternObject.toHapticPattern() else {
                reject("Unable to create pattern", "Unknown error", nil)
                return
            }
            
            let patternPlayer = try engine.makePlayer(with: hapticPattern)
            players[pattern] = patternPlayer

            resolve(true)
        } catch let e {
            reject("Unable to make player", e.localizedDescription, nil)
        }
    }

    /**
     * Starts an existing HapticPatternPlayer at a given time. If the player does not exist, the HapticEngine will attempt to create it using -makePlayer before resolving. If the engine does not exist, the HapticEngine will attempt to also create and start that before resolving. If the engine does exist, we assume it has already been started.
     * @param uuid Optional Engine UUID
     * @param startTime number (TimeInterval) offset to begin the pattern
     * @returns Resolving Promise with boolean indicating if it was possible to start the player (and create it if needed)
     */
    @objc(startPlayerAtTime:pattern:startTime:resolve:reject:)
    func startPlayerAtTime(uuid: NSString?,
                           pattern: HapticPattern,
                           startTime: CGFloat,
                           resolve: RCTPromiseResolveBlock,
                           reject: RCTPromiseRejectBlock) {
        var engine: CHHapticEngine
        
        if let existingEngine = shared.engines[uuid ?? Key.defaultEngine] {
            engine = existingEngine
        }
        
        else {
            do {
                let newEngine = try CHHapticEngine()
                shared.engines[uuid ?? Key.defaultEngine] = newEngine
                engine = newEngine
            } catch let e {
                reject("Unable to create engine", e.localizedDescription, e)
                return
            }
            
            do {
                try engine.start()
            } catch let e {
                reject("Unable to start engine", e.localizedDescription, e)
            }
        }

        var hapticPatternPlayer: CHHapticPatternPlayer
        
        if let existingPatternPlayer = shared.players[pattern] {
            hapticPatternPlayer = existingPatternPlayer
        }
        
        else {
            do {
                let patternObject = HapticPatternObject(pattern)
                guard let hapticPattern = patternObject.toHapticPattern() else {
                    reject("Unable to create pattern", "Unknown error", nil)
                    return
                }
                
                let patternPlayer = try engine.makePlayer(with: hapticPattern)
                players[pattern] = patternPlayer
                hapticPatternPlayer = patternPlayer
            } catch let e {
                reject("Unable to make player", e.localizedDescription, nil)
                return
            }
        }
        
        do {
            try hapticPatternPlayer.start(atTime: TimeInterval(startTime))
            
            resolve(true)
        } catch let e {
            reject("Unable to start player", e.localizedDescription, nil)
        }
    }
    
    /**
     * Stops the HapticEngine immediately. If a UUID is given, the engine with the expected UUID is stopped. If no UUID is given, then the default engine is stopped.
     * @param uuid Optional UUID representing the HapticEngine from -start
     * @returns Resolving Promise with boolean indicating if it was possible to stop
     */
    @objc(stop:resolve:reject:)
    func stop(uuid: NSString?,
              resolve: @escaping RCTPromiseResolveBlock,
              reject: @escaping RCTPromiseRejectBlock) {
        guard let existingEngine = shared.engines[uuid ?? Key.defaultEngine] else {
            reject("Unable to find engine", "Engine has not been created", nil)
            return
        }
        
        existingEngine.stop { (err) in
            if let err = err {
                reject("Unable to stop engine", err.localizedDescription, nil)
            } else {
                resolve(true)
            }
        }
    }
}
