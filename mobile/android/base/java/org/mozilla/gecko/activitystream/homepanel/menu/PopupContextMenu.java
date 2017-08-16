/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package org.mozilla.gecko.activitystream.homepanel.menu;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.support.design.widget.NavigationView;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import org.mozilla.gecko.AppConstants;
import org.mozilla.gecko.R;
import org.mozilla.gecko.activitystream.ActivityStreamTelemetry;
import org.mozilla.gecko.home.HomePager;
import org.mozilla.gecko.activitystream.homepanel.model.Item;

/* package-private */ class PopupContextMenu
        extends ActivityStreamContextMenu {

    private final PopupWindow popupWindow;
    private final NavigationView navigationView;

    private final View anchor;

    public PopupContextMenu(final Context context,
                            View anchor,
                            final ActivityStreamTelemetry.Extras.Builder telemetryExtraBuilder,
                            final MenuMode mode,
                            final Item item,
                            HomePager.OnUrlOpenListener onUrlOpenListener,
                            HomePager.OnUrlOpenInBackgroundListener onUrlOpenInBackgroundListener) {
        super(context,
                telemetryExtraBuilder,
                mode,
                item,
                onUrlOpenListener,
                onUrlOpenInBackgroundListener);

        this.anchor = anchor;

        final LayoutInflater inflater = LayoutInflater.from(context);

        View card = inflater.inflate(R.layout.activity_stream_contextmenu_popupmenu, null);
        navigationView = (NavigationView) card.findViewById(R.id.menu);
        navigationView.setNavigationItemSelectedListener(this);

        popupWindow = new PopupWindow(context);
        popupWindow.setContentView(card);
        popupWindow.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        popupWindow.setFocusable(true);

        // On a variety of devices running Android 4 and 5, PopupWindow is assigned height/width = 0 - we therefore
        // need to manually override that behaviour. There don't appear to be any reported issues
        // with devices running 6 (Marshmallow) or newer, so we should restrict the workaround
        // as much as possible:
        if (AppConstants.Versions.preMarshmallow) {
            popupWindow.setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
            popupWindow.setWidth(ViewGroup.LayoutParams.WRAP_CONTENT);
        }

        super.postInit();
    }

    @Override
    public MenuItem getItemByID(int id) {
        return navigationView.getMenu().findItem(id);
    }

    @Override
    public void show() {
        // By default popupWindow follows the pre-material convention of displaying the popup
        // below a View. We need to shift it over the view:
        popupWindow.showAsDropDown(anchor,
                0,
                -(anchor.getHeight() + anchor.getPaddingBottom()));
    }

    public void dismiss() {
        popupWindow.dismiss();
    }
}
