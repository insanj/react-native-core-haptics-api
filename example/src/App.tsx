import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { HapticEngine } from 'react-native-core-haptics-api';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>(
    'Is Loading...'
  );

  React.useEffect(() => {
    HapticEngine.getSupportsHaptics().then((supportsHaptics) => {
      if (supportsHaptics) {
        setResult('Supports Haptics! :)');
      } else {
        setResult('Does Not Support Haptics :(');
      }
    });

    // HapticEngine.create()
    //   .then((success) => {
    //     console.log('HapticEngine.create() response =', success);

    //     if (!success) {
    //       setResult('Cannot detect if it supports haptics :/');
    //       return;
    //     }

    //     HapticEngine.capabilitiesForHardware()
    //       .then((capable) => {
    //         console.log(
    //           'HapticEngine.capabilitiesForHardware() response =',
    //           capable
    //         );

    //         const capabilities = HapticEngine.getCapabilities();
    //         console.log(
    //           'HapticEngine.getCapabilities() response =',
    //           capabilities
    //         );

    //         if (capabilities.supportsHaptics) {
    //           setResult('Supports Haptics! :)');
    //         } else {
    //           setResult('Does Not Support Haptics :(');
    //         }
    //       })
    //       .catch((e) => {
    //         console.log(e);
    //       });
    //   })
    //   .catch((e) => {
    //     console.log(e);
    //   });
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
