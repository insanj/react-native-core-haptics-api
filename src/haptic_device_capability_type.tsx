import { NativeModules } from 'react-native';

type HapticDeviceCapabiltyType = {
  supportsHaptics: boolean;
  supportsAudio: boolean;
};

const { 
  HapticDeviceCapabilty,
} = NativeModules;

export default HapticDeviceCapabilty as HapticDeviceCapabiltyType;
