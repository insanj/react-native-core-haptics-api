import { NativeModules } from 'react-native';

type HapticEventParameterIDType = {
  rawValue: string;
  new (rawValue: string): HapticEventParameterIDType;
};

const { HapticEventParameterID } = NativeModules;

export default HapticEventParameterID as HapticEventParameterIDType;
