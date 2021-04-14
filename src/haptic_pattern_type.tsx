import { NativeModules } from 'react-native';

import type HapticEvent from './haptic_event_type';

type HapticPatternType = {
    hapticEvents: [typeof HapticEvent];
};

const { 
    HapticPattern,
} = NativeModules;

export default HapticPattern as HapticPatternType;
