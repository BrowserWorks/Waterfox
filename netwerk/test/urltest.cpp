/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
    A test file to check default URL parsing.
    -Gagan Saksena 03/25/99
*/

#include <stdio.h>

#include "TestCommon.h"
#include "plstr.h"
#include "nsIServiceManager.h"
#include "nsIIOService.h"
#include "nsIURL.h"
#include "nsCOMPtr.h"
#include "nsStringAPI.h"
#include "nsNetCID.h"
#include "nsIComponentRegistrar.h"
#include "nsComponentManagerUtils.h"
#include "nsServiceManagerUtils.h"
#include "nsXPCOM.h"
#include "prprf.h"
#include "mozilla/Sprintf.h"

// Define CIDs...
static NS_DEFINE_CID(kIOServiceCID,              NS_IOSERVICE_CID);
static NS_DEFINE_CID(kStdURLCID,                 NS_STANDARDURL_CID);

char* gFileIO = 0;

enum {
    URL_FACTORY_DEFAULT,
    URL_FACTORY_STDURL
};

nsresult writeoutto(const char* i_pURL, char** o_Result, int32_t urlFactory = URL_FACTORY_DEFAULT)
{
    if (!o_Result || !i_pURL)
        return NS_ERROR_FAILURE;
    *o_Result = 0;
    nsCOMPtr<nsIURI> pURL;
    nsresult result = NS_OK;

    switch (urlFactory) {
        case URL_FACTORY_STDURL: {
            nsIURI* url;
            result = CallCreateInstance(kStdURLCID, &url);
            if (NS_FAILED(result))
            {
                printf("CreateInstance failed\n");
                return NS_ERROR_FAILURE;
            }
            pURL = url;
            result = pURL->SetSpec(nsDependentCString(i_pURL));
            if (NS_FAILED(result))
            {
                printf("SetSpec failed\n");
                return NS_ERROR_FAILURE;
            }
            break;
        }
        case URL_FACTORY_DEFAULT: {
            nsCOMPtr<nsIIOService> pService = 
                     do_GetService(kIOServiceCID, &result);
            if (NS_FAILED(result)) 
            {
                printf("Service failed!\n");
                return NS_ERROR_FAILURE;
            }   
            result = pService->NewURI(nsDependentCString(i_pURL), nullptr, nullptr, getter_AddRefs(pURL));
        }
    }

    nsCString output;
    if (NS_SUCCEEDED(result))
    {
        nsCOMPtr<nsIURL> tURL = do_QueryInterface(pURL);
        nsAutoCString temp;
        int32_t port;
        nsresult rv;

#define RESULT() NS_SUCCEEDED(rv) ? temp.get() : ""

        rv = tURL->GetScheme(temp);
        output += RESULT();
        output += ',';
        rv = tURL->GetUsername(temp);
        output += RESULT();
        output += ',';
        rv = tURL->GetPassword(temp);
        output += RESULT();
        output += ',';
        rv = tURL->GetHost(temp);
        output += RESULT();
        output += ',';
        rv = tURL->GetPort(&port);
        char portbuffer[40];
        SprintfLiteral(portbuffer, "%d", port);
        output.Append(portbuffer);
        output += ',';
        rv = tURL->GetDirectory(temp);
        output += RESULT();
        output += ',';
        rv = tURL->GetFileBaseName(temp);
        output += RESULT();
        output += ',';
        rv = tURL->GetFileExtension(temp);
        output += RESULT();
        output += ',';
        // removed with https://bugzilla.mozilla.org/show_bug.cgi?id=665706
        // rv = tURL->GetParam(temp); 
        // output += RESULT();
        output += ',';
        rv = tURL->GetQuery(temp);
        output += RESULT();
        output += ',';
        rv = tURL->GetRef(temp);
        output += RESULT();
        output += ',';
        rv = tURL->GetSpec(temp);
        output += RESULT();
        *o_Result = ToNewCString(output);
    } else {
        output = "Can not create URL";
        *o_Result = ToNewCString(output);
    }
    return NS_OK;
}

nsresult writeout(const char* i_pURL, int32_t urlFactory = URL_FACTORY_DEFAULT)
{
    if (!i_pURL) return NS_ERROR_FAILURE;
    nsCString temp;
    nsresult rv = writeoutto(i_pURL, getter_Copies(temp), urlFactory);
    printf("%s\n%s\n", i_pURL, temp.get());
    return rv;
}

