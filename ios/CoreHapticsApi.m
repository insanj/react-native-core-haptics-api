#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(HapticEngine, NSObject)

RCT_EXTERN_METHOD(getDeviceCapabilities:(RCTPromiseResolveBlock)resolve
                                 reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(start:(NSString *)uuid
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(makePlayer:(NSDictionary *)pattern
                        uuid:(NSString *)uuid
                     resolve:(RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(startPlayerAtTime:(NSDictionary *)pattern
                          startTime:(CGFloat)startTime
                               uuid:(NSString *)uuid
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
