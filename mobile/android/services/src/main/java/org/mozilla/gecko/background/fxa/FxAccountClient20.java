/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.background.fxa;

import android.support.annotation.NonNull;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.mozilla.gecko.background.common.log.Logger;
import org.mozilla.gecko.background.fxa.FxAccountClientException.FxAccountClientMalformedResponseException;
import org.mozilla.gecko.background.fxa.FxAccountClientException.FxAccountClientRemoteException;
import org.mozilla.gecko.fxa.FxAccountConstants;
import org.mozilla.gecko.Locales;
import org.mozilla.gecko.fxa.devices.FxAccountDevice;
import org.mozilla.gecko.sync.ExtendedJSONObject;
import org.mozilla.gecko.sync.Utils;
import org.mozilla.gecko.sync.crypto.HKDF;
import org.mozilla.gecko.sync.net.AuthHeaderProvider;
import org.mozilla.gecko.sync.net.BaseResource;
import org.mozilla.gecko.sync.net.BaseResourceDelegate;
import org.mozilla.gecko.sync.net.HawkAuthHeaderProvider;
import org.mozilla.gecko.sync.net.Resource;
import org.mozilla.gecko.sync.net.SyncResponse;
import org.mozilla.gecko.sync.net.SyncStorageResponse;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.security.GeneralSecurityException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.Executor;

import javax.crypto.Mac;

import ch.boye.httpclientandroidlib.HttpEntity;
import ch.boye.httpclientandroidlib.HttpHeaders;
import ch.boye.httpclientandroidlib.HttpResponse;
import ch.boye.httpclientandroidlib.client.ClientProtocolException;
import ch.boye.httpclientandroidlib.client.methods.HttpRequestBase;
import ch.boye.httpclientandroidlib.impl.client.DefaultHttpClient;

/**
 * An HTTP client for talking to an FxAccount server.
 * <p>
 * <p>
 * The delegate structure used is a little different from the rest of the code
 * base. We add a <code>RequestDelegate</code> layer that processes a typed
 * value extracted from the body of a successful response.
 */
public class FxAccountClient20 implements FxAccountClient {
  protected static final String LOG_TAG = FxAccountClient20.class.getSimpleName();

  protected static final String ACCEPT_HEADER = "application/json;charset=utf-8";

  public static final String JSON_KEY_EMAIL = "email";
  public static final String JSON_KEY_KEYFETCHTOKEN = "keyFetchToken";
  public static final String JSON_KEY_SESSIONTOKEN = "sessionToken";
  public static final String JSON_KEY_UID = "uid";
  public static final String JSON_KEY_VERIFIED = "verified";
  public static final String JSON_KEY_ERROR = "error";
  public static final String JSON_KEY_MESSAGE = "message";
  public static final String JSON_KEY_INFO = "info";
  public static final String JSON_KEY_CODE = "code";
  public static final String JSON_KEY_ERRNO = "errno";
  public static final String JSON_KEY_EXISTS = "exists";

  protected static final String[] requiredErrorStringFields = { JSON_KEY_ERROR, JSON_KEY_MESSAGE, JSON_KEY_INFO };
  protected static final String[] requiredErrorLongFields = { JSON_KEY_CODE, JSON_KEY_ERRNO };

  /**
   * The server's URI.
   * <p>
   * We assume throughout that this ends with a trailing slash (and guarantee as
   * much in the constructor).
   */
  protected final String serverURI;

  protected final Executor executor;

  public FxAccountClient20(String serverURI, Executor executor) {
    if (serverURI == null) {
      throw new IllegalArgumentException("Must provide a server URI.");
    }
    if (executor == null) {
      throw new IllegalArgumentException("Must provide a non-null executor.");
    }
    this.serverURI = serverURI.endsWith("/") ? serverURI : serverURI + "/";
    if (!this.serverURI.endsWith("/")) {
      throw new IllegalArgumentException("Constructed serverURI must end with a trailing slash: " + this.serverURI);
    }
    this.executor = executor;
  }

  protected BaseResource getBaseResource(String path, Map<String, String> queryParameters) throws UnsupportedEncodingException, URISyntaxException {
    if (queryParameters == null || queryParameters.isEmpty()) {
      return getBaseResource(path);
    }
    final String[] array = new String[2 * queryParameters.size()];
    int i = 0;
    for (Entry<String, String> entry : queryParameters.entrySet()) {
      array[i++] = entry.getKey();
      array[i++] = entry.getValue();
    }
    return getBaseResource(path, array);
  }

