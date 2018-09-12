package com.anue.rn.nativead;

import android.app.Application;

import com.anue.rn.nativead.module.CYNativeReactPackage;
import com.anue.rn.nativead.module.Constant;
import com.anue.rn.nativead.module.RNImageViewReactPackage;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;
import com.google.android.gms.ads.MobileAds;

import java.util.Arrays;
import java.util.List;


public class MainApplication extends Application implements ReactApplication {

    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
        @Override
        public boolean getUseDeveloperSupport() {
            return BuildConfig.DEBUG;
        }

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                    new MainReactPackage(),
                    new CYNativeReactPackage(),
                    new RNImageViewReactPackage()
            );
        }

        @Override
        protected String getJSMainModuleName() {
            return BuildConfig.ENTRY_FILE_NAME.replace(".js", "");
        }
    };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        SoLoader.init(this, /* native exopackage */ false);
//        MobileAds.initialize(this, Constant.ADMOB_APP_ID);
    }
}
