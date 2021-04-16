#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(HapticEngine, NSObject)

RCT_EXTERN_METHOD(getDeviceCapabilities:(RCTPromiseResolveBlock)resolve
                                 reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(start:(NSString *)uuid
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(makePlayer:(NSString *)uuid
                     pattern:(NSDictionary *)pattern
                     resolve:(RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(startPlayerAtTime:(NSString *)uuid
                            pattern:(NSDictionary *)pattern
                          startTime:(CGFloat)startTime
                            resolve:(RCTPromiseResolveBlock)resolve
                             reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(stop:(NSString *)uuid
               resolve:(RCTPromiseResolveBlock)resolve
                reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
