import { NativeModules } from 'react-native';

import type HapticDeviceCapabilty from './haptic_device_capability_type';
import type HapticPattern from './haptic_pattern_type';
import type HapticPatternPlayer from './haptic_pattern_player_type';

type HapticEngineType = {
  capabilitiesForHardware(): typeof HapticDeviceCapabilty;
  create(): Promise<HapticEngineType>;
  makePlayer(
    pattern: typeof HapticPattern
  ): Promise<typeof HapticPatternPlayer>;
  start(): Promise<void>;
  stop(): Promise<void>;
};

const { HapticEngine } = NativeModules;

export default HapticEngine as HapticEngineType;
