#include "configargs.h"

#define GCCPLUGIN_VERSION_MAJOR   4
#define GCCPLUGIN_VERSION_MINOR   7
#define GCCPLUGIN_VERSION_PATCHLEVEL   3
#define GCCPLUGIN_VERSION  (GCCPLUGIN_VERSION_MAJOR*1000 + GCCPLUGIN_VERSION_MINOR)

static char basever[] = "4.7.3";
static char datestamp[] = "20130411";
static char devphase[] = "";
static char revision[] = "";

/* FIXME plugins: We should make the version information more precise.
   One way to do is to add a checksum. */

static struct plugin_gcc_version gcc_version = {basever, datestamp,
						devphase, revision,
						configuration_arguments};
