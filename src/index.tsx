import { NativeModules } from 'react-native';

type CoreHapticsApiType = {
  multiply(a: number, b: number): Promise<number>;
};

const { CoreHapticsApi } = NativeModules;

export default CoreHapticsApi as CoreHapticsApiType;