/* construct a url and print out its elements separated by commas and
   the whole spec */
nsresult testURL(const char* i_pURL, int32_t urlFactory = URL_FACTORY_DEFAULT)
{

    if (i_pURL)
        return writeout(i_pURL, urlFactory);

    if (!gFileIO)
        return NS_ERROR_FAILURE;

    FILE *testfile = fopen(gFileIO, "rt");
    if (!testfile) 
    {
        fprintf(stderr, "Cannot open testfile: %s\n", gFileIO);
        return NS_ERROR_FAILURE;
    }

    char temp[512];
    int count=0;
    int failed=0;
    nsCString prevResult;
    nsCString tempurl;

    while (fgets(temp,512,testfile))
    {
        if (*temp == '#' || !*temp)
            continue;

        if (0 == count%3)
        {
            printf("Testing:  %s\n", temp);
            writeoutto(temp, getter_Copies(prevResult), urlFactory);
        }
        else if (1 == count%3) {
            tempurl.Assign(temp);
        } else { 
            if (prevResult.IsEmpty())
                printf("no results to compare to!\n");
            else 
            {
                int32_t res;
                printf("Result:   %s\n", prevResult.get());
                if (urlFactory != URL_FACTORY_DEFAULT) {
                    printf("Expected: %s\n", tempurl.get());
                    res = PL_strcmp(tempurl.get(), prevResult.get());
                } else {
                    printf("Expected: %s\n", temp);
                    res = PL_strcmp(temp, prevResult.get());
                }

                if (res == 0)
                    printf("\tPASSED\n\n");
                else 
                {
                    printf("\tFAILED\n\n");
                    failed++;
                }
            }
        }
        count++;
    }
    if (failed>0) {
        printf("%d tests FAILED out of %d\n", failed, count/3);
        return NS_ERROR_FAILURE;
    } else {
        printf("All %d tests PASSED.\n", count/3);
        return NS_OK;
    }
}

nsresult makeAbsTest(const char* i_BaseURI, const char* relativePortion,
                     const char* expectedResult)
{
    if (!i_BaseURI)
        return NS_ERROR_FAILURE;

    // build up the base URL
    nsresult status;
    nsCOMPtr<nsIURI> baseURL = do_CreateInstance(kStdURLCID, &status);
    if (NS_FAILED(status))
    {
        printf("CreateInstance failed\n");
        return status;
    }
    status = baseURL->SetSpec(nsDependentCString(i_BaseURI));
    if (NS_FAILED(status)) return status;


    // get the new spec
    nsAutoCString newURL;
    status = baseURL->Resolve(nsDependentCString(relativePortion), newURL);
    if (NS_FAILED(status)) return status;

    printf("Analyzing %s\n", baseURL->GetSpecOrDefault().get());
    printf("With      %s\n", relativePortion);

    printf("Got       %s\n", newURL.get());
    if (expectedResult) {
        printf("Expect    %s\n", expectedResult);
        int res = PL_strcmp(newURL.get(), expectedResult);
        if (res == 0) {
            printf("\tPASSED\n\n");
            return NS_OK;
        } else {
            printf("\tFAILED\n\n");
            return NS_ERROR_FAILURE;
        }
    }
    return NS_OK;
}

