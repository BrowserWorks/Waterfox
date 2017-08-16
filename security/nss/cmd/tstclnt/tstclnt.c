/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
**
** Sample client side test program that uses SSL and NSS
**
*/

#include "secutil.h"
#include "basicutil.h"

#if defined(XP_UNIX)
#include <unistd.h>
#else
#include <ctype.h> /* for isalpha() */
#endif

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>

#include "nspr.h"
#include "prio.h"
#include "prnetdb.h"
#include "nss.h"
#include "ocsp.h"
#include "ssl.h"
#include "sslproto.h"
#include "pk11func.h"
#include "secmod.h"
#include "plgetopt.h"
#include "plstr.h"

#if defined(WIN32)
#include <fcntl.h>
#include <io.h>
#endif

#define PRINTF   \
    if (verbose) \
    printf
#define FPRINTF  \
    if (verbose) \
    fprintf

#define MAX_WAIT_FOR_SERVER 600
#define WAIT_INTERVAL 100

#define EXIT_CODE_HANDSHAKE_FAILED 254

#define EXIT_CODE_SIDECHANNELTEST_GOOD 0
#define EXIT_CODE_SIDECHANNELTEST_BADCERT 1
#define EXIT_CODE_SIDECHANNELTEST_NODATA 2
#define EXIT_CODE_SIDECHANNELTEST_REVOKED 3

PRIntervalTime maxInterval = PR_INTERVAL_NO_TIMEOUT;

int ssl3CipherSuites[] = {
    -1,                                /* SSL_FORTEZZA_DMS_WITH_FORTEZZA_CBC_SHA* a */
    -1,                                /* SSL_FORTEZZA_DMS_WITH_RC4_128_SHA     * b */
    TLS_RSA_WITH_RC4_128_MD5,          /* c */
    TLS_RSA_WITH_3DES_EDE_CBC_SHA,     /* d */
    TLS_RSA_WITH_DES_CBC_SHA,          /* e */
    -1,                                /* TLS_RSA_EXPORT_WITH_RC4_40_MD5        * f */
    -1,                                /* TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5    * g */
    -1,                                /* SSL_FORTEZZA_DMS_WITH_NULL_SHA        * h */
    TLS_RSA_WITH_NULL_MD5,             /* i */
    -1,                                /* SSL_RSA_FIPS_WITH_3DES_EDE_CBC_SHA    * j */
    -1,                                /* SSL_RSA_FIPS_WITH_DES_CBC_SHA         * k */
    -1,                                /* TLS_RSA_EXPORT1024_WITH_DES_CBC_SHA   * l */
    -1,                                /* TLS_RSA_EXPORT1024_WITH_RC4_56_SHA    * m */
    TLS_RSA_WITH_RC4_128_SHA,          /* n */
    TLS_DHE_DSS_WITH_RC4_128_SHA,      /* o */
    TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA, /* p */
    TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA, /* q */
    TLS_DHE_RSA_WITH_DES_CBC_SHA,      /* r */
    TLS_DHE_DSS_WITH_DES_CBC_SHA,      /* s */
    TLS_DHE_DSS_WITH_AES_128_CBC_SHA,  /* t */
    TLS_DHE_RSA_WITH_AES_128_CBC_SHA,  /* u */
    TLS_RSA_WITH_AES_128_CBC_SHA,      /* v */
    TLS_DHE_DSS_WITH_AES_256_CBC_SHA,  /* w */
    TLS_DHE_RSA_WITH_AES_256_CBC_SHA,  /* x */
    TLS_RSA_WITH_AES_256_CBC_SHA,      /* y */
    TLS_RSA_WITH_NULL_SHA,             /* z */
    0
};

unsigned long __cmp_umuls;
PRBool verbose;
int dumpServerChain = 0;
int renegotiationsToDo = 0;
int renegotiationsDone = 0;

static char *progName;

secuPWData pwdata = { PW_NONE, 0 };

SSLNamedGroup *enabledGroups = NULL;
unsigned int enabledGroupsCount = 0;

void
printSecurityInfo(PRFileDesc *fd)
{
    CERTCertificate *cert;
    const SECItemArray *csa;
    const SECItem *scts;
    SSL3Statistics *ssl3stats = SSL_GetStatistics();
    SECStatus result;
    SSLChannelInfo channel;
    SSLCipherSuiteInfo suite;

    result = SSL_GetChannelInfo(fd, &channel, sizeof channel);
    if (result == SECSuccess &&
        channel.length == sizeof channel &&
        channel.cipherSuite) {
        result = SSL_GetCipherSuiteInfo(channel.cipherSuite,
                                        &suite, sizeof suite);
        if (result == SECSuccess) {
            FPRINTF(stderr,
                    "tstclnt: SSL version %d.%d using %d-bit %s with %d-bit %s MAC\n",
                    channel.protocolVersion >> 8, channel.protocolVersion & 0xff,
                    suite.effectiveKeyBits, suite.symCipherName,
                    suite.macBits, suite.macAlgorithmName);
            FPRINTF(stderr,
                    "tstclnt: Server Auth: %d-bit %s, Key Exchange: %d-bit %s\n"
                    "         Compression: %s, Extended Master Secret: %s\n",
                    channel.authKeyBits, suite.authAlgorithmName,
                    channel.keaKeyBits, suite.keaTypeName,
                    channel.compressionMethodName,
                    channel.extendedMasterSecretUsed ? "Yes" : "No");
        }
    }
    cert = SSL_RevealCert(fd);
    if (cert) {
        char *ip = CERT_NameToAscii(&cert->issuer);
        char *sp = CERT_NameToAscii(&cert->subject);
        if (sp) {
            fprintf(stderr, "subject DN: %s\n", sp);
            PORT_Free(sp);
        }
        if (ip) {
            fprintf(stderr, "issuer  DN: %s\n", ip);
            PORT_Free(ip);
        }
        CERT_DestroyCertificate(cert);
        cert = NULL;
    }
    fprintf(stderr,
            "%ld cache hits; %ld cache misses, %ld cache not reusable\n"
            "%ld stateless resumes\n",
            ssl3stats->hsh_sid_cache_hits, ssl3stats->hsh_sid_cache_misses,
            ssl3stats->hsh_sid_cache_not_ok, ssl3stats->hsh_sid_stateless_resumes);

    csa = SSL_PeerStapledOCSPResponses(fd);
    if (csa) {
        fprintf(stderr, "Received %d Cert Status items (OCSP stapled data)\n",
                csa->len);
    }
    scts = SSL_PeerSignedCertTimestamps(fd);
    if (scts && scts->len) {
        fprintf(stderr, "Received a Signed Certificate Timestamp of length"
                        " %u\n",
                scts->len);
    }
}

static void
PrintUsageHeader(const char *progName)
{
    fprintf(stderr,
            "Usage:  %s -h host [-a 1st_hs_name ] [-a 2nd_hs_name ] [-p port]\n"
            "[-D | -d certdir] [-C] [-b | -R root-module] \n"
            "[-n nickname] [-Bafosvx] [-c ciphers] [-Y] [-Z]\n"
            "[-V [min-version]:[max-version]] [-K] [-T] [-U]\n"
            "[-r N] [-w passwd] [-W pwfile] [-q [-t seconds]] [-I groups]\n"
            "[-A requestfile] [-L totalconnections]\n"
            "\n",
            progName);
}