  /**
   * Create <code>BaseResource</code>, encoding query parameters carefully.
   * <p>
   * This is equivalent to <code>android.net.Uri.Builder</code>, which is not
   * present in our JUnit 4 tests.
   *
   * @param path fragment.
   * @param queryParameters list of key/value query parameter pairs.  Must be even length!
   * @return <code>BaseResource<instance>
   * @throws URISyntaxException
   * @throws UnsupportedEncodingException
   */
  protected BaseResource getBaseResource(String path, String... queryParameters) throws URISyntaxException, UnsupportedEncodingException {
    final StringBuilder sb = new StringBuilder(serverURI);
    sb.append(path);
    if (queryParameters != null) {
      int i = 0;
      while (i < queryParameters.length) {
        sb.append(i > 0 ? "&" : "?");
        final String key = queryParameters[i++];
        final String val = queryParameters[i++];
        sb.append(URLEncoder.encode(key, "UTF-8"));
        sb.append("=");
        sb.append(URLEncoder.encode(val, "UTF-8"));
      }
    }
    return new BaseResource(new URI(sb.toString()));
  }

  /**
   * Process a typed value extracted from a successful response (in an
   * endpoint-dependent way).
   */
  public interface RequestDelegate<T> {
    public void handleError(Exception e);
    public void handleFailure(FxAccountClientRemoteException e);
    public void handleSuccess(T result);
  }

  /**
   * Thin container for two cryptographic keys.
   */
  public static class TwoKeys {
    public final byte[] kA;
    public final byte[] wrapkB;
    public TwoKeys(byte[] kA, byte[] wrapkB) {
      this.kA = kA;
      this.wrapkB = wrapkB;
    }
  }

  protected <T> void invokeHandleError(final RequestDelegate<T> delegate, final Exception e) {
    executor.execute(new Runnable() {
      @Override
      public void run() {
        delegate.handleError(e);
      }
    });
  }

  enum ResponseType {
    JSON_ARRAY,
    JSON_OBJECT
  }

  /**
   * Translate resource callbacks into request callbacks invoked on the provided
   * executor.
   * <p>
   * Override <code>handleSuccess</code> to parse the body of the resource
   * request and call the request callback. <code>handleSuccess</code> is
   * invoked via the executor, so you don't need to delegate further.
   */
  protected abstract class ResourceDelegate<T> extends BaseResourceDelegate {

    protected void handleSuccess(final int status, HttpResponse response, final ExtendedJSONObject body) throws Exception {
      throw new UnsupportedOperationException();
    }

    protected void handleSuccess(final int status, HttpResponse response, final JSONArray body) throws Exception {
      throw new UnsupportedOperationException();
    }

    protected final RequestDelegate<T> delegate;

    protected final byte[] tokenId;
    protected final byte[] reqHMACKey;
    protected final SkewHandler skewHandler;
    protected final ResponseType responseType;

    /**
     * Create a delegate for an un-authenticated resource.
     */
    public ResourceDelegate(final Resource resource, final RequestDelegate<T> delegate, ResponseType responseType) {
      this(resource, delegate, responseType, null, null);
    }

    /**
     * Create a delegate for a Hawk-authenticated resource.
     * <p>
     * Every Hawk request that encloses an entity (PATCH, POST, and PUT) will
     * include the payload verification hash.
     */
    public ResourceDelegate(final Resource resource, final RequestDelegate<T> delegate, ResponseType responseType, final byte[] tokenId, final byte[] reqHMACKey) {
      super(resource);
      this.delegate = delegate;
      this.reqHMACKey = reqHMACKey;
      this.tokenId = tokenId;
      this.skewHandler = SkewHandler.getSkewHandlerForResource(resource);
      this.responseType = responseType;
    }

    @Override
    public AuthHeaderProvider getAuthHeaderProvider() {
      if (tokenId != null && reqHMACKey != null) {
        // We always include the payload verification hash for FxA Hawk-authenticated requests.
        final boolean includePayloadVerificationHash = true;
        return new HawkAuthHeaderProvider(Utils.byte2Hex(tokenId), reqHMACKey, includePayloadVerificationHash, skewHandler.getSkewInSeconds());
      }
      return super.getAuthHeaderProvider();
    }

    @Override
    public String getUserAgent() {
      return FxAccountConstants.USER_AGENT;
    }

