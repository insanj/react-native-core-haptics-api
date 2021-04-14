import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { HapticEngine } from 'react-native-core-haptics-api';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    const capabilitiesForHardware = HapticEngine.capabilitiesForHardware();
    setResult(capabilitiesForHardware.supportsHaptics ? 1 : 0);
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
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
