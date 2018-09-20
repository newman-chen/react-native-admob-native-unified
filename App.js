
//#region import
import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Platform,
} from 'react-native';
import CYNativeAdView from './app/components/CYNativeAdView';
import CYTemplateAdView from './app/components/CYTemplateAdView';
import CYNativeImageView from './app/components/CYNativeImageView';
//#endregion

//#region variable
// const unitID = "ca-app-pub-3940256099942544/3986624511" // ios image
// const unitID = "ca-app-pub-3940256099942544/2521693316" // ios video
// const unitID = "ca-app-pub-3940256099942544/2247696110" // android image
const unitID = "ca-app-pub-3940256099942544/1044960115" // android video
const dfpUnitId = "/6499/example/native" //Custom Rendering
const CNYES_AD_UNIT_ID_7 = Platform.select({
  ios: '/1018855/app_news_headline_native_7/app_news_headline_native_7_IOS',
  android:
    '/1018855/app_news_headline_native_7/app_news_headline_native_7_Android',
});
//#endregion

export default class App extends Component {
  constructor(props) {
    super(props)
    this.state = {
      count: 0,
    }
  }

  componentDidMount() {
    console.log("App componentDidMount")
  }

  //#region render
  render() {
    return (
      <View style={styles.container}>
        <View>
          <Text style={{color: 'black'}}>Custom Rendering Ad Unit Id :</Text><Text>{dfpUnitId}</Text>
        </View>
        <CYNativeAdView
          style={styles.nativeView}
          adUnitID={dfpUnitId}
          adColors={['#2200ff00', '#ff0000', '#660000', '#53cd12', '#11000000']}
          adLayoutWithImage={true}
          onUnifiedNativeAdLoaded={this.onAdLoaded}
          onAdFailedToLoad={this.onAdFailedToLoad}
          onAdImpression={this.onAdImpression}
          onAdClicked={this.onAdClicked}
          onAdLeftApplication={this.onAdLeftApplication}
          onRef={ref => (this.child = ref)}
        />
        <TouchableOpacity style={styles.button}
          onPress={this.onPress}>
          <Text>Refresh Ad</Text>
        </TouchableOpacity>
        <View style={[styles.countContainer]}>
          <Text style={[styles.countText]}>
            {this.state.count !== 0 ? this.state.count : null}
          </Text>
        </View>
        <View>
          <Text style={{color: 'black'}}>Custom Template Ad Unit Id : </Text><Text>{CNYES_AD_UNIT_ID_7}</Text>
        </View>
        <CYTemplateAdView
          style={styles.nativeView}
          adUnitID={CNYES_AD_UNIT_ID_7}
          adLayoutWithImage={true}
          onUnifiedNativeAdLoaded={this.onAdLoaded}
          onAdFailedToLoad={this.onAdFailedToLoad}
          onAdImpression={this.onAdImpression}
          onAdClicked={this.onAdClicked}
          onAdLeftApplication={this.onAdLeftApplication}
          onRef={ref => (this.child = ref)}
        />
      </View>
    );
  }
  //#endregion

  /* <CYNativeImageView
         style={styles.natvieImageView}
         /> */

  //#region callback
  onAdLoaded = () => {
    console.log("App onAdLoaded from ")
  }

  onAdFailedToLoad = () => {
    console.log("App onAdFailedToLoad")
  }

  onAdImpression = () => {
    console.log("App onAdImpression")
  }

  onAdClicked = () => {
    console.log('App onAdClicked')
  }

  onAdLeftApplication = () => {
    console.log("App onAdLeftApplication")
  }
  //#endregion

  //#region function
  onPress = () => {
    this.child.requestNativeAd()
    this.setState({
      count: this.state.count + 1,
    },
      () => {
        console.log("App press on text view")
      }
    )
  }
}
//#endregion

//<CYNativeImageView
//        style={styles.natvieImageView}
//    />

// <View style={styles.container}>
//   <Text>Open up App.js to start working on your app!</Text>
//   <Text>Changes you make will automatically reload.</Text>
//   <Text>Shake your phone to open the developer menu.</Text>
// </View>

//#region style
const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    paddingHorizontal: 10,
    marginTop: 20,
  },
  text: {
    width: '100%',
    color: 'black',
    backgroundColor: 'green',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 10,
  },
  nativeView: {
    flex: 1,
    justifyContent: 'flex-start',
  },
  natvieImageView: {
    height: 120,
    width: 120,
  },
  button: {
    alignItems: 'center',
    backgroundColor: '#DDDDDD',
    padding: 10
  },
  countContainer: {
    alignItems: 'center',
    padding: 10
  },
  countText: {
    color: '#FF00FF'
  },
});
//#endregion
