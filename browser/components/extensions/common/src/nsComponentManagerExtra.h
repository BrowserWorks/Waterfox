
#ifndef nsComponentManagerExtra_h__
#define nsComponentManagerExtra_h__

#include "nsCOMPtr.h"
#include "nsIComponentManagerExtra.h"
#include "nsLiteralString.h"

class nsComponentManagerExtra : public nsIComponentManagerExtra
{
public:

  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSICOMPONENTMANAGEREXTRA

private:
  virtual ~nsComponentManagerExtra();
};

#endif // nsComponentManagerExtra_h__
