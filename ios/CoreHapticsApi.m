#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(HapticDeviceCapabilty, NSObject)

@end

@interface RCT_EXTERN_MODULE(HapticEventParameter, NSObject)

@end

@interface RCT_EXTERN_MODULE(HapticEventEventType, NSObject)

@end

@interface RCT_EXTERN_MODULE(HapticEvent, NSObject)

@end

@interface RCT_EXTERN_MODULE(HapticPattern, NSObject)

@end

@interface RCT_EXTERN_MODULE(HapticPatternPlayer, NSObject)

RCT_EXTERN_METHOD(start:(float)startTime
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

@end

@interface RCT_EXTERN_MODULE(HapticEngine, NSObject)

RCT_EXTERN_METHOD(capabilitiesForHardware)

RCT_EXTERN_METHOD(createWithResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(makePlayer:(HapticPattern)hapticPattern
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(startWithResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
