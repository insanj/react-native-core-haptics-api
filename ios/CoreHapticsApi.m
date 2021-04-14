#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(HapticDeviceCapabilty, NSObject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end

@interface RCT_EXTERN_MODULE(HapticEventParameterID, NSObject)

RCT_EXTERN_METHOD(create:(NSString *)rawValue  
                 resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end

@interface RCT_EXTERN_MODULE(HapticEventParameter, NSObject)

RCT_EXTERN_METHOD(create:(HapticEventParameterID *)parameterID
                  value:(float)value
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end

@interface RCT_EXTERN_MODULE(HapticEventEventType, NSObject)

RCT_EXTERN_METHOD(create:(NSString *)rawValue
                 resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end

@interface RCT_EXTERN_MODULE(HapticEvent, NSObject)

RCT_EXTERN_METHOD(create:(HapticEventEventType *)eventType 
              parameters:(NSArray *)parameters 
            relativeTime:(float)relativeTime 
                duration:(float)duration
                 resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end

@interface RCT_EXTERN_MODULE(HapticPattern, NSObject)

RCT_EXTERN_METHOD(create:(NSArray *)hapticEvents  
                 resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end

@interface RCT_EXTERN_MODULE(HapticPatternPlayer, NSObject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end

@interface RCT_EXTERN_MODULE(HapticEngine, NSObject)

RCT_EXTERN_METHOD(getSupportsHaptics:(RCTPromiseResolveBlock)resolve
                              reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(create:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(makePlayer:(HapticPattern)hapticPattern
                    resolve:(RCTPromiseResolveBlock)resolve
                     reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(start:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(startPlayerAtTime:(float)startTime
                            resolve:(RCTPromiseResolveBlock)resolve
                             reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(stop:(RCTPromiseResolveBlock)resolve
                reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
