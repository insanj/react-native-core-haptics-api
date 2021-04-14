import { NativeModules } from 'react-native';

import type HapticEventEvent from './haptic_event_event_type';
import type HapticEventParameter from './haptic_event_parameter_type';

type HapticEventType = {
    eventType: typeof HapticEventEvent;
    parameters: [typeof HapticEventParameter];
    relativeTime: number;
    duration: number;
};

const { 
    HapticEvent,
} = NativeModules;

export default HapticEvent as HapticEventType;
