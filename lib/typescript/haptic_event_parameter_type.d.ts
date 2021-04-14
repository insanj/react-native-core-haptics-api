import type HapticEventParameterID from './haptic_event_parameter_id_type';
declare type HapticEventParameterType = {
    parameterID: typeof HapticEventParameterID;
    value: number;
    create(parameterID: typeof HapticEventParameterID, value: number): HapticEventParameterType;
};
declare const _default: HapticEventParameterType;
export default _default;
