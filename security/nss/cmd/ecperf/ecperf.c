/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "blapi.h"
#include "ec.h"
#include "ecl-curve.h"
#include "prprf.h"
#include "basicutil.h"
#include "pkcs11.h"
#include "nspr.h"
#include "secutil.h"
#include <stdio.h>

#define __PASTE(x, y) x##y

/*
 * Get the NSS specific PKCS #11 function names.
 */
#undef CK_PKCS11_FUNCTION_INFO
#undef CK_NEED_ARG_LIST

#define CK_EXTERN extern
#define CK_PKCS11_FUNCTION_INFO(func) \
    CK_RV __PASTE(NS, func)
#define CK_NEED_ARG_LIST 1

#include "pkcs11f.h"

/* mapping between ECCurveName enum and pointers to ECCurveParams */
static SECOidTag ecCurve_oid_map[] = {
    SEC_OID_UNKNOWN,                /* ECCurve_noName */
    SEC_OID_ANSIX962_EC_PRIME192V1, /* ECCurve_NIST_P192 */
    SEC_OID_SECG_EC_SECP224R1,      /* ECCurve_NIST_P224 */
    SEC_OID_ANSIX962_EC_PRIME256V1, /* ECCurve_NIST_P256 */
    SEC_OID_SECG_EC_SECP384R1,      /* ECCurve_NIST_P384 */
    SEC_OID_SECG_EC_SECP521R1,      /* ECCurve_NIST_P521 */
    SEC_OID_SECG_EC_SECT163K1,      /* ECCurve_NIST_K163 */
    SEC_OID_SECG_EC_SECT163R1,      /* ECCurve_NIST_B163 */
    SEC_OID_SECG_EC_SECT233K1,      /* ECCurve_NIST_K233 */
    SEC_OID_SECG_EC_SECT233R1,      /* ECCurve_NIST_B233 */
    SEC_OID_SECG_EC_SECT283K1,      /* ECCurve_NIST_K283 */
    SEC_OID_SECG_EC_SECT283R1,      /* ECCurve_NIST_B283 */
    SEC_OID_SECG_EC_SECT409K1,      /* ECCurve_NIST_K409 */
    SEC_OID_SECG_EC_SECT409R1,      /* ECCurve_NIST_B409 */
    SEC_OID_SECG_EC_SECT571K1,      /* ECCurve_NIST_K571 */
    SEC_OID_SECG_EC_SECT571R1,      /* ECCurve_NIST_B571 */
    SEC_OID_ANSIX962_EC_PRIME192V2,
    SEC_OID_ANSIX962_EC_PRIME192V3,
    SEC_OID_ANSIX962_EC_PRIME239V1,
    SEC_OID_ANSIX962_EC_PRIME239V2,
    SEC_OID_ANSIX962_EC_PRIME239V3,
    SEC_OID_ANSIX962_EC_C2PNB163V1,
    SEC_OID_ANSIX962_EC_C2PNB163V2,
    SEC_OID_ANSIX962_EC_C2PNB163V3,
    SEC_OID_ANSIX962_EC_C2PNB176V1,
    SEC_OID_ANSIX962_EC_C2TNB191V1,
    SEC_OID_ANSIX962_EC_C2TNB191V2,
    SEC_OID_ANSIX962_EC_C2TNB191V3,
    SEC_OID_ANSIX962_EC_C2PNB208W1,
    SEC_OID_ANSIX962_EC_C2TNB239V1,
    SEC_OID_ANSIX962_EC_C2TNB239V2,
    SEC_OID_ANSIX962_EC_C2TNB239V3,
    SEC_OID_ANSIX962_EC_C2PNB272W1,
    SEC_OID_ANSIX962_EC_C2PNB304W1,
    SEC_OID_ANSIX962_EC_C2TNB359V1,
    SEC_OID_ANSIX962_EC_C2PNB368W1,
    SEC_OID_ANSIX962_EC_C2TNB431R1,
    SEC_OID_SECG_EC_SECP112R1,
    SEC_OID_SECG_EC_SECP112R2,
    SEC_OID_SECG_EC_SECP128R1,
    SEC_OID_SECG_EC_SECP128R2,
    SEC_OID_SECG_EC_SECP160K1,
    SEC_OID_SECG_EC_SECP160R1,
    SEC_OID_SECG_EC_SECP160R2,
    SEC_OID_SECG_EC_SECP192K1,
    SEC_OID_SECG_EC_SECP224K1,
    SEC_OID_SECG_EC_SECP256K1,
    SEC_OID_SECG_EC_SECT113R1,
    SEC_OID_SECG_EC_SECT113R2,
    SEC_OID_SECG_EC_SECT131R1,
    SEC_OID_SECG_EC_SECT131R2,
    SEC_OID_SECG_EC_SECT163R1,
    SEC_OID_SECG_EC_SECT193R1,
    SEC_OID_SECG_EC_SECT193R2,
    SEC_OID_SECG_EC_SECT239K1,
    SEC_OID_UNKNOWN, /* ECCurve_WTLS_1 */
    SEC_OID_UNKNOWN, /* ECCurve_WTLS_8 */
    SEC_OID_UNKNOWN, /* ECCurve_WTLS_9 */
    SEC_OID_CURVE25519,
    SEC_OID_UNKNOWN /* ECCurve_pastLastCurve */
};

