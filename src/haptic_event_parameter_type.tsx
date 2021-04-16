import type HapticEventParameterID from './haptic_event_parameter_id_type';

interface HapticEventParameter {
  parameterID: HapticEventParameterID;
  value: number;
};

export default HapticEventParameter;
