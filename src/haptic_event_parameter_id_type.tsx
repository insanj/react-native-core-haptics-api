import { NativeModules } from 'react-native';

type HapticEventParameterIDType = {
    rawValue: string;
};

const { 
    HapticEventParameterID,
} = NativeModules;

export default HapticEventParameterID as HapticEventParameterIDType;
