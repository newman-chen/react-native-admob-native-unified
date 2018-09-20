package com.anue.rn.nativead.module;

import com.anue.rn.nativead.util.CYLog;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

import javax.annotation.Nullable;

public class CYNativeCustomTemplateAdViewManager extends ViewGroupManager<CYNativeCustomTemplateAdView> {
    private static final String TAG = "CYNativeCustomTemplateAdViewManager";
    public static final String REACT_CLASS = "CYTemplateAdView";

    public static final String PROP_AD_UNIT_ID = "adUnitID";
    public static final String PROP_AD_LAYOUT_WITH_IMAGE = "adLayoutWithImage";

    public static final String EVENT_AD_FAILED_TO_LOAD = "onAdFailedToLoad";
    public static final String EVENT_AD_CLICKED = "onAdClicked";
    public static final String EVENT_AD_CLOSED = "onAdClosed";
    public static final String EVENT_AD_OPENED = "onAdOpened";
    public static final String EVENT_AD_IMPRESSION = "onAdImpression";
    public static final String EVENT_AD_LOADED = "onAdLoaded";
    public static final String EVENT_AD_LEFT_APPLICATION = "onAdLeftApplication";
    public static final String EVENT_UNIFIED_NATIVE_AD_LOADED = "onUnifiedNativeAdLoaded";

    public static final int COMMAND_REQUEST_NATIVE_AD = 1;

    private ThemedReactContext mContext;
    private CYNativeCustomTemplateAdView nativeAdView;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected CYNativeCustomTemplateAdView createViewInstance(ThemedReactContext reactContext) {
        mContext = reactContext;
        nativeAdView = new CYNativeCustomTemplateAdView(reactContext);
        return nativeAdView;
    }

    @Nullable
    @Override
    public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
        MapBuilder.Builder<String, Object> builder = MapBuilder.builder();
        String[] events = new String[]{
                EVENT_AD_FAILED_TO_LOAD,
                EVENT_AD_CLICKED,
                EVENT_AD_CLOSED,
                EVENT_AD_OPENED,
                EVENT_AD_IMPRESSION,
                EVENT_AD_LOADED,
                EVENT_AD_LEFT_APPLICATION,
                EVENT_UNIFIED_NATIVE_AD_LOADED
        };
        for (String event : events) {
            builder.put(event, MapBuilder.of("registrationName", event));
        }
        return builder.build();
    }

    @Nullable
    @Override
    public Map<String, Integer> getCommandsMap() {
        return MapBuilder.of("commandRequestNativeAd", COMMAND_REQUEST_NATIVE_AD);
    }

    @Override
    public void receiveCommand(CYNativeCustomTemplateAdView root, int commandId, @Nullable ReadableArray args) {
        CYLog.d(TAG, "got command !!  --- commandId : ", commandId);
        switch (commandId) {
            case COMMAND_REQUEST_NATIVE_AD:
                root.requestNativeAd();
                break;
        }
    }

    @ReactProp(name = PROP_AD_LAYOUT_WITH_IMAGE)
    public void setPropAdLayoutWithImage(final CYNativeCustomTemplateAdView view, final boolean hasImage) {
        CYLog.d(TAG, "setPropAdLayoutWithImage() with hasImage:", hasImage);
        view.setHasImage(hasImage);
    }

    @ReactProp(name = PROP_AD_UNIT_ID)
    public void setPropAdUnitId(final CYNativeCustomTemplateAdView view, final String adUnitId) {
        CYLog.d(TAG, "setPropAdUnitId() with adUnitId:", adUnitId);
        view.setAdmobAdUnitId(adUnitId);
    }
}