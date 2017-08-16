/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.sync.stage;

import android.accounts.Account;
import android.content.Context;
import android.os.SystemClock;
import android.support.annotation.NonNull;
import android.text.TextUtils;
import android.util.Log;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.mozilla.gecko.AppConstants;
import org.mozilla.gecko.background.common.log.Logger;
import org.mozilla.gecko.background.fxa.FxAccountClient;
import org.mozilla.gecko.background.fxa.FxAccountClient20;
import org.mozilla.gecko.background.fxa.FxAccountClientException;
import org.mozilla.gecko.fxa.FirefoxAccounts;
import org.mozilla.gecko.fxa.authenticator.AndroidFxAccount;
import org.mozilla.gecko.fxa.login.State;
import org.mozilla.gecko.sync.CommandProcessor;
import org.mozilla.gecko.sync.CommandProcessor.Command;
import org.mozilla.gecko.sync.CryptoRecord;
import org.mozilla.gecko.sync.ExtendedJSONObject;
import org.mozilla.gecko.sync.HTTPFailureException;
import org.mozilla.gecko.sync.NoCollectionKeysSetException;
import org.mozilla.gecko.sync.Utils;
import org.mozilla.gecko.sync.crypto.CryptoException;
import org.mozilla.gecko.sync.crypto.KeyBundle;
import org.mozilla.gecko.sync.delegates.ClientsDataDelegate;
import org.mozilla.gecko.sync.net.AuthHeaderProvider;
import org.mozilla.gecko.sync.net.BaseResource;
import org.mozilla.gecko.sync.net.SyncStorageCollectionRequest;
import org.mozilla.gecko.sync.net.SyncStorageRecordRequest;
import org.mozilla.gecko.sync.net.SyncStorageResponse;
import org.mozilla.gecko.sync.net.WBOCollectionRequestDelegate;
import org.mozilla.gecko.sync.net.WBORequestDelegate;
import org.mozilla.gecko.sync.repositories.NullCursorException;
import org.mozilla.gecko.sync.repositories.android.ClientsDatabaseAccessor;
import org.mozilla.gecko.sync.repositories.android.RepoUtils;
import org.mozilla.gecko.sync.repositories.domain.ClientRecord;
import org.mozilla.gecko.sync.repositories.domain.ClientRecordFactory;
import org.mozilla.gecko.sync.repositories.domain.VersionConstants;
import org.mozilla.gecko.sync.telemetry.TelemetryCollector;

import ch.boye.httpclientandroidlib.HttpStatus;

public class SyncClientsEngineStage extends AbstractSessionManagingSyncStage {
  private static final String LOG_TAG = "SyncClientsEngineStage";

  public static final String COLLECTION_NAME       = "clients";
  public static final String STAGE_NAME            = COLLECTION_NAME;
  public static final int CLIENTS_TTL_REFRESH      = 604800000;   // 7 days in milliseconds.
  public static final int MAX_UPLOAD_FAILURE_COUNT = 5;
  public static final long NOTIFY_TAB_SENT_TTL_SECS = TimeUnit.SECONDS.convert(1L, TimeUnit.HOURS); // 1 hour

  protected final ClientRecordFactory factory = new ClientRecordFactory();
  protected ClientUploadDelegate clientUploadDelegate;
  protected ClientDownloadDelegate clientDownloadDelegate;

  // Be sure to use this safely via getClientsDatabaseAccessor/closeDataAccessor.
  protected ClientsDatabaseAccessor db;

  protected volatile boolean shouldWipe;
  protected volatile boolean shouldUploadLocalRecord;     // Set if, e.g., we received commands or need to refresh our version.
  protected final AtomicInteger uploadAttemptsCount = new AtomicInteger();
  protected final List<ClientRecord> modifiedClientsToUpload = new ArrayList<ClientRecord>();

  protected int getClientsCount() {
    return getClientsDatabaseAccessor().clientsCount();
  }

  protected synchronized ClientsDatabaseAccessor getClientsDatabaseAccessor() {
    if (db == null) {
      db = new ClientsDatabaseAccessor(session.getContext());
    }
    return db;
  }

  protected synchronized void closeDataAccessor() {
    if (db == null) {
      return;
    }
    db.close();
    db = null;
  }

