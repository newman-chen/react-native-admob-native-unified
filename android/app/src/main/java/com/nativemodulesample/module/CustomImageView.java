package com.nativemodulesample.module;

import android.content.Context;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.nativemodulesample.R;

public class CustomImageView extends LinearLayout {
    public CustomImageView(Context context) {
        super(context);

        ImageView view = new ImageView(context);
        view.setImageResource(R.mipmap.ic_launcher);
        view.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));

        addView(view);
    }
}
