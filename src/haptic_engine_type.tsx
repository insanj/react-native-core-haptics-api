import { NativeModules } from 'react-native';

import type HapticPattern from './haptic_pattern_type';

type HapticEngineType = {
  /**
   * Get JSON representation of HapticDeviceCapabilty. Currently supported keys:
   * - supportsHaptics
   * - supportsAudio
   */
  getDeviceCapabilities(): Promise<object>;
  
  /**
   * Starts the HapticEngine. Provide UUID to create multiple engines, otherwise, a default UUID is used which only supports 1 HapticEngine instance at a time.
   * If needed, this also creates the CHHapticEngine underlying instance. Required step before playing any HapticPatternPlayer, but does not initiate a HapticPatternPlayer session itself. Use -makePlayer and/or -startPlayerAtTime.
   * There is no way to get a reference to the HapticEngine itself in JS, so we hold onto it as a singleton value. We assume that, unless a UUID is given, we only need to retain one reference to one engine.
   * @param uuid Optional UUID to associate with the HapticEngine if more than one is needed
   * @returns Resolving Promise with boolean indicating if it was possible to create/start the engine
   */
  start(uuid: string): Promise<boolean>;

  /**
   * Creates a new HapticPatternPlayer with given HapticPattern. This player is stored in the HapticEngine singleton. Once the engine is started, this player may also be started at a given time using -startPlayerAtTime. The correct player is chosen by matching the HapticPattern given here (a simple equality check using parameterID and value). A HapticPattern is a type which consists of:
   * - parameterID (HapticEventParameterID, a string-based type with only rawValue)
   * - value (number)
   * @param pattern Pattern to use when creating a new player
   * @returns Resolving Promise with boolean indicating if it was possible to create the player
   */
  makePlayer(pattern: HapticPattern): Promise<boolean>;

  /**
   * Starts an existing HapticPatternPlayer at a given time. If the player does not exist, the HapticEngine will attempt to create it using -makePlayer before resolving.
   * @param startTime number (TimeInterval) offset to begin the pattern
   * @returns Resolving Promise with boolean indicating if it was possible to start the player (and create it if needed)
   */
  startPlayerAtTime(pattern: HapticPattern, startTime: number): Promise<boolean>;

  /**
   * Stops the HapticEngine immediately. If a UUID is given, the engine with the expected UUID is stopped. If no UUID is given, then the default engine is stopped.
   * @param uuid Optional UUID representing the HapticEngine from -start
   * @returns Resolving Promise with boolean indicating if it was possible to stop
   */
  stop(uuid: String): Promise<boolean>;
};

const { HapticEngine } = NativeModules;

export default HapticEngine as HapticEngineType;