    @Override
    public void handleHttpResponse(HttpResponse response) {
      try {
        final int status = validateResponse(response);
        skewHandler.updateSkew(response, now());
        invokeHandleSuccess(status, response);
      } catch (FxAccountClientRemoteException e) {
        if (!skewHandler.updateSkew(response, now())) {
          // If we couldn't update skew, but we got a failure, let's try clearing the skew.
          skewHandler.resetSkew();
        }
        invokeHandleFailure(e);
      }
    }

    protected void invokeHandleFailure(final FxAccountClientRemoteException e) {
      executor.execute(new Runnable() {
        @Override
        public void run() {
          delegate.handleFailure(e);
        }
      });
    }

    protected void invokeHandleSuccess(final int status, final HttpResponse response) {
      executor.execute(new Runnable() {
        @Override
        public void run() {
          try {
            SyncResponse syncResponse = new SyncResponse(response);
            if (responseType == ResponseType.JSON_ARRAY) {
              JSONArray body = syncResponse.jsonArrayBody();
              ResourceDelegate.this.handleSuccess(status, response, body);
            } else {
              ExtendedJSONObject body = syncResponse.jsonObjectBody();
              ResourceDelegate.this.handleSuccess(status, response, body);
            }
          } catch (Exception e) {
            delegate.handleError(e);
          }
        }
      });
    }

    @Override
    public void handleHttpProtocolException(final ClientProtocolException e) {
      invokeHandleError(delegate, e);
    }

    @Override
    public void handleHttpIOException(IOException e) {
      invokeHandleError(delegate, e);
    }

    @Override
    public void handleTransportException(GeneralSecurityException e) {
      invokeHandleError(delegate, e);
    }

    @Override
    public void addHeaders(HttpRequestBase request, DefaultHttpClient client) {
      super.addHeaders(request, client);

      // The basics.
      final Locale locale = Locale.getDefault();
      request.addHeader(HttpHeaders.ACCEPT_LANGUAGE, Locales.getLanguageTag(locale));
      request.addHeader(HttpHeaders.ACCEPT, ACCEPT_HEADER);
    }
  }

  protected <T> void post(BaseResource resource, final ExtendedJSONObject requestBody) {
    if (requestBody == null) {
      resource.post((HttpEntity) null);
    } else {
      resource.post(requestBody);
    }
  }

  @SuppressWarnings("static-method")
  public long now() {
    return System.currentTimeMillis();
  }

  /**
   * Intepret a response from the auth server.
   * <p>
   * Throw an appropriate exception on errors; otherwise, return the response's
   * status code.
   *
   * @return response's HTTP status code.
   * @throws FxAccountClientException
   */
  public static int validateResponse(HttpResponse response) throws FxAccountClientRemoteException {
    final int status = response.getStatusLine().getStatusCode();
    if (status == 200) {
      return status;
    }
    int code;
    int errno;
    String error;
    String message;
    String info;
    ExtendedJSONObject body;
    try {
      body = new SyncStorageResponse(response).jsonObjectBody();
      body.throwIfFieldsMissingOrMisTyped(requiredErrorStringFields, String.class);
      body.throwIfFieldsMissingOrMisTyped(requiredErrorLongFields, Long.class);
      code = body.getLong(JSON_KEY_CODE).intValue();
      errno = body.getLong(JSON_KEY_ERRNO).intValue();
      error = body.getString(JSON_KEY_ERROR);
      message = body.getString(JSON_KEY_MESSAGE);
      info = body.getString(JSON_KEY_INFO);
    } catch (Exception e) {
      throw new FxAccountClientMalformedResponseException(response);
    }
    throw new FxAccountClientRemoteException(response, code, errno, error, message, info, body);
  }

  /**
   * Don't call this directly. Use <code>unbundleBody</code> instead.
   */
  protected void unbundleBytes(byte[] bundleBytes, byte[] respHMACKey, byte[] respXORKey, byte[]... rest)
      throws InvalidKeyException, NoSuchAlgorithmException, FxAccountClientException {
    if (bundleBytes.length < 32) {
      throw new IllegalArgumentException("input bundle must include HMAC");
    }
    int len = respXORKey.length;
    if (bundleBytes.length != len + 32) {
      throw new IllegalArgumentException("input bundle and XOR key with HMAC have different lengths");
    }
    int left = len;
    for (byte[] array : rest) {
      left -= array.length;
    }
    if (left != 0) {
      throw new IllegalArgumentException("XOR key and total output arrays have different lengths");
    }

    byte[] ciphertext = new byte[len];
    byte[] HMAC = new byte[32];
    System.arraycopy(bundleBytes, 0, ciphertext, 0, len);
    System.arraycopy(bundleBytes, len, HMAC, 0, 32);

    Mac hmacHasher = HKDF.makeHMACHasher(respHMACKey);
    byte[] computedHMAC = hmacHasher.doFinal(ciphertext);
    if (!Arrays.equals(computedHMAC, HMAC)) {
      throw new FxAccountClientException("Bad message HMAC");
    }

    int offset = 0;
    for (byte[] array : rest) {
      for (int i = 0; i < array.length; i++) {
        array[i] = (byte) (respXORKey[offset + i] ^ ciphertext[offset + i]);
      }
      offset += array.length;
    }
  }

