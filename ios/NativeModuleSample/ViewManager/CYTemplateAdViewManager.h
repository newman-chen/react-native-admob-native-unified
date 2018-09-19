//
//  CYTemplateAdViewManager.h
//  NativeModuleSample
//
//  Created by Bill Lin on 2018/9/19.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <React/RCTViewManager.h>

//MARK: Register
@interface RCT_EXTERN_MODULE(CYTemplateAdViewManager, RCTViewManager)

//MARK: Property
RCT_EXPORT_VIEW_PROPERTY(adUnitID, NSString)
//RCT_EXPORT_VIEW_PROPERTY(adColors, NSArray<NSString>)
RCT_EXPORT_VIEW_PROPERTY(adLayoutWithImage, BOOL)

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