nsresult doMakeAbsTest(const char* i_URL = 0, const char* i_relativePortion=0)
{
    if (i_URL && i_relativePortion)
    {
        return makeAbsTest(i_URL, i_relativePortion, nullptr);
    }

    // Run standard tests. These tests are based on the ones described in 
    // rfc2396 with the exception of the handling of ?y which is wrong as
    // notified by on of the RFC authors.

    /* Section C.1.  Normal Examples

      g:h        = <URL:g:h>
      g          = <URL:http://a/b/c/g>
      ./g        = <URL:http://a/b/c/g>
      g/         = <URL:http://a/b/c/g/>
      /g         = <URL:http://a/g>
      //g        = <URL:http://g>
      ?y         = <URL:http://a/b/c/d;p?y>
      g?y        = <URL:http://a/b/c/g?y>
      g?y/./x    = <URL:http://a/b/c/g?y/./x>
      #s         = <URL:http://a/b/c/d;p?q#s>
      g#s        = <URL:http://a/b/c/g#s>
      g#s/./x    = <URL:http://a/b/c/g#s/./x>
      g?y#s      = <URL:http://a/b/c/g?y#s>
      ;x         = <URL:http://a/b/c/;x>
      g;x        = <URL:http://a/b/c/g;x>
      g;x?y#s    = <URL:http://a/b/c/g;x?y#s>
      .          = <URL:http://a/b/c/>
      ./         = <URL:http://a/b/c/>
      ..         = <URL:http://a/b/>
      ../        = <URL:http://a/b/>
      ../g       = <URL:http://a/b/g>
      ../..      = <URL:http://a/>
      ../../     = <URL:http://a/>
      ../../g    = <URL:http://a/g>
    */

    struct test {
        const char* baseURL;
        const char* relativeURL;
        const char* expectedResult;
    };

    test tests[] = {
        // Tests from rfc2396, section C.1 with the exception of the
        // handling of ?y
        { "http://a/b/c/d;p?q#f",     "g:h",         "g:h" },
        { "http://a/b/c/d;p?q#f",     "g",           "http://a/b/c/g" },
        { "http://a/b/c/d;p?q#f",     "./g",         "http://a/b/c/g" },
        { "http://a/b/c/d;p?q#f",     "g/",          "http://a/b/c/g/" },
        { "http://a/b/c/d;p?q#f",     "/g",          "http://a/g" },
        { "http://a/b/c/d;p?q#f",     "//g",         "http://g" },
        { "http://a/b/c/d;p?q#f",     "?y",          "http://a/b/c/d;p?y" },
        { "http://a/b/c/d;p?q#f",     "g?y",         "http://a/b/c/g?y" },
        { "http://a/b/c/d;p?q#f",     "g?y/./x",     "http://a/b/c/g?y/./x" },
        { "http://a/b/c/d;p?q#f",     "#s",          "http://a/b/c/d;p?q#s" },
        { "http://a/b/c/d;p?q#f",     "g#s",         "http://a/b/c/g#s" },
        { "http://a/b/c/d;p?q#f",     "g#s/./x",     "http://a/b/c/g#s/./x" },
        { "http://a/b/c/d;p?q#f",     "g?y#s",       "http://a/b/c/g?y#s" },
        { "http://a/b/c/d;p?q#f",     ";x",          "http://a/b/c/;x" },
        { "http://a/b/c/d;p?q#f",     "g;x",         "http://a/b/c/g;x" },
        { "http://a/b/c/d;p?q#f",     "g;x?y#s",     "http://a/b/c/g;x?y#s" },
        { "http://a/b/c/d;p?q#f",     ".",           "http://a/b/c/" },
        { "http://a/b/c/d;p?q#f",     "./",          "http://a/b/c/" },
        { "http://a/b/c/d;p?q#f",     "..",          "http://a/b/" },
        { "http://a/b/c/d;p?q#f",     "../",         "http://a/b/" },
        { "http://a/b/c/d;p?q#f",     "../g",        "http://a/b/g" },
        { "http://a/b/c/d;p?q#f",     "../..",       "http://a/" },
        { "http://a/b/c/d;p?q#f",     "../../",      "http://a/" },
        { "http://a/b/c/d;p?q#f",     "../../g",     "http://a/g" },

        // Our additional tests...
        { "http://a/b/c/d;p?q#f",     "#my::anchor", "http://a/b/c/d;p?q#my::anchor" },
        { "http://a/b/c/d;p?q#f",     "get?baseRef=viewcert.jpg", "http://a/b/c/get?baseRef=viewcert.jpg" },

        // Make sure relative query's work right even if the query
        // string contains absolute urls or other junk.
        { "http://a/b/c/d;p?q#f",     "?http://foo",        "http://a/b/c/d;p?http://foo" },
        { "http://a/b/c/d;p?q#f",     "g?http://foo",       "http://a/b/c/g?http://foo" },
        {"http://a/b/c/d;p?q#f",      "g/h?http://foo",     "http://a/b/c/g/h?http://foo" },
        { "http://a/b/c/d;p?q#f",     "g/h/../H?http://foo","http://a/b/c/g/H?http://foo" },
        { "http://a/b/c/d;p?q#f",     "g/h/../H?http://foo?baz", "http://a/b/c/g/H?http://foo?baz" },
        { "http://a/b/c/d;p?q#f",     "g/h/../H?http://foo;baz", "http://a/b/c/g/H?http://foo;baz" },
        { "http://a/b/c/d;p?q#f",     "g/h/../H?http://foo#bar", "http://a/b/c/g/H?http://foo#bar" },
        { "http://a/b/c/d;p?q#f",     "g/h/../H;baz?http://foo", "http://a/b/c/g/H;baz?http://foo" },
        { "http://a/b/c/d;p?q#f",     "g/h/../H;baz?http://foo#bar", "http://a/b/c/g/H;baz?http://foo#bar" },
        { "http://a/b/c/d;p?q#f",     R"(g/h/../H;baz?C:\temp)", R"(http://a/b/c/g/H;baz?C:\temp)" },
        { "http://a/b/c/d;p?q#f",     "", "http://a/b/c/d;p?q" },
        { "http://a/b/c/d;p?q#f",     "#", "http://a/b/c/d;p?q#" },
        { "http://a/b/c;p/d;p?q#f",   "../g;p" , "http://a/b/g;p" },

    };

    const int numTests = sizeof(tests) / sizeof(tests[0]);
    int failed = 0;
    nsresult rv;
    for (auto & test : tests)
    {
        rv = makeAbsTest(test.baseURL, test.relativeURL,
                         test.expectedResult);
        if (NS_FAILED(rv))
            failed++;
    }
    if (failed>0) {
        printf("%d tests FAILED out of %d\n", failed, numTests);
        return NS_ERROR_FAILURE;
    } else {
        printf("All %d tests PASSED.\n", numTests);
        return NS_OK;
    }
}