  protected void unbundleBody(ExtendedJSONObject body, byte[] requestKey, byte[] ctxInfo, byte[]... rest) throws Exception {
    int length = 0;
    for (byte[] array : rest) {
      length += array.length;
    }

    if (body == null) {
      throw new FxAccountClientException("body must be non-null");
    }
    String bundle = body.getString("bundle");
    if (bundle == null) {
      throw new FxAccountClientException("bundle must be a non-null string");
    }
    byte[] bundleBytes = Utils.hex2Byte(bundle);

    final byte[] respHMACKey = new byte[32];
    final byte[] respXORKey = new byte[length];
    HKDF.deriveMany(requestKey, new byte[0], ctxInfo, respHMACKey, respXORKey);
    unbundleBytes(bundleBytes, respHMACKey, respXORKey, rest);
  }

  public void keys(byte[] keyFetchToken, final RequestDelegate<TwoKeys> delegate) {
    final byte[] tokenId = new byte[32];
    final byte[] reqHMACKey = new byte[32];
    final byte[] requestKey = new byte[32];
    try {
      HKDF.deriveMany(keyFetchToken, new byte[0], FxAccountUtils.KW("keyFetchToken"), tokenId, reqHMACKey, requestKey);
    } catch (Exception e) {
      invokeHandleError(delegate, e);
      return;
    }

    BaseResource resource;
    try {
      resource = getBaseResource("account/keys");
    } catch (URISyntaxException | UnsupportedEncodingException e) {
      invokeHandleError(delegate, e);
      return;
    }

    resource.delegate = new ResourceDelegate<TwoKeys>(resource, delegate, ResponseType.JSON_OBJECT, tokenId, reqHMACKey) {
      @Override
      public void handleSuccess(int status, HttpResponse response, ExtendedJSONObject body) throws Exception {
        byte[] kA = new byte[FxAccountUtils.CRYPTO_KEY_LENGTH_BYTES];
        byte[] wrapkB = new byte[FxAccountUtils.CRYPTO_KEY_LENGTH_BYTES];
        unbundleBody(body, requestKey, FxAccountUtils.KW("account/keys"), kA, wrapkB);
        delegate.handleSuccess(new TwoKeys(kA, wrapkB));
      }
    };
    resource.get();
  }

  /**
   * Thin container for account status response.
   */
  public static class AccountStatusResponse {
    public final boolean exists;
    public AccountStatusResponse(boolean exists) {
      this.exists = exists;
    }
  }

  /**
   * Query the account status of an account given a uid.
   *
   * @param uid to query.
   * @param delegate to invoke callbacks.
   */
  public void accountStatus(String uid, final RequestDelegate<AccountStatusResponse> delegate) {
    final BaseResource resource;
    try {
      final Map<String, String> params = new HashMap<>(1);
      params.put("uid", uid);
      resource = getBaseResource("account/status", params);
    } catch (URISyntaxException | UnsupportedEncodingException e) {
      invokeHandleError(delegate, e);
      return;
    }

    resource.delegate = new ResourceDelegate<AccountStatusResponse>(resource, delegate, ResponseType.JSON_OBJECT) {
      @Override
      public void handleSuccess(int status, HttpResponse response, ExtendedJSONObject body) throws Exception {
        boolean exists = body.getBoolean(JSON_KEY_EXISTS);
        delegate.handleSuccess(new AccountStatusResponse(exists));
      }
    };
    resource.get();
  }

  /**
   * Thin container for recovery email status response.
   */
  public static class RecoveryEmailStatusResponse {
    public final String email;
    public final boolean verified;
    public RecoveryEmailStatusResponse(String email, boolean verified) {
      this.email = email;
      this.verified = verified;
    }
  }

