import { NativeModules } from 'react-native';

// import type HapticDeviceCapabilty from './haptic_device_capability_type';
import type HapticPattern from './haptic_pattern_type';
// import type HapticPatternPlayer from './haptic_pattern_player_type';

type HapticEngineType = {
  // player: typeof HapticPatternPlayer;
  // capabilities: typeof HapticDeviceCapabilty;
  // getPlayer(): typeof HapticPatternPlayer;
  getSupportsHaptics(): Promise<boolean>;
  startPlayerAtTime(startTime: number): Promise<void>;
  // capabilitiesForHardware(): Promise<boolean>;
  create(): Promise<boolean>;
  makePlayer(pattern: typeof HapticPattern): Promise<boolean>;
  start(): Promise<void>;
  stop(): Promise<void>;
};

const { HapticEngine } = NativeModules;

export default HapticEngine as HapticEngineType;
