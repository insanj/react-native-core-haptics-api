import type HapticEvent from './haptic_event_type';
declare type HapticPatternType = {
    hapticEvents: [typeof HapticEvent];
    create(hapticEvents: [typeof HapticEvent]): HapticPatternType;
};
declare const _default: HapticPatternType;
export default _default;
