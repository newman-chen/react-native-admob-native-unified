//
//  CYNativeAdViewManager.m
//  ReactNativeTest2
//
//  Created by Bill Lin on 2018/6/14.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "CYNativeAdViewManager.h"
#import <React/RCTUIManager.h>
#import "NativeModuleSample-Swift.h"

@implementation CYNativeAdViewManager

- (UIView *)view
{
  RCTLog(@"sambow333 view");
  CYNativeAdView* nativeAdView = [[CYNativeAdView alloc] init];
  //MARK: Event
  [nativeAdView setOnAdFailedToLoadClosure:^(CYNativeAdView* view) {
    if (!view.onAdFailedToLoad)
    {
      return;
    }
    view.onAdFailedToLoad(@{});
  }];
  [nativeAdView setOnAdClosedClosure:^(CYNativeAdView* view) {
    if (!view.onAdClosed)
    {
      return;
    }
    view.onAdClosed(@{});
  }];
  [nativeAdView setOnAdClickedClosure:^(CYNativeAdView* view) {
    if (!view.onAdClicked)
    {
      return;
    }
    view.onAdClicked(@{});
  }];
  [nativeAdView setOnAdImpressionClosure:^(CYNativeAdView* view) {
    if (!view.onAdImpression)
    {
      return;
    }
    view.onAdImpression(@{});
  }];
  [nativeAdView setOnAdLeftApplicationClosure:^(CYNativeAdView* view) {
    if (!view.onAdLeftApplication)
    {
      return;
    }
    view.onAdLeftApplication(@{});
  }];
  [nativeAdView setOnUnifiedNativeAdLoadedClosure:^(CYNativeAdView* view) {
    if (!view.onUnifiedNativeAdLoaded)
    {
      return;
    }
    view.onUnifiedNativeAdLoaded(@{});
  }];
  return nativeAdView;
}

//MARK: Method
-(void) reloadAd:(nonnull NSNumber*) node
{
  RCTLog(@"sambow333 reloadAd");
  dispatch_queue_t mainQueue = dispatch_get_main_queue();
  dispatch_async(mainQueue, ^(){
    UIView* temp = [self.bridge.uiManager viewForReactTag:node];
    if ([[temp class] isEqual:[CYNativeAdView class]])
    {
      CYNativeAdView* view = (CYNativeAdView*) temp;
      [view reloadAd];
    }
  });
}

@end
