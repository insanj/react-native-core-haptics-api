import { NativeModules } from 'react-native';

type HapticEventEventTypeType = {
  rawValue: string;
  new (rawValue: string): HapticEventEventTypeType;
};

const { HapticEventEventType } = NativeModules;

export default HapticEventEventType as HapticEventEventTypeType;