static void
PrintParameterUsage(void)
{
    fprintf(stderr, "%-20s Send different SNI name. 1st_hs_name - at first\n"
                    "%-20s handshake, 2nd_hs_name - at second handshake.\n"
                    "%-20s Default is host from the -h argument.\n",
            "-a name",
            "", "");
    fprintf(stderr, "%-20s Hostname to connect with\n", "-h host");
    fprintf(stderr, "%-20s Port number for SSL server\n", "-p port");
    fprintf(stderr,
            "%-20s Directory with cert database (default is ~/.netscape)\n",
            "-d certdir");
    fprintf(stderr, "%-20s Run without a cert database\n", "-D");
    fprintf(stderr, "%-20s Load the default \"builtins\" root CA module\n", "-b");
    fprintf(stderr, "%-20s Load the given root CA module\n", "-R");
    fprintf(stderr, "%-20s Print certificate chain information\n", "-C");
    fprintf(stderr, "%-20s (use -C twice to print more certificate details)\n", "");
    fprintf(stderr, "%-20s (use -C three times to include PEM format certificate dumps)\n", "");
    fprintf(stderr, "%-20s Nickname of key and cert for client auth\n",
            "-n nickname");
    fprintf(stderr,
            "%-20s Restricts the set of enabled SSL/TLS protocols versions.\n"
            "%-20s All versions are enabled by default.\n"
            "%-20s Possible values for min/max: ssl3 tls1.0 tls1.1 tls1.2 tls1.3\n"
            "%-20s Example: \"-V ssl3:\" enables SSL 3 and newer.\n",
            "-V [min]:[max]", "", "", "");
    fprintf(stderr, "%-20s Send TLS_FALLBACK_SCSV\n", "-K");
    fprintf(stderr, "%-20s Prints only payload data. Skips HTTP header.\n", "-S");
    fprintf(stderr, "%-20s Client speaks first. \n", "-f");
    fprintf(stderr, "%-20s Use synchronous certificate validation\n", "-O");
    fprintf(stderr, "%-20s Override bad server cert. Make it OK.\n", "-o");
    fprintf(stderr, "%-20s Disable SSL socket locking.\n", "-s");
    fprintf(stderr, "%-20s Verbose progress reporting.\n", "-v");
    fprintf(stderr, "%-20s Ping the server and then exit.\n", "-q");
    fprintf(stderr, "%-20s Timeout for server ping (default: no timeout).\n", "-t seconds");
    fprintf(stderr, "%-20s Renegotiate N times (resuming session if N>1).\n", "-r N");
    fprintf(stderr, "%-20s Enable the session ticket extension.\n", "-u");
    fprintf(stderr, "%-20s Enable compression.\n", "-z");
    fprintf(stderr, "%-20s Enable false start.\n", "-g");
    fprintf(stderr, "%-20s Enable the cert_status extension (OCSP stapling).\n", "-T");
    fprintf(stderr, "%-20s Enable the signed_certificate_timestamp extension.\n", "-U");
    fprintf(stderr, "%-20s Require fresh revocation info from side channel.\n"
                    "%-20s -F once means: require for server cert only\n"
                    "%-20s -F twice means: require for intermediates, too\n"
                    "%-20s (Connect, handshake with server, disable dynamic download\n"
                    "%-20s  of OCSP/CRL, verify cert using CERT_PKIXVerifyCert.)\n"
                    "%-20s Exit code:\n"
                    "%-20s 0: have fresh and valid revocation data, status good\n"
                    "%-20s 1: cert failed to verify, prior to revocation checking\n"
                    "%-20s 2: missing, old or invalid revocation data\n"
                    "%-20s 3: have fresh and valid revocation data, status revoked\n",
            "-F", "", "", "", "", "", "", "", "", "");
    fprintf(stderr, "%-20s Test -F allows 0=any (default), 1=only OCSP, 2=only CRL\n", "-M");
    fprintf(stderr, "%-20s Restrict ciphers\n", "-c ciphers");
    fprintf(stderr, "%-20s Print cipher values allowed for parameter -c and exit\n", "-Y");
    fprintf(stderr, "%-20s Enforce using an IPv4 destination address\n", "-4");
    fprintf(stderr, "%-20s Enforce using an IPv6 destination address\n", "-6");
    fprintf(stderr, "%-20s (Options -4 and -6 cannot be combined.)\n", "");
    fprintf(stderr, "%-20s Enable the extended master secret extension [RFC7627]\n", "-G");
    fprintf(stderr, "%-20s Require the use of FFDHE supported groups [RFC7919]\n", "-H");
    fprintf(stderr, "%-20s Read from a file instead of stdin\n", "-A");
    fprintf(stderr, "%-20s Allow 0-RTT data (TLS 1.3 only)\n", "-Z");
    fprintf(stderr, "%-20s Disconnect and reconnect up to N times total\n", "-L");
    fprintf(stderr, "%-20s Comma separated list of enabled groups for TLS key exchange.\n"
                    "%-20s The following values are valid:\n"
                    "%-20s P256, P384, P521, x25519, FF2048, FF3072, FF4096, FF6144, FF8192\n",
            "-I", "", "");
}

static void
Usage(const char *progName)
{
    PrintUsageHeader(progName);
    PrintParameterUsage();
    exit(1);
}

static void
PrintCipherUsage(const char *progName)
{
    PrintUsageHeader(progName);
    fprintf(stderr, "%-20s Letter(s) chosen from the following list\n",
            "-c ciphers");
    fprintf(stderr,
            "c    SSL3 RSA WITH RC4 128 MD5\n"
            "d    SSL3 RSA WITH 3DES EDE CBC SHA\n"
            "e    SSL3 RSA WITH DES CBC SHA\n"
            "i    SSL3 RSA WITH NULL MD5\n"
            "n    SSL3 RSA WITH RC4 128 SHA\n"
            "o    SSL3 DHE DSS WITH RC4 128 SHA\n"
            "p    SSL3 DHE RSA WITH 3DES EDE CBC SHA\n"
            "q    SSL3 DHE DSS WITH 3DES EDE CBC SHA\n"
            "r    SSL3 DHE RSA WITH DES CBC SHA\n"
            "s    SSL3 DHE DSS WITH DES CBC SHA\n"
            "t    SSL3 DHE DSS WITH AES 128 CBC SHA\n"
            "u    SSL3 DHE RSA WITH AES 128 CBC SHA\n"
            "v    SSL3 RSA WITH AES 128 CBC SHA\n"
            "w    SSL3 DHE DSS WITH AES 256 CBC SHA\n"
            "x    SSL3 DHE RSA WITH AES 256 CBC SHA\n"
            "y    SSL3 RSA WITH AES 256 CBC SHA\n"
            "z    SSL3 RSA WITH NULL SHA\n"
            "\n"
            ":WXYZ  Use cipher with hex code { 0xWX , 0xYZ } in TLS\n");
    exit(1);
}

void
milliPause(PRUint32 milli)
{
    PRIntervalTime ticks = PR_MillisecondsToInterval(milli);
    PR_Sleep(ticks);
}

void
disableAllSSLCiphers(void)
{
    const PRUint16 *cipherSuites = SSL_GetImplementedCiphers();
    int i = SSL_GetNumImplementedCiphers();
    SECStatus rv;

    /* disable all the SSL3 cipher suites */
    while (--i >= 0) {
        PRUint16 suite = cipherSuites[i];
        rv = SSL_CipherPrefSetDefault(suite, PR_FALSE);
        if (rv != SECSuccess) {
            PRErrorCode err = PR_GetError();
            fprintf(stderr,
                    "SSL_CipherPrefSet didn't like value 0x%04x (i = %d): %s\n",
                    suite, i, SECU_Strerror(err));
            exit(2);
        }
    }
}

typedef struct
{
    PRBool shouldPause; /* PR_TRUE if we should use asynchronous peer cert
                        * authentication */
    PRBool isPaused;    /* PR_TRUE if libssl is waiting for us to validate the
                        * peer's certificate and restart the handshake. */
    void *dbHandle;     /* Certificate database handle to use while
                        * authenticating the peer's certificate. */
    PRBool testFreshStatusFromSideChannel;
    PRErrorCode sideChannelRevocationTestResultCode;
    PRBool requireDataForIntermediates;
    PRBool allowOCSPSideChannelData;
    PRBool allowCRLSideChannelData;
} ServerCertAuth;

/*
 * Callback is called when incoming certificate is not valid.
 * Returns SECSuccess to accept the cert anyway, SECFailure to reject.
 */
static SECStatus
ownBadCertHandler(void *arg, PRFileDesc *socket)
{
    PRErrorCode err = PR_GetError();
    /* can log invalid cert here */
    fprintf(stderr, "Bad server certificate: %d, %s\n", err,
            SECU_Strerror(err));
    return SECSuccess; /* override, say it's OK. */
}

#define EXIT_CODE_SIDECHANNELTEST_GOOD 0
#define EXIT_CODE_SIDECHANNELTEST_BADCERT 1
#define EXIT_CODE_SIDECHANNELTEST_NODATA 2
#define EXIT_CODE_SIDECHANNELTEST_REVOKED 3

