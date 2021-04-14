import { NativeModules } from 'react-native';

type HapticEventEventType = {
    rawValue: string;
};

const { 
    HapticEventEvent,
} = NativeModules;

export default HapticEventEvent as HapticEventEventType;