typedef SECStatus (*op_func)(void *, void *, void *);
typedef SECStatus (*pk11_op_func)(CK_SESSION_HANDLE, void *, void *, void *);

typedef struct ThreadDataStr {
    op_func op;
    void *p1;
    void *p2;
    void *p3;
    int iters;
    PRLock *lock;
    int count;
    SECStatus status;
    int isSign;
} ThreadData;

void
PKCS11Thread(void *data)
{
    ThreadData *threadData = (ThreadData *)data;
    pk11_op_func op = (pk11_op_func)threadData->op;
    int iters = threadData->iters;
    unsigned char sigData[256];
    SECItem sig;
    CK_SESSION_HANDLE session;
    CK_RV crv;

    threadData->status = SECSuccess;
    threadData->count = 0;

    /* get our thread's session */
    PR_Lock(threadData->lock);
    crv = NSC_OpenSession(1, CKF_SERIAL_SESSION, NULL, 0, &session);
    PR_Unlock(threadData->lock);
    if (crv != CKR_OK) {
        return;
    }

    if (threadData->isSign) {
        sig.data = sigData;
        sig.len = sizeof(sigData);
        threadData->p2 = (void *)&sig;
    }

    while (iters--) {
        threadData->status = (*op)(session, threadData->p1,
                                   threadData->p2, threadData->p3);
        if (threadData->status != SECSuccess) {
            break;
        }
        threadData->count++;
    }
    return;
}

void
genericThread(void *data)
{
    ThreadData *threadData = (ThreadData *)data;
    int iters = threadData->iters;
    unsigned char sigData[256];
    SECItem sig;

    threadData->status = SECSuccess;
    threadData->count = 0;

    if (threadData->isSign) {
        sig.data = sigData;
        sig.len = sizeof(sigData);
        threadData->p2 = (void *)&sig;
    }

    while (iters--) {
        threadData->status = (*threadData->op)(threadData->p1,
                                               threadData->p2, threadData->p3);
        if (threadData->status != SECSuccess) {
            break;
        }
        threadData->count++;
    }
    return;
}