void printusage(void)
{
    printf("urltest [-std] [-file <filename>] <URL> "
           " [-abs <relative>]\n\n"
           "\t-std  : Generate results using nsStdURL.\n"
           "\t-file : Read URLs from file.\n"
           "\t-abs  : Make an absolute URL from the base (<URL>) and the\n"
           "\t\trelative path specified. If -abs is given without\n"
           "\t\ta base URI standard RFC 2396 relative URL tests\n"
           "\t\tare performed. Implies -std.\n"
           "\t<URL> : The string representing the URL.\n");
}

int main(int argc, char **argv)
{
    if (test_common_init(&argc, &argv) != 0)
        return -1;

    if (argc < 2) {
        printusage();
        return 0;
    }
    {
        nsCOMPtr<nsIServiceManager> servMan;
        NS_InitXPCOM2(getter_AddRefs(servMan), nullptr, nullptr);

        // end of all messages from register components...
        printf("------------------\n\n");

        int32_t urlFactory = URL_FACTORY_DEFAULT;
        bool bMakeAbs= false;
        char* relativePath = 0;
        char* url = 0;
        for (int i=1; i<argc; i++) {
            if (PL_strcasecmp(argv[i], "-std") == 0)
            {
                urlFactory = URL_FACTORY_STDURL;
                if (i+1 >= argc)
                {
                    printusage();
                    return 0;
                }
            }
            else if (PL_strcasecmp(argv[i], "-abs") == 0)
            {
                if (!gFileIO)
                {
                    relativePath = argv[i+1];
                    i++;
                }
                bMakeAbs = true;
            }
            else if (PL_strcasecmp(argv[i], "-file") == 0)
            {
                if (i+1 >= argc)
                {
                    printusage();
                    return 0;
                }
                gFileIO = argv[i+1];
                i++;
            }
            else
            {
                url = argv[i];
            }
        }
        PRTime startTime = PR_Now();
        if (bMakeAbs)
        {
            if (url && relativePath) {
              doMakeAbsTest(url, relativePath);
            } else {
              doMakeAbsTest();
            }
        }
        else
        {
            if (gFileIO) {
              testURL(0, urlFactory);
            } else {
              testURL(url, urlFactory);
            }
        }
        if (gFileIO)
        {
            PRTime endTime = PR_Now();
            printf("Elapsed time: %d micros.\n", (int32_t)
                (endTime - startTime));
        }
    } // this scopes the nsCOMPtrs
    // no nsCOMPtrs are allowed to be alive when you call NS_ShutdownXPCOM
    return NS_FAILED(NS_ShutdownXPCOM(nullptr)) ? 1 : 0;
}