static void
verifyFromSideChannel(CERTCertificate *cert, ServerCertAuth *sca)
{
    PRUint64 revDoNotUse =
        CERT_REV_M_DO_NOT_TEST_USING_THIS_METHOD;

    PRUint64 revUseLocalOnlyAndSoftFail =
        CERT_REV_M_TEST_USING_THIS_METHOD |
        CERT_REV_M_FORBID_NETWORK_FETCHING |
        CERT_REV_M_REQUIRE_INFO_ON_MISSING_SOURCE |
        CERT_REV_M_IGNORE_MISSING_FRESH_INFO |
        CERT_REV_M_STOP_TESTING_ON_FRESH_INFO;

    PRUint64 revUseLocalOnlyAndHardFail =
        CERT_REV_M_TEST_USING_THIS_METHOD |
        CERT_REV_M_FORBID_NETWORK_FETCHING |
        CERT_REV_M_REQUIRE_INFO_ON_MISSING_SOURCE |
        CERT_REV_M_FAIL_ON_MISSING_FRESH_INFO |
        CERT_REV_M_STOP_TESTING_ON_FRESH_INFO;

    PRUint64 methodFlagsDoNotUse[2];
    PRUint64 methodFlagsCheckSoftFail[2];
    PRUint64 methodFlagsCheckHardFail[2];
    CERTRevocationTests revTestsDoNotCheck;
    CERTRevocationTests revTestsOverallSoftFail;
    CERTRevocationTests revTestsOverallHardFail;
    CERTRevocationFlags rev;
    CERTValInParam cvin[2];
    CERTValOutParam cvout[1];
    SECStatus rv;

    methodFlagsDoNotUse[cert_revocation_method_crl] = revDoNotUse;
    methodFlagsDoNotUse[cert_revocation_method_ocsp] = revDoNotUse;

    methodFlagsCheckSoftFail[cert_revocation_method_crl] =
        sca->allowCRLSideChannelData ? revUseLocalOnlyAndSoftFail : revDoNotUse;
    methodFlagsCheckSoftFail[cert_revocation_method_ocsp] =
        sca->allowOCSPSideChannelData ? revUseLocalOnlyAndSoftFail : revDoNotUse;

    methodFlagsCheckHardFail[cert_revocation_method_crl] =
        sca->allowCRLSideChannelData ? revUseLocalOnlyAndHardFail : revDoNotUse;
    methodFlagsCheckHardFail[cert_revocation_method_ocsp] =
        sca->allowOCSPSideChannelData ? revUseLocalOnlyAndHardFail : revDoNotUse;

    revTestsDoNotCheck.cert_rev_flags_per_method = methodFlagsDoNotUse;
    revTestsDoNotCheck.number_of_defined_methods = 2;
    revTestsDoNotCheck.number_of_preferred_methods = 0;
    revTestsDoNotCheck.cert_rev_method_independent_flags =
        CERT_REV_MI_TEST_ALL_LOCAL_INFORMATION_FIRST |
        CERT_REV_MI_NO_OVERALL_INFO_REQUIREMENT;

    revTestsOverallSoftFail.cert_rev_flags_per_method = 0; /* must define later */
    revTestsOverallSoftFail.number_of_defined_methods = 2;
    revTestsOverallSoftFail.number_of_preferred_methods = 0;
    revTestsOverallSoftFail.cert_rev_method_independent_flags =
        CERT_REV_MI_TEST_ALL_LOCAL_INFORMATION_FIRST |
        CERT_REV_MI_NO_OVERALL_INFO_REQUIREMENT;

    revTestsOverallHardFail.cert_rev_flags_per_method = 0; /* must define later */
    revTestsOverallHardFail.number_of_defined_methods = 2;
    revTestsOverallHardFail.number_of_preferred_methods = 0;
    revTestsOverallHardFail.cert_rev_method_independent_flags =
        CERT_REV_MI_TEST_ALL_LOCAL_INFORMATION_FIRST |
        CERT_REV_MI_REQUIRE_SOME_FRESH_INFO_AVAILABLE;

    rev.chainTests = revTestsDoNotCheck;
    rev.leafTests = revTestsDoNotCheck;

    cvin[0].type = cert_pi_revocationFlags;
    cvin[0].value.pointer.revocation = &rev;
    cvin[1].type = cert_pi_end;

    cvout[0].type = cert_po_end;

    /* Strategy:
     *
     * Verify with revocation checking disabled.
     * On failure return 1.
     *
     * if result if "good", then continue testing.
     *
     * Verify with CERT_REV_M_FAIL_ON_MISSING_FRESH_INFO.
     * If result is good, return 0.
     *
     * On failure continue testing, find out why it failed.
     *
     * Verify with CERT_REV_M_IGNORE_MISSING_FRESH_INFO
     *
     * If result is "good", then our previous test failed,
     * because we don't have fresh revocation info, return 2.
     *
     * If result is still bad, we do have revocation info,
     * and it says "revoked" or something equivalent, return 3.
     */

    /* revocation checking disabled */
    rv = CERT_PKIXVerifyCert(cert, certificateUsageSSLServer,
                             cvin, cvout, NULL);
    if (rv != SECSuccess) {
        sca->sideChannelRevocationTestResultCode =
            EXIT_CODE_SIDECHANNELTEST_BADCERT;
        return;
    }

    /* revocation checking, hard fail */
    if (sca->allowOCSPSideChannelData && sca->allowCRLSideChannelData) {
        /* any method is allowed. use soft fail on individual checks,
         * but use hard fail on the overall check
         */
        revTestsOverallHardFail.cert_rev_flags_per_method = methodFlagsCheckSoftFail;
    } else {
        /* only one method is allowed. use hard fail on the individual checks.
         * hard/soft fail is irrelevant on overall flags.
         */
        revTestsOverallHardFail.cert_rev_flags_per_method = methodFlagsCheckHardFail;
    }
    rev.leafTests = revTestsOverallHardFail;
    rev.chainTests =
        sca->requireDataForIntermediates ? revTestsOverallHardFail : revTestsDoNotCheck;
    rv = CERT_PKIXVerifyCert(cert, certificateUsageSSLServer,
                             cvin, cvout, NULL);
    if (rv == SECSuccess) {
        sca->sideChannelRevocationTestResultCode =
            EXIT_CODE_SIDECHANNELTEST_GOOD;
        return;
    }

    /* revocation checking, soft fail */
    revTestsOverallSoftFail.cert_rev_flags_per_method = methodFlagsCheckSoftFail;
    rev.leafTests = revTestsOverallSoftFail;
    rev.chainTests =
        sca->requireDataForIntermediates ? revTestsOverallSoftFail : revTestsDoNotCheck;
    rv = CERT_PKIXVerifyCert(cert, certificateUsageSSLServer,
                             cvin, cvout, NULL);
    if (rv == SECSuccess) {
        sca->sideChannelRevocationTestResultCode =
            EXIT_CODE_SIDECHANNELTEST_NODATA;
        return;
    }

    sca->sideChannelRevocationTestResultCode =
        EXIT_CODE_SIDECHANNELTEST_REVOKED;
}

static void
dumpCertificatePEM(CERTCertificate *cert)
{
    SECItem data;
    data.data = cert->derCert.data;
    data.len = cert->derCert.len;
    fprintf(stderr, "%s\n%s\n%s\n", NS_CERT_HEADER,
            BTOA_DataToAscii(data.data, data.len), NS_CERT_TRAILER);
}

static void
dumpServerCertificateChain(PRFileDesc *fd)
{
    CERTCertList *peerCertChain = NULL;
    CERTCertListNode *node = NULL;
    CERTCertificate *peerCert = NULL;
    CERTCertificateList *foundChain = NULL;
    SECU_PPFunc dumpFunction = NULL;
    PRBool dumpCertPEM = PR_FALSE;

    if (!dumpServerChain) {
        return;
    } else if (dumpServerChain == 1) {
        dumpFunction = (SECU_PPFunc)SECU_PrintCertificateBasicInfo;
    } else {
        dumpFunction = (SECU_PPFunc)SECU_PrintCertificate;
        if (dumpServerChain > 2) {
            dumpCertPEM = PR_TRUE;
        }
    }

    SECU_EnableWrap(PR_FALSE);

    fprintf(stderr, "==== certificate(s) sent by server: ====\n");
    peerCertChain = SSL_PeerCertificateChain(fd);
    if (peerCertChain) {
        node = CERT_LIST_HEAD(peerCertChain);
        while (!CERT_LIST_END(node, peerCertChain)) {
            CERTCertificate *cert = node->cert;
            SECU_PrintSignedContent(stderr, &cert->derCert, "Certificate", 0,
                                    dumpFunction);
            if (dumpCertPEM) {
                dumpCertificatePEM(cert);
            }
            node = CERT_LIST_NEXT(node);
        }
    }

    if (peerCertChain) {
        peerCert = SSL_RevealCert(fd);
        if (peerCert) {
            foundChain = CERT_CertChainFromCert(peerCert, certificateUsageSSLServer,
                                                PR_TRUE);
        }
        if (foundChain) {
            unsigned int count = 0;
            fprintf(stderr, "==== locally found issuer certificate(s): ====\n");
            for (count = 0; count < (unsigned int)foundChain->len; count++) {
                CERTCertificate *c;
                PRBool wasSentByServer = PR_FALSE;
                c = CERT_FindCertByDERCert(CERT_GetDefaultCertDB(), &foundChain->certs[count]);

                node = CERT_LIST_HEAD(peerCertChain);
                while (!CERT_LIST_END(node, peerCertChain)) {
                    CERTCertificate *cert = node->cert;
                    if (CERT_CompareCerts(cert, c)) {
                        wasSentByServer = PR_TRUE;
                        break;
                    }
                    node = CERT_LIST_NEXT(node);
                }

                if (!wasSentByServer) {
                    SECU_PrintSignedContent(stderr, &c->derCert, "Certificate", 0,
                                            dumpFunction);
                    if (dumpCertPEM) {
                        dumpCertificatePEM(c);
                    }
                }
                CERT_DestroyCertificate(c);
            }
            CERT_DestroyCertificateList(foundChain);
        }
        if (peerCert) {
            CERT_DestroyCertificate(peerCert);
        }

        CERT_DestroyCertList(peerCertChain);
        peerCertChain = NULL;
    }

    fprintf(stderr, "==== end of certificate chain information ====\n");
    fflush(stderr);
}

