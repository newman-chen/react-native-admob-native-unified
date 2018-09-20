package com.anue.rn.nativead.module;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.AppCompatImageView;
import android.support.v7.widget.AppCompatTextView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.anue.rn.nativead.R;
import com.anue.rn.nativead.util.CYLog;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.formats.MediaView;
import com.google.android.gms.ads.formats.NativeAdOptions;
import com.google.android.gms.ads.formats.NativeCustomTemplateAd;

import static com.anue.rn.nativead.module.Constant.ADMOB_AD_UNIT_ID;

public class CYNativeCustomTemplateAdView extends LinearLayout {
    private static final String TAG = "CYNativeCustomTemplateAdView";
    // Media container
    protected LinearLayout mediaContainer;
    protected ImageView imageView;
    protected MediaView mediaView;
    protected AppCompatTextView headlineTextView;
    protected AppCompatTextView sponsorName;

    private String admobAdUnitId;
    private String customTemplateId = "10157685";

    public CYNativeCustomTemplateAdView(Context context) {
        super(context);
        createNativeAd(context);
    }

    private void createNativeAd(Context context) {
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View viewRoot = layoutInflater.inflate(R.layout.ad_custom_template, this, true);
        initViews(viewRoot);
    }

    private void initViews(View view) {
        mediaContainer = (LinearLayout) view.findViewById(R.id.ad_media_container);
        mediaView = (MediaView) view.findViewById(R.id.ad_media);
        imageView = (ImageView) view.findViewById(R.id.ad_image);

        headlineTextView = (AppCompatTextView) view.findViewById(R.id.ad_headline);
        sponsorName = (AppCompatTextView) view.findViewById(R.id.ad_advertiser);
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
        builder.forCustomTemplateAd(customTemplateId, new NativeCustomTemplateAd.OnCustomTemplateAdLoadedListener() {
            @Override
            public void onCustomTemplateAdLoaded(NativeCustomTemplateAd nativeCustomTemplateAd) {
                // Display ad and record impression
                if (nativeCustomTemplateAd != null) {
                    populateNativeCustomTemplateAd(nativeCustomTemplateAd);
                }
                sendEvent(CYNativeAdViewManager.EVENT_UNIFIED_NATIVE_AD_LOADED, null);
            }
        }, new NativeCustomTemplateAd.OnCustomClickListener() {
            @Override
            public void onCustomClick(NativeCustomTemplateAd nativeCustomTemplateAd, String s) {
                if (nativeCustomTemplateAd != null) {
                    nativeCustomTemplateAd.performClick(s);
                }
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

        //.addTestDevice("1E3E20447441F98AB5982F1269C6EA33")
//        adLoader.loadAd(new PublisherAdRequest.Builder().build());
        adLoader.loadAd(new AdRequest.Builder().build());
    }

    private void populateNativeCustomTemplateAd(NativeCustomTemplateAd templateAd) {
        CYLog.d(TAG, "templateAd::", templateAd.getText("Title"));
        CYLog.d(TAG, "templateAd::", templateAd.getImage("Cover").getUri().toString());
        CYLog.d(TAG, "templateAd::", templateAd.getText("Sponsor"));

        headlineTextView.setText(templateAd.getText("Title")+"贊助");
        if (templateAd.getImage("Cover") != null) {
            imageView.setImageDrawable(templateAd.getImage("Cover").getDrawable());
            imageView.setVisibility(VISIBLE);
        } else {
            imageView.setVisibility(GONE);
        }
        mediaView.setVisibility(GONE);
        sponsorName.setText(templateAd.getText("Sponsor"));

        templateAd.recordImpression();
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
        if (mediaContainer != null) {
            mediaContainer.setVisibility(hasImage ? VISIBLE : INVISIBLE);
        }
    }

    public void setAdmobAdUnitId(@NonNull String admobAdUnitId) {
        this.admobAdUnitId = admobAdUnitId;
    }

    public void requestNativeAd() {
        refreshAd();
    }
}