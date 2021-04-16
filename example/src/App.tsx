import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { HapticEngine, 
  HapticPatternType, 
  HapticEventType,
  HapticEventParameterType,
  HapticEventParameterIDType,
  HapticEventEventTypeType,
  HapticDeviceCapabilityType
} from 'react-native-core-haptics-api';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>(
    'Is Loading...'
  );
  
  /**
   * See README.md, this is copy & paste from that file.
   */
  const playExampleHapticPattern = async () => {
    // before running, it's a good idea to check if the device supports haptics
    const capabilities = await HapticEngine.getDeviceCapabilities() as HapticDeviceCapabilityType;
    if (!capabilities.supportsHaptics) {
        throw new Error("Device does not support haptics :(");
    }

    // build the patterns that the HapticEngine has to play
    const hapticEvent = {} as HapticEventType;

    // the first two properties are simple number (TimeInterval) value
    hapticEvent.duration = 0.5;
    hapticEvent.relativeTime = 0;

    // now, let's provide the eventType, a tiny JSON object with a string underlying value. we wrap this object in order to support enum checking (and other features) in the future.
    const eventType: HapticEventEventTypeType = {
        rawValue: "HapticContinuous"
    };

    hapticEvent.eventType = eventType;

    // next, we provide the parameters (i.e. keyframes) for this pattern, each a float-pointing value with an identifier to associate that value with the proper Haptic config option
    const parameters: HapticEventParameterType[] = [];

    const intensityParameterID: HapticEventParameterIDType = {
        rawValue: "HapticIntensity"
    };

    const intensityParameter: HapticEventParameterType = {
        parameterID: intensityParameterID,
        value: 1
    };

    parameters.push(intensityParameter);

    const sharpnessParameterID: HapticEventParameterIDType = {
        rawValue: "HapticSharpness"
    };

    const sharpnessParameter: HapticEventParameterType = {
        parameterID: sharpnessParameterID,
        value: 0.6
    };

    parameters.push(sharpnessParameter);

    hapticEvent.parameters = parameters;

    // okay, now we've fully assembled our "event" object, which we can now send through to the CoreHaptics API
    // this should match the following layout:
    // const event = {
    //     parameters: [{
    //         parameterID: {
    //             rawValue: "HapticIntensity"
    //         },
    //         value: 1,
    //     }, {
    //         parameterID: {
    //             "HapticSharpness",
    //         },
    //         value: 0.6
    //     }],
    //     eventType: {
    //         rawValue: "HapticContinuous",
    //     },
    //     duration: 0.5,
    //     relativeTime: 0
    // };

    // and we can pull multiple events into a complex pattern like so
    const hapticEvents: HapticEventType[] = [
        hapticEvent
    ];

    const pattern: HapticPatternType = {
        hapticEvents
    };

    // when we're ready to play, we must first start the HapticEngine (if it has never been started before). we can provide a UUID instead of null if we need more than one HapticEngine.
    await HapticEngine.start(undefined);

    // now, we create a player for this specific pattern (which is cached based on the setup of the pattern)
    await HapticEngine.makePlayer(pattern, undefined);

    // play time! finds the player and engine in memory based on UUID and pattern data
    const startTime = 0;
    await HapticEngine.startPlayerAtTime(pattern, startTime, undefined);

    setTimeout(() => {
      // and when we're ready to stop, we can do
      HapticEngine.stop(undefined)
        .then(() => {
            // yay happy path :)
        })
        .catch(stopError => {
          console.error(stopError);
        })
    }, 1000);
  }

  React.useEffect(() => {
    playExampleHapticPattern()
      .then(() => {
        setResult("Finished playing example! :)");
      })
      .catch(() => {
        setResult("Unable to play example");
      })
  }, []);

  return (
    <View style={styles.container}>
      <Text>This Device: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
