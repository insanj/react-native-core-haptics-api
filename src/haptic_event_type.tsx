import { NativeModules } from 'react-native';

import type HapticEventEventType from './haptic_event_event_type_type';
import type HapticEventParameter from './haptic_event_parameter_type';

type HapticEventType = {
  eventType: typeof HapticEventEventType;
  parameters: [typeof HapticEventParameter];
  relativeTime: number;
  duration: number;
  new (
    eventType: typeof HapticEventEventType,
    parameters: [typeof HapticEventParameter],
    relativeTime: number,
    duration: number
  ): HapticEventType;
};

const { HapticEvent } = NativeModules;

export default HapticEvent as HapticEventType;