  /**
   * The following two delegates, ClientDownloadDelegate and ClientUploadDelegate
   * are both triggered in a chain, starting when execute() calls
   * downloadClientRecords().
   *
   * Client records are downloaded using a get() request. Upon success of the
   * get() request, the local client record is uploaded.
   *
   * @author Marina Samuel
   *
   */
  public class ClientDownloadDelegate extends WBOCollectionRequestDelegate {

    // We use this on each WBO, so lift it out.
    final ClientsDataDelegate clientsDelegate = session.getClientsDelegate();
    boolean localAccountGUIDDownloaded = false;

    @Override
    public AuthHeaderProvider getAuthHeaderProvider() {
      return session.getAuthHeaderProvider();
    }

    @Override
    public String ifUnmodifiedSince() {
      // TODO last client download time?
      return null;
    }

    @Override
    public void handleRequestSuccess(SyncStorageResponse response) {

      // Hang onto the server's last modified timestamp to use
      // in X-If-Unmodified-Since for upload.
      session.config.persistServerClientsTimestamp(response.normalizedWeaveTimestamp());
      BaseResource.consumeEntity(response);

      // Wipe the clients table if it still hasn't been wiped but needs to be.
      wipeAndStore(null);

      // If we successfully downloaded all records but ours was not one of them
      // then reset the timestamp.
      if (!localAccountGUIDDownloaded) {
        Logger.info(LOG_TAG, "Local client GUID does not exist on the server. Upload timestamp will be reset.");
        session.config.persistServerClientRecordTimestamp(0);
      }
      localAccountGUIDDownloaded = false;

      final int clientsCount;
      try {
        clientsCount = getClientsCount();
      } finally {
        // Close the database to clear cached readableDatabase/writableDatabase
        // after we've completed our last transaction (db.store()).
        closeDataAccessor();
      }

      Logger.debug(LOG_TAG, "Database contains " + clientsCount + " clients.");
      Logger.debug(LOG_TAG, "Server response asserts " + response.weaveRecords() + " records.");

      // TODO: persist the response timestamp to know whether to download next time (Bug 726055).
      clientUploadDelegate = new ClientUploadDelegate();
      clientsDelegate.setClientsCount(clientsCount);

      // If we upload remote records, checkAndUpload() will be called upon
      // upload success in the delegate. Otherwise call checkAndUpload() now.
      if (modifiedClientsToUpload.size() > 0) {
        // modifiedClientsToUpload is cleared in uploadRemoteRecords, save what we need here
        final List<String> devicesToNotify = new ArrayList<>();
        for (ClientRecord record : modifiedClientsToUpload) {
          if (!TextUtils.isEmpty(record.fxaDeviceId)) {
            devicesToNotify.add(record.fxaDeviceId);
          }
        }

        // This method is synchronous, there's no risk of notifying the clients
        // before we actually uploaded the records
        uploadRemoteRecords();

        // Notify the clients who got their record written
        notifyClients(devicesToNotify);

        return;
      }
      checkAndUpload();
    }

    private void notifyClients(final List<String> devicesToNotify) {
      final ExecutorService executor = Executors.newSingleThreadExecutor();
      final Context context = session.getContext();
      final Account account = FirefoxAccounts.getFirefoxAccount(context);
      if (account == null) {
        Log.e(LOG_TAG, "Can't notify other clients: no account");
        return;
      }
      final AndroidFxAccount fxAccount = new AndroidFxAccount(context, account);
      final ExtendedJSONObject payload = createNotifyDevicesPayload();

      final byte[] sessionToken;
      try {
        sessionToken = fxAccount.getState().getSessionToken();
      } catch (State.NotASessionTokenState e) {
        // Most of the time we should never reach this, but there can be races with the account
        // state, so better safe than sorry.
        Log.e(LOG_TAG, "Could not get a session token during Sync (?)", e);
        return;
      }

      // API doc : https://github.com/mozilla/fxa-auth-server/blob/master/docs/api.md#post-v1accountdevicesnotify
      final FxAccountClient fxAccountClient = new FxAccountClient20(fxAccount.getAccountServerURI(), executor);
      fxAccountClient.notifyDevices(sessionToken, devicesToNotify, payload, NOTIFY_TAB_SENT_TTL_SECS, new FxAccountClient20.RequestDelegate<ExtendedJSONObject>() {
        @Override
        public void handleError(Exception e) {
          Log.e(LOG_TAG, "Error while notifying devices", e);
        }

        @Override
        public void handleFailure(FxAccountClientException.FxAccountClientRemoteException e) {
          Log.e(LOG_TAG, "Error while notifying devices", e);
        }

        @Override
        public void handleSuccess(ExtendedJSONObject result) {
          Log.i(LOG_TAG, devicesToNotify.size() + " devices notified");
        }
      });
    }

