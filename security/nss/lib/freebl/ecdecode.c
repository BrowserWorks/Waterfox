/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef NSS_DISABLE_ECC

#ifdef FREEBL_NO_DEPEND
#include "stubs.h"
#endif

#include "blapi.h"
#include "secoid.h"
#include "secitem.h"
#include "secerr.h"
#include "ec.h"
#include "ecl-curve.h"

#define CHECK_OK(func) \
    if (func == NULL)  \
    goto cleanup
#define CHECK_SEC_OK(func)         \
    if (SECSuccess != (rv = func)) \
    goto cleanup

/*
 * Initializes a SECItem from a hexadecimal string
 *
 * Warning: This function ignores leading 00's, so any leading 00's
 * in the hexadecimal string must be optional.
 */
static SECItem *
hexString2SECItem(PLArenaPool *arena, SECItem *item, const char *str)
{
    int i = 0;
    int byteval = 0;
    int tmp = PORT_Strlen(str);

    PORT_Assert(arena);
    PORT_Assert(item);

    if ((tmp % 2) != 0)
        return NULL;

    /* skip leading 00's unless the hex string is "00" */
    while ((tmp > 2) && (str[0] == '0') && (str[1] == '0')) {
        str += 2;
        tmp -= 2;
    }

    item->data = (unsigned char *)PORT_ArenaAlloc(arena, tmp / 2);
    if (item->data == NULL)
        return NULL;
    item->len = tmp / 2;

    while (str[i]) {
        if ((str[i] >= '0') && (str[i] <= '9'))
            tmp = str[i] - '0';
        else if ((str[i] >= 'a') && (str[i] <= 'f'))
            tmp = str[i] - 'a' + 10;
        else if ((str[i] >= 'A') && (str[i] <= 'F'))
            tmp = str[i] - 'A' + 10;
        else
            return NULL;

        byteval = byteval * 16 + tmp;
        if ((i % 2) != 0) {
            item->data[i / 2] = byteval;
            byteval = 0;
        }
        i++;
    }

    return item;
}

/* Copy all of the fields from srcParams into dstParams
 */
SECStatus
EC_CopyParams(PLArenaPool *arena, ECParams *dstParams,
              const ECParams *srcParams)
{
    SECStatus rv = SECFailure;

    dstParams->arena = arena;
    dstParams->type = srcParams->type;
    dstParams->fieldID.size = srcParams->fieldID.size;
    dstParams->fieldID.type = srcParams->fieldID.type;
    if (srcParams->fieldID.type == ec_field_GFp ||
        srcParams->fieldID.type == ec_field_plain) {
        CHECK_SEC_OK(SECITEM_CopyItem(arena, &dstParams->fieldID.u.prime,
                                      &srcParams->fieldID.u.prime));
    } else {
        CHECK_SEC_OK(SECITEM_CopyItem(arena, &dstParams->fieldID.u.poly,
                                      &srcParams->fieldID.u.poly));
    }
    dstParams->fieldID.k1 = srcParams->fieldID.k1;
    dstParams->fieldID.k2 = srcParams->fieldID.k2;
    dstParams->fieldID.k3 = srcParams->fieldID.k3;
    CHECK_SEC_OK(SECITEM_CopyItem(arena, &dstParams->curve.a,
                                  &srcParams->curve.a));
    CHECK_SEC_OK(SECITEM_CopyItem(arena, &dstParams->curve.b,
                                  &srcParams->curve.b));
    CHECK_SEC_OK(SECITEM_CopyItem(arena, &dstParams->curve.seed,
                                  &srcParams->curve.seed));
    CHECK_SEC_OK(SECITEM_CopyItem(arena, &dstParams->base,
                                  &srcParams->base));
    CHECK_SEC_OK(SECITEM_CopyItem(arena, &dstParams->order,
                                  &srcParams->order));
    CHECK_SEC_OK(SECITEM_CopyItem(arena, &dstParams->DEREncoding,
                                  &srcParams->DEREncoding));
    dstParams->name = srcParams->name;
    CHECK_SEC_OK(SECITEM_CopyItem(arena, &dstParams->curveOID,
                                  &srcParams->curveOID));
    dstParams->cofactor = srcParams->cofactor;

    return SECSuccess;

cleanup:
    return SECFailure;
}

static SECStatus
gf_populate_params(ECCurveName name, ECFieldType field_type, ECParams *params)
{
    SECStatus rv = SECFailure;
    const ECCurveParams *curveParams;
    /* 2 ['0'+'4'] + MAX_ECKEY_LEN * 2 [x,y] * 2 [hex string] + 1 ['\0'] */
    char genenc[3 + 2 * 2 * MAX_ECKEY_LEN];

    if ((name < ECCurve_noName) || (name > ECCurve_pastLastCurve))
        goto cleanup;
    params->name = name;
    curveParams = ecCurve_map[params->name];
    CHECK_OK(curveParams);
    params->fieldID.size = curveParams->size;
    params->fieldID.type = field_type;
    if (field_type == ec_field_GFp ||
        field_type == ec_field_plain) {
        CHECK_OK(hexString2SECItem(params->arena, &params->fieldID.u.prime,
                                   curveParams->irr));
    } else {
        CHECK_OK(hexString2SECItem(params->arena, &params->fieldID.u.poly,
                                   curveParams->irr));
    }
    CHECK_OK(hexString2SECItem(params->arena, &params->curve.a,
                               curveParams->curvea));
    CHECK_OK(hexString2SECItem(params->arena, &params->curve.b,
                               curveParams->curveb));
    genenc[0] = '0';
    genenc[1] = '4';
    genenc[2] = '\0';
    strcat(genenc, curveParams->genx);
    strcat(genenc, curveParams->geny);
    CHECK_OK(hexString2SECItem(params->arena, &params->base, genenc));
    CHECK_OK(hexString2SECItem(params->arena, &params->order,
                               curveParams->order));
    params->cofactor = curveParams->cofactor;

    rv = SECSuccess;

cleanup:
    return rv;
}

