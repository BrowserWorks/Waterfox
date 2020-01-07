/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.activitystream.homepanel.stream;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.view.View;
import android.widget.TextView;

import org.mozilla.gecko.GeckoSharedPrefs;
import org.mozilla.gecko.R;
import org.mozilla.gecko.Telemetry;
import org.mozilla.gecko.TelemetryContract;
import org.mozilla.gecko.activitystream.homepanel.ActivityStreamPanel;
import org.mozilla.gecko.fxa.FxAccountConstants;
import org.mozilla.gecko.fxa.activities.FxAccountWebFlowActivity;


public class FxaBannerRow extends StreamViewHolder {

    public static final @LayoutRes int LAYOUT_ID = R.layout.activity_stream_fxa_banner;

    @SuppressLint("ApplySharedPref")
    public FxaBannerRow(View itemView) {
        super(itemView);

        final View signUpButton = itemView.findViewById(R.id.banner_sign_up);
        signUpButton.setOnClickListener(v -> {
            Telemetry.sendUIEvent(TelemetryContract.Event.ACTION, TelemetryContract.Method.BUTTON, "awesomescreen-signup");

            final Intent intent = new Intent(FxAccountConstants.ACTION_FXA_SIGN_UP);
            intent.putExtra(FxAccountWebFlowActivity.EXTRA_ENDPOINT, FxAccountConstants.ENDPOINT_AWESOMESCREEN_SIGNUP);
            intent.setFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
            itemView.getContext().startActivity(intent);
        });

        final TextView signInButton = itemView.findViewById(R.id.banner_sign_in);
        final String signInPrompt = itemView.getContext().getString(R.string.activity_stream_signin_prompt);
        final String signInPromptButton = itemView.getContext().getString(R.string.activity_stream_signin_prompt_button);
        final String signInText = signInPrompt + " " + signInPromptButton;
        SpannableString spannableString = new SpannableString(signInText);
        ClickableSpan signInClick = new ClickableSpan() {
            @Override
            public void onClick(@NonNull View view) {
                Telemetry.sendUIEvent(TelemetryContract.Event.ACTION, TelemetryContract.Method.BUTTON, "awesomescreen-signin");

                final Intent intent = new Intent(FxAccountConstants.ACTION_FXA_GET_STARTED);
                intent.putExtra(FxAccountWebFlowActivity.EXTRA_ENDPOINT, FxAccountConstants.ENDPOINT_AWESOMESCREEN_SIGNIN);
                intent.setFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
                view.getContext().startActivity(intent);
            }
        };
        spannableString.setSpan(signInClick, signInPrompt.length() + 1, signInText.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        signInButton.setText(spannableString);
        signInButton.setMovementMethod(LinkMovementMethod.getInstance());
        signInButton.setHighlightColor(Color.BLUE);


        final View dismissButton = itemView.findViewById(R.id.banner_dismiss);
        dismissButton.setOnClickListener(v -> {
            Telemetry.sendUIEvent(TelemetryContract.Event.ACTION, TelemetryContract.Method.BUTTON, "awesomescreen-signup-dismiss");
            final SharedPreferences sharedPreferences = GeckoSharedPrefs.forProfile(itemView.getContext());
            //Note: In ActivityStreamHomeFragment we have a prefs listener for this value.
            //We commit asap in order to reload our recyclerview as soon as the user dismissed the row.
            sharedPreferences.edit().putBoolean(ActivityStreamPanel.PREF_USER_DISMISSED_FXA_BANNER, true).commit();

        });
    }
}
