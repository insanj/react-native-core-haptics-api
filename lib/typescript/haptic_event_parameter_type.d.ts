import type HapticEventParameterID from './haptic_event_parameter_id_type';
export default interface HapticEventParameter {
    parameterID: HapticEventParameterID;
    value: number;
}
