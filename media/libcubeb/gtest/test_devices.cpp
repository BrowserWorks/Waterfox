/*
 * Copyright © 2015 Haakon Sporsheim <haakon.sporsheim@telenordigital.com>
 *
 * This program is made available under an ISC-style license.  See the
 * accompanying file LICENSE for details.
 */

/* libcubeb enumerate device test/example.
 * Prints out a list of devices enumerated. */
#include "gtest/gtest.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory>
#include "cubeb/cubeb.h"
#include "common.h"

static void
print_device_info(cubeb_device_info * info, FILE * f)
{
  char devfmts[64] = "";
  const char * devtype, * devstate, * devdeffmt;

  switch (info->type) {
    case CUBEB_DEVICE_TYPE_INPUT:
      devtype = "input";
      break;
    case CUBEB_DEVICE_TYPE_OUTPUT:
      devtype = "output";
      break;
    case CUBEB_DEVICE_TYPE_UNKNOWN:
    default:
      devtype = "unknown?";
      break;
  };

  switch (info->state) {
    case CUBEB_DEVICE_STATE_DISABLED:
      devstate = "disabled";
      break;
    case CUBEB_DEVICE_STATE_UNPLUGGED:
      devstate = "unplugged";
      break;
    case CUBEB_DEVICE_STATE_ENABLED:
      devstate = "enabled";
      break;
    default:
      devstate = "unknown?";
      break;
  };

  switch (info->default_format) {
    case CUBEB_DEVICE_FMT_S16LE:
      devdeffmt = "S16LE";
      break;
    case CUBEB_DEVICE_FMT_S16BE:
      devdeffmt = "S16BE";
      break;
    case CUBEB_DEVICE_FMT_F32LE:
      devdeffmt = "F32LE";
      break;
    case CUBEB_DEVICE_FMT_F32BE:
      devdeffmt = "F32BE";
      break;
    default:
      devdeffmt = "unknown?";
      break;
  };

  if (info->format & CUBEB_DEVICE_FMT_S16LE)
    strcat(devfmts, " S16LE");
  if (info->format & CUBEB_DEVICE_FMT_S16BE)
    strcat(devfmts, " S16BE");
  if (info->format & CUBEB_DEVICE_FMT_F32LE)
    strcat(devfmts, " F32LE");
  if (info->format & CUBEB_DEVICE_FMT_F32BE)
    strcat(devfmts, " F32BE");

  fprintf(f,
      "dev: \"%s\"%s\n"
      "\tName:    \"%s\"\n"
      "\tGroup:   \"%s\"\n"
      "\tVendor:  \"%s\"\n"
      "\tType:    %s\n"
      "\tState:   %s\n"
      "\tCh:      %u\n"
      "\tFormat:  %s (0x%x) (default: %s)\n"
      "\tRate:    %u - %u (default: %u)\n"
      "\tLatency: lo %u frames, hi %u frames\n",
      info->device_id, info->preferred ? " (PREFERRED)" : "",
      info->friendly_name, info->group_id, info->vendor_name,
      devtype, devstate, info->max_channels,
      (devfmts[0] == '\0') ? devfmts : devfmts + 1,
      (unsigned int)info->format, devdeffmt,
      info->min_rate, info->max_rate, info->default_rate,
      info->latency_lo, info->latency_hi);
}

static void
print_device_collection(cubeb_device_collection * collection, FILE * f)
{
  uint32_t i;

  for (i = 0; i < collection->count; i++)
    print_device_info(&collection->device[i], f);
}

TEST(cubeb, destroy_default_collection)
{
  int r;
  cubeb * ctx = NULL;
  cubeb_device_collection collection{ nullptr, 0 };

  r = common_init(&ctx, "Cubeb audio test");
  ASSERT_EQ(r, CUBEB_OK) << "Error initializing cubeb library";

  std::unique_ptr<cubeb, decltype(&cubeb_destroy)>
    cleanup_cubeb_at_exit(ctx, cubeb_destroy);

  ASSERT_EQ(collection.device, nullptr);
  ASSERT_EQ(collection.count, (size_t) 0);

  r = cubeb_device_collection_destroy(ctx, &collection);
  if (r != CUBEB_ERROR_NOT_SUPPORTED) {
    ASSERT_EQ(r, CUBEB_OK);
    ASSERT_EQ(collection.device, nullptr);
    ASSERT_EQ(collection.count, (size_t) 0);
  }
}

TEST(cubeb, enumerate_devices)
{
  int r;
  cubeb * ctx = NULL;
  cubeb_device_collection collection;

  r = common_init(&ctx, "Cubeb audio test");
  ASSERT_EQ(r, CUBEB_OK) << "Error initializing cubeb library";

  std::unique_ptr<cubeb, decltype(&cubeb_destroy)>
    cleanup_cubeb_at_exit(ctx, cubeb_destroy);

  fprintf(stdout, "Enumerating input devices for backend %s\n",
      cubeb_get_backend_id(ctx));

  r = cubeb_enumerate_devices(ctx, CUBEB_DEVICE_TYPE_INPUT, &collection);
  if (r == CUBEB_ERROR_NOT_SUPPORTED) {
    fprintf(stderr, "Device enumeration not supported"
                    " for this backend, skipping this test.\n");
    r = CUBEB_OK;
  }
  ASSERT_EQ(r, CUBEB_OK) << "Error enumerating devices " << r;

  fprintf(stdout, "Found %zu input devices\n", collection.count);
  print_device_collection(&collection, stdout);
  cubeb_device_collection_destroy(ctx, &collection);

  fprintf(stdout, "Enumerating output devices for backend %s\n",
          cubeb_get_backend_id(ctx));

  r = cubeb_enumerate_devices(ctx, CUBEB_DEVICE_TYPE_OUTPUT, &collection);
  ASSERT_EQ(r, CUBEB_OK) << "Error enumerating devices " << r;

  fprintf(stdout, "Found %zu output devices\n", collection.count);
  print_device_collection(&collection, stdout);
  cubeb_device_collection_destroy(ctx, &collection);
}
