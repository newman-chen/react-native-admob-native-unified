package com.nativemodulesample.module;

import android.graphics.Color;
import android.support.annotation.NonNull;
import android.text.TextUtils;
import android.view.View;

import com.facebook.react.bridge.JSApplicationIllegalArgumentException;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.nativemodulesample.util.CYLog;

import java.util.Map;

import javax.annotation.Nullable;

public class CYNativeAdViewManager extends ViewGroupManager<CYNativeAdView> {
    private static final String TAG = "CYNativeAdViewManager";
    public static final String REACT_CLASS = "CYNativeAd";

    public static final String PROP_AD_UNIT_ID = "adUnitID";
    public static final String PROP_AD_COLORS = "adColors";

    public static final String EVENT_AD_FAILED_TO_LOAD = "onAdFailedToLoad";
    public static final String EVENT_AD_CLICKED = "onAdClicked";
    public static final String EVENT_AD_CLOSED = "onAdClosed";
    public static final String EVENT_AD_OPENED = "onAdOpened";
    public static final String EVENT_AD_IMPRESSION = "onAdImpression";
    public static final String EVENT_AD_LOADED = "onAdLoaded";
    public static final String EVENT_AD_LEFT_APPLICATION = "onAdLeftApplication";
    public static final String EVENT_UNIFIED_NATIVE_AD_LOADED = "onUnifiedNativeAdLoaded";

    public static final int COMMAND_REQUEST_NATIVE_AD = 1;

    private static final String COLOR_REGEX = "^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$";

    private ThemedReactContext mContext;
    private CYNativeAdView nativeAdView;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected CYNativeAdView createViewInstance(ThemedReactContext reactContext) {
        mContext = reactContext;
        nativeAdView = new CYNativeAdView(reactContext);
        return nativeAdView;
    }

    @Override
    public void addView(CYNativeAdView parent, View child, int index) {
        throw new RuntimeException("CYNativeAdView cannot have subviews");
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
    public void receiveCommand(CYNativeAdView root, int commandId, @Nullable ReadableArray args) {
        CYLog.d(TAG, "got command !!  --- commandId : ", commandId);
        switch (commandId) {
            case COMMAND_REQUEST_NATIVE_AD:
                root.requestNativeAd();
                break;
        }
    }

    @ReactProp(name = PROP_AD_UNIT_ID)
    public void setPropAdUnitId(final CYNativeAdView view, final String adUnitId) {
        CYLog.d(TAG, "setPropAdUnitId() with adUnitId:", adUnitId);
        view.setAdmobAdUnitId(adUnitId);
    }

    /**
     *
     * @param view
     * @param colors color[0] : ad's background color
     *               color[1] : ad's headline text color
     *               color[2] : ad's body text color
     *               color[3] : ad's button text color
     *               color[4] : ad's button background color
     */
    @ReactProp(name = PROP_AD_COLORS)
    public void setPropAdColors(final CYNativeAdView view, ReadableArray colors) {
        CYLog.d(TAG, "setPropAdColors() with colors:");
        String type0 = colors.getType(0).name();
        if ("String".equals(type0)) {
            String color0 = colors.getString(0);
            if (!TextUtils.isEmpty(color0)) {
                view.setBackgroundColor(getColor(color0));
            }
        }

        String type1 = colors.getType(1).name();
        if ("String".equals(type1)) {
            String color1 = colors.getString(1);
            if (!TextUtils.isEmpty(color1)) {
                view.setHeadlineColor(getColor(color1));
            }
        }

        String type2 = colors.getType(2).name();
        if ("String".equals(type2)) {
            String color2 = colors.getString(2);
            if (!TextUtils.isEmpty(color2)) {
                view.setBodyTextColor(getColor(color2));
            }
        }

        String type3 = colors.getType(3).name();
        if ("String".equals(type3)) {
            String color3 = colors.getString(3);
            if (!TextUtils.isEmpty(color3)) {
                view.setButtonTextColor(getColor(color3));
            }
        }

        String type4 = colors.getType(4).name();
        if ("String".equals(type4)) {
            String color4 = colors.getString(4);
            if (!TextUtils.isEmpty(color4)) {
                view.setButtonBackgroundColor(getColor(color4));
            }
        }
    }

    private int getColor(@NonNull String colorString) throws JSApplicationIllegalArgumentException {
        if (colorString.matches(COLOR_REGEX)) {
            return Color.parseColor(colorString);
        } else {
            throw new JSApplicationIllegalArgumentException("Invalid arrowColor property: " + colorString);
        }
    }
}