    @NonNull
    @SuppressWarnings("unchecked")
    private ExtendedJSONObject createNotifyDevicesPayload() {
      final ExtendedJSONObject payload = new ExtendedJSONObject();
      payload.put("version", 1);
      payload.put("command", "sync:collection_changed");
      final ExtendedJSONObject data = new ExtendedJSONObject();
      final JSONArray collections = new JSONArray();
      collections.add("clients");
      data.put("collections", collections);
      payload.put("data", data);
      return payload;
    }

    @Override
    public void handleRequestFailure(SyncStorageResponse response) {
      BaseResource.consumeEntity(response); // We don't need the response at all, and any exception handling shouldn't need the response body.
      localAccountGUIDDownloaded = false;

      try {
        Logger.info(LOG_TAG, "Client upload failed. Aborting sync.");
        doAbort(new HTTPFailureException(response), "Client download failed.");
      } finally {
        // Close the database upon failure.
        closeDataAccessor();
      }
    }

    @Override
    public void handleRequestError(Exception ex) {
      localAccountGUIDDownloaded = false;
      try {
        Logger.info(LOG_TAG, "Client upload error. Aborting sync.");
        doAbort(ex, "Failure fetching client record.");
      } finally {
        // Close the database upon error.
        closeDataAccessor();
      }
    }

    @Override
    public void handleWBO(CryptoRecord record) {
      ClientRecord r;
      try {
        r = (ClientRecord) factory.createRecord(record.decrypt());
        if (clientsDelegate.isLocalGUID(r.guid)) {
          Logger.info(LOG_TAG, "Local client GUID exists on server and was downloaded.");
          localAccountGUIDDownloaded = true;
          handleDownloadedLocalRecord(r);
        } else {
          // Only need to store record if it isn't our local one.
          wipeAndStore(r);
          addCommands(r);
          // Note that we are downloading all client records during every sync. As such, telemetry
          // will include every client currently present in the constellation of devices.
          // See the downloadClientRecords method elsewhere in the file.
          telemetryStageCollector.getSyncCollector().addDevice(r);
        }
        RepoUtils.logClient(r);
      } catch (Exception e) {
        doAbort(e, "Exception handling client WBO.");
        return;
      }
    }

    @Override
    public KeyBundle keyBundle() {
      try {
        return session.keyBundleForCollection(COLLECTION_NAME);
      } catch (NoCollectionKeysSetException e) {
        return null;
      }
    }
  }

  public class ClientUploadDelegate extends WBORequestDelegate {
    protected static final String LOG_TAG = "ClientUploadDelegate";
    public Long currentlyUploadingRecordTimestamp;
    public boolean currentlyUploadingLocalRecord;

    @Override
    public AuthHeaderProvider getAuthHeaderProvider() {
      return session.getAuthHeaderProvider();
    }

    private void setUploadDetails(boolean isLocalRecord) {
      // Use the timestamp for the whole collection per Sync storage 1.1 spec.
      currentlyUploadingRecordTimestamp = session.config.getPersistedServerClientsTimestamp();
      currentlyUploadingLocalRecord = isLocalRecord;
    }

    @Override
    public String ifUnmodifiedSince() {
      Long timestampInMilliseconds = currentlyUploadingRecordTimestamp;

      // It's the first upload so we don't care about X-If-Unmodified-Since.
      if (timestampInMilliseconds <= 0) {
        return null;
      }

      return Utils.millisecondsToDecimalSecondsString(timestampInMilliseconds);
    }

