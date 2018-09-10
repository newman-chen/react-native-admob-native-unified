//
//  CYNativeAdModule.m
//  NativeModuleSample
//
//  Created by Bill Lin on 2018/6/21.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "CYNativeAdModule.h"

@interface RCT_EXTERN_MODULE(CYUnifiedAdViewManager, RCTViewManager)

//MARK: Property
RCT_EXPORT_VIEW_PROPERTY(adUnitID, NSString)
RCT_EXPORT_VIEW_PROPERTY(adColors, NSArray<NSString>)

//MARK: Method
RCT_EXTERN_METHOD(reloadAd:(nonnull NSNumber *)node)

//MARK: Event
RCT_EXPORT_VIEW_PROPERTY(onAdFailedToLoad, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdClosed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdClicked, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdImpression, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdLeftApplication, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onUnifiedNativeAdLoaded, RCTBubblingEventBlock)
@end

@implementation CYNativeAdModule
RCT_EXPORT_MODULE()
@end
