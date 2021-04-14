import { NativeModules } from 'react-native';

type HapticPatternPlayerType = {
  //   start(startTime: number): Promise<void>;
};

const { HapticPatternPlayer } = NativeModules;

export default HapticPatternPlayer as HapticPatternPlayerType;