  /**
   * Query the recovery email status of an account given a valid session token.
   * <p>
   * This API is a little odd: the auth server returns the email and
   * verification state of the account that corresponds to the (opaque) session
   * token. It might fail if the session token is unknown (or invalid, or
   * revoked).
   *
   * @param sessionToken
   *          to query.
   * @param delegate
   *          to invoke callbacks.
   */
  public void recoveryEmailStatus(byte[] sessionToken, final RequestDelegate<RecoveryEmailStatusResponse> delegate) {
    final byte[] tokenId = new byte[32];
    final byte[] reqHMACKey = new byte[32];
    final byte[] requestKey = new byte[32];
    try {
      HKDF.deriveMany(sessionToken, new byte[0], FxAccountUtils.KW("sessionToken"), tokenId, reqHMACKey, requestKey);
    } catch (Exception e) {
      invokeHandleError(delegate, e);
      return;
    }

    BaseResource resource;
    try {
      resource = getBaseResource("recovery_email/status");
    } catch (URISyntaxException | UnsupportedEncodingException e) {
      invokeHandleError(delegate, e);
      return;
    }

    resource.delegate = new ResourceDelegate<RecoveryEmailStatusResponse>(resource, delegate, ResponseType.JSON_OBJECT, tokenId, reqHMACKey) {
      @Override
      public void handleSuccess(int status, HttpResponse response, ExtendedJSONObject body) throws Exception {
        String[] requiredStringFields = new String[] { JSON_KEY_EMAIL };
        body.throwIfFieldsMissingOrMisTyped(requiredStringFields, String.class);
        String email = body.getString(JSON_KEY_EMAIL);
        Boolean verified = body.getBoolean(JSON_KEY_VERIFIED);
        delegate.handleSuccess(new RecoveryEmailStatusResponse(email, verified));
      }
    };
    resource.get();
  }

  @SuppressWarnings("unchecked")
  public void sign(final byte[] sessionToken, final ExtendedJSONObject publicKey, long durationInMilliseconds, final RequestDelegate<String> delegate) {
    final ExtendedJSONObject body = new ExtendedJSONObject();
    body.put("publicKey", publicKey);
    body.put("duration", durationInMilliseconds);

    final byte[] tokenId = new byte[32];
    final byte[] reqHMACKey = new byte[32];
    try {
      HKDF.deriveMany(sessionToken, new byte[0], FxAccountUtils.KW("sessionToken"), tokenId, reqHMACKey);
    } catch (Exception e) {
      invokeHandleError(delegate, e);
      return;
    }

    BaseResource resource;
    try {
      resource = getBaseResource("certificate/sign");
    } catch (URISyntaxException | UnsupportedEncodingException e) {
      invokeHandleError(delegate, e);
      return;
    }

    resource.delegate = new ResourceDelegate<String>(resource, delegate, ResponseType.JSON_OBJECT, tokenId, reqHMACKey) {
      @Override
      public void handleSuccess(int status, HttpResponse response, ExtendedJSONObject body) throws Exception {
        String cert = body.getString("cert");
        if (cert == null) {
          delegate.handleError(new FxAccountClientException("cert must be a non-null string"));
          return;
        }
        delegate.handleSuccess(cert);
      }
    };
    post(resource, body);
  }

  protected static final String[] LOGIN_RESPONSE_REQUIRED_STRING_FIELDS = new String[] { JSON_KEY_UID, JSON_KEY_SESSIONTOKEN };
  protected static final String[] LOGIN_RESPONSE_REQUIRED_STRING_FIELDS_KEYS = new String[] { JSON_KEY_UID, JSON_KEY_SESSIONTOKEN, JSON_KEY_KEYFETCHTOKEN, };
  protected static final String[] LOGIN_RESPONSE_REQUIRED_BOOLEAN_FIELDS = new String[] { JSON_KEY_VERIFIED };

  /**
   * Thin container for login response.
   * <p>
   * The <code>remoteEmail</code> field is the email address as normalized by the
   * server, and is <b>not necessarily</b> the email address delivered to the
   * <code>login</code> or <code>create</code> call.
   */
  public static class LoginResponse {
    public final String remoteEmail;
    public final String uid;
    public final byte[] sessionToken;
    public final boolean verified;
    public final byte[] keyFetchToken;

    public LoginResponse(String remoteEmail, String uid, boolean verified, byte[] sessionToken, byte[] keyFetchToken) {
      this.remoteEmail = remoteEmail;
      this.uid = uid;
      this.verified = verified;
      this.sessionToken = sessionToken;
      this.keyFetchToken = keyFetchToken;
    }
  }