    @Override
    public void handleRequestSuccess(SyncStorageResponse response) {
      Logger.debug(LOG_TAG, "Upload succeeded.");
      uploadAttemptsCount.set(0);

      // X-Weave-Timestamp is the modified time of uploaded records.
      // Always persist this.
      final long responseTimestamp = response.normalizedWeaveTimestamp();
      Logger.trace(LOG_TAG, "Timestamp from header is: " + responseTimestamp);

      if (responseTimestamp == -1) {
        final String message = "Response did not contain a valid timestamp.";
        doAbort(new RuntimeException(message), message);
        return;
      }

      BaseResource.consumeEntity(response);
      session.config.persistServerClientsTimestamp(responseTimestamp);

      // If we're not uploading our record, we're done here; just
      // clean up and finish.
      if (!currentlyUploadingLocalRecord) {
        // TODO: check failed uploads in body.
        clearRecordsToUpload();
        checkAndUpload();
        return;
      }

      // If we're processing our record, we have a little more cleanup
      // to do.
      shouldUploadLocalRecord = false;
      session.config.persistServerClientRecordTimestamp(responseTimestamp);
      doAdvance();
    }

    @Override
    public void handleRequestFailure(SyncStorageResponse response) {
      int statusCode = response.getStatusCode();

      // If upload failed because of `ifUnmodifiedSince` then there are new
      // commands uploaded to our record. We must download and process them first.
      if (!shouldUploadLocalRecord ||
          statusCode == HttpStatus.SC_PRECONDITION_FAILED ||
          uploadAttemptsCount.incrementAndGet() > MAX_UPLOAD_FAILURE_COUNT) {

        Logger.debug(LOG_TAG, "Client upload failed. Aborting sync.");
        if (!currentlyUploadingLocalRecord) {
          modifiedClientsToUpload.clear(); // These will be redownloaded.
        }
        BaseResource.consumeEntity(response); // The exception thrown should need the response body.
        doAbort(new HTTPFailureException(response), "Client upload failed.");
        return;
      }
      Logger.trace(LOG_TAG, "Retrying upload…");
      // Preconditions:
      // shouldUploadLocalRecord == true &&
      // statusCode != 412 &&
      // uploadAttemptCount < MAX_UPLOAD_FAILURE_COUNT
      checkAndUpload();
    }

    @Override
    public void handleRequestError(Exception ex) {
      Logger.info(LOG_TAG, "Client upload error. Aborting sync.");
      doAbort(ex, "Client upload failed.");
    }

    @Override
    public KeyBundle keyBundle() {
      try {
        return session.keyBundleForCollection(COLLECTION_NAME);
      } catch (NoCollectionKeysSetException e) {
        return null;
      }
    }
  }

  @Override
  public void execute() throws NoSuchStageException {
    // We can be disabled just for this sync.
    boolean enabledThisSync = session.isEngineLocallyEnabled(STAGE_NAME);
    if (!enabledThisSync) {
      // These log messages look best when they match the messages in ServerSyncStage.
      Logger.debug(LOG_TAG, "Stage " + STAGE_NAME + " disabled just for this sync.");
      Logger.info(LOG_TAG, "Skipping stage " + STAGE_NAME + ".");
      doAdvance();
      return;
    }

    if (shouldDownload()) {
      downloadClientRecords();   // Will kick off upload, too…
    } else {
      // Upload if necessary.
    }
  }

  @Override
  protected void resetLocal() {
    // Clear timestamps and local data.
    session.config.persistServerClientRecordTimestamp(0L);   // TODO: roll these into one.
    session.config.persistServerClientsTimestamp(0L);

    session.getClientsDelegate().setClientsCount(0);
    try {
      getClientsDatabaseAccessor().wipeDB();
    } finally {
      closeDataAccessor();
    }
  }

  @Override
  protected void wipeLocal() throws Exception {
    // Nothing more to do.
    this.resetLocal();
  }

  @Override
  public Integer getStorageVersion() {
    return VersionConstants.CLIENTS_ENGINE_VERSION;
  }

  protected String getLocalClientVersion() {
    return AppConstants.MOZ_APP_VERSION;
  }

  @SuppressWarnings("unchecked")
  protected JSONArray getLocalClientProtocols() {
    final JSONArray protocols = new JSONArray();
    protocols.add(ClientRecord.PROTOCOL_LEGACY_SYNC);
    protocols.add(ClientRecord.PROTOCOL_FXA_SYNC);
    return protocols;
  }