/* Time iter repetitions of operation op. */
SECStatus
M_TimeOperation(void (*threadFunc)(void *),
                op_func opfunc, char *op, void *param1, void *param2,
                void *param3, int iters, int numThreads, PRLock *lock,
                CK_SESSION_HANDLE session, int isSign, double *rate)
{
    double dUserTime;
    int i, total;
    PRIntervalTime startTime, totalTime;
    PRThread **threadIDs;
    ThreadData *threadData;
    pk11_op_func pk11_op = (pk11_op_func)opfunc;
    SECStatus rv;

    /* verify operation works before testing performance */
    if (session) {
        rv = (*pk11_op)(session, param1, param2, param3);
    } else {
        rv = (*opfunc)(param1, param2, param3);
    }
    if (rv != SECSuccess) {
        SECU_PrintError("Error:", op);
        return rv;
    }

    /* get Data structures */
    threadIDs = (PRThread **)PORT_Alloc(numThreads * sizeof(PRThread *));
    threadData = (ThreadData *)PORT_Alloc(numThreads * sizeof(ThreadData));

    startTime = PR_Now();
    if (numThreads == 1) {
        for (i = 0; i < iters; i++) {
            if (session) {
                rv = (*pk11_op)(session, param1, param2, param3);
            } else {
                rv = (*opfunc)(param1, param2, param3);
            }
            if (rv != SECSuccess) {
                PORT_Free(threadIDs);
                PORT_Free(threadData);
                SECU_PrintError("Error:", op);
                return rv;
            }
        }
        total = iters;
    } else {
        for (i = 0; i < numThreads; i++) {
            threadData[i].op = opfunc;
            threadData[i].p1 = (void *)param1;
            threadData[i].p2 = (void *)param2;
            threadData[i].p3 = (void *)param3;
            threadData[i].iters = iters;
            threadData[i].lock = lock;
            threadData[i].isSign = isSign;
            threadIDs[i] = PR_CreateThread(PR_USER_THREAD, threadFunc,
                                           (void *)&threadData[i], PR_PRIORITY_NORMAL,
                                           PR_GLOBAL_THREAD, PR_JOINABLE_THREAD, 0);
        }

        total = 0;
        for (i = 0; i < numThreads; i++) {
            PR_JoinThread(threadIDs[i]);
            /* check the status */
            total += threadData[i].count;
        }
    }

    totalTime = PR_Now() - startTime;
    /* SecondsToInterval seems to be broken here ... */
    dUserTime = (double)totalTime / (double)1000000;
    if (dUserTime) {
        printf("    %-15s count:%4d sec: %3.2f op/sec: %6.2f\n",
               op, total, dUserTime, (double)total / dUserTime);
        if (rate) {
            *rate = ((double)total) / dUserTime;
        }
    }
    PORT_Free(threadIDs);
    PORT_Free(threadData);

    return SECSuccess;
}

/* Test curve using specific field arithmetic. */
#define ECTEST_NAMED_GFP(name_c, name_v)                                        \
    if (usefreebl) {                                                            \
        printf("Testing %s using freebl implementation...\n", name_c);          \
        rv = ectest_curve_freebl(name_v, iterations, numThreads, ec_field_GFp); \
        if (rv != SECSuccess)                                                   \
            goto cleanup;                                                       \
        printf("... okay.\n");                                                  \
    }                                                                           \
    if (usepkcs11) {                                                            \
        printf("Testing %s using pkcs11 implementation...\n", name_c);          \
        rv = ectest_curve_pkcs11(name_v, iterations, numThreads);               \
        if (rv != SECSuccess)                                                   \
            goto cleanup;                                                       \
        printf("... okay.\n");                                                  \
    }

/* Test curve using specific field arithmetic. */
#define ECTEST_NAMED_CUSTOM(name_c, name_v)                                       \
    if (usefreebl) {                                                              \
        printf("Testing %s using freebl implementation...\n", name_c);            \
        rv = ectest_curve_freebl(name_v, iterations, numThreads, ec_field_plain); \
        if (rv != SECSuccess)                                                     \
            goto cleanup;                                                         \
        printf("... okay.\n");                                                    \
    }                                                                             \
    if (usepkcs11) {                                                              \
        printf("Testing %s using pkcs11 implementation...\n", name_c);            \
        rv = ectest_curve_pkcs11(name_v, iterations, numThreads);                 \
        if (rv != SECSuccess)                                                     \
            goto cleanup;                                                         \
        printf("... okay.\n");                                                    \
    }

#define PK11_SETATTRS(x, id, v, l) \
    (x)->type = (id);              \
    (x)->pValue = (v);             \
    (x)->ulValueLen = (l);

