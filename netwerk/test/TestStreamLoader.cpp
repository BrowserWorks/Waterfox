#include <stdio.h>
#include "TestCommon.h"
#include "nsNetUtil.h"
#include "nsServiceManagerUtils.h"
#include "nsThreadUtils.h"
#include "NetwerkTestLogging.h"
#include "mozilla/Attributes.h"
#include "nsIScriptSecurityManager.h"

//
// set NSPR_LOG_MODULES=Test:5
//
static PRLogModuleInfo *gTestLog = nullptr;
#define LOG(args) MOZ_LOG(gTestLog, mozilla::LogLevel::Debug, args)

class MyStreamLoaderObserver final : public nsIStreamLoaderObserver
{
  ~MyStreamLoaderObserver() = default;

public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSISTREAMLOADEROBSERVER
};

NS_IMPL_ISUPPORTS(MyStreamLoaderObserver, nsIStreamLoaderObserver)

NS_IMETHODIMP
MyStreamLoaderObserver::OnStreamComplete(nsIStreamLoader *loader,
                                         nsISupports     *ctxt,
                                         nsresult         status,
                                         uint32_t         resultLen,
                                         const uint8_t   *result)
{
  LOG(("OnStreamComplete [status=%x resultLen=%u]\n", status, resultLen));

  nsCOMPtr<nsIRequest> request;
  loader->GetRequest(getter_AddRefs(request));
  LOG(("  request=%p\n", request.get()));

  QuitPumpingEvents();
  return NS_OK;
}

int main(int argc, char **argv)
{
  if (test_common_init(&argc, &argv) != 0)
    return -1;

  if (argc < 2) {
    printf("usage: %s <url>\n", argv[0]);
    return -1;
  }

  gTestLog = PR_NewLogModule("Test");

  nsresult rv = NS_InitXPCOM2(nullptr, nullptr, nullptr);
  if (NS_FAILED(rv))
    return -1;

  {
    nsCOMPtr<nsIURI> uri;
    rv = NS_NewURI(getter_AddRefs(uri), nsDependentCString(argv[1]));
    if (NS_FAILED(rv))
      return -1;

    nsCOMPtr<nsIScriptSecurityManager> secman =
      do_GetService(NS_SCRIPTSECURITYMANAGER_CONTRACTID, &rv);
    NS_ENSURE_SUCCESS(rv, -1);
       nsCOMPtr<nsIPrincipal> systemPrincipal;
    rv = secman->GetSystemPrincipal(getter_AddRefs(systemPrincipal));
    NS_ENSURE_SUCCESS(rv, -1);

    nsCOMPtr<nsIChannel> chan;
    rv = NS_NewChannel(getter_AddRefs(chan),
                       uri,
                       systemPrincipal,
                       nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_INHERITS,
                       nsIContentPolicy::TYPE_OTHER);

    if (NS_FAILED(rv))
      return -1;

    nsCOMPtr<nsIStreamLoaderObserver> observer = new MyStreamLoaderObserver();
    if (!observer)
      return -1;

    nsCOMPtr<nsIStreamLoader> loader;
    rv = NS_NewStreamLoader(getter_AddRefs(loader), observer);
    if (NS_FAILED(rv))
      return -1;

    rv = chan->AsyncOpen2(loader);
    if (NS_FAILED(rv))
      return -1;

    PumpEvents();
  } // this scopes the nsCOMPtrs
  // no nsCOMPtrs are allowed to be alive when you call NS_ShutdownXPCOM
  NS_ShutdownXPCOM(nullptr);
  return 0;
}
