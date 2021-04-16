import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { HapticEngine, HapticDeviceCapabilityType } from 'react-native-core-haptics-api';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>(
    'Is Loading...'
  );

  React.useEffect(() => {
    HapticEngine.getDeviceCapabilities()
      .then(capabilities => {
        console.log("HapticEngine.getDeviceCapabilities() result =", capabilities);
        const hapticCapability = capabilities as HapticDeviceCapabilityType;
        if (hapticCapability.supportsHaptics) {
          setResult("Supports Haptics! :)");
        } else {
          setResult("Does Not Support Haptics :(");
        }
      }).catch(err => {
        console.error("HapticEngine.getDeviceCapabilities() error =", err);
        setResult("Unable to check capabilities :/");
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
