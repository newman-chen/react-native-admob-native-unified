import React, {Component} from 'react';
import {
    requireNativeComponent,
    UIManager,
    findNodeHandle,
    ViewPropTypes,
    StyleSheet,
    Platform,
} from 'react-native';
import { string, func, arrayOf, number, oneOfType } from 'prop-types';

const reloadAdKey = Platform.select({
    ios: UIManager.CYUnifiedAdView.Commands.reloadAd,
    android: 1,
  });

class CYNativeAdView extends Component {
    constructor() {
        super();
    }

    componentDidMount() {
        this.requestNativeAd()
        this.props.onRef(this)
    }

    componentWillUnmount() {
        this.props.onRef(undefined)
    }

    requestNativeAd() {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.nativeAdViewRef),
            reloadAdKey,
            null
        );
    }

    render() {
        return (
            <CYNativeAd
                {...this.props}
                style={styles.natvieAdView}
                ref={el => (this.nativeAdViewRef = el)}
            />
        );
    }
}

const styles = StyleSheet.create({
    natvieAdView: {
        height: 167,
        width: '100%',
        
    }
});

CYNativeAdView.propTypes = {
    ...ViewPropTypes,

    /**
     * ad unit ID provided from admob
     */
    adUnitID: string,

    /**
     * color[0] : ad's background color
     * color[1] : ad's headline text color
     * color[2] : ad's body text color
     * color[3] : ad's button text color
     * color[4] : ad's button backgroud color
     * e.g. {['#00ffff','#ff00ff', '#660000', '#53cd12', '#66000000']}
     */
    adColors: arrayOf(oneOfType([string])),

    /**
     * indicate that ad has failed to load
     */
    onAdFailedToLoad: func,

    /**
     * indicate that ad has been clicked
     */
    onAdClicked: func,

    /**
     * indicate that ad has been closed
     */
    onAdClosed: func,

    /*onAdOpened: func, */

    /**
     * indicate that an impression has been recorded for the ad
     */
    onAdImpression: func,

    /**
     *  indicates that the ad is causing the device to switch to a 
     *  different application (such as a web browser). This must be 
     *  called before the current application is put in the background.
     */
    onAdLeftApplication: func,

    /**
     * indicate that native ad has been loaded
     */
    onUnifiedNativeAdLoaded: func, 
};

const CYNativeAd = requireNativeComponent('CYUnifiedAdView', CYNativeAdView)

export default CYNativeAdView;