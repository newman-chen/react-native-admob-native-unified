package com.anue.rn.nativead.util;

import android.util.Log;

import com.anue.rn.nativead.BuildConfig;


public class CYLog {

    private static final boolean m_bDebugFlag;
    private static final boolean m_bSecurityFlag; // for security usage, print sensitive data
    private static final String TAG = "CYNativeAdView";

    static {
        m_bDebugFlag = BuildConfig.DEBUG;
        m_bSecurityFlag = false; // FIXME disable by default
    }

    public CYLog() {
    }

    public static void e(String tag, Object... messages) {
        if (m_bDebugFlag) {
            StringBuilder sb = new StringBuilder(getBracketTag(tag));
            if (messages != null) {
                for (Object msg : messages) {
                    sb.append(msg);
                }
            }
            Log.e(TAG, sb.toString());
        }
    }

    public static void e(String tag, String msg, Throwable throwable) {
        if (m_bDebugFlag) {
            Log.e(TAG, getBracketTag(tag) + msg, throwable);
        }
    }

    public static void d(String tag, String msg) {
        if (m_bDebugFlag) {
            Log.d(TAG, getBracketTag(tag) + msg);
        }
    }

    public static void d(String tag, Object... messages) {
        if (m_bDebugFlag) {
            StringBuilder sb = new StringBuilder(getBracketTag(tag));
            if (messages != null) {
                for (Object msg : messages) {
                    sb.append(msg);
                }
            }
            Log.d(TAG, sb.toString());
        }
    }

    public static void w(String tag, Object... messages) {
        if (m_bDebugFlag) {
            StringBuilder sb = new StringBuilder(getBracketTag(tag));
            if (messages != null) {
                for (Object msg : messages) {
                    sb.append(msg);
                }
            }
            Log.w(TAG, sb.toString());
        }
    }

    public static void w(String tag, String message, Throwable throwable) {
        if (m_bDebugFlag) {
            Log.w(TAG, getBracketTag(tag) + message, throwable);
        }
    }

    public static void critical(String tag, Object... messages) {
        if (m_bSecurityFlag) {
            StringBuilder sb = new StringBuilder(getBracketTag(tag));
            if (messages != null) {
                for (Object msg : messages) {
                    sb.append(msg);
                }
            }
            Log.d(TAG, sb.toString());
        }
    }

    private static String getBracketTag(String tag) {
        return "[" + tag + "]";
    }
}