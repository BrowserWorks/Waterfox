package org.mozilla.geckoview.example.messaging;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;
import org.mozilla.geckoview.GeckoResult;
import org.mozilla.geckoview.GeckoRuntime;
import org.mozilla.geckoview.GeckoRuntimeSettings;
import org.mozilla.geckoview.GeckoSession;
import org.mozilla.geckoview.GeckoView;
import org.mozilla.geckoview.WebExtension;

public class MainActivity extends AppCompatActivity {
    private static GeckoRuntime sRuntime;

    private static final String EXTENSION_LOCATION = "resource://android/assets/messaging/";
    private static final String EXTENSION_ID = "messaging@example.com";
    // If you make changes to the extension you need to update this
    private static final String EXTENSION_VERSION = "1.0";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        GeckoView view = findViewById(R.id.geckoview);
        GeckoSession session = new GeckoSession();

        if (sRuntime == null) {
            GeckoRuntimeSettings settings = new GeckoRuntimeSettings.Builder()
                    .remoteDebuggingEnabled(true)
                    .build();
            sRuntime = GeckoRuntime.create(this, settings);
        }

        WebExtension.MessageDelegate messageDelegate = new WebExtension.MessageDelegate() {
            @Nullable
            @Override
            public GeckoResult<Object> onMessage(final @NonNull String nativeApp,
                                                 final @NonNull Object message,
                                                 final @NonNull WebExtension.MessageSender sender) {
                if (message instanceof JSONObject) {
                    JSONObject json = (JSONObject) message;
                    try {
                        if (json.has("type") && "WPAManifest".equals(json.getString("type"))) {
                            JSONObject manifest = json.getJSONObject("manifest");
                            Log.d("MessageDelegate", "Found WPA manifest: " + manifest);
                        }
                    } catch (JSONException ex) {
                        Log.e("MessageDelegate", "Invalid manifest", ex);
                    }
                }
                return null;
            }
        };

        // Let's check if the extension is already installed first
        sRuntime.getWebExtensionController().list().then(extensionList -> {
            for (WebExtension extension : extensionList) {
                if (extension.id.equals(EXTENSION_ID)
                        && extension.metaData.version.equals(EXTENSION_VERSION)) {
                    // Extension already installed, no need to install it again
                    return GeckoResult.fromValue(extension);
                }
            }

            // Install if it's not already installed.
            return sRuntime.getWebExtensionController().installBuiltIn(EXTENSION_LOCATION);
        }).accept(
                // Set delegate that will receive messages coming from this extension.
                extension -> session.getWebExtensionController()
                        .setMessageDelegate(extension, messageDelegate, "browser"),
                // Something bad happened, let's log an error
                e -> Log.e("MessageDelegate", "Error registering extension", e)
        );


        session.open(sRuntime);
        view.setSession(session);
        session.loadUri("https://mobile.twitter.com");
    }
}
