
# React-Native for unified native ad UI component 

Add example for adding unified native ad UI component for react-native usage

# Run Android Project
```shell
npm install
npm run android
```

# How to use
參考以下範例或是參考 [App.js](https://github.com/newman-chen/react-native-unified-native-ad-sample/blob/master/App.js)
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

# For more information
1. [How to Create Native UI component for React-Native](https://medium.com/@newmanchen/%E5%A6%82%E4%BD%95%E5%BB%BA%E7%AB%8B-android-native-ui-component-with-react-native-ce198854ba22)
2. [Official Doc for Native Component](https://facebook.github.io/react-native/docs/native-components-android.html)
3. [Native Ad Advanced](https://developers.google.com/admob/android/native-unified)
