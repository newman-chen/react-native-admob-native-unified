
# React-Native for unified native ad UI component 

Add example for adding unified native ad UI component for react-native usage

# Before you run (iOS)
```shell
pod install --repo-update
```

# Run Project
```shell
npm install
npm run android-dev //android
npm run ios-dev     //ios
```

# How to use
參考以下範例或是參考 [App.js](https://github.com/newman-chen/react-native-admob-native-unified/blob/master/App.js)
```javascript
<CYNativeAdView
    style={styles.nativeView} 
    adUnitID='ca-app-pub-3940256099942544/2247696110'    // your ad unit id
    adColors={['#2200ff00', '#ff0000', '#660000', '#53cd12', '#11000000']}    // color sets
    onUnifiedNativeAdLoaded={this.onAdLoaded}    // callback for ad is loaded
    onAdFailedToLoad={this.onAdFailedToLoad}
    onAdImpression={this.onAdImpression}
    onAdClicked={this.onAdClicked}
    onAdLeftApplication={this.onAdLeftApplication}
/>
```

# Trouble shooting
### 1. No bundle URL present
Make sure you're running a packager server or have included a .jsbundle file in your application bundle
### solution:
- Open a terminal window
- ```cd``` into ```$YOUR_PROJECT/ios```
- Remove the build folder with ```rm -r build```
- Run ```npm run ios-dev``` again

### 2. RCTBridge required dispatch_sync to load RCTDevLoadingView. This may lead to deadlocks
### solution:
- edit AppDelegate.m
```Objective-C
#if RCT_DEV
#import <React/RCTDevLoadingView.h>
#endif
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL *jsCodeLocation;

    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];

    RCTBridge *bridge = [[RCTBridge alloc] initWithBundleURL:jsCodeLocation
                                            moduleProvider:nil
                                             launchOptions:launchOptions];

    #if RCT_DEV
    [bridge moduleForClass:[RCTDevLoadingView class]];
    #endif
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"NativeModuleSample"
                                            initialProperties:nil];
}
@end
```

# For more information
1. [How to Create Native UI component for React-Native in Android](https://medium.com/p/ce198854ba22/)
2. [How to Create Native UI component for React-Native in iOS](https://medium.com/p/ce198854ba22/)
3. [Official Doc for Native Component](https://facebook.github.io/react-native/docs/native-components-android.html)
4. [Native Ad Advanced](https://developers.google.com/admob/android/native-unified)
