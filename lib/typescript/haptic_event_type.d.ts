import type HapticEventEvent from './haptic_event_event_type';
import type HapticEventParameter from './haptic_event_parameter_type';
declare type HapticEventType = {
    eventType: typeof HapticEventEvent;
    parameters: [typeof HapticEventParameter];
    relativeTime: number;
    duration: number;
};
declare const _default: HapticEventType;
export default _default;
