import type HapticEventEventType from './haptic_event_event_type_type';
import type HapticEventParameter from './haptic_event_parameter_type';

export default interface HapticEvent {
  eventType: HapticEventEventType;
  parameters: [HapticEventParameter],
  relativeTime: number,
  duration: number
}
