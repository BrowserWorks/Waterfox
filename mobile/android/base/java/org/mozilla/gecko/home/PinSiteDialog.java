/* -*- Mode: Java; c-basic-offset: 4; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.home;

import java.util.EnumSet;

import org.mozilla.gecko.R;
import org.mozilla.gecko.db.BrowserContract.URLColumns;
import org.mozilla.gecko.db.BrowserDB.FilterFlags;
import org.mozilla.gecko.util.StringUtils;

import android.app.Dialog;
import android.content.Context;
import android.database.Cursor;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.LoaderManager;
import android.support.v4.app.LoaderManager.LoaderCallbacks;
import android.support.v4.content.Loader;
import android.support.v4.widget.CursorAdapter;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;

/**
 * Dialog fragment that displays frecency search results, for pinning a site, in a GridView.
 */
public class PinSiteDialog extends DialogFragment {
    // Listener for url selection
    public static interface OnSiteSelectedListener {
        public void onSiteSelected(String url, String title);
    }

    // Cursor loader ID for search query
    private static final int LOADER_ID_SEARCH = 0;

    // Holds the current search term to use in the query
    private String mSearchTerm;

    // Adapter for the list of search results
    private SearchAdapter mAdapter;

    // Search entry
    private EditText mSearch;

    // Search results
    private ListView mList;

    // Callbacks used for the search loader
    private CursorLoaderCallbacks mLoaderCallbacks;

    // Bookmark selected listener
    private OnSiteSelectedListener mOnSiteSelectedListener;

    public static PinSiteDialog newInstance() {
        return new PinSiteDialog();
    }

    private PinSiteDialog() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setStyle(DialogFragment.STYLE_NO_TITLE, android.R.style.Theme_Holo_Light_Dialog);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // All list views are styled to look the same with a global activity theme.
        // If the style of the list changes, inflate it from an XML.
        return inflater.inflate(R.layout.pin_site_dialog, container, false);
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        mSearch = (EditText) view.findViewById(R.id.search);
        mSearch.addTextChangedListener(new TextWatcher() {
            @Override
            public void afterTextChanged(Editable s) {
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                setSearchTerm(mSearch.getText().toString());
                filter(mSearchTerm);
            }
        });

        mSearch.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (keyCode != KeyEvent.KEYCODE_ENTER || mOnSiteSelectedListener == null) {
                    return false;
                }

                // If the user manually entered a search term or URL, wrap the value in
                // a special URI until we can get a valid URL for this bookmark.
                final String text = mSearch.getText().toString().trim();
                if (!TextUtils.isEmpty(text)) {
                    final String url = StringUtils.encodeUserEnteredUrl(text);
                    mOnSiteSelectedListener.onSiteSelected(url, text);
                    dismiss();
                }

                return true;
            }
        });

        mSearch.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus) {
                    // On rotation, the view gets destroyed and we could be in a race to get the dialog
                    // and window (see bug 1072959).
                    Dialog dialog = getDialog();
                    if (dialog == null) {
                        return;
                    }
                    Window window = dialog.getWindow();
                    if (window == null) {
                        return;
                    }
                    window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
                }
            }
        });

        mList = (HomeListView) view.findViewById(R.id.list);
        mList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (mOnSiteSelectedListener != null) {
                    final Cursor c = mAdapter.getCursor();
                    if (c == null || !c.moveToPosition(position)) {
                        return;
                    }

                    final String url = c.getString(c.getColumnIndexOrThrow(URLColumns.URL));
                    final String title = c.getString(c.getColumnIndexOrThrow(URLColumns.TITLE));
                    mOnSiteSelectedListener.onSiteSelected(url, title);
                }

                // Dismiss the fragment and the dialog.
                dismiss();
            }
        });
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        final LoaderManager manager = getLoaderManager();

        // Initialize the search adapter
        mAdapter = new SearchAdapter(getActivity());
        mList.setAdapter(mAdapter);

        // Create callbacks before the initial loader is started
        mLoaderCallbacks = new CursorLoaderCallbacks();

        // Reconnect to the loader only if present
        manager.initLoader(LOADER_ID_SEARCH, null, mLoaderCallbacks);

        // If there is a search term, put it in the text field
        if (!TextUtils.isEmpty(mSearchTerm)) {
            mSearch.setText(mSearchTerm);
            mSearch.selectAll();
        }

        // Always start with an empty filter
        filter("");
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();

        // Discard any additional site selection as the dialog
        // is getting destroyed (see bug 935542).
        setOnSiteSelectedListener(null);
    }

    public void setSearchTerm(String searchTerm) {
        mSearchTerm = searchTerm;
    }

    private void filter(String searchTerm) {
        // Restart loaders with the new search term
        SearchLoader.restart(getLoaderManager(), LOADER_ID_SEARCH,
                             mLoaderCallbacks, searchTerm,
                             EnumSet.of(FilterFlags.EXCLUDE_PINNED_SITES));
    }

    public void setOnSiteSelectedListener(OnSiteSelectedListener listener) {
        mOnSiteSelectedListener = listener;
    }

    private static class SearchAdapter extends CursorAdapter {
        private final LayoutInflater mInflater;

        public SearchAdapter(Context context) {
            super(context, null, 0);
            mInflater = LayoutInflater.from(context);
        }

        @Override
        public void bindView(View view, Context context, Cursor cursor) {
            TwoLinePageRow row = (TwoLinePageRow) view;
            row.setShowIcons(false);
            row.updateFromCursor(cursor);
        }

        @Override
        public View newView(Context context, Cursor cursor, ViewGroup parent) {
            return (TwoLinePageRow) mInflater.inflate(R.layout.home_item_row, parent, false);
        }
    }

    private class CursorLoaderCallbacks implements LoaderCallbacks<Cursor> {
        @Override
        public Loader<Cursor> onCreateLoader(int id, Bundle args) {
            return SearchLoader.createInstance(getActivity(), args);
        }

        @Override
        public void onLoadFinished(Loader<Cursor> loader, Cursor c) {
            mAdapter.swapCursor(c);
        }

        @Override
        public void onLoaderReset(Loader<Cursor> loader) {
            mAdapter.swapCursor(null);
        }
    }
}
