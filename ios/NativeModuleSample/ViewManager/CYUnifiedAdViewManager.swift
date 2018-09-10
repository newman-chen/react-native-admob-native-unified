//
//  CYUnifiedAdViewManager.swift
//  NativeModuleSample
//
//  Created by Bill Lin on 2018/6/20.
//  Copyright © 2018年 Facebook. All rights reserved.
//

import UIKit
@objc (CYUnifiedAdViewManager)
class CYUnifiedAdViewManager: RCTViewManager {
  override func view() -> UIView! {
    print("sambow222", self.bridge.module(forName: "CYNativeAdModule"))
    print("sambow222", "view")
    let nativeAdView = CYNativeAdView()
    nativeAdView.onAdClosedClosure = { (view) in
      if let block = view.onAdClosed{
        block(nil)
      }
    }
    nativeAdView.onAdClickedClosure = { (view) in
      if let block = view.onAdClicked{
        block(nil)
      }
    }
    nativeAdView.onAdImpressionClosure = { (view) in
      if let block = view.onAdImpression{
        block(nil)
      }
    }
    nativeAdView.onAdFailedToLoadClosure = { (view) in
      if let block = view.onAdFailedToLoad{
        block(nil)
      }
    }
    nativeAdView.onAdLeftApplicationClosure = { (view) in
      if let block = view.onAdLeftApplication{
        block(nil)
      }
    }
    nativeAdView.onUnifiedNativeAdLoadedClosure = { (view) in
      if let block = view.onUnifiedNativeAdLoaded{
        block(nil)
      }
    }
    return nativeAdView
  }
  
  func reloadAd(_ node:NSNumber) {
    print("sambow222", "reloadAd")
    DispatchQueue.main.async {
      let nativeAdView = self.bridge.uiManager.view(forReactTag: node) as! CYNativeAdView
      nativeAdView.reloadAd()
    }
  }
}
