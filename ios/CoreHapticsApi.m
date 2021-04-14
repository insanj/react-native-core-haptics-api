#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(HapticDeviceCapabilty, NSObject)

@end

@interface RCT_EXTERN_MODULE(HapticEventParameterID, NSObject)

RCT_EXTERN_METHOD(create:(NSString *)rawValue)

@end

@interface RCT_EXTERN_MODULE(HapticEventParameter, NSObject)

RCT_EXTERN_METHOD(create:(HapticEventParameterID *)parameterID
                  value:(float)value)


@end

@interface RCT_EXTERN_MODULE(HapticEventEventType, NSObject)

RCT_EXTERN_METHOD(create:(NSString *)rawValue)

@end

@interface RCT_EXTERN_MODULE(HapticEvent, NSObject)

RCT_EXTERN_METHOD(create:(HapticEventEventType *)eventType 
                  parameters:(NSArray *)parameters 
                  relativeTime:(float)relativeTime 
                  duration:(float)duration)

@end

@interface RCT_EXTERN_MODULE(HapticPattern, NSObject)

RCT_EXTERN_METHOD(create:(NSArray *)hapticEvents)

@end

@interface RCT_EXTERN_MODULE(HapticPatternPlayer, NSObject)

RCT_EXTERN_METHOD(start:(float)startTime
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end

@interface RCT_EXTERN_MODULE(HapticEngine, NSObject)

RCT_EXTERN_METHOD(capabilitiesForHardware)

RCT_EXTERN_METHOD(create:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(makePlayer:(HapticPattern)hapticPattern
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(start:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(stop:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
