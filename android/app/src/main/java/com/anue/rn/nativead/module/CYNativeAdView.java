package com.anue.rn.nativead.module;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RatingBar;
import android.widget.TextView;
import android.widget.Toast;

import com.anue.rn.nativead.R;
import com.anue.rn.nativead.util.CYLog;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.VideoController;
import com.google.android.gms.ads.formats.MediaView;
import com.google.android.gms.ads.formats.NativeAdOptions;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;

import static com.anue.rn.nativead.module.Constant.ADMOB_AD_UNIT_ID;

public class CYNativeAdView extends LinearLayout {
    private static final String TAG = "CYNativeAdView";
    // Native Ad View
    protected UnifiedNativeAdView unifiedNativeAdView;
    // Media container
    protected LinearLayout mediaContainer;
    protected ImageView imageView;
    protected MediaView mediaView;

    private String admobAdUnitId;

    public CYNativeAdView(Context context) {
        super(context);
        createNativeAd(context);
    }

    private void createNativeAd(Context context) {
        if (unifiedNativeAdView != null) {
            unifiedNativeAdView.destroy();
        }

        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View viewRoot = layoutInflater.inflate(R.layout.ad_unified_simple, this, true);
        unifiedNativeAdView = (UnifiedNativeAdView) viewRoot.findViewById(R.id.unified_ad_view);
        initViews();
    }

    private void initViews() {
        mediaContainer = (LinearLayout) unifiedNativeAdView.findViewById(R.id.ad_media_container);
        mediaView = (MediaView) unifiedNativeAdView.findViewById(R.id.ad_media);
        imageView = (ImageView) unifiedNativeAdView.findViewById(R.id.ad_image);

        unifiedNativeAdView.setIconView(unifiedNativeAdView.findViewById(R.id.ad_app_icon));
        unifiedNativeAdView.setHeadlineView(unifiedNativeAdView.findViewById(R.id.ad_headline));
        unifiedNativeAdView.setAdvertiserView(unifiedNativeAdView.findViewById(R.id.ad_advertiser));
//        unifiedNativeAdView.setCallToActionView(unifiedNativeAdView.findViewById(R.id.ad_call_to_action));
    }

    // to realize the wrap content in view , need to trigger requestLayout and re-layout by yourself
    // https://github.com/facebook/react-native/issues/4990
    @Override
    public void requestLayout() {
        super.requestLayout();

        // The spinner relies on a measure + layout pass happening after it calls requestLayout().
        // Without this, the widget never actually changes the selection and doesn't call the
        // appropriate listeners. Since we override onLayout in our ViewGroups, a layout pass never
        // happens after a call to requestLayout, so we simulate one here.
        post(measureAndLayout);
    }

    private final Runnable measureAndLayout = new Runnable() {
        @Override
        public void run() {
            measure(
                    MeasureSpec.makeMeasureSpec(getWidth(), MeasureSpec.EXACTLY),
                    MeasureSpec.makeMeasureSpec(getHeight(), MeasureSpec.EXACTLY));
            layout(getLeft(), getTop(), getRight(), getBottom());
        }
    };

    /**
     * Creates a request for a new native ad based on the boolean parameters and calls the
     * corresponding "populate" method when one is successfully returned.
     */
    private void refreshAd() {
        if (TextUtils.isEmpty(admobAdUnitId)) {
            admobAdUnitId = ADMOB_AD_UNIT_ID;
        } else {
            CYLog.d(TAG, "admobAdUnitId is not null");
        }
        AdLoader.Builder builder = new AdLoader.Builder(getContext(), admobAdUnitId);
        builder.forUnifiedNativeAd(new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
            @Override
            public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                // OnUnifiedNativeAdLoadedListener implementation.
                if (unifiedNativeAd != null) {
                    populateUnifiedNativeAdView(unifiedNativeAd);
                    printNativeInfo(unifiedNativeAd);
                }
                sendEvent(CYNativeAdViewManager.EVENT_UNIFIED_NATIVE_AD_LOADED, null);
            }
        });


//        boolean muted = false; // FIXME option
//        VideoOptions videoOptions = new VideoOptions.Builder()
//                .setStartMuted(muted)
//                .build();
        NativeAdOptions adOptions = new NativeAdOptions.Builder()
