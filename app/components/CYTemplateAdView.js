import React, {Component} from 'react';
import {
    requireNativeComponent,
    UIManager,
    findNodeHandle,
    ViewPropTypes,
    StyleSheet,
    Platform,
} from 'react-native';
import propTypes, { func, string } from 'prop-types';

const reloadAdKey = Platform.select({
    ios: UIManager.CYTemplateAdView.Commands.reloadAd,
    android: 1,
  });

class CYTemplateAdView extends Component {
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
            <CYTemplateAd
                {...this.props}
                style={styles.natvieAdView}
                ref={el => (this.nativeAdViewRef = el)}
            />
        );
    }
}

const styles = StyleSheet.create({
    natvieAdView: {
        height: 112,
        width: '100%',
        
    }
});

CYTemplateAdView.propTypes = {
    ...ViewPropTypes,

    /**
     * ad unit ID provided from admob
     */
    adUnitID: propTypes.string,

    /**
     * ad unit ID provided from admob
     */
    // templateId: propTypes.string,

    /*
     * has image within this layout
     */
    adLayoutWithImage: propTypes.bool,

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

const CYTemplateAd = requireNativeComponent('CYTemplateAdView', CYTemplateAdView)

export default CYTemplateAdView;