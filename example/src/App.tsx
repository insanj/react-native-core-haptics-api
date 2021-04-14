import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { HapticEngine } from 'react-native-core-haptics-api';

export default function App() {
  const [result, setResult] = React.useState<boolean | undefined>();

  React.useEffect(() => {
    HapticEngine.create().then((engine) => {
      const capabilities = engine.capabilitiesForHardware();
      setResult(capabilities.supportsHaptics);
    }).catch(e => {
      console.log(e);
    });
  }, []);

  return (
    <View style={styles.container}>
      <Text>
        This Device:{' '}
        {result
          ? 'This Device Supports Haptics! :)'
          : 'This Device Does Not Support Haptics :('}
      </Text>
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