SECStatus
PKCS11_Derive(CK_SESSION_HANDLE session, CK_OBJECT_HANDLE *hKey,
              CK_MECHANISM *pMech, int *dummy)
{
    CK_RV crv;
    CK_OBJECT_HANDLE newKey;
    CK_BBOOL cktrue = CK_TRUE;
    CK_OBJECT_CLASS keyClass = CKO_SECRET_KEY;
    CK_KEY_TYPE keyType = CKK_GENERIC_SECRET;
    CK_ATTRIBUTE keyTemplate[3];
    CK_ATTRIBUTE *attrs = keyTemplate;

    PK11_SETATTRS(attrs, CKA_CLASS, &keyClass, sizeof(keyClass));
    attrs++;
    PK11_SETATTRS(attrs, CKA_KEY_TYPE, &keyType, sizeof(keyType));
    attrs++;
    PK11_SETATTRS(attrs, CKA_DERIVE, &cktrue, 1);
    attrs++;

    crv = NSC_DeriveKey(session, pMech, *hKey, keyTemplate, 3, &newKey);
    if (crv != CKR_OK) {
        printf("Derive Failed CK_RV=0x%x\n", (int)crv);
        return SECFailure;
    }
    return SECSuccess;
}

SECStatus
PKCS11_Sign(CK_SESSION_HANDLE session, CK_OBJECT_HANDLE *hKey,
            SECItem *sig, SECItem *digest)
{
    CK_RV crv;
    CK_MECHANISM mech;
    CK_ULONG sigLen = sig->len;

    mech.mechanism = CKM_ECDSA;
    mech.pParameter = NULL;
    mech.ulParameterLen = 0;

    crv = NSC_SignInit(session, &mech, *hKey);
    if (crv != CKR_OK) {
        printf("Sign Failed CK_RV=0x%x\n", (int)crv);
        return SECFailure;
    }
    crv = NSC_Sign(session, digest->data, digest->len, sig->data, &sigLen);
    if (crv != CKR_OK) {
        printf("Sign Failed CK_RV=0x%x\n", (int)crv);
        return SECFailure;
    }
    sig->len = (unsigned int)sigLen;
    return SECSuccess;
}

SECStatus
PKCS11_Verify(CK_SESSION_HANDLE session, CK_OBJECT_HANDLE *hKey,
              SECItem *sig, SECItem *digest)
{
    CK_RV crv;
    CK_MECHANISM mech;

    mech.mechanism = CKM_ECDSA;
    mech.pParameter = NULL;
    mech.ulParameterLen = 0;

    crv = NSC_VerifyInit(session, &mech, *hKey);
    if (crv != CKR_OK) {
        printf("Verify Failed CK_RV=0x%x\n", (int)crv);
        return SECFailure;
    }
    crv = NSC_Verify(session, digest->data, digest->len, sig->data, sig->len);
    if (crv != CKR_OK) {
        printf("Verify Failed CK_RV=0x%x\n", (int)crv);
        return SECFailure;
    }
    return SECSuccess;
}

static SECStatus
ecName2params(ECCurveName curve, SECKEYECParams *params)
{
    SECOidData *oidData = NULL;

    if ((curve < ECCurve_noName) || (curve > ECCurve_pastLastCurve) ||
        ((oidData = SECOID_FindOIDByTag(ecCurve_oid_map[curve])) == NULL)) {
        PORT_SetError(SEC_ERROR_UNSUPPORTED_ELLIPTIC_CURVE);
        return SECFailure;
    }

    SECITEM_AllocItem(NULL, params, (2 + oidData->oid.len));
    /*
     * params->data needs to contain the ASN encoding of an object ID (OID)
     * representing the named curve. The actual OID is in
     * oidData->oid.data so we simply prepend 0x06 and OID length
     */
    params->data[0] = SEC_ASN1_OBJECT_ID;
    params->data[1] = oidData->oid.len;
    memcpy(params->data + 2, oidData->oid.data, oidData->oid.len);

    return SECSuccess;
}

/* Performs basic tests of elliptic curve cryptography over prime fields.
 * If tests fail, then it prints an error message, aborts, and returns an
 * error code. Otherwise, returns 0. */
