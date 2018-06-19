package com.nativemodulesample.module;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;

public class RNViewManager extends ViewGroupManager<CustomImageView> {
    @Override
    public String getName() {
        return "RNImageView";
    }

    @Override
    protected CustomImageView createViewInstance(ThemedReactContext reactContext) {
        CustomImageView view = new CustomImageView(reactContext);
        return view;
    }
}