static SECStatus
ownAuthCertificate(void *arg, PRFileDesc *fd, PRBool checkSig,
                   PRBool isServer)
{
    ServerCertAuth *serverCertAuth = (ServerCertAuth *)arg;

    if (dumpServerChain) {
        dumpServerCertificateChain(fd);
    }

    if (!serverCertAuth->shouldPause) {
        CERTCertificate *cert;
        unsigned int i;
        const SECItemArray *csa;

        if (!serverCertAuth->testFreshStatusFromSideChannel) {
            return SSL_AuthCertificate(serverCertAuth->dbHandle,
                                       fd, checkSig, isServer);
        }

        /* No verification attempt must have happened before now,
         * to ensure revocation data has been actively retrieved yet,
         * or our test will produce incorrect results.
         */

        cert = SSL_RevealCert(fd);
        if (!cert) {
            exit(254);
        }

        csa = SSL_PeerStapledOCSPResponses(fd);
        if (csa) {
            for (i = 0; i < csa->len; ++i) {
                PORT_SetError(0);
                if (CERT_CacheOCSPResponseFromSideChannel(
                        serverCertAuth->dbHandle, cert, PR_Now(),
                        &csa->items[i], arg) != SECSuccess) {
                    PORT_Assert(PR_GetError() != 0);
                }
            }
        }

        verifyFromSideChannel(cert, serverCertAuth);
        CERT_DestroyCertificate(cert);
        /* return success to ensure our caller will continue and we will
         * reach the code that handles
         * serverCertAuth->sideChannelRevocationTestResultCode
         */
        return SECSuccess;
    }

    FPRINTF(stderr, "%s: using asynchronous certificate validation\n",
            progName);

    PORT_Assert(!serverCertAuth->isPaused);
    serverCertAuth->isPaused = PR_TRUE;
    return SECWouldBlock;
}

SECStatus
own_GetClientAuthData(void *arg,
                      PRFileDesc *socket,
                      struct CERTDistNamesStr *caNames,
                      struct CERTCertificateStr **pRetCert,
                      struct SECKEYPrivateKeyStr **pRetKey)
{
    if (verbose > 1) {
        SECStatus rv;
        fprintf(stderr, "Server requested Client Authentication\n");
        if (caNames && caNames->nnames > 0) {
            PLArenaPool *arena = caNames->arena;
            if (!arena)
                arena = PORT_NewArena(2048);
            if (arena) {
                int i;
                for (i = 0; i < caNames->nnames; ++i) {
                    char *nameString;
                    CERTName dn;
                    rv = SEC_QuickDERDecodeItem(arena,
                                                &dn,
                                                SEC_ASN1_GET(CERT_NameTemplate),
                                                caNames->names + i);
                    if (rv != SECSuccess)
                        continue;
                    nameString = CERT_NameToAscii(&dn);
                    if (!nameString)
                        continue;
                    fprintf(stderr, "CA[%d]: %s\n", i + 1, nameString);
                    PORT_Free(nameString);
                }
                if (!caNames->arena) {
                    PORT_FreeArena(arena, PR_FALSE);
                }
            }
        }
        rv = NSS_GetClientAuthData(arg, socket, caNames, pRetCert, pRetKey);
        if (rv == SECSuccess && *pRetCert) {
            char *nameString = CERT_NameToAscii(&((*pRetCert)->subject));
            if (nameString) {
                fprintf(stderr, "sent cert: %s\n", nameString);
                PORT_Free(nameString);
            }
        } else {
            fprintf(stderr, "send no cert\n");
        }
        return rv;
    }
    return NSS_GetClientAuthData(arg, socket, caNames, pRetCert, pRetKey);
}

#if defined(WIN32) || defined(OS2)
void
thread_main(void *arg)
{
    PRFileDesc *ps = (PRFileDesc *)arg;
    PRFileDesc *std_in = PR_GetSpecialFD(PR_StandardInput);
    int wc, rc;
    char buf[256];

#ifdef WIN32
    {
        /* Put stdin into O_BINARY mode
        ** or else incoming \r\n's will become \n's.
        */
        int smrv = _setmode(_fileno(stdin), _O_BINARY);
        if (smrv == -1) {
            fprintf(stderr,
                    "%s: Cannot change stdin to binary mode. Use -i option instead.\n",
                    progName);
            /* plow ahead anyway */
        }
    }
#endif

    do {
        rc = PR_Read(std_in, buf, sizeof buf);
        if (rc <= 0)
            break;
        wc = PR_Send(ps, buf, rc, 0, maxInterval);
    } while (wc == rc);
    PR_Close(ps);
}

#endif

static void
printHostNameAndAddr(const char *host, const PRNetAddr *addr)
{
    PRUint16 port = PR_NetAddrInetPort(addr);
    char addrBuf[80];
    PRStatus st = PR_NetAddrToString(addr, addrBuf, sizeof addrBuf);

    if (st == PR_SUCCESS) {
        port = PR_ntohs(port);
        FPRINTF(stderr, "%s: connecting to %s:%hu (address=%s)\n",
                progName, host, port, addrBuf);
    }
}

/*
 *  Prints output according to skipProtoHeader flag. If skipProtoHeader
 *  is not set, prints without any changes, otherwise looking
 *  for \n\r\n(empty line sequence: HTTP header separator) and
 *  prints everything after it.
 */
static void
separateReqHeader(const PRFileDesc *outFd, const char *buf, const int nb,
                  PRBool *wrStarted, int *ptrnMatched)
{

    /* it is sufficient to look for only "\n\r\n". Hopping that
     * HTTP response format satisfies the standard */
    char *ptrnStr = "\n\r\n";
    char *resPtr;

    if (nb == 0) {
        return;
    }

    if (*ptrnMatched > 0) {
        /* Get here only if previous separateReqHeader call found
         * only a fragment of "\n\r\n" in previous buffer. */
        PORT_Assert(*ptrnMatched < 3);

        /* the size of fragment of "\n\r\n" what we want to find in this
         * buffer is equal to *ptrnMatched */
        if (*ptrnMatched <= nb) {
            /* move the pointer to the beginning of the fragment */
            int strSize = *ptrnMatched;
            char *tmpPtrn = ptrnStr + (3 - strSize);
            if (PL_strncmp(buf, tmpPtrn, strSize) == 0) {
                /* print the rest of the buffer(without the fragment) */
                PR_Write((void *)outFd, buf + strSize, nb - strSize);
                *wrStarted = PR_TRUE;
                return;
            }
        } else {
            /* we are here only when nb == 1 && *ptrnMatched == 2 */
            if (*buf == '\r') {
                *ptrnMatched = 1;
            } else {
                *ptrnMatched = 0;
            }
            return;
        }
    }
    resPtr = PL_strnstr(buf, ptrnStr, nb);
    if (resPtr != NULL) {
        /* if "\n\r\n" was found in the buffer, calculate offset
         * and print the rest of the buffer */
        int newBn = nb - (resPtr - buf + 3); /* 3 is the length of "\n\r\n" */

        PR_Write((void *)outFd, resPtr + 3, newBn);
        *wrStarted = PR_TRUE;
        return;
    } else {
        /* try to find a fragment of "\n\r\n" at the end of the buffer.
         * if found, set *ptrnMatched to the number of chars left to find
         * in the next buffer.*/
        int i;
        for (i = 1; i < 3; i++) {
            char *bufPrt;
            int strSize = 3 - i;

            if (strSize > nb) {
                continue;
            }
            bufPrt = (char *)(buf + nb - strSize);

            if (PL_strncmp(bufPrt, ptrnStr, strSize) == 0) {
                *ptrnMatched = i;
                return;
            }
        }
    }
}

#define SSOCK_FD 0
#define STDIN_FD 1

