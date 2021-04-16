![](rn_ch.png)

# react-native-core-haptics-api

✋ React Native → iOS Core Haptics

## About

react-native-core-haptics-api is a lightweight iOS-only module designed to expose the following Core Haptics methods to React Native:

- `-capabilitiesForHardware`
- `-stop`
- `-makePlayer`
- `-start`

This requires surfacing the following interfaces:

- `HapticDeviceCapabilty`
- `HapticEventParameterID`
- `HapticEventParameter`
- `HapticEventEventType`
- `HapticEvent`
- `HapticPattern`

Which provide JSON representations of all required iOS objects. All functionality is funneled through the central type:

- `HapticEngine`

These features are made available using syntax and patterns that resemble the native Swift implementation as closely as possible. This means largely remodeling the flow to use a singleton-based structure with TypeScript interfaces, and thus no direct handoff of native objects (which is not supported in React Native modules as of today).

No other functionality is planned for this library, although feature parity with iOS Core Haptics is technically possible.

Read more about [Core Haptics on the Apple Developer site](https://developer.apple.com/documentation/corehaptics).

## Install

```sh
yarn install SnowcodeDesign/react-native-core-haptics-api
```

or

```sh
npm install SnowcodeDesign/react-native-core-haptics-api
```

## Usage

```js
// import the needed classes at the top of the file
import { HapticEngine, 
  HapticPatternType, 
  HapticEventType,
  HapticEventParameterType,
  HapticEventParameterIDType,
  HapticEventEventTypeType,
  HapticDeviceCapabilityType
} from 'react-native-core-haptics-api';

// this is copy & paste from ./example/src/App.tsx
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
}
```

## Authors

```
Julian Weiss
snowcode.design
(c) 2021 Julian Weiss & Gamebytes
```

## License

```
MIT License

Copyright (c) 2021 Julian Weiss & Gamebytes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
