//
//  CYTemplateAdViewManager.m
//  NativeModuleSample
//
//  Created by Bill Lin on 2018/9/19.
//  Copyright © 2018年 Facebook. All rights reserved.
//


#import "CYTemplateAdViewManager.h"
#import <React/RCTUIManager.h>
#if (PROD == 1)
#import "NativeModuleSample-Swift.h"
#else
#import "NativeModuleSampleDev-Swift.h"
#endif

@implementation CYTemplateAdViewManager

- (UIView *)view
{
  CYTemplateAdView* templateAdView = [[CYTemplateAdView alloc] init];
  //MARK: Event
  [templateAdView setOnAdFailedToLoadClosure:^(CYTemplateAdView* view) {
    if (!view.onAdFailedToLoad)
    {
      return;
    }
    view.onAdFailedToLoad(@{});
  }];
  [templateAdView setOnAdClosedClosure:^(CYTemplateAdView* view) {
    if (!view.onAdClosed)
    {
      return;
    }
    view.onAdClosed(@{});
  }];
  [templateAdView setOnAdClickedClosure:^(CYTemplateAdView* view) {
    if (!view.onAdClicked)
    {
      return;
    }
    view.onAdClicked(@{});
  }];
  [templateAdView setOnAdImpressionClosure:^(CYTemplateAdView* view) {
    if (!view.onAdImpression)
    {
      return;
    }
    view.onAdImpression(@{});
  }];
  [templateAdView setOnAdLeftApplicationClosure:^(CYTemplateAdView* view) {
    if (!view.onAdLeftApplication)
    {
      return;
    }
    view.onAdLeftApplication(@{});
  }];
  [templateAdView setOnUnifiedNativeAdLoadedClosure:^(CYTemplateAdView* view) {
    if (!view.onUnifiedNativeAdLoaded)
    {
      return;
    }
    view.onUnifiedNativeAdLoaded(@{});
  }];
  return templateAdView;
}

//MARK: Method
-(void) reloadAd:(nonnull NSNumber*) node
{
  dispatch_queue_t mainQueue = dispatch_get_main_queue();
  dispatch_async(mainQueue, ^(){
    UIView* temp = [self.bridge.uiManager viewForReactTag:node];
    if ([[temp class] isEqual:[CYTemplateAdView class]])
    {
      CYTemplateAdView* view = (CYTemplateAdView*) temp;
      [view reloadAd];
    }
  });
}

@end
