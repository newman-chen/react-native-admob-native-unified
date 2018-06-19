import React, {Component} from 'react';
import {
    requireNativeComponent,
    UIManager,
    findNodeHandle,
    ViewPropTypes,
} from 'react-native';

class CYNativeImageView extends Component {
    constructor() {
        super();
    }

    render() {
        return (
            <RNImageView
                {...this.props}
                ref={el => (this.nativeImageViewRef = el)}
            />
        );
    }
}

CYNativeImageView.propTypes = {
    ...ViewPropTypes,
    
};

const RNImageView = requireNativeComponent('RNImageView', CYNativeImageView)

export default CYNativeImageView;