SECStatus
ectest_curve_pkcs11(ECCurveName curve, int iterations, int numThreads)
{
    CK_OBJECT_HANDLE ecPriv;
    CK_OBJECT_HANDLE ecPub;
    CK_SESSION_HANDLE session;
    SECItem sig;
    SECItem digest;
    SECKEYECParams ecParams;
    CK_MECHANISM mech;
    CK_ECDH1_DERIVE_PARAMS ecdh_params;
    unsigned char sigData[256];
    unsigned char digestData[20];
    unsigned char pubKeyData[256];
    PRLock *lock = NULL;
    double signRate, deriveRate = 0;
    CK_ATTRIBUTE template;
    SECStatus rv;
    CK_RV crv;

    ecParams.data = NULL;
    ecParams.len = 0;
    rv = ecName2params(curve, &ecParams);
    if (rv != SECSuccess) {
        goto cleanup;
    }

    crv = NSC_OpenSession(1, CKF_SERIAL_SESSION, NULL, 0, &session);
    if (crv != CKR_OK) {
        printf("OpenSession Failed CK_RV=0x%x\n", (int)crv);
        return SECFailure;
    }

    PORT_Memset(digestData, 0xa5, sizeof(digestData));
    digest.data = digestData;
    digest.len = sizeof(digestData);
    sig.data = sigData;
    sig.len = sizeof(sigData);

    template.type = CKA_EC_PARAMS;
    template.pValue = ecParams.data;
    template.ulValueLen = ecParams.len;
    mech.mechanism = CKM_EC_KEY_PAIR_GEN;
    mech.pParameter = NULL;
    mech.ulParameterLen = 0;
    crv = NSC_GenerateKeyPair(session, &mech,
                              &template, 1, NULL, 0, &ecPub, &ecPriv);
    if (crv != CKR_OK) {
        printf("GenerateKeyPair Failed CK_RV=0x%x\n", (int)crv);
        return SECFailure;
    }

    template.type = CKA_EC_POINT;
    template.pValue = pubKeyData;
    template.ulValueLen = sizeof(pubKeyData);
    crv = NSC_GetAttributeValue(session, ecPub, &template, 1);
    if (crv != CKR_OK) {
        printf("GenerateKeyPair Failed CK_RV=0x%x\n", (int)crv);
        return SECFailure;
    }

    ecdh_params.kdf = CKD_NULL;
    ecdh_params.ulSharedDataLen = 0;
    ecdh_params.pSharedData = NULL;
    ecdh_params.ulPublicDataLen = template.ulValueLen;
    ecdh_params.pPublicData = template.pValue;

    mech.mechanism = CKM_ECDH1_DERIVE;
    mech.pParameter = (void *)&ecdh_params;
    mech.ulParameterLen = sizeof(ecdh_params);

    lock = PR_NewLock();

    if (ecCurve_map[curve]->usage & KU_KEY_AGREEMENT) {
        rv = M_TimeOperation(PKCS11Thread, (op_func)PKCS11_Derive, "ECDH_Derive",
                             &ecPriv, &mech, NULL, iterations, numThreads,
                             lock, session, 0, &deriveRate);
        if (rv != SECSuccess) {
            goto cleanup;
        }
    }

    if (ecCurve_map[curve]->usage & KU_DIGITAL_SIGNATURE) {
        rv = M_TimeOperation(PKCS11Thread, (op_func)PKCS11_Sign, "ECDSA_Sign",
                             (void *)&ecPriv, &sig, &digest, iterations, numThreads,
                             lock, session, 1, &signRate);
        if (rv != SECSuccess) {
            goto cleanup;
        }
        printf("        ECDHE max rate = %.2f\n", (deriveRate + signRate) / 4.0);
        /* get a signature */
        rv = PKCS11_Sign(session, &ecPriv, &sig, &digest);
        if (rv != SECSuccess) {
            goto cleanup;
        }
        rv = M_TimeOperation(PKCS11Thread, (op_func)PKCS11_Verify, "ECDSA_Verify",
                             (void *)&ecPub, &sig, &digest, iterations, numThreads,
                             lock, session, 0, NULL);
        if (rv != SECSuccess) {
            goto cleanup;
        }
    }

cleanup:
    if (lock) {
        PR_DestroyLock(lock);
    }
    return rv;
}