  protected ClientRecord newLocalClientRecord(ClientsDataDelegate delegate) {
    final String ourGUID = delegate.getAccountGUID();
    final String ourName = delegate.getClientName();

    ClientRecord r = new ClientRecord(ourGUID);
    r.name = ourName;
    r.version = getLocalClientVersion();
    r.protocols = getLocalClientProtocols();

    r.os = "Android";
    r.application = AppConstants.MOZ_APP_DISPLAYNAME;
    r.appPackage = AppConstants.ANDROID_PACKAGE_NAME;
    r.device = android.os.Build.MODEL;
    r.formfactor = delegate.getFormFactor();

    Context context = session.getContext();
    final Account account = FirefoxAccounts.getFirefoxAccount(context);
    if (account != null) {
      final AndroidFxAccount fxAccount = new AndroidFxAccount(context, account);
      final String deviceId = fxAccount.getDeviceId();
      if (!TextUtils.isEmpty(deviceId)) {
        r.fxaDeviceId = deviceId;
      }
    }

    return r;
  }

  // TODO: Bug 726055 - More considered handling of when to sync.
  protected boolean shouldDownload() {
    // Ask info/collections whether a download is needed.
    return true;
  }

  protected boolean shouldUpload() {
    if (shouldUploadLocalRecord) {
      return true;
    }

    long lastUpload = session.config.getPersistedServerClientRecordTimestamp();   // Defaults to 0.
    if (lastUpload == 0) {
      return true;
    }

    if (session.getClientsDelegate().getLastModifiedTimestamp() > lastUpload) {
      // Something's changed locally since we last uploaded.
      return true;
    }

    // Note the opportunity for clock drift problems here.
    // TODO: if we track download times, we can use the timestamp of most
    // recent download response instead of the current time.
    long now = System.currentTimeMillis();
    long age = now - lastUpload;
    return age >= CLIENTS_TTL_REFRESH;
  }

  protected void handleDownloadedLocalRecord(ClientRecord r) {
    session.config.persistServerClientRecordTimestamp(r.lastModified);

    if (!getLocalClientVersion().equals(r.version) ||
        !getLocalClientProtocols().equals(r.protocols)) {
      shouldUploadLocalRecord = true;
    }
    processCommands(r.commands);
  }

  protected void processCommands(JSONArray commands) {
    if (commands == null ||
        commands.size() == 0) {
      return;
    }

    shouldUploadLocalRecord = true;
    CommandProcessor processor = CommandProcessor.getProcessor();

    for (Object o : commands) {
      processor.processCommand(session, new ExtendedJSONObject((JSONObject) o));
    }
  }

  @SuppressWarnings("unchecked")
  protected void addCommands(ClientRecord record) throws NullCursorException {
    Logger.trace(LOG_TAG, "Adding commands to " + record.guid);
    List<Command> commands = db.fetchCommandsForClient(record.guid);

    if (commands == null || commands.size() == 0) {
      Logger.trace(LOG_TAG, "No commands to add.");
      return;
    }

    for (Command command : commands) {
      JSONObject jsonCommand = command.asJSONObject();
      if (record.commands == null) {
        record.commands = new JSONArray();
      }
      record.commands.add(jsonCommand);
    }
    modifiedClientsToUpload.add(record);
  }

  @SuppressWarnings("unchecked")
  protected void uploadRemoteRecords() {
    Logger.trace(LOG_TAG, "In uploadRemoteRecords. Uploading " + modifiedClientsToUpload.size() + " records" );

    for (ClientRecord r : modifiedClientsToUpload) {
      Logger.trace(LOG_TAG, ">> Uploading record " + r.guid + ": " + r.name);
    }

    if (modifiedClientsToUpload.size() == 1) {
      ClientRecord record = modifiedClientsToUpload.get(0);
      Logger.debug(LOG_TAG, "Only 1 remote record to upload.");
      Logger.debug(LOG_TAG, "Record last modified: " + record.lastModified);
      CryptoRecord cryptoRecord = encryptClientRecord(record);
      if (cryptoRecord != null) {
        clientUploadDelegate.setUploadDetails(false);
        this.uploadClientRecord(cryptoRecord);
      }
      return;
    }

    JSONArray cryptoRecords = new JSONArray();
    for (ClientRecord record : modifiedClientsToUpload) {
      Logger.trace(LOG_TAG, "Record " + record.guid + " is being uploaded" );

      CryptoRecord cryptoRecord = encryptClientRecord(record);
      cryptoRecords.add(cryptoRecord.toJSONObject());
    }
    Logger.debug(LOG_TAG, "Uploading records: " + cryptoRecords.size());
    clientUploadDelegate.setUploadDetails(false);
    this.uploadClientRecords(cryptoRecords);
  }

  protected void checkAndUpload() {
    if (!shouldUpload()) {
      Logger.debug(LOG_TAG, "Not uploading client record.");
      doAdvance();
      return;
    }

    final ClientRecord localClient = newLocalClientRecord(session.getClientsDelegate());
    clientUploadDelegate.setUploadDetails(true);
    CryptoRecord cryptoRecord = encryptClientRecord(localClient);
    if (cryptoRecord != null) {
      this.uploadClientRecord(cryptoRecord);
    }
  }

  protected CryptoRecord encryptClientRecord(ClientRecord recordToUpload) {
    // Generate CryptoRecord from ClientRecord to upload.
    final String encryptionFailure = "Couldn't encrypt new client record.";

    try {
      CryptoRecord cryptoRecord = recordToUpload.getEnvelope();
      cryptoRecord.keyBundle = clientUploadDelegate.keyBundle();
      if (cryptoRecord.keyBundle == null) {
        doAbort(new NoCollectionKeysSetException(), "No collection keys set.");
        return null;
      }
      return cryptoRecord.encrypt();
    } catch (UnsupportedEncodingException e) {
      doAbort(e, encryptionFailure + " Unsupported encoding.");
    } catch (CryptoException e) {
      doAbort(e, encryptionFailure);
    }
    return null;
  }

  public void clearRecordsToUpload() {
    try {
      getClientsDatabaseAccessor().wipeCommandsTable();
      modifiedClientsToUpload.clear();
    } finally {
      closeDataAccessor();
    }
  }

  protected void downloadClientRecords() {
    shouldWipe = true;
    clientDownloadDelegate = makeClientDownloadDelegate();

    try {
      final URI getURI = session.config.collectionURI(COLLECTION_NAME, true);
      final SyncStorageCollectionRequest request = new SyncStorageCollectionRequest(getURI);
      request.delegate = clientDownloadDelegate;

      Logger.trace(LOG_TAG, "Downloading client records.");
      request.get();
    } catch (URISyntaxException e) {
      doAbort(e, "Invalid URI.");
    }
  }

  protected void uploadClientRecords(JSONArray records) {
    Logger.trace(LOG_TAG, "Uploading " + records.size() + " client records.");
    try {
      final URI postURI = session.config.collectionURI(COLLECTION_NAME, false);
      final SyncStorageRecordRequest request = new SyncStorageRecordRequest(postURI);
      request.delegate = clientUploadDelegate;
      request.post(records);
    } catch (URISyntaxException e) {
      doAbort(e, "Invalid URI.");
    } catch (Exception e) {
      doAbort(e, "Unable to parse body.");
    }
  }

  /**
   * Upload a client record via HTTP POST to the parent collection.
   */
  protected void uploadClientRecord(CryptoRecord record) {
    Logger.debug(LOG_TAG, "Uploading client record " + record.guid);
    try {
      final URI postURI = session.config.collectionURI(COLLECTION_NAME);
      final SyncStorageRecordRequest request = new SyncStorageRecordRequest(postURI);
      request.delegate = clientUploadDelegate;
      request.post(record);
    } catch (URISyntaxException e) {
      doAbort(e, "Invalid URI.");
    }
  }

  protected ClientDownloadDelegate makeClientDownloadDelegate() {
    return new ClientDownloadDelegate();
  }

  protected void wipeAndStore(ClientRecord record) {
    final ClientsDatabaseAccessor db = getClientsDatabaseAccessor();
    if (shouldWipe) {
      db.wipeClientsTable();
      shouldWipe = false;
    }
    if (record != null) {
      db.store(record);
    }
  }

  private void doAdvance() {
    telemetryStageCollector.finished = SystemClock.elapsedRealtime();
    session.advance();
  }

  private void doAbort(Exception e, String reason) {
    telemetryStageCollector.finished = SystemClock.elapsedRealtime();
    telemetryStageCollector.error = new TelemetryCollector.StageErrorBuilder()
            .setLastException(e)
            .build();
    session.abort(e, reason);
  }
}