#define HEXCHAR_TO_INT(c, i)                   \
    if (((c) >= '0') && ((c) <= '9')) {        \
        i = (c) - '0';                         \
    } else if (((c) >= 'a') && ((c) <= 'f')) { \
        i = (c) - 'a' + 10;                    \
    } else if (((c) >= 'A') && ((c) <= 'F')) { \
        i = (c) - 'A' + 10;                    \
    } else {                                   \
        Usage(progName);                       \
    }

static SECStatus
restartHandshakeAfterServerCertIfNeeded(PRFileDesc *fd,
                                        ServerCertAuth *serverCertAuth,
                                        PRBool override)
{
    SECStatus rv;
    PRErrorCode error;

    if (!serverCertAuth->isPaused)
        return SECSuccess;

    FPRINTF(stderr, "%s: handshake was paused by auth certificate hook\n",
            progName);

    serverCertAuth->isPaused = PR_FALSE;
    rv = SSL_AuthCertificate(serverCertAuth->dbHandle, fd, PR_TRUE, PR_FALSE);
    if (rv != SECSuccess) {
        error = PR_GetError();
        if (error == 0) {
            PR_NOT_REACHED("SSL_AuthCertificate return SECFailure without "
                           "setting error code.");
            error = PR_INVALID_STATE_ERROR;
        } else if (override) {
            rv = ownBadCertHandler(NULL, fd);
        }
    }
    if (rv == SECSuccess) {
        error = 0;
    }

    if (SSL_AuthCertificateComplete(fd, error) != SECSuccess) {
        rv = SECFailure;
    } else {
        /* restore the original error code, which could be reset by
         * SSL_AuthCertificateComplete */
        PORT_SetError(error);
    }

    return rv;
}

char *host = NULL;
char *nickname = NULL;
char *cipherString = NULL;
int multiplier = 0;
SSLVersionRange enabledVersions;
int disableLocking = 0;
int enableSessionTickets = 0;
int enableCompression = 0;
int enableFalseStart = 0;
int enableCertStatus = 0;
int enableSignedCertTimestamps = 0;
int forceFallbackSCSV = 0;
int enableExtendedMasterSecret = 0;
PRBool requireDHNamedGroups = 0;
PRSocketOptionData opt;
PRNetAddr addr;
PRBool allowIPv4 = PR_TRUE;
PRBool allowIPv6 = PR_TRUE;
PRBool pingServerFirst = PR_FALSE;
int pingTimeoutSeconds = -1;
PRBool clientSpeaksFirst = PR_FALSE;
PRBool skipProtoHeader = PR_FALSE;
ServerCertAuth serverCertAuth;
char *hs1SniHostName = NULL;
char *hs2SniHostName = NULL;
PRUint16 portno = 443;
int override = 0;
char *requestString = NULL;
PRInt32 requestStringLen = 0;
PRBool requestSent = PR_FALSE;
PRBool enableZeroRtt = PR_FALSE;

static int
writeBytesToServer(PRFileDesc *s, const char *buf, int nb)
{
    SECStatus rv;
    const char *bufp = buf;
    PRPollDesc pollDesc;

    pollDesc.in_flags = PR_POLL_WRITE | PR_POLL_EXCEPT;
    pollDesc.out_flags = 0;
    pollDesc.fd = s;

    FPRINTF(stderr, "%s: Writing %d bytes to server\n",
            progName, nb);
    do {
        PRInt32 cc = PR_Send(s, bufp, nb, 0, maxInterval);
        if (cc < 0) {
            PRErrorCode err = PR_GetError();
            if (err != PR_WOULD_BLOCK_ERROR) {
                SECU_PrintError(progName,
                                "write to SSL socket failed");
                return 254;
            }
            cc = 0;
        }
        bufp += cc;
        nb -= cc;
        if (nb <= 0)
            break;

        rv = restartHandshakeAfterServerCertIfNeeded(s,
                                                     &serverCertAuth, override);
        if (rv != SECSuccess) {
            SECU_PrintError(progName, "authentication of server cert failed");
            return EXIT_CODE_HANDSHAKE_FAILED;
        }

        pollDesc.in_flags = PR_POLL_WRITE | PR_POLL_EXCEPT;
        pollDesc.out_flags = 0;
        FPRINTF(stderr,
                "%s: about to call PR_Poll on writable socket !\n",
                progName);
        cc = PR_Poll(&pollDesc, 1, PR_INTERVAL_NO_TIMEOUT);
        if (cc < 0) {
            SECU_PrintError(progName,
                            "PR_Poll failed");
            return -1;
        }
        FPRINTF(stderr,
                "%s: PR_Poll returned with writable socket !\n",
                progName);
    } while (1);

    return 0;
}

void
handshakeCallback(PRFileDesc *fd, void *client_data)
{
    const char *secondHandshakeName = (char *)client_data;
    if (secondHandshakeName) {
        SSL_SetURL(fd, secondHandshakeName);
    }
    printSecurityInfo(fd);
    if (renegotiationsDone < renegotiationsToDo) {
        SSL_ReHandshake(fd, (renegotiationsToDo < 2));
        ++renegotiationsDone;
    }
    if (requestString && requestSent) {
        /* This data was sent in 0-RTT. */
        SSLChannelInfo info;
        SECStatus rv;

        rv = SSL_GetChannelInfo(fd, &info, sizeof(info));
        if (rv != SECSuccess)
            return;

        if (!info.earlyDataAccepted) {
            FPRINTF(stderr, "Early data rejected. Re-sending\n");
            writeBytesToServer(fd, requestString, requestStringLen);
        }
    }
}

#define REQUEST_WAITING (requestString && !requestSent)

