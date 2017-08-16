/* vim:set ts=4 sw=4 sts=4 et cin: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsHttpConnectionMgr_h__
#define nsHttpConnectionMgr_h__

#include "nsHttpConnection.h"
#include "nsHttpTransaction.h"
#include "nsTArray.h"
#include "nsThreadUtils.h"
#include "nsClassHashtable.h"
#include "nsDataHashtable.h"
#include "nsAutoPtr.h"
#include "mozilla/ReentrantMonitor.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/Attributes.h"
#include "AlternateServices.h"
#include "ARefBase.h"
#include "nsWeakReference.h"
#include "TCPFastOpen.h"

#include "nsIObserver.h"
#include "nsITimer.h"

class nsIHttpUpgradeListener;

namespace mozilla {
namespace net {
class EventTokenBucket;
class NullHttpTransaction;
struct HttpRetParams;

// 8d411b53-54bc-4a99-8b78-ff125eab1564
#define NS_HALFOPENSOCKET_IID \
{ 0x8d411b53, 0x54bc, 0x4a99, {0x8b, 0x78, 0xff, 0x12, 0x5e, 0xab, 0x15, 0x64 }}

//-----------------------------------------------------------------------------

// message handlers have this signature
class nsHttpConnectionMgr;
typedef void (nsHttpConnectionMgr:: *nsConnEventHandler)(int32_t, ARefBase *);

class nsHttpConnectionMgr final : public nsIObserver
                                , public AltSvcCache
{
public:
    NS_DECL_THREADSAFE_ISUPPORTS
    NS_DECL_NSIOBSERVER

    // parameter names
    enum nsParamName {
        MAX_URGENT_START_Q,
        MAX_CONNECTIONS,
        MAX_PERSISTENT_CONNECTIONS_PER_HOST,
        MAX_PERSISTENT_CONNECTIONS_PER_PROXY,
        MAX_REQUEST_DELAY,
        THROTTLING_ENABLED,
        THROTTLING_SUSPEND_FOR,
        THROTTLING_RESUME_FOR,
        THROTTLING_RESUME_IN
    };

    //-------------------------------------------------------------------------
    // NOTE: functions below may only be called on the main thread.
    //-------------------------------------------------------------------------

    nsHttpConnectionMgr();

    MOZ_MUST_USE nsresult Init(uint16_t maxUrgentExcessiveConns,
                               uint16_t maxConnections,
                               uint16_t maxPersistentConnectionsPerHost,
                               uint16_t maxPersistentConnectionsPerProxy,
                               uint16_t maxRequestDelay,
                               bool throttleEnabled,
                               uint32_t throttleSuspendFor,
                               uint32_t throttleResumeFor,
                               uint32_t throttleResumeIn);
    MOZ_MUST_USE nsresult Shutdown();

    //-------------------------------------------------------------------------
    // NOTE: functions below may be called on any thread.
    //-------------------------------------------------------------------------

    // Schedules next pruning of dead connection to happen after
    // given time.
    void PruneDeadConnectionsAfter(uint32_t time);

    // Stops timer scheduled for next pruning of dead connections if
    // there are no more idle connections or active spdy ones
    void ConditionallyStopPruneDeadConnectionsTimer();

    // Stops timer used for the read timeout tick if there are no currently
    // active connections.
    void ConditionallyStopTimeoutTick();

    // adds a transaction to the list of managed transactions.
    MOZ_MUST_USE nsresult AddTransaction(nsHttpTransaction *, int32_t priority);

    // called to reschedule the given transaction.  it must already have been
    // added to the connection manager via AddTransaction.
    MOZ_MUST_USE nsresult RescheduleTransaction(nsHttpTransaction *,
                                                int32_t priority);

    // TOOD
    void UpdateClassOfServiceOnTransaction(nsHttpTransaction *,
                                           uint32_t classOfService);

    // cancels a transaction w/ the given reason.
    MOZ_MUST_USE nsresult CancelTransaction(nsHttpTransaction *,
                                            nsresult reason);
    MOZ_MUST_USE nsresult CancelTransactions(nsHttpConnectionInfo *,
                                             nsresult reason);

    // called to force the connection manager to prune its list of idle
    // connections.
    MOZ_MUST_USE nsresult PruneDeadConnections();

    // called to close active connections with no registered "traffic"
    MOZ_MUST_USE nsresult PruneNoTraffic();

    // "VerifyTraffic" means marking connections now, and then check again in
    // N seconds to see if there's been any traffic and if not, kill
    // that connection.
    MOZ_MUST_USE nsresult VerifyTraffic();

    // Close all idle persistent connections and prevent any active connections
    // from being reused. Optional connection info resets CI specific
    // information such as Happy Eyeballs history.
    MOZ_MUST_USE nsresult DoShiftReloadConnectionCleanup(nsHttpConnectionInfo *);

    // called to get a reference to the socket transport service.  the socket
    // transport service is not available when the connection manager is down.
    MOZ_MUST_USE nsresult GetSocketThreadTarget(nsIEventTarget **);

    // called to indicate a transaction for the connectionInfo is likely coming
    // soon. The connection manager may use this information to start a TCP
    // and/or SSL level handshake for that resource immediately so that it is
    // ready when the transaction is submitted. No obligation is taken on by the
    // connection manager, nor is the submitter obligated to actually submit a
    // real transaction for this connectionInfo.
    MOZ_MUST_USE nsresult SpeculativeConnect(nsHttpConnectionInfo *,
                                             nsIInterfaceRequestor *,
                                             uint32_t caps = 0,
                                             NullHttpTransaction * = nullptr);

    // called when a connection is done processing a transaction.  if the
    // connection can be reused then it will be added to the idle list, else
    // it will be closed.
    MOZ_MUST_USE nsresult ReclaimConnection(nsHttpConnection *conn);

    // called by the main thread to execute the taketransport() logic on the
    // socket thread after a 101 response has been received and the socket
    // needs to be transferred to an expectant upgrade listener such as
    // websockets.
    MOZ_MUST_USE nsresult
    CompleteUpgrade(nsAHttpConnection *aConn,
                    nsIHttpUpgradeListener *aUpgradeListener);

    // called to update a parameter after the connection manager has already
    // been initialized.
    MOZ_MUST_USE nsresult UpdateParam(nsParamName name, uint16_t value);

    // called from main thread to post a new request token bucket
    // to the socket thread
    MOZ_MUST_USE nsresult UpdateRequestTokenBucket(EventTokenBucket *aBucket);

    // clears the connection history mCT
    MOZ_MUST_USE nsresult ClearConnectionHistory();

    void ReportFailedToProcess(nsIURI *uri);

    // Causes a large amount of connection diagnostic information to be
    // printed to the javascript console
    void PrintDiagnostics();

    //-------------------------------------------------------------------------
    // NOTE: functions below may be called only on the socket thread.
    //-------------------------------------------------------------------------

    // called to change the connection entry associated with conn from specific into
    // a wildcard (i.e. http2 proxy friendy) mapping
    void MoveToWildCardConnEntry(nsHttpConnectionInfo *specificCI,
                                 nsHttpConnectionInfo *wildcardCI,
                                 nsHttpConnection *conn);

    // called to force the transaction queue to be processed once more, giving
    // preference to the specified connection.
    MOZ_MUST_USE nsresult ProcessPendingQ(nsHttpConnectionInfo *);
    MOZ_MUST_USE bool     ProcessPendingQForEntry(nsHttpConnectionInfo *);

    // Try and process all pending transactions
    MOZ_MUST_USE nsresult ProcessPendingQ();

    // This is used to force an idle connection to be closed and removed from
    // the idle connection list. It is called when the idle connection detects
    // that the network peer has closed the transport.
    MOZ_MUST_USE nsresult CloseIdleConnection(nsHttpConnection *);
    MOZ_MUST_USE nsresult RemoveIdleConnection(nsHttpConnection *);

    // The connection manager needs to know when a normal HTTP connection has been
    // upgraded to SPDY because the dispatch and idle semantics are a little
    // bit different.
    void ReportSpdyConnection(nsHttpConnection *, bool usingSpdy);

    bool GetConnectionData(nsTArray<HttpRetParams> *);

    void ResetIPFamilyPreference(nsHttpConnectionInfo *);

    uint16_t MaxRequestDelay() { return mMaxRequestDelay; }

    // public, so that the SPDY/http2 seesions can activate
    void ActivateTimeoutTick();

    nsresult UpdateCurrentTopLevelOuterContentWindowId(uint64_t aWindowId);

    // tracks and untracks active transactions according their throttle status
    void AddActiveTransaction(nsHttpTransaction* aTrans, bool aThrottled);
    void RemoveActiveTransaction(nsHttpTransaction* aTrans, bool aThrottled);
    void MoveActiveTransaction(nsHttpTransaction* aTrans, bool aThrottled);

    // called by nsHttpTransaction::WriteSegments.  decides whether the transaction
    // should stop reading data based on: the throttling ticker status, overall
    // status of all active transactions regarding active tab and respective
    // throttling state.
    bool ShouldStopReading(nsHttpTransaction* aTrans, bool aThrottled);

    // return true iff the connection has pending transactions for the active tab.
    // it's mainly used to disallow throttling (stop reading) of a response
    // belonging to the same conn info to free up a connection ASAP.
    // NOTE: relatively expensive to call, there are two hashtable lookups.
    bool IsConnEntryUnderPressure(nsHttpConnectionInfo*);

private:
    virtual ~nsHttpConnectionMgr();

    class nsHalfOpenSocket;
    class PendingTransactionInfo;

    // nsConnectionEntry
    //
    // mCT maps connection info hash key to nsConnectionEntry object, which
    // contains list of active and idle connections as well as the list of
    // pending transactions.
    //
    class nsConnectionEntry
    {
    public:
        explicit nsConnectionEntry(nsHttpConnectionInfo *ci);
        ~nsConnectionEntry();

        RefPtr<nsHttpConnectionInfo> mConnInfo;
        nsTArray<RefPtr<PendingTransactionInfo> > mUrgentStartQ;// the urgent start transaction queue

        // This table provides a mapping from top level outer content window id
        // to a queue of pending transaction information.
        // The transaction's order in pending queue is decided by whether it's a
        // blocking transaction and its priority.
        // Note that the window id could be 0 if the http request
        // is initialized without a window.
        nsClassHashtable<nsUint64HashKey,
                         nsTArray<RefPtr<PendingTransactionInfo>>> mPendingTransactionTable;
        nsTArray<RefPtr<nsHttpConnection> >  mActiveConns; // active connections
        nsTArray<RefPtr<nsHttpConnection> >  mIdleConns;   // idle persistent connections
        nsTArray<nsHalfOpenSocket*>  mHalfOpens;   // half open connections
        nsTArray<RefPtr<nsHalfOpenSocket> >  mHalfOpenFastOpenBackups;   // backup half open connections for connection in fast open phase

        bool AvailableForDispatchNow();

        // calculate the number of half open sockets that have not had at least 1
        // connection complete
        uint32_t UnconnectedHalfOpens();

        // Remove a particular half open socket from the mHalfOpens array
        void RemoveHalfOpen(nsHalfOpenSocket *);

        // Spdy sometimes resolves the address in the socket manager in order
        // to re-coalesce sharded HTTP hosts. The dotted decimal address is
        // combined with the Anonymous flag and OA from the connection information
        // to build the hash key for hosts in the same ip pool.
        //
        nsTArray<nsCString> mCoalescingKeys;

        // To have the UsingSpdy flag means some host with the same connection
        // entry has done NPN=spdy/* at some point. It does not mean every
        // connection is currently using spdy.
        bool mUsingSpdy : 1;

        // Flags to remember our happy-eyeballs decision.
        // Reset only by Ctrl-F5 reload.
        // True when we've first connected an IPv4 server for this host,
        // initially false.
        bool mPreferIPv4 : 1;
        // True when we've first connected an IPv6 server for this host,
        // initially false.
        bool mPreferIPv6 : 1;

        // True if this connection entry has initiated a socket
        bool mUsedForConnection : 1;

        // Try using TCP Fast Open.
        bool mUseFastOpen : 1;

        // Set the IP family preference flags according the connected family
        void RecordIPFamilyPreference(uint16_t family);
        // Resets all flags to their default values
        void ResetIPFamilyPreference();

        // Return the count of pending transactions for all window ids.
        size_t PendingQLength() const;

        // Add a transaction information into the pending queue in
        // |mPendingTransactionTable| according to the transaction's
        // top level outer content window id.
        void InsertTransaction(PendingTransactionInfo *info,
                               bool aInsertAsFirstForTheSamePriority = false);

        // Append transactions to the |result| whose window id
        // is equal to |windowId|.
        // NOTE: maxCount == 0 will get all transactions in the queue.
        void AppendPendingQForFocusedWindow(
            uint64_t windowId,
            nsTArray<RefPtr<PendingTransactionInfo>> &result,
            uint32_t maxCount = 0);

        // Append transactions whose window id isn't equal to |windowId|.
        // NOTE: windowId == 0 will get all transactions for both
        // focused and non-focused windows.
        void AppendPendingQForNonFocusedWindows(
            uint64_t windowId,
            nsTArray<RefPtr<PendingTransactionInfo>> &result,
            uint32_t maxCount = 0);

        // Remove the empty pendingQ in |mPendingTransactionTable|.
        void RemoveEmptyPendingQ();
    };

public:
    static nsAHttpConnection *MakeConnectionHandle(nsHttpConnection *aWrapped);
    void RegisterOriginCoalescingKey(nsHttpConnection *, const nsACString &host, int32_t port);

private:

    // nsHalfOpenSocket is used to hold the state of an opening TCP socket
    // while we wait for it to establish and bind it to a connection

    class nsHalfOpenSocket final : public nsIOutputStreamCallback,
                                   public nsITransportEventSink,
                                   public nsIInterfaceRequestor,
                                   public nsITimerCallback,
                                   public nsSupportsWeakReference,
                                   public TCPFastOpen
    {
        ~nsHalfOpenSocket();

    public:
        NS_DECLARE_STATIC_IID_ACCESSOR(NS_HALFOPENSOCKET_IID)
        NS_DECL_THREADSAFE_ISUPPORTS
        NS_DECL_NSIOUTPUTSTREAMCALLBACK
        NS_DECL_NSITRANSPORTEVENTSINK
        NS_DECL_NSIINTERFACEREQUESTOR
        NS_DECL_NSITIMERCALLBACK

        nsHalfOpenSocket(nsConnectionEntry *ent,
                         nsAHttpTransaction *trans,
                         uint32_t caps,
                         bool speculative,
                         bool isFromPredictor);

        MOZ_MUST_USE nsresult SetupStreams(nsISocketTransport **,
                                           nsIAsyncInputStream **,
                                           nsIAsyncOutputStream **,
                                           bool isBackup);
        MOZ_MUST_USE nsresult SetupPrimaryStreams();
        MOZ_MUST_USE nsresult SetupBackupStreams();
        void     SetupBackupTimer();
        void     CancelBackupTimer();
        void     Abandon();
        double   Duration(TimeStamp epoch);
        nsISocketTransport *SocketTransport() { return mSocketTransport; }
        nsISocketTransport *BackupTransport() { return mBackupTransport; }

        nsAHttpTransaction *Transaction() { return mTransaction; }

        bool IsSpeculative() { return mSpeculative; }

        bool IsFromPredictor() { return mIsFromPredictor; }

        bool Allow1918() { return mAllow1918; }
        void SetAllow1918(bool val) { mAllow1918 = val; }

        bool HasConnected() { return mHasConnected; }

        void PrintDiagnostics(nsCString &log);

        bool Claim();
        void Unclaim();

        bool FastOpenEnabled() override;
        nsresult StartFastOpen() override;
        void SetFastOpenConnected(nsresult, bool aWillRetry) override;
        void FastOpenNotSupported() override;
        void SetFastOpenStatus(uint8_t tfoStatus) override;
        void CancelFastOpenConnection();
    private:
        nsresult SetupConn(nsIAsyncOutputStream *out,
                           bool aFastOpen);

        // To find out whether |mTransaction| is still in the connection entry's
        // pending queue. If the transaction is found and |removeWhenFound| is
        // true, the transaction will be removed from the pending queue.
        already_AddRefed<PendingTransactionInfo>
        FindTransactionHelper(bool removeWhenFound);

        nsConnectionEntry              *mEnt;
        RefPtr<nsAHttpTransaction>     mTransaction;
        bool                           mDispatchedMTransaction;
        nsCOMPtr<nsISocketTransport>   mSocketTransport;
        nsCOMPtr<nsIAsyncOutputStream> mStreamOut;
        nsCOMPtr<nsIAsyncInputStream>  mStreamIn;
        uint32_t                       mCaps;

        // mSpeculative is set if the socket was created from
        // SpeculativeConnect(). It is cleared when a transaction would normally
        // start a new connection from scratch but instead finds this one in
        // the half open list and claims it for its own use. (which due to
        // the vagaries of scheduling from the pending queue might not actually
        // match up - but it prevents a speculative connection from opening
        // more connections that are needed.)
        bool                           mSpeculative;

        // mIsFromPredictor is set if the socket originated from the network
        // Predictor. It is used to gather telemetry data on used speculative
        // connections from the predictor.
        bool                           mIsFromPredictor;

        bool                           mAllow1918;

        TimeStamp             mPrimarySynStarted;
        TimeStamp             mBackupSynStarted;

        // for syn retry
        nsCOMPtr<nsITimer>             mSynTimer;
        nsCOMPtr<nsISocketTransport>   mBackupTransport;
        nsCOMPtr<nsIAsyncOutputStream> mBackupStreamOut;
        nsCOMPtr<nsIAsyncInputStream>  mBackupStreamIn;

        // mHasConnected tracks whether one of the sockets has completed the
        // connection process. It may have completed unsuccessfully.
        bool                           mHasConnected;

        bool                           mPrimaryConnectedOK;
        bool                           mBackupConnectedOK;

        // A nsHalfOpenSocket can be made for a concrete non-null transaction,
        // but the transaction can be dispatch to another connection. In that
        // case we can free this transaction to be claimed by other
        // transactions.
        bool                           mFreeToUse;
        nsresult                       mPrimaryStreamStatus;

        bool                           mFastOpenInProgress;
        RefPtr<nsHttpConnection>       mConnectionNegotiatingFastOpen;
    };
    friend class nsHalfOpenSocket;

    class PendingTransactionInfo : public ARefBase
    {
    public:
        explicit PendingTransactionInfo(nsHttpTransaction * trans)
            : mTransaction(trans)
        {}

        NS_INLINE_DECL_THREADSAFE_REFCOUNTING(PendingTransactionInfo)

        void PrintDiagnostics(nsCString &log);
    public: // meant to be public.
        RefPtr<nsHttpTransaction> mTransaction;
        nsWeakPtr mHalfOpen;
        nsWeakPtr mActiveConn;

    private:
        virtual ~PendingTransactionInfo() {}
    };
    friend class PendingTransactionInfo;

    class PendingComparator
    {
    public:
        bool Equals(const PendingTransactionInfo *aPendingTrans,
                    const nsAHttpTransaction *aTrans) const {
            return aPendingTrans->mTransaction.get() == aTrans;
        }
    };

    //-------------------------------------------------------------------------
    // NOTE: these members may be accessed from any thread (use mReentrantMonitor)
    //-------------------------------------------------------------------------

    ReentrantMonitor    mReentrantMonitor;
    nsCOMPtr<nsIEventTarget>     mSocketThreadTarget;

    // connection limits
    uint16_t mMaxUrgentExcessiveConns;
    uint16_t mMaxConns;
    uint16_t mMaxPersistConnsPerHost;
    uint16_t mMaxPersistConnsPerProxy;
    uint16_t mMaxRequestDelay; // in seconds
    bool mThrottleEnabled;
    uint32_t mThrottleSuspendFor;
    uint32_t mThrottleResumeFor;
    uint32_t mThrottleResumeIn;
    Atomic<bool, mozilla::Relaxed> mIsShuttingDown;

    //-------------------------------------------------------------------------
    // NOTE: these members are only accessed on the socket transport thread
    //-------------------------------------------------------------------------

    MOZ_MUST_USE bool ProcessPendingQForEntry(nsConnectionEntry *,
                                              bool considerAll);
    bool DispatchPendingQ(nsTArray<RefPtr<PendingTransactionInfo>> &pendingQ,
                                   nsConnectionEntry *ent,
                                   bool considerAll);

    // Return total active connection count, which is the sum of
    // active connections and unconnected half open connections.
    uint32_t TotalActiveConnections(nsConnectionEntry *ent) const;

    // Return |mMaxPersistConnsPerProxy| or |mMaxPersistConnsPerHost|,
    // depending whether the proxy is used.
    uint32_t MaxPersistConnections(nsConnectionEntry *ent) const;

    bool     AtActiveConnectionLimit(nsConnectionEntry *, uint32_t caps);
    MOZ_MUST_USE nsresult TryDispatchTransaction(nsConnectionEntry *ent,
                                                 bool onlyReusedConnection,
                                                 PendingTransactionInfo *pendingTransInfo);
    MOZ_MUST_USE nsresult DispatchTransaction(nsConnectionEntry *,
                                              nsHttpTransaction *,
                                              nsHttpConnection *);
    MOZ_MUST_USE nsresult DispatchAbstractTransaction(nsConnectionEntry *,
                                                      nsAHttpTransaction *,
                                                      uint32_t,
                                                      nsHttpConnection *,
                                                      int32_t);
    bool     RestrictConnections(nsConnectionEntry *);
    MOZ_MUST_USE nsresult ProcessNewTransaction(nsHttpTransaction *);
    MOZ_MUST_USE nsresult EnsureSocketThreadTarget();
    void     ClosePersistentConnections(nsConnectionEntry *ent);
    void     ReportProxyTelemetry(nsConnectionEntry *ent);
    MOZ_MUST_USE nsresult CreateTransport(nsConnectionEntry *,
                                          nsAHttpTransaction *, uint32_t, bool,
                                          bool, bool,
                                          PendingTransactionInfo *pendingTransInfo);
    void     AddActiveConn(nsHttpConnection *, nsConnectionEntry *);
    void     DecrementActiveConnCount(nsHttpConnection *);
    void     StartedConnect();
    void     RecvdConnect();

    // This function will unclaim the claimed connection or set a halfOpen
    // socket to the speculative state if the transaction claiming them ends up
    // using another connection.
    void ReleaseClaimedSockets(nsConnectionEntry *ent,
                               PendingTransactionInfo * pendingTransInfo);

    void InsertTransactionSorted(nsTArray<RefPtr<PendingTransactionInfo> > &pendingQ,
                                 PendingTransactionInfo *pendingTransInfo,
                                 bool aInsertAsFirstForTheSamePriority = false);

    nsConnectionEntry *GetOrCreateConnectionEntry(nsHttpConnectionInfo *,
                                                  bool allowWildCard);

    MOZ_MUST_USE nsresult MakeNewConnection(nsConnectionEntry *ent,
                                            PendingTransactionInfo *pendingTransInfo);

    // Manage h2 connection coalescing
    // The hashtable contains arrays of weak pointers to nsHttpConnections
    nsClassHashtable<nsCStringHashKey, nsTArray<nsWeakPtr> > mCoalescingHash;

    nsHttpConnection *FindCoalescableConnection(nsConnectionEntry *ent, bool justKidding);
    nsHttpConnection *FindCoalescableConnectionByHashKey(nsConnectionEntry *ent, const nsCString &key, bool justKidding);
    void UpdateCoalescingForNewConn(nsHttpConnection *conn, nsConnectionEntry *ent);
    nsHttpConnection *GetSpdyActiveConn(nsConnectionEntry *ent);

    void               ProcessSpdyPendingQ(nsConnectionEntry *ent);
    void               DispatchSpdyPendingQ(nsTArray<RefPtr<PendingTransactionInfo>> &pendingQ,
                                            nsConnectionEntry *ent,
                                            nsHttpConnection *conn);
    // used to marshall events to the socket transport thread.
    MOZ_MUST_USE nsresult PostEvent(nsConnEventHandler  handler,
                                    int32_t             iparam = 0,
                                    ARefBase            *vparam = nullptr);

    // Used to close all transactions in the |pendingQ| with the given |reason|.
    // Note that the |pendingQ| will be also cleared.
    void CancelTransactionsHelper(
        nsTArray<RefPtr<PendingTransactionInfo>> &pendingQ,
        const nsHttpConnectionInfo *ci,
        const nsConnectionEntry *ent,
        nsresult reason);

    // message handlers
    void OnMsgShutdown             (int32_t, ARefBase *);
    void OnMsgShutdownConfirm      (int32_t, ARefBase *);
    void OnMsgNewTransaction       (int32_t, ARefBase *);
    void OnMsgReschedTransaction   (int32_t, ARefBase *);
    void OnMsgUpdateClassOfServiceOnTransaction  (int32_t, ARefBase *);
    void OnMsgCancelTransaction    (int32_t, ARefBase *);
    void OnMsgCancelTransactions   (int32_t, ARefBase *);
    void OnMsgProcessPendingQ      (int32_t, ARefBase *);
    void OnMsgPruneDeadConnections (int32_t, ARefBase *);
    void OnMsgSpeculativeConnect   (int32_t, ARefBase *);
    void OnMsgReclaimConnection    (int32_t, ARefBase *);
    void OnMsgCompleteUpgrade      (int32_t, ARefBase *);
    void OnMsgUpdateParam          (int32_t, ARefBase *);
    void OnMsgDoShiftReloadConnectionCleanup (int32_t, ARefBase *);
    void OnMsgProcessFeedback      (int32_t, ARefBase *);
    void OnMsgProcessAllSpdyPendingQ (int32_t, ARefBase *);
    void OnMsgUpdateRequestTokenBucket (int32_t, ARefBase *);
    void OnMsgVerifyTraffic (int32_t, ARefBase *);
    void OnMsgPruneNoTraffic (int32_t, ARefBase *);
    void OnMsgUpdateCurrentTopLevelOuterContentWindowId (int32_t, ARefBase *);

    // Total number of active connections in all of the ConnectionEntry objects
    // that are accessed from mCT connection table.
    uint16_t mNumActiveConns;
    // Total number of idle connections in all of the ConnectionEntry objects
    // that are accessed from mCT connection table.
    uint16_t mNumIdleConns;
    // Total number of spdy connections which are a subset of the active conns
    uint16_t mNumSpdyActiveConns;
    // Total number of connections in mHalfOpens ConnectionEntry objects
    // that are accessed from mCT connection table
    uint32_t mNumHalfOpenConns;

    // Holds time in seconds for next wake-up to prune dead connections.
    uint64_t mTimeOfNextWakeUp;
    // Timer for next pruning of dead connections.
    nsCOMPtr<nsITimer> mTimer;
    // Timer for pruning stalled connections after changed network.
    nsCOMPtr<nsITimer> mTrafficTimer;
    bool mPruningNoTraffic;

    // A 1s tick to call nsHttpConnection::ReadTimeoutTick on
    // active http/1 connections and check for orphaned half opens.
    // Disabled when there are no active or half open connections.
    nsCOMPtr<nsITimer> mTimeoutTick;
    bool mTimeoutTickArmed;
    uint32_t mTimeoutTickNext;

    //
    // the connection table
    //
    // this table is indexed by connection key.  each entry is a
    // nsConnectionEntry object. It is unlocked and therefore must only
    // be accessed from the socket thread.
    //
    nsClassHashtable<nsCStringHashKey, nsConnectionEntry> mCT;

    // Read Timeout Tick handlers
    void TimeoutTick();

    // For diagnostics
    void OnMsgPrintDiagnostics(int32_t, ARefBase *);

    nsCString mLogData;
    uint64_t mCurrentTopLevelOuterContentWindowId;

    // Called on a pref change
    void SetThrottlingEnabled(bool aEnable);

    // Two hashtalbes keeping track of active transactions regarding window id and throttling.
    // Used by the throttling algorithm to obtain number of transactions for the active tab
    // and for inactive tabs according their throttle status.
    // mActiveTransactions[0] are all unthrottled transactions, mActiveTransactions[1] throttled.
    nsClassHashtable<nsUint64HashKey, nsTArray<RefPtr<nsHttpTransaction>>> mActiveTransactions[2];

    // Whether we are inside the "stop reading" interval, altered by the throttle ticker
    bool mThrottlingInhibitsReading;

    // ticker for the 'stop reading'/'resume reading' signal
    nsCOMPtr<nsITimer> mThrottleTicker;
    // Checks if the combination of active transactions requires the ticker.
    bool IsThrottleTickerNeeded();
    // The method also unschedules the delayed resume of background tabs timer
    // if the ticker was about to be scheduled.
    void EnsureThrottleTickerIfNeeded();
    // Drops also the mThrottlingInhibitsReading flag.  Immediate or delayed resume
    // of currently throttled transactions is not affected by this method.
    void DestroyThrottleTicker();
    // Handler for the ticker: alters the mThrottlingInhibitsReading flag.
    void ThrottlerTick();

    // mechanism to delay immediate resume of background tabs and chrome initiated
    // throttled transactions after the last transaction blocking their unthrottle
    // has been removed.  Needs to be delayed because during a page load there is
    // a number of intervals when there is no transaction that would cause throttling.
    // Hence, throttling of long standing responses, like downloads, would be mostly
    // ineffective if resumed during every such interval.
    nsCOMPtr<nsITimer> mDelayedResumeReadTimer;
    // Schedule the resume
    void DelayedResumeBackgroundThrottledTransactions();
    // Simply destroys the timer
    void CancelDelayedResumeBackgroundThrottledTransactions();
    // Handler for the timer: resumes all background throttled transactions
    void ResumeBackgroundThrottledTransactions();

    // Simple helpers, iterates the given hash/array and resume.
    // @param excludeActive: skip active tabid transactions.
    void ResumeReadOf(nsClassHashtable<nsUint64HashKey, nsTArray<RefPtr<nsHttpTransaction>>>&,
                      bool excludeActive = false);
    void ResumeReadOf(nsTArray<RefPtr<nsHttpTransaction>>*);

    // Cached status of the active tab active transactions existence,
    // saves a lot of hashtable lookups
    bool mActiveTabTransactionsExist;
    bool mActiveTabUnthrottledTransactionsExist;

    void LogActiveTransactions(char);
};

NS_DEFINE_STATIC_IID_ACCESSOR(nsHttpConnectionMgr::nsHalfOpenSocket, NS_HALFOPENSOCKET_IID)

} // namespace net
} // namespace mozilla

#endif // !nsHttpConnectionMgr_h__