SECStatus
ECDH_DeriveWrap(ECPrivateKey *priv, ECPublicKey *pub, int *dummy)
{
    SECItem secret;
    unsigned char secretData[256];
    SECStatus rv;

    secret.data = secretData;
    secret.len = sizeof(secretData);

    rv = ECDH_Derive(&pub->publicValue, &pub->ecParams,
                     &priv->privateValue, 0, &secret);
    SECITEM_FreeItem(&secret, PR_FALSE);
    return rv;
}

/* Performs basic tests of elliptic curve cryptography over prime fields.
 * If tests fail, then it prints an error message, aborts, and returns an
 * error code. Otherwise, returns 0. */
SECStatus
ectest_curve_freebl(ECCurveName curve, int iterations, int numThreads,
                    ECFieldType fieldType)
{
    ECParams ecParams = { 0 };
    ECPrivateKey *ecPriv = NULL;
    ECPublicKey ecPub;
    SECItem sig;
    SECItem digest;
    unsigned char sigData[256];
    unsigned char digestData[20];
    double signRate, deriveRate = 0;
    char genenc[3 + 2 * 2 * MAX_ECKEY_LEN];
    SECStatus rv = SECFailure;
    PLArenaPool *arena;

    arena = PORT_NewArena(DER_DEFAULT_CHUNKSIZE);
    if (!arena) {
        return SECFailure;
    }

    if ((curve < ECCurve_noName) || (curve > ECCurve_pastLastCurve)) {
        PORT_FreeArena(arena, PR_FALSE);
        return SECFailure;
    }

    ecParams.name = curve;
    ecParams.type = ec_params_named;
    ecParams.curveOID.data = NULL;
    ecParams.curveOID.len = 0;
    ecParams.curve.seed.data = NULL;
    ecParams.curve.seed.len = 0;
    ecParams.DEREncoding.data = NULL;
    ecParams.DEREncoding.len = 0;

    ecParams.fieldID.size = ecCurve_map[curve]->size;
    ecParams.fieldID.type = fieldType;
    SECU_HexString2SECItem(arena, &ecParams.fieldID.u.prime, ecCurve_map[curve]->irr);
    SECU_HexString2SECItem(arena, &ecParams.curve.a, ecCurve_map[curve]->curvea);
    SECU_HexString2SECItem(arena, &ecParams.curve.b, ecCurve_map[curve]->curveb);
    genenc[0] = '0';
    genenc[1] = '4';
    genenc[2] = '\0';
    strcat(genenc, ecCurve_map[curve]->genx);
    strcat(genenc, ecCurve_map[curve]->geny);
    SECU_HexString2SECItem(arena, &ecParams.base, genenc);
    SECU_HexString2SECItem(arena, &ecParams.order, ecCurve_map[curve]->order);
    ecParams.cofactor = ecCurve_map[curve]->cofactor;

    PORT_Memset(digestData, 0xa5, sizeof(digestData));
    digest.data = digestData;
    digest.len = sizeof(digestData);
    sig.data = sigData;
    sig.len = sizeof(sigData);

    rv = EC_NewKey(&ecParams, &ecPriv);
    if (rv != SECSuccess) {
        return SECFailure;
    }
    ecPub.ecParams = ecParams;
    ecPub.publicValue = ecPriv->publicValue;

    if (ecCurve_map[curve]->usage & KU_KEY_AGREEMENT) {
        rv = M_TimeOperation(genericThread, (op_func)ECDH_DeriveWrap, "ECDH_Derive",
                             ecPriv, &ecPub, NULL, iterations, numThreads, 0, 0, 0, &deriveRate);
        if (rv != SECSuccess) {
            goto cleanup;
        }
    }

    if (ecCurve_map[curve]->usage & KU_DIGITAL_SIGNATURE) {
        rv = M_TimeOperation(genericThread, (op_func)ECDSA_SignDigest, "ECDSA_Sign",
                             ecPriv, &sig, &digest, iterations, numThreads, 0, 0, 1, &signRate);
        if (rv != SECSuccess)
            goto cleanup;
        printf("        ECDHE max rate = %.2f\n", (deriveRate + signRate) / 4.0);
        rv = ECDSA_SignDigest(ecPriv, &sig, &digest);
        if (rv != SECSuccess) {
            goto cleanup;
        }
        rv = M_TimeOperation(genericThread, (op_func)ECDSA_VerifyDigest, "ECDSA_Verify",
                             &ecPub, &sig, &digest, iterations, numThreads, 0, 0, 0, NULL);
        if (rv != SECSuccess) {
            goto cleanup;
        }
    }

cleanup:
    PORT_FreeArena(arena, PR_FALSE);
    PORT_FreeArena(ecPriv->ecParams.arena, PR_FALSE);
    return rv;
}