//                .setVideoOptions(videoOptions)
                .setAdChoicesPlacement(NativeAdOptions.ADCHOICES_TOP_RIGHT)
                .build();
        builder.withNativeAdOptions(adOptions);

        AdLoader adLoader = builder.withAdListener(new AdListener() {
            @Override
            public void onAdFailedToLoad(int i) {
                super.onAdFailedToLoad(i);
                Toast.makeText(getContext(),
                        "Failed to load native ad: " + i, Toast.LENGTH_SHORT).show();
                sendEvent(CYNativeAdViewManager.EVENT_AD_FAILED_TO_LOAD, null);
            }

            @Override
            public void onAdClicked() {
                super.onAdClicked();
                sendEvent(CYNativeAdViewManager.EVENT_AD_CLICKED, null);
            }

            @Override
            public void onAdClosed() {
                super.onAdClosed();
                sendEvent(CYNativeAdViewManager.EVENT_AD_CLOSED, null);
            }

            @Override
            public void onAdOpened() {
                super.onAdOpened();
                sendEvent(CYNativeAdViewManager.EVENT_AD_OPENED, null);
            }

            @Override
            public void onAdImpression() {
                super.onAdImpression();
                sendEvent(CYNativeAdViewManager.EVENT_AD_IMPRESSION, null);
            }

            @Override
            public void onAdLoaded() {
                super.onAdLoaded();
                sendEvent(CYNativeAdViewManager.EVENT_AD_LOADED, null);
            }

            @Override
            public void onAdLeftApplication() {
                super.onAdLeftApplication();
                sendEvent(CYNativeAdViewManager.EVENT_AD_LEFT_APPLICATION, null);
            }
        })
                .build();

        adLoader.loadAd(new AdRequest.Builder().build());
    }

    private void populateUnifiedNativeAdView(@NonNull UnifiedNativeAd nativeAd) {
        VideoController vc = nativeAd.getVideoController();
        if (vc != null) {
            vc.setVideoLifecycleCallbacks(new VideoController.VideoLifecycleCallbacks() {
                public void onVideoEnd() {
                    super.onVideoEnd();
                    CYLog.d(TAG, "onVideoEnd()");
                }
            });
            CYLog.d(TAG, "video aspect ration is ", vc.getAspectRatio());
        }
        if (vc != null && vc.hasVideoContent()) {
            unifiedNativeAdView.setMediaView(mediaView);
            mediaView.setVisibility(VISIBLE);
            imageView.setVisibility(GONE);
        } else {
            unifiedNativeAdView.setImageView(imageView);
            mediaView.setVisibility(GONE);
            imageView.setVisibility(VISIBLE);

            if (!nativeAd.getImages().isEmpty()) {
                imageView.setImageDrawable(nativeAd.getImages().get(0).getDrawable());
            }
        }

        // Some assets are guaranteed to be in every UnifiedNativeAd.
        ((TextView) unifiedNativeAdView.getHeadlineView()).setText(nativeAd.getHeadline());

        if (nativeAd.getIcon() == null) {
            unifiedNativeAdView.getIconView().setVisibility(GONE);
        } else {
            ((ImageView) unifiedNativeAdView.getIconView()).setImageDrawable(nativeAd.getIcon().getDrawable());
            unifiedNativeAdView.getIconView().setVisibility(VISIBLE);
        }
        if (nativeAd.getAdvertiser() == null) {
            unifiedNativeAdView.getAdvertiserView().setVisibility(GONE);
        } else {
            ((TextView) unifiedNativeAdView.getAdvertiserView()).setText(nativeAd.getAdvertiser());
            unifiedNativeAdView.getAdvertiserView().setVisibility(VISIBLE);
        }

        unifiedNativeAdView.setNativeAd(nativeAd);
    }

    private void sendEvent(String name, @Nullable WritableMap event) {
        CYLog.d(TAG, "sendEvent to RN : name : ", name);
        ReactContext reactContext = (ReactContext) getContext();
        reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                getId(),
                name,
                event);
    }

    public void setHasImage(boolean hasImage) {
        if (unifiedNativeAdView != null) {
            if (mediaContainer != null) {
                mediaContainer.setVisibility(hasImage ? VISIBLE : INVISIBLE);
            }
        }
    }

    public void setAdmobAdUnitId(@NonNull String admobAdUnitId) {
        this.admobAdUnitId = admobAdUnitId;
    }

    public void setHeadlineColor(@NonNull int color) {
        if (unifiedNativeAdView != null) {
            if (unifiedNativeAdView.getHeadlineView() != null) {
                ((TextView) unifiedNativeAdView.getHeadlineView()).setTextColor(color);
            }
        }
    }

    public void setBodyTextColor(@NonNull int color) {
        if (unifiedNativeAdView != null) {
            if (unifiedNativeAdView.getBodyView() != null) {
                ((TextView) unifiedNativeAdView.getBodyView()).setTextColor(color);
            }
        }
    }

    public void setButtonTextColor(@NonNull int color) {
        if (unifiedNativeAdView != null) {
            if (unifiedNativeAdView.getCallToActionView() != null) {
                ((Button) unifiedNativeAdView.getCallToActionView()).setTextColor(color);
            }
        }
    }

    public void setButtonBackgroundColor(@NonNull int color) {
        if (unifiedNativeAdView != null) {
            if (unifiedNativeAdView.getCallToActionView() != null) {
                unifiedNativeAdView.getCallToActionView().setBackgroundColor(color);
            }
        }
    }

    public void requestNativeAd() {
        refreshAd();
    }

    private void printNativeInfo(UnifiedNativeAd nativeAd) {
        CYLog.d(TAG, "nativeAd.headline : " + nativeAd.getHeadline());
        CYLog.d(TAG, "nativeAd.body : " + nativeAd.getBody());
        CYLog.d(TAG, "nativeAd.callToAction : " + nativeAd.getCallToAction());
        CYLog.d(TAG, "nativeAd.price : " + nativeAd.getPrice());
        CYLog.d(TAG, "nativeAd.store : " + nativeAd.getStore());
        CYLog.d(TAG, "nativeAd.starRating : " + nativeAd.getStarRating());
        CYLog.d(TAG, "nativeAd.advertiser : " + nativeAd.getAdvertiser());
        CYLog.d(TAG, "nativeAd.getImages().get(0).getUri().toString() : " + nativeAd.getImages().get(0).getUri().toString());

        VideoController vc = nativeAd.getVideoController();
        if (vc.hasVideoContent()) {
            CYLog.d(TAG, "============== HAS_VIDEO_CONTENT :: hasVideoContent : " + vc.hasVideoContent());
        } else {
            CYLog.d(TAG, "this ad does not contain video");
        }
    }
}