/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#if (PROD == 1)
#import "NativeModuleSample-Swift.h"
#else
#import "NativeModuleSampleDev-Swift.h"
#endif

#if RCT_DEV
#import <React/RCTDevLoadingView.h>
#endif

@import GoogleMobileAds;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
//  NSString* appId = @"ca-app-pub-3940256099942544~1458002511"; // ios
// //     NSString* appId = @"ca-app-pub-3940256099942544~3347511713"; // android
//  [GADMobileAds configureWithApplicationID:appId];
  
  NSURL *jsCodeLocation;
  
  if (PROD == 1)
  {
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
  }
  else
  {
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"indexDev" fallbackResource:nil];
  }
  RCTBridge *bridge = [[RCTBridge alloc] initWithBundleURL:jsCodeLocation
                                            moduleProvider:nil
                                             launchOptions:launchOptions];
  
  //#if RCT_DEV
  [bridge moduleForClass:[RCTDevLoadingView class]];
  //#endif
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"NativeModuleSample"
                                            initialProperties:nil];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