static int
run_client(void)
{
    int headerSeparatorPtrnId = 0;
    int error = 0;
    SECStatus rv;
    PRStatus status;
    PRInt32 filesReady;
    int npds;
    PRFileDesc *s = NULL;
    PRFileDesc *std_out;
    PRPollDesc pollset[2];
    PRBool wrStarted = PR_FALSE;

    requestSent = PR_FALSE;

    /* Create socket */
    s = PR_OpenTCPSocket(addr.raw.family);
    if (s == NULL) {
        SECU_PrintError(progName, "error creating socket");
        error = 1;
        goto done;
    }

    opt.option = PR_SockOpt_Nonblocking;
    opt.value.non_blocking = PR_TRUE; /* default */
    if (serverCertAuth.testFreshStatusFromSideChannel) {
        opt.value.non_blocking = PR_FALSE;
    }
    status = PR_SetSocketOption(s, &opt);
    if (status != PR_SUCCESS) {
        SECU_PrintError(progName, "error setting socket options");
        error = 1;
        goto done;
    }

    s = SSL_ImportFD(NULL, s);
    if (s == NULL) {
        SECU_PrintError(progName, "error importing socket");
        error = 1;
        goto done;
    }

    SSL_SetPKCS11PinArg(s, &pwdata);

    rv = SSL_OptionSet(s, SSL_SECURITY, 1);
    if (rv != SECSuccess) {
        SECU_PrintError(progName, "error enabling socket");
        error = 1;
        goto done;
    }

    rv = SSL_OptionSet(s, SSL_HANDSHAKE_AS_CLIENT, 1);
    if (rv != SECSuccess) {
        SECU_PrintError(progName, "error enabling client handshake");
        error = 1;
        goto done;
    }

    /* all SSL3 cipher suites are enabled by default. */
    if (cipherString) {
        char *cstringSaved = cipherString;
        int ndx;

        while (0 != (ndx = *cipherString++)) {
            int cipher = 0;

            if (ndx == ':') {
                int ctmp = 0;

                HEXCHAR_TO_INT(*cipherString, ctmp)
                cipher |= (ctmp << 12);
                cipherString++;
                HEXCHAR_TO_INT(*cipherString, ctmp)
                cipher |= (ctmp << 8);
                cipherString++;
                HEXCHAR_TO_INT(*cipherString, ctmp)
                cipher |= (ctmp << 4);
                cipherString++;
                HEXCHAR_TO_INT(*cipherString, ctmp)
                cipher |= ctmp;
                cipherString++;
            } else {
                if (!isalpha(ndx))
                    Usage(progName);
                ndx = tolower(ndx) - 'a';
                if (ndx < PR_ARRAY_SIZE(ssl3CipherSuites)) {
                    cipher = ssl3CipherSuites[ndx];
                }
            }
            if (cipher > 0) {
                SECStatus status;
                status = SSL_CipherPrefSet(s, cipher, SSL_ALLOWED);
                if (status != SECSuccess)
                    SECU_PrintError(progName, "SSL_CipherPrefSet()");
            } else {
                Usage(progName);
            }
        }
        PORT_Free(cstringSaved);
    }

    rv = SSL_VersionRangeSet(s, &enabledVersions);
    if (rv != SECSuccess) {
        SECU_PrintError(progName, "error setting SSL/TLS version range ");
        error = 1;
        goto done;
    }

    /* disable SSL socket locking */
    rv = SSL_OptionSet(s, SSL_NO_LOCKS, disableLocking);
    if (rv != SECSuccess) {
        SECU_PrintError(progName, "error disabling SSL socket locking");
        error = 1;
        goto done;
    }

    /* enable Session Ticket extension. */
    rv = SSL_OptionSet(s, SSL_ENABLE_SESSION_TICKETS, enableSessionTickets);
    if (rv != SECSuccess) {
        SECU_PrintError(progName, "error enabling Session Ticket extension");
        error = 1;
        goto done;
    }

    /* enable compression. */
    rv = SSL_OptionSet(s, SSL_ENABLE_DEFLATE, enableCompression);
    if (rv != SECSuccess) {
        SECU_PrintError(progName, "error enabling compression");
        error = 1;
        goto done;
    }

    /* enable false start. */
    rv = SSL_OptionSet(s, SSL_ENABLE_FALSE_START, enableFalseStart);
    if (rv != SECSuccess) {
        SECU_PrintError(progName, "error enabling false start");
        error = 1;
        goto done;
    }

    if (forceFallbackSCSV) {
        rv = SSL_OptionSet(s, SSL_ENABLE_FALLBACK_SCSV, PR_TRUE);
        if (rv != SECSuccess) {
            SECU_PrintError(progName, "error forcing fallback scsv");
            error = 1;
            goto done;
        }
    }

    /* enable cert status (OCSP stapling). */
    rv = SSL_OptionSet(s, SSL_ENABLE_OCSP_STAPLING, enableCertStatus);
    if (rv != SECSuccess) {
        SECU_PrintError(progName, "error enabling cert status (OCSP stapling)");
        error = 1;
        goto done;
    }

    /* enable extended master secret mode */
    if (enableExtendedMasterSecret) {
        rv = SSL_OptionSet(s, SSL_ENABLE_EXTENDED_MASTER_SECRET, PR_TRUE);
        if (rv != SECSuccess) {
            SECU_PrintError(progName, "error enabling extended master secret");
            error = 1;
            goto done;
        }
    }

    /* enable 0-RTT (TLS 1.3 only) */
    if (enableZeroRtt) {
        rv = SSL_OptionSet(s, SSL_ENABLE_0RTT_DATA, PR_TRUE);
        if (rv != SECSuccess) {
            SECU_PrintError(progName, "error enabling 0-RTT");
            error = 1;
            goto done;
        }
    }

    /* require the use of fixed finite-field DH groups */
    if (requireDHNamedGroups) {
        rv = SSL_OptionSet(s, SSL_REQUIRE_DH_NAMED_GROUPS, PR_TRUE);
        if (rv != SECSuccess) {
            SECU_PrintError(progName, "error in requiring the use of fixed finite-field DH groups");
            error = 1;
            goto done;
        }
    }

    /* enable Signed Certificate Timestamps. */
    rv = SSL_OptionSet(s, SSL_ENABLE_SIGNED_CERT_TIMESTAMPS,
                       enableSignedCertTimestamps);
    if (rv != SECSuccess) {
        SECU_PrintError(progName, "error enabling signed cert timestamps");
        error = 1;
        goto done;
    }

    if (enabledGroups) {
        rv = SSL_NamedGroupConfig(s, enabledGroups, enabledGroupsCount);
        if (rv < 0) {
            SECU_PrintError(progName, "SSL_NamedGroupConfig failed");
            error = 1;
            goto done;
        }
    }

    serverCertAuth.dbHandle = CERT_GetDefaultCertDB();

    SSL_AuthCertificateHook(s, ownAuthCertificate, &serverCertAuth);
    if (override) {
        SSL_BadCertHook(s, ownBadCertHandler, NULL);
    }
    SSL_GetClientAuthDataHook(s, own_GetClientAuthData, (void *)nickname);
    SSL_HandshakeCallback(s, handshakeCallback, hs2SniHostName);
    if (hs1SniHostName) {
        SSL_SetURL(s, hs1SniHostName);
    } else {
        SSL_SetURL(s, host);
    }

    /* Try to connect to the server */
    status = PR_Connect(s, &addr, PR_INTERVAL_NO_TIMEOUT);
    if (status != PR_SUCCESS) {
        if (PR_GetError() == PR_IN_PROGRESS_ERROR) {
            if (verbose)
                SECU_PrintError(progName, "connect");
            milliPause(50 * multiplier);
            pollset[SSOCK_FD].in_flags = PR_POLL_WRITE | PR_POLL_EXCEPT;
            pollset[SSOCK_FD].out_flags = 0;
            pollset[SSOCK_FD].fd = s;
            while (1) {
                FPRINTF(stderr,
                        "%s: about to call PR_Poll for connect completion!\n",
                        progName);
                filesReady = PR_Poll(pollset, 1, PR_INTERVAL_NO_TIMEOUT);
                if (filesReady < 0) {
                    SECU_PrintError(progName, "unable to connect (poll)");
                    error = 1;
                    goto done;
                }
                FPRINTF(stderr,
                        "%s: PR_Poll returned 0x%02x for socket out_flags.\n",
                        progName, pollset[SSOCK_FD].out_flags);
                if (filesReady == 0) { /* shouldn't happen! */
                    FPRINTF(stderr, "%s: PR_Poll returned zero!\n", progName);
                    error = 1;
                    goto done;
                }
                status = PR_GetConnectStatus(pollset);
                if (status == PR_SUCCESS) {
                    break;
                }
                if (PR_GetError() != PR_IN_PROGRESS_ERROR) {
                    SECU_PrintError(progName, "unable to connect (poll)");
                    error = 1;
                    goto done;
                }
                SECU_PrintError(progName, "poll");
                milliPause(50 * multiplier);
            }
        } else {
            SECU_PrintError(progName, "unable to connect");
            error = 1;
            goto done;
        }
    }

    pollset[SSOCK_FD].fd = s;
    pollset[SSOCK_FD].in_flags = PR_POLL_EXCEPT |
                                 (clientSpeaksFirst ? 0 : PR_POLL_READ);
    pollset[STDIN_FD].fd = PR_GetSpecialFD(PR_StandardInput);
    if (!REQUEST_WAITING) {
        pollset[STDIN_FD].in_flags = PR_POLL_READ;
        npds = 2;
    } else {
        npds = 1;
    }
    std_out = PR_GetSpecialFD(PR_StandardOutput);

#if defined(WIN32) || defined(OS2)
    /* PR_Poll cannot be used with stdin on Windows or OS/2.  (sigh).
    ** But use of PR_Poll and non-blocking sockets is a major feature
    ** of this program.  So, we simulate a pollable stdin with a
    ** TCP socket pair and a  thread that reads stdin and writes to
    ** that socket pair.
    */
    {
        PRFileDesc *fds[2];
        PRThread *thread;

        int nspr_rv = PR_NewTCPSocketPair(fds);
        if (nspr_rv != PR_SUCCESS) {
            SECU_PrintError(progName, "PR_NewTCPSocketPair failed");
            error = 1;
            goto done;
        }
        pollset[STDIN_FD].fd = fds[1];

        thread = PR_CreateThread(PR_USER_THREAD, thread_main, fds[0],
                                 PR_PRIORITY_NORMAL, PR_GLOBAL_THREAD,
                                 PR_UNJOINABLE_THREAD, 0);
        if (!thread) {
            SECU_PrintError(progName, "PR_CreateThread failed");
            error = 1;
            goto done;
        }
    }
#endif

    if (serverCertAuth.testFreshStatusFromSideChannel) {
        SSL_ForceHandshake(s);
        error = serverCertAuth.sideChannelRevocationTestResultCode;
        goto done;
    }

    /*
    ** Select on stdin and on the socket. Write data from stdin to
    ** socket, read data from socket and write to stdout.
    */
    FPRINTF(stderr, "%s: ready...\n", progName);
    while ((pollset[SSOCK_FD].in_flags | pollset[STDIN_FD].in_flags) ||
           REQUEST_WAITING) {
        char buf[4000]; /* buffer for stdin */
        int nb;         /* num bytes read from stdin. */

        rv = restartHandshakeAfterServerCertIfNeeded(s, &serverCertAuth,
                                                     override);
        if (rv != SECSuccess) {
            error = EXIT_CODE_HANDSHAKE_FAILED;
            SECU_PrintError(progName, "authentication of server cert failed");
            goto done;
        }

        pollset[SSOCK_FD].out_flags = 0;
        pollset[STDIN_FD].out_flags = 0;

        FPRINTF(stderr, "%s: about to call PR_Poll !\n", progName);
        filesReady = PR_Poll(pollset, npds, PR_INTERVAL_NO_TIMEOUT);
        if (filesReady < 0) {
            SECU_PrintError(progName, "select failed");
            error = 1;
            goto done;
        }
        if (filesReady == 0) { /* shouldn't happen! */
            FPRINTF(stderr, "%s: PR_Poll returned zero!\n", progName);
            error = 1;
            goto done;
        }
        FPRINTF(stderr, "%s: PR_Poll returned!\n", progName);
        if (pollset[STDIN_FD].in_flags) {
            FPRINTF(stderr,
                    "%s: PR_Poll returned 0x%02x for stdin out_flags.\n",
                    progName, pollset[STDIN_FD].out_flags);
        }
        if (pollset[SSOCK_FD].in_flags) {
            FPRINTF(stderr,
                    "%s: PR_Poll returned 0x%02x for socket out_flags.\n",
                    progName, pollset[SSOCK_FD].out_flags);
        }
        if (REQUEST_WAITING) {
            error = writeBytesToServer(s, requestString, requestStringLen);
            if (error) {
                goto done;
            }
            requestSent = PR_TRUE;
            pollset[SSOCK_FD].in_flags = PR_POLL_READ;
        }
        if (pollset[STDIN_FD].out_flags & PR_POLL_READ) {
            /* Read from stdin and write to socket */
            nb = PR_Read(pollset[STDIN_FD].fd, buf, sizeof(buf));
            FPRINTF(stderr, "%s: stdin read %d bytes\n", progName, nb);
            if (nb < 0) {
                if (PR_GetError() != PR_WOULD_BLOCK_ERROR) {
                    SECU_PrintError(progName, "read from stdin failed");
                    error = 1;
                    break;
                }
            } else if (nb == 0) {
                /* EOF on stdin, stop polling stdin for read. */
                pollset[STDIN_FD].in_flags = 0;
            } else {
                error = writeBytesToServer(s, buf, nb);
                if (error) {
                    goto done;
                }
                pollset[SSOCK_FD].in_flags = PR_POLL_READ;
            }
        }

        if (pollset[SSOCK_FD].in_flags) {
            FPRINTF(stderr,
                    "%s: PR_Poll returned 0x%02x for socket out_flags.\n",
                    progName, pollset[SSOCK_FD].out_flags);
        }
        if ((pollset[SSOCK_FD].out_flags & PR_POLL_READ) ||
            (pollset[SSOCK_FD].out_flags & PR_POLL_ERR)
#ifdef PR_POLL_HUP
            || (pollset[SSOCK_FD].out_flags & PR_POLL_HUP)
#endif
                ) {
            /* Read from socket and write to stdout */
            nb = PR_Recv(pollset[SSOCK_FD].fd, buf, sizeof buf, 0, maxInterval);
            FPRINTF(stderr, "%s: Read from server %d bytes\n", progName, nb);
            if (nb < 0) {
                if (PR_GetError() != PR_WOULD_BLOCK_ERROR) {
                    SECU_PrintError(progName, "read from socket failed");
                    error = 1;
                    goto done;
                }
            } else if (nb == 0) {
                /* EOF from socket... stop polling socket for read */
                pollset[SSOCK_FD].in_flags = 0;
            } else {
                if (skipProtoHeader != PR_TRUE || wrStarted == PR_TRUE) {
                    PR_Write(std_out, buf, nb);
                } else {
                    separateReqHeader(std_out, buf, nb, &wrStarted,
                                      &headerSeparatorPtrnId);
                }
                if (verbose)
                    fputs("\n\n", stderr);
            }
        }
        milliPause(50 * multiplier);
    }

done:
    if (s) {
        PR_Close(s);
    }

    return error;
}