  // Public for testing only; prefer login and loginAndGetKeys (without boolean parameter).
  public void login(final byte[] emailUTF8, final byte[] quickStretchedPW, final boolean getKeys,
                    final Map<String, String> queryParameters,
                    final RequestDelegate<LoginResponse> delegate) {
    final BaseResource resource;
    final ExtendedJSONObject body;
    try {
      final String path = "account/login";
      final Map<String, String> modifiedParameters = new HashMap<>();
      if (queryParameters != null) {
        modifiedParameters.putAll(queryParameters);
      }
      if (getKeys) {
        modifiedParameters.put("keys", "true");
      }
      resource = getBaseResource(path, modifiedParameters);
      body = new FxAccount20LoginDelegate(emailUTF8, quickStretchedPW).getCreateBody();
    } catch (Exception e) {
      invokeHandleError(delegate, e);
      return;
    }

    resource.delegate = new ResourceDelegate<LoginResponse>(resource, delegate, ResponseType.JSON_OBJECT) {
      @Override
      public void handleSuccess(int status, HttpResponse response,  ExtendedJSONObject body) throws Exception {
        final String[] requiredStringFields = getKeys ? LOGIN_RESPONSE_REQUIRED_STRING_FIELDS_KEYS : LOGIN_RESPONSE_REQUIRED_STRING_FIELDS;
        body.throwIfFieldsMissingOrMisTyped(requiredStringFields, String.class);

        final String[] requiredBooleanFields = LOGIN_RESPONSE_REQUIRED_BOOLEAN_FIELDS;
        body.throwIfFieldsMissingOrMisTyped(requiredBooleanFields, Boolean.class);

        String uid = body.getString(JSON_KEY_UID);
        boolean verified = body.getBoolean(JSON_KEY_VERIFIED);
        byte[] sessionToken = Utils.hex2Byte(body.getString(JSON_KEY_SESSIONTOKEN));
        byte[] keyFetchToken = null;
        if (getKeys) {
          keyFetchToken = Utils.hex2Byte(body.getString(JSON_KEY_KEYFETCHTOKEN));
        }
        LoginResponse loginResponse = new LoginResponse(new String(emailUTF8, "UTF-8"), uid, verified, sessionToken, keyFetchToken);

        delegate.handleSuccess(loginResponse);
      }
    };

    post(resource, body);
  }

  public void createAccount(final byte[] emailUTF8, final byte[] quickStretchedPW,
                            final boolean getKeys,
                            final boolean preVerified,
                            final Map<String, String> queryParameters,
                            final RequestDelegate<LoginResponse> delegate) {
    final BaseResource resource;
    final ExtendedJSONObject body;
    try {
      final String path = "account/create";
      final Map<String, String> modifiedParameters = new HashMap<>();
      if (queryParameters != null) {
        modifiedParameters.putAll(queryParameters);
      }
      if (getKeys) {
        modifiedParameters.put("keys", "true");
      }
      resource = getBaseResource(path, modifiedParameters);
      body = new FxAccount20CreateDelegate(emailUTF8, quickStretchedPW, preVerified).getCreateBody();
    } catch (Exception e) {
      invokeHandleError(delegate, e);
      return;
    }

    // This is very similar to login, except verified is not required.
    resource.delegate = new ResourceDelegate<LoginResponse>(resource, delegate, ResponseType.JSON_OBJECT) {
      @Override
      public void handleSuccess(int status, HttpResponse response, ExtendedJSONObject body) throws Exception {
        final String[] requiredStringFields = getKeys ? LOGIN_RESPONSE_REQUIRED_STRING_FIELDS_KEYS : LOGIN_RESPONSE_REQUIRED_STRING_FIELDS;
        body.throwIfFieldsMissingOrMisTyped(requiredStringFields, String.class);

        String uid = body.getString(JSON_KEY_UID);
        boolean verified = false; // In production, we're definitely not verified immediately upon creation.
        Boolean tempVerified = body.getBoolean(JSON_KEY_VERIFIED);
        if (tempVerified != null) {
          verified = tempVerified;
        }
        byte[] sessionToken = Utils.hex2Byte(body.getString(JSON_KEY_SESSIONTOKEN));
        byte[] keyFetchToken = null;
        if (getKeys) {
          keyFetchToken = Utils.hex2Byte(body.getString(JSON_KEY_KEYFETCHTOKEN));
        }
        LoginResponse loginResponse = new LoginResponse(new String(emailUTF8, "UTF-8"), uid, verified, sessionToken, keyFetchToken);

        delegate.handleSuccess(loginResponse);
      }
    };

    post(resource, body);
  }

