package com.anue.rn.nativead.module;

import android.content.Context;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.anue.rn.nativead.R;


public class CustomImageView extends LinearLayout {
    public CustomImageView(Context context) {
        super(context);

        ImageView view = new ImageView(context);
        view.setImageResource(R.mipmap.ic_launcher);
        view.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));

        addView(view);
    }
}