PRInt32
ReadFile(const char *filename, char **data)
{
    char *ret = NULL;
    char buf[8192];
    unsigned int len = 0;
    PRStatus rv;

    PRFileDesc *fd = PR_Open(filename, PR_RDONLY, 0);
    if (!fd)
        return -1;

    for (;;) {
        rv = PR_Read(fd, buf, sizeof(buf));
        if (rv < 0) {
            PR_Free(ret);
            return rv;
        }

        if (!rv)
            break;

        ret = PR_Realloc(ret, len + rv);
        if (!ret) {
            return -1;
        }
        PORT_Memcpy(ret + len, buf, rv);
        len += rv;
    }

    *data = ret;
    return len;
}

int
main(int argc, char **argv)
{
    PLOptState *optstate;
    PLOptStatus optstatus;
    PRStatus status;
    PRStatus prStatus;
    int error = 0;
    char *tmp;
    SECStatus rv;
    char *certDir = NULL;
    PRBool openDB = PR_TRUE;
    PRBool loadDefaultRootCAs = PR_FALSE;
    char *rootModule = NULL;
    int numConnections = 1;
    PRFileDesc *s = NULL;

    serverCertAuth.shouldPause = PR_TRUE;
    serverCertAuth.isPaused = PR_FALSE;
    serverCertAuth.dbHandle = NULL;
    serverCertAuth.testFreshStatusFromSideChannel = PR_FALSE;
    serverCertAuth.sideChannelRevocationTestResultCode = EXIT_CODE_HANDSHAKE_FAILED;
    serverCertAuth.requireDataForIntermediates = PR_FALSE;
    serverCertAuth.allowOCSPSideChannelData = PR_TRUE;
    serverCertAuth.allowCRLSideChannelData = PR_TRUE;

    progName = strrchr(argv[0], '/');
    if (!progName)
        progName = strrchr(argv[0], '\\');
    progName = progName ? progName + 1 : argv[0];

    tmp = PR_GetEnvSecure("NSS_DEBUG_TIMEOUT");
    if (tmp && tmp[0]) {
        int sec = PORT_Atoi(tmp);
        if (sec > 0) {
            maxInterval = PR_SecondsToInterval(sec);
        }
    }

    SSL_VersionRangeGetSupported(ssl_variant_stream, &enabledVersions);

    /* XXX: 'B' was used in the past but removed in 3.28,
     *      please leave some time before resuing it. */
    optstate = PL_CreateOptState(argc, argv,
                                 "46A:CDFGHI:KL:M:OR:STUV:W:YZa:bc:d:fgh:m:n:op:qr:st:uvw:z");
    while ((optstatus = PL_GetNextOpt(optstate)) == PL_OPT_OK) {
        switch (optstate->option) {
            case '?':
            default:
                Usage(progName);
                break;

            case '4':
                allowIPv6 = PR_FALSE;
                if (!allowIPv4)
                    Usage(progName);
                break;
            case '6':
                allowIPv4 = PR_FALSE;
                if (!allowIPv6)
                    Usage(progName);
                break;

            case 'A':
                requestStringLen = ReadFile(optstate->value, &requestString);
                if (requestStringLen < 0) {
                    fprintf(stderr, "Couldn't read file %s\n", optstate->value);
                    exit(1);
                }
                break;

            case 'C':
                ++dumpServerChain;
                break;

            case 'D':
                openDB = PR_FALSE;
                break;

            case 'F':
                if (serverCertAuth.testFreshStatusFromSideChannel) {
                    /* parameter given twice or more */
                    serverCertAuth.requireDataForIntermediates = PR_TRUE;
                }
                serverCertAuth.testFreshStatusFromSideChannel = PR_TRUE;
                break;

            case 'G':
                enableExtendedMasterSecret = PR_TRUE;
                break;

            case 'H':
                requireDHNamedGroups = PR_TRUE;
                break;

            case 'O':
                serverCertAuth.shouldPause = PR_FALSE;
                break;

            case 'K':
                forceFallbackSCSV = PR_TRUE;
                break;

            case 'L':
                numConnections = atoi(optstate->value);
                break;

            case 'M':
                switch (atoi(optstate->value)) {
                    case 1:
                        serverCertAuth.allowOCSPSideChannelData = PR_TRUE;
                        serverCertAuth.allowCRLSideChannelData = PR_FALSE;
                        break;
                    case 2:
                        serverCertAuth.allowOCSPSideChannelData = PR_FALSE;
                        serverCertAuth.allowCRLSideChannelData = PR_TRUE;
                        break;
                    case 0:
                    default:
                        serverCertAuth.allowOCSPSideChannelData = PR_TRUE;
                        serverCertAuth.allowCRLSideChannelData = PR_TRUE;
                        break;
                };
                break;

            case 'R':
                rootModule = PORT_Strdup(optstate->value);
                break;

            case 'S':
                skipProtoHeader = PR_TRUE;
                break;

            case 'T':
                enableCertStatus = 1;
                break;

            case 'U':
                enableSignedCertTimestamps = 1;
                break;

            case 'V':
                if (SECU_ParseSSLVersionRangeString(optstate->value,
                                                    enabledVersions, &enabledVersions) !=
                    SECSuccess) {
                    fprintf(stderr, "Bad version specified.\n");
                    Usage(progName);
                }
                break;

            case 'Y':
                PrintCipherUsage(progName);
                exit(0);
                break;

            case 'Z':
                enableZeroRtt = PR_TRUE;
                break;

            case 'a':
                if (!hs1SniHostName) {
                    hs1SniHostName = PORT_Strdup(optstate->value);
                } else if (!hs2SniHostName) {
                    hs2SniHostName = PORT_Strdup(optstate->value);
                } else {
                    Usage(progName);
                }
                break;

            case 'b':
                loadDefaultRootCAs = PR_TRUE;
                break;

            case 'c':
                cipherString = PORT_Strdup(optstate->value);
                break;

            case 'g':
                enableFalseStart = 1;
                break;

            case 'd':
                certDir = PORT_Strdup(optstate->value);
                break;

            case 'f':
                clientSpeaksFirst = PR_TRUE;
                break;

            case 'h':
                host = PORT_Strdup(optstate->value);
                break;

            case 'm':
                multiplier = atoi(optstate->value);
                if (multiplier < 0)
                    multiplier = 0;
                break;

            case 'n':
                nickname = PORT_Strdup(optstate->value);
                break;

            case 'o':
                override = 1;
                break;

            case 'p':
                portno = (PRUint16)atoi(optstate->value);
                break;

            case 'q':
                pingServerFirst = PR_TRUE;
                break;

            case 's':
                disableLocking = 1;
                break;

            case 't':
                pingTimeoutSeconds = atoi(optstate->value);
                break;

            case 'u':
                enableSessionTickets = PR_TRUE;
                break;

            case 'v':
                verbose++;
                break;

            case 'r':
                renegotiationsToDo = atoi(optstate->value);
                break;

            case 'w':
                pwdata.source = PW_PLAINTEXT;
                pwdata.data = PORT_Strdup(optstate->value);
                break;

            case 'W':
                pwdata.source = PW_FROMFILE;
                pwdata.data = PORT_Strdup(optstate->value);
                break;

            case 'z':
                enableCompression = 1;
                break;

            case 'I':
                rv = parseGroupList(optstate->value, &enabledGroups, &enabledGroupsCount);
                if (rv != SECSuccess) {
                    PL_DestroyOptState(optstate);
                    fprintf(stderr, "Bad group specified.\n");
                    Usage(progName);
                }
                break;
        }
    }

    PL_DestroyOptState(optstate);

    if (optstatus == PL_OPT_BAD) {
        Usage(progName);
    }

    if (!host || !portno) {
        fprintf(stderr, "%s: parameters -h and -p are mandatory\n", progName);
        Usage(progName);
    }

    if (serverCertAuth.testFreshStatusFromSideChannel &&
        serverCertAuth.shouldPause) {
        fprintf(stderr, "%s: -F requires the use of -O\n", progName);
        exit(1);
    }

    if (certDir && !openDB) {
        fprintf(stderr, "%s: Cannot combine parameters -D and -d\n", progName);
        exit(1);
    }

    if (rootModule && loadDefaultRootCAs) {
        fprintf(stderr, "%s: Cannot combine parameters -b and -R\n", progName);
        exit(1);
    }

    PR_Init(PR_SYSTEM_THREAD, PR_PRIORITY_NORMAL, 1);

    PK11_SetPasswordFunc(SECU_GetModulePassword);

    status = PR_StringToNetAddr(host, &addr);
    if (status == PR_SUCCESS) {
        addr.inet.port = PR_htons(portno);
    } else {
        /* Lookup host */
        PRAddrInfo *addrInfo;
        void *enumPtr = NULL;

        addrInfo = PR_GetAddrInfoByName(host, PR_AF_UNSPEC,
                                        PR_AI_ADDRCONFIG | PR_AI_NOCANONNAME);
        if (!addrInfo) {
            SECU_PrintError(progName, "error looking up host");
            error = 1;
            goto done;
        }
        for (;;) {
            enumPtr = PR_EnumerateAddrInfo(enumPtr, addrInfo, portno, &addr);
            if (enumPtr == NULL)
                break;
            if (addr.raw.family == PR_AF_INET && allowIPv4)
                break;
            if (addr.raw.family == PR_AF_INET6 && allowIPv6)
                break;
        }
        PR_FreeAddrInfo(addrInfo);
        if (enumPtr == NULL) {
            SECU_PrintError(progName, "error looking up host address");
            error = 1;
            goto done;
        }
    }

    printHostNameAndAddr(host, &addr);

    if (!certDir) {
        certDir = SECU_DefaultSSLDir(); /* Look in $SSL_DIR */
        certDir = SECU_ConfigDirectory(certDir);
    } else {
        char *certDirTmp = certDir;
        certDir = SECU_ConfigDirectory(certDirTmp);
        PORT_Free(certDirTmp);
    }

    if (pingServerFirst) {
        int iter = 0;
        PRErrorCode err;

        int max_attempts = MAX_WAIT_FOR_SERVER;
        if (pingTimeoutSeconds >= 0) {
            /* If caller requested a timeout, let's try just twice. */
            max_attempts = 2;
        }
        do {
            PRIntervalTime timeoutInterval = PR_INTERVAL_NO_TIMEOUT;
            s = PR_OpenTCPSocket(addr.raw.family);
            if (s == NULL) {
                SECU_PrintError(progName, "Failed to create a TCP socket");
                error = 1;
                goto done;
            }
            opt.option = PR_SockOpt_Nonblocking;
            opt.value.non_blocking = PR_FALSE;
            prStatus = PR_SetSocketOption(s, &opt);
            if (prStatus != PR_SUCCESS) {
                SECU_PrintError(progName,
                                "Failed to set blocking socket option");
                error = 1;
                goto done;
            }
            if (pingTimeoutSeconds >= 0) {
                timeoutInterval = PR_SecondsToInterval(pingTimeoutSeconds);
            }
            prStatus = PR_Connect(s, &addr, timeoutInterval);
            if (prStatus == PR_SUCCESS) {
                PR_Shutdown(s, PR_SHUTDOWN_BOTH);
                goto done;
            }
            err = PR_GetError();
            if ((err != PR_CONNECT_REFUSED_ERROR) &&
                (err != PR_CONNECT_RESET_ERROR)) {
                SECU_PrintError(progName, "TCP Connection failed");
                error = 1;
                goto done;
            }
            PR_Close(s);
            s = NULL;
            PR_Sleep(PR_MillisecondsToInterval(WAIT_INTERVAL));
        } while (++iter < max_attempts);
        SECU_PrintError(progName,
                        "Client timed out while waiting for connection to server");
        error = 1;
        goto done;
    }

    /* open the cert DB, the key DB, and the secmod DB. */
    if (openDB) {
        rv = NSS_Init(certDir);
        if (rv != SECSuccess) {
            SECU_PrintError(progName, "unable to open cert database");
            error = 1;
            goto done;
        }
    } else {
        rv = NSS_NoDB_Init(NULL);
        if (rv != SECSuccess) {
            SECU_PrintError(progName, "failed to initialize NSS");
            error = 1;
            goto done;
        }
    }

    if (loadDefaultRootCAs) {
        SECMOD_AddNewModule("Builtins",
                            DLL_PREFIX "nssckbi." DLL_SUFFIX, 0, 0);
    } else if (rootModule) {
        SECMOD_AddNewModule("Builtins", rootModule, 0, 0);
    }

    /* all SSL3 cipher suites are enabled by default. */
    if (cipherString) {
        /* disable all the ciphers, then enable the ones we want. */
        disableAllSSLCiphers();
    }

    while (numConnections--) {
        error = run_client();
        if (error) {
            goto done;
        }
    }

done:
    if (s) {
        PR_Close(s);
    }

    if (hs1SniHostName) {
        PORT_Free(hs1SniHostName);
    }
    if (hs2SniHostName) {
        PORT_Free(hs2SniHostName);
    }
    if (nickname) {
        PORT_Free(nickname);
    }
    if (pwdata.data) {
        PORT_Free(pwdata.data);
    }
    PORT_Free(host);
    PORT_Free(requestString);

    if (enabledGroups) {
        PORT_Free(enabledGroups);
    }
    if (NSS_IsInitialized()) {
        SSL_ClearSessionCache();
        if (NSS_Shutdown() != SECSuccess) {
            error = 1;
        }
    }

    FPRINTF(stderr, "tstclnt: exiting with return code %d\n", error);
    PR_Cleanup();
    return error;
}