  /**
   * We want users to be able to enter their email address case-insensitively.
   * We stretch the password locally using the email address as a salt, to make
   * dictionary attacks more expensive. This means that a client with a
   * case-differing email address is unable to produce the correct
   * authorization, even though it knows the password. In this case, the server
   * returns the email that the account was created with, so that the client can
   * re-stretch the password locally with the correct email salt. This version
   * of <code>login</code> retries at most one time with a server provided email
   * address.
   * <p>
   * Be aware that consumers will not see the initial error response from the
   * server providing an alternate email (if there is one).
   *
   * @param emailUTF8
   *          user entered email address.
   * @param stretcher
   *          delegate to stretch and re-stretch password.
   * @param getKeys
   *          true if a <code>keyFetchToken</code> should be returned (in
   *          addition to the standard <code>sessionToken</code>).
   * @param queryParameters
   * @param delegate
   *          to invoke callbacks.
   */
  public void login(final byte[] emailUTF8, final PasswordStretcher stretcher, final boolean getKeys,
                    final Map<String, String> queryParameters,
                    final RequestDelegate<LoginResponse> delegate) {
    byte[] quickStretchedPW;
    try {
      FxAccountUtils.pii(LOG_TAG, "Trying user provided email: '" + new String(emailUTF8, "UTF-8") + "'" );
      quickStretchedPW = stretcher.getQuickStretchedPW(emailUTF8);
    } catch (Exception e) {
      delegate.handleError(e);
      return;
    }

    this.login(emailUTF8, quickStretchedPW, getKeys, queryParameters, new RequestDelegate<LoginResponse>() {
      @Override
      public void handleSuccess(LoginResponse result) {
        delegate.handleSuccess(result);
      }

      @Override
      public void handleError(Exception e) {
        delegate.handleError(e);
      }

      @Override
      public void handleFailure(FxAccountClientRemoteException e) {
        String alternateEmail = e.body.getString(JSON_KEY_EMAIL);
        if (!e.isBadEmailCase() || alternateEmail == null) {
          delegate.handleFailure(e);
          return;
        };

        Logger.info(LOG_TAG, "Server returned alternate email; retrying login with provided email.");
        FxAccountUtils.pii(LOG_TAG, "Trying server provided email: '" + alternateEmail + "'" );

        try {
          // Nota bene: this is not recursive, since we call the fixed password
          // signature here, which invokes a non-retrying version.
          byte[] alternateEmailUTF8 = alternateEmail.getBytes("UTF-8");
          byte[] alternateQuickStretchedPW = stretcher.getQuickStretchedPW(alternateEmailUTF8);
          login(alternateEmailUTF8, alternateQuickStretchedPW, getKeys, queryParameters, delegate);
        } catch (Exception innerException) {
          delegate.handleError(innerException);
          return;
        }
      }
    });
  }

  /**
   * Registers a device given a valid session token.
   *
   * @param sessionToken to query.
   * @param delegate to invoke callbacks.
   */
  @Override
  public void registerOrUpdateDevice(byte[] sessionToken, FxAccountDevice device, RequestDelegate<FxAccountDevice> delegate) {
    final byte[] tokenId = new byte[32];
    final byte[] reqHMACKey = new byte[32];
    final byte[] requestKey = new byte[32];
    try {
      HKDF.deriveMany(sessionToken, new byte[0], FxAccountUtils.KW("sessionToken"), tokenId, reqHMACKey, requestKey);
    } catch (Exception e) {
      invokeHandleError(delegate, e);
      return;
    }

    final BaseResource resource;
    final ExtendedJSONObject body;
    try {
      resource = getBaseResource("account/device");
      body = device.toJson();
    } catch (URISyntaxException | UnsupportedEncodingException e) {
      invokeHandleError(delegate, e);
      return;
    }

    resource.delegate = new ResourceDelegate<FxAccountDevice>(resource, delegate, ResponseType.JSON_OBJECT, tokenId, reqHMACKey) {
      @Override
      public void handleSuccess(int status, HttpResponse response, ExtendedJSONObject body) {
        try {
          delegate.handleSuccess(FxAccountDevice.fromJson(body));
        } catch (Exception e) {
          delegate.handleError(e);
        }
      }
    };

    post(resource, body);
  }

