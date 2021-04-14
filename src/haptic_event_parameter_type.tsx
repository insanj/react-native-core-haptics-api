import { NativeModules } from 'react-native';

import type HapticEventParameterID from './haptic_event_parameter_id_type';

type HapticEventParameterType = {
  parameterID: typeof HapticEventParameterID;
  value: number;
  new (
    parameterID: typeof HapticEventParameterID,
    value: number
  ): HapticEventParameterType;
};

const { HapticEventParameter } = NativeModules;

export default HapticEventParameter as HapticEventParameterType;