/* Prints help information. */
void
printUsage(char *prog)
{
    printf("Usage: %s [-i iterations] [-t threads ] [-ans] [-fp] [-Al]\n"
           "-a: ansi\n-n: nist\n-s: secp\n-f: usefreebl\n-p: usepkcs11\n-A: all\n",
           prog);
}

/* Performs tests of elliptic curve cryptography over prime fields If
 * tests fail, then it prints an error message, aborts, and returns an
 * error code. Otherwise, returns 0. */
int
main(int argv, char **argc)
{
    int ansi = 0;
    int nist = 0;
    int secp = 0;
    int usefreebl = 0;
    int usepkcs11 = 0;
    int i;
    SECStatus rv = SECSuccess;
    int iterations = 100;
    int numThreads = 1;

    const CK_C_INITIALIZE_ARGS pk11args = {
        NULL, NULL, NULL, NULL, CKF_LIBRARY_CANT_CREATE_OS_THREADS,
        (void *)"flags=readOnly,noCertDB,noModDB", NULL
    };

    /* read command-line arguments */
    for (i = 1; i < argv; i++) {
        if (PL_strcasecmp(argc[i], "-i") == 0) {
            i++;
            iterations = atoi(argc[i]);
        } else if (PL_strcasecmp(argc[i], "-t") == 0) {
            i++;
            numThreads = atoi(argc[i]);
        } else if (PL_strcasecmp(argc[i], "-A") == 0) {
            ansi = nist = secp = 1;
            usepkcs11 = usefreebl = 1;
        } else if (PL_strcasecmp(argc[i], "-a") == 0) {
            ansi = 1;
        } else if (PL_strcasecmp(argc[i], "-n") == 0) {
            nist = 1;
        } else if (PL_strcasecmp(argc[i], "-s") == 0) {
            secp = 1;
        } else if (PL_strcasecmp(argc[i], "-p") == 0) {
            usepkcs11 = 1;
        } else if (PL_strcasecmp(argc[i], "-f") == 0) {
            usefreebl = 1;
        } else {
            printUsage(argc[0]);
            return 0;
        }
    }

    if ((ansi | nist | secp) == 0) {
        nist = 1;
    }
    if ((usepkcs11 | usefreebl) == 0) {
        usefreebl = 1;
    }

    rv = RNG_RNGInit();
    if (rv != SECSuccess) {
        SECU_PrintError("Error:", "RNG_RNGInit");
        return -1;
    }
    RNG_SystemInfoForRNG();

    rv = SECOID_Init();
    if (rv != SECSuccess) {
        SECU_PrintError("Error:", "SECOID_Init");
        goto cleanup;
    }

    if (usepkcs11) {
        CK_RV crv = NSC_Initialize((CK_VOID_PTR)&pk11args);
        if (crv != CKR_OK) {
            fprintf(stderr, "NSC_Initialize failed crv=0x%x\n", (unsigned int)crv);
            return SECFailure;
        }
    }

    /* specific arithmetic tests */
    if (nist) {
        ECTEST_NAMED_GFP("NIST-P256", ECCurve_NIST_P256);
        ECTEST_NAMED_GFP("NIST-P384", ECCurve_NIST_P384);
        ECTEST_NAMED_GFP("NIST-P521", ECCurve_NIST_P521);
        ECTEST_NAMED_CUSTOM("Curve25519", ECCurve25519);
    }

cleanup:
    rv |= SECOID_Shutdown();
    RNG_RNGShutdown();

    if (rv != SECSuccess) {
        printf("Error: exiting with error value\n");
    }
    return rv;
}