SECStatus
EC_FillParams(PLArenaPool *arena, const SECItem *encodedParams,
              ECParams *params)
{
    SECStatus rv = SECFailure;
    SECOidTag tag;
    SECItem oid = { siBuffer, NULL, 0 };

#if EC_DEBUG
    int i;

    printf("Encoded params in EC_DecodeParams: ");
    for (i = 0; i < encodedParams->len; i++) {
        printf("%02x:", encodedParams->data[i]);
    }
    printf("\n");
#endif

    if ((encodedParams->len != ANSI_X962_CURVE_OID_TOTAL_LEN) &&
        (encodedParams->len != SECG_CURVE_OID_TOTAL_LEN) &&
        (encodedParams->len != PKIX_NEWCURVES_OID_TOTAL_LEN)) {
        PORT_SetError(SEC_ERROR_UNSUPPORTED_ELLIPTIC_CURVE);
        return SECFailure;
    };

    oid.len = encodedParams->len - 2;
    oid.data = encodedParams->data + 2;
    if ((encodedParams->data[0] != SEC_ASN1_OBJECT_ID) ||
        ((tag = SECOID_FindOIDTag(&oid)) == SEC_OID_UNKNOWN)) {
        PORT_SetError(SEC_ERROR_UNSUPPORTED_ELLIPTIC_CURVE);
        return SECFailure;
    }

    params->arena = arena;
    params->cofactor = 0;
    params->type = ec_params_named;
    params->name = ECCurve_noName;

    /* Fill out curveOID */
    params->curveOID.len = oid.len;
    params->curveOID.data = (unsigned char *)PORT_ArenaAlloc(arena, oid.len);
    if (params->curveOID.data == NULL)
        goto cleanup;
    memcpy(params->curveOID.data, oid.data, oid.len);

#if EC_DEBUG
    printf("Curve: %s\n", SECOID_FindOIDTagDescription(tag));
#endif

    switch (tag) {
        case SEC_OID_ANSIX962_EC_PRIME256V1:
            /* Populate params for prime256v1 aka secp256r1
             * (the NIST P-256 curve)
             */
            CHECK_SEC_OK(gf_populate_params(ECCurve_X9_62_PRIME_256V1, ec_field_GFp,
                                            params));
            break;

        case SEC_OID_SECG_EC_SECP384R1:
            /* Populate params for secp384r1
             * (the NIST P-384 curve)
             */
            CHECK_SEC_OK(gf_populate_params(ECCurve_SECG_PRIME_384R1, ec_field_GFp,
                                            params));
            break;

        case SEC_OID_SECG_EC_SECP521R1:
            /* Populate params for secp521r1
             * (the NIST P-521 curve)
             */
            CHECK_SEC_OK(gf_populate_params(ECCurve_SECG_PRIME_521R1, ec_field_GFp,
                                            params));
            break;

        case SEC_OID_CURVE25519:
            /* Populate params for Curve25519 */
            CHECK_SEC_OK(gf_populate_params(ECCurve25519, ec_field_plain, params));
            break;

        default:
            break;
    };

cleanup:
    if (!params->cofactor) {
        PORT_SetError(SEC_ERROR_UNSUPPORTED_ELLIPTIC_CURVE);
#if EC_DEBUG
        printf("Unrecognized curve, returning NULL params\n");
#endif
    }

    return rv;
}

SECStatus
EC_DecodeParams(const SECItem *encodedParams, ECParams **ecparams)
{
    PLArenaPool *arena;
    ECParams *params;
    SECStatus rv = SECFailure;

    /* Initialize an arena for the ECParams structure */
    if (!(arena = PORT_NewArena(NSS_FREEBL_DEFAULT_CHUNKSIZE)))
        return SECFailure;

    params = (ECParams *)PORT_ArenaZAlloc(arena, sizeof(ECParams));
    if (!params) {
        PORT_FreeArena(arena, PR_TRUE);
        return SECFailure;
    }

    /* Copy the encoded params */
    SECITEM_AllocItem(arena, &(params->DEREncoding),
                      encodedParams->len);
    memcpy(params->DEREncoding.data, encodedParams->data, encodedParams->len);

    /* Fill out the rest of the ECParams structure based on
     * the encoded params
     */
    rv = EC_FillParams(arena, encodedParams, params);
    if (rv == SECFailure) {
        PORT_FreeArena(arena, PR_TRUE);
        return SECFailure;
    } else {
        *ecparams = params;
        ;
        return SECSuccess;
    }
}

int
EC_GetPointSize(const ECParams *params)
{
    ECCurveName name = params->name;
    const ECCurveParams *curveParams;

    if ((name < ECCurve_noName) || (name > ECCurve_pastLastCurve) ||
        ((curveParams = ecCurve_map[name]) == NULL)) {
        /* unknown curve, calculate point size from params. assume standard curves with 2 points 
         * and a point compression indicator byte */
        int sizeInBytes = (params->fieldID.size + 7) / 8;
        return sizeInBytes * 2 + 1;
    }
    return curveParams->pointSize;
}

#endif /* NSS_DISABLE_ECC */