  @Override
  public void destroyDevice(byte[] sessionToken, String deviceId, RequestDelegate<ExtendedJSONObject> delegate) {
    final byte[] tokenId = new byte[32];
    final byte[] reqHMACKey = new byte[32];
    final byte[] requestKey = new byte[32];
    try {
      HKDF.deriveMany(sessionToken, new byte[0], FxAccountUtils.KW("sessionToken"), tokenId, reqHMACKey, requestKey);
    } catch (Exception e) {
      invokeHandleError(delegate, e);
      return;
    }

    final BaseResource resource;
    final ExtendedJSONObject body = new ExtendedJSONObject();
    body.put("id", deviceId);
    try {
      resource = getBaseResource("account/device/destroy");
    } catch (URISyntaxException | UnsupportedEncodingException e) {
      invokeHandleError(delegate, e);
      return;
    }

    resource.delegate = new ResourceDelegate<ExtendedJSONObject>(resource, delegate, ResponseType.JSON_OBJECT, tokenId, reqHMACKey) {
      @Override
      public void handleSuccess(int status, HttpResponse response, ExtendedJSONObject body) {
        try {
          delegate.handleSuccess(body);
        } catch (Exception e) {
          delegate.handleError(e);
        }
      }
    };

    post(resource, body);
  }

  @Override
  public void deviceList(byte[] sessionToken, RequestDelegate<FxAccountDevice[]> delegate) {
    final byte[] tokenId = new byte[32];
    final byte[] reqHMACKey = new byte[32];
    final byte[] requestKey = new byte[32];
    try {
      HKDF.deriveMany(sessionToken, new byte[0], FxAccountUtils.KW("sessionToken"), tokenId, reqHMACKey, requestKey);
    } catch (Exception e) {
      invokeHandleError(delegate, e);
      return;
    }

    final BaseResource resource;
    try {
      resource = getBaseResource("account/devices");
    } catch (URISyntaxException | UnsupportedEncodingException e) {
      invokeHandleError(delegate, e);
      return;
    }

    resource.delegate = new ResourceDelegate<FxAccountDevice[]>(resource, delegate, ResponseType.JSON_ARRAY, tokenId, reqHMACKey) {
      @Override
      public void handleSuccess(int status, HttpResponse response, JSONArray devicesJson) {
        try {
          FxAccountDevice[] devices = new FxAccountDevice[devicesJson.size()];
          for (int i = 0; i < devices.length; i++) {
            ExtendedJSONObject deviceJson = new ExtendedJSONObject((JSONObject) devicesJson.get(i));
            devices[i] = FxAccountDevice.fromJson(deviceJson);
          }
          delegate.handleSuccess(devices);
        } catch (Exception e) {
          delegate.handleError(e);
        }
      }
    };

    resource.get();
  }

  @Override
  public void notifyDevices(@NonNull byte[] sessionToken, @NonNull List<String> deviceIds, ExtendedJSONObject payload, Long TTL, RequestDelegate<ExtendedJSONObject> delegate) {
    final byte[] tokenId = new byte[32];
    final byte[] reqHMACKey = new byte[32];
    final byte[] requestKey = new byte[32];
    try {
      HKDF.deriveMany(sessionToken, new byte[0], FxAccountUtils.KW("sessionToken"), tokenId, reqHMACKey, requestKey);
    } catch (Exception e) {
      invokeHandleError(delegate, e);
      return;
    }

    final BaseResource resource;
    final ExtendedJSONObject body = createNotifyDevicesBody(deviceIds, payload, TTL);
    try {
      resource = getBaseResource("account/devices/notify");
    } catch (URISyntaxException | UnsupportedEncodingException e) {
      invokeHandleError(delegate, e);
      return;
    }

    resource.delegate = new ResourceDelegate<ExtendedJSONObject>(resource, delegate, ResponseType.JSON_OBJECT, tokenId, reqHMACKey) {
      @Override
      public void handleSuccess(int status, HttpResponse response, ExtendedJSONObject body) {
        try {
          delegate.handleSuccess(body);
        } catch (Exception e) {
          delegate.handleError(e);
        }
      }
    };

    post(resource, body);
  }

  @NonNull
  @SuppressWarnings("unchecked")
  private ExtendedJSONObject createNotifyDevicesBody(@NonNull List<String> deviceIds, ExtendedJSONObject payload, Long TTL) {
    final ExtendedJSONObject body = new ExtendedJSONObject();
    final JSONArray to = new JSONArray();
    to.addAll(deviceIds);
    body.put("to", to);
    if (payload != null) {
      body.put("payload", payload);
    }
    if (TTL != null) {
      body.put("TTL", TTL);
    }
    return body;
  }
}
