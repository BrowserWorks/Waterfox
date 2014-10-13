/*
 * Copyright (C) 2009 Ole André Vadla Ravnås <oleavr@soundrop.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include "qtkitvideosrc.h"

#import "corevideobuffer.h"

#import <QTKit/QTKit.h>

#define DEFAULT_DEVICE_INDEX  -1

#define DEVICE_YUV_FOURCC     "UYVY"
#define DEVICE_FPS_N          30
#define DEVICE_FPS_D          1

#define FRAME_QUEUE_SIZE      2

GST_DEBUG_CATEGORY (gst_qtkit_video_src_debug);
#define GST_CAT_DEFAULT gst_qtkit_video_src_debug

static GstStaticPadTemplate src_template = GST_STATIC_PAD_TEMPLATE ("src",
    GST_PAD_SRC,
    GST_PAD_ALWAYS,
    GST_STATIC_CAPS (
        "video/x-raw, "
            "format =" DEVICE_YUV_FOURCC ", "
            "width = (int) 640, "
            "height = (int) 480, "
            "framerate = [0/1, 100/1], "
            "pixel-aspect-ratio = (fraction) 1/1"
            "; "
        "video/x-raw, "
            "format =" DEVICE_YUV_FOURCC ", "
            "width = (int) 160, "
            "height = (int) 120, "
            "framerate = [0/1, 100/1], "
            "pixel-aspect-ratio = (fraction) 1/1"
            "; "
        "video/x-raw, "
            "format =" DEVICE_YUV_FOURCC ", "
            "width = (int) 176, "
            "height = (int) 144, "
            "framerate = [0/1, 100/1], "
            "pixel-aspect-ratio = (fraction) 12/11"
            "; "
        "video/x-raw, "
            "format =" DEVICE_YUV_FOURCC ", "
            "width = (int) 320, "
            "height = (int) 240, "
            "framerate = [0/1, 100/1], "
            "pixel-aspect-ratio = (fraction) 1/1"
            "; "
        "video/x-raw, "
            "format =" DEVICE_YUV_FOURCC ", "
            "width = (int) 352, "
            "height = (int) 288, "
            "framerate = [0/1, 100/1], "
            "pixel-aspect-ratio = (fraction) 12/11"
            ";"
    )
);

typedef enum _QueueState {
  NO_FRAMES = 1,
  HAS_FRAME_OR_STOP_REQUEST,
} QueueState;

G_DEFINE_TYPE (GstQTKitVideoSrc, gst_qtkit_video_src, GST_TYPE_PUSH_SRC);

@interface GstQTKitVideoSrcImpl : NSObject {
  GstElement *element;
  GstBaseSrc *baseSrc;
  GstPushSrc *pushSrc;

  int deviceIndex;

  QTCaptureSession *session;
  QTCaptureDeviceInput *input;
  QTCaptureDecompressedVideoOutput *output;
  QTCaptureDevice *device;

  NSConditionLock *queueLock;
  NSMutableArray *queue;
  BOOL stopRequest;

  gint width, height;
  gint fps_n, fps_d;  
  GstClockTime duration;
  guint64 offset;
}

- (id)init;
- (id)initWithSrc:(GstPushSrc *)src;

@property int deviceIndex;

- (BOOL)openDevice;
- (void)closeDevice;
- (BOOL)setCaps:(GstCaps *)caps;
- (BOOL)start;
- (BOOL)stop;
- (BOOL)unlock;
- (BOOL)unlockStop;
- (GstCaps *)fixate:(GstCaps *)caps;
- (BOOL)query:(GstQuery *)query;
- (GstStateChangeReturn)changeState:(GstStateChange)transition;
- (GstFlowReturn)create:(GstBuffer **)buf;
- (void)timestampBuffer:(GstBuffer *)buf;
- (void)captureOutput:(QTCaptureOutput *)captureOutput
  didOutputVideoFrame:(CVImageBufferRef)videoFrame
     withSampleBuffer:(QTSampleBuffer *)sampleBuffer
       fromConnection:(QTCaptureConnection *)connection;

@end

@implementation GstQTKitVideoSrcImpl

- (id)init
{
  return [self initWithSrc:NULL];
}

- (id)initWithSrc:(GstPushSrc *)src
{
  if ((self = [super init])) {
    element = GST_ELEMENT_CAST (src);
    baseSrc = GST_BASE_SRC_CAST (src);
    pushSrc = src;

    deviceIndex = DEFAULT_DEVICE_INDEX;

    device = nil;

    gst_base_src_set_live (baseSrc, TRUE);
    gst_base_src_set_format (baseSrc, GST_FORMAT_TIME);
  }

  return self;
}

@synthesize deviceIndex;

- (BOOL)openDevice
{
  NSString *mediaType = QTMediaTypeVideo;
  NSError *error = nil;

  if (deviceIndex == -1) {
    device = [QTCaptureDevice defaultInputDeviceWithMediaType:mediaType];
    if (device == nil) {
      GST_ELEMENT_ERROR (element, RESOURCE, NOT_FOUND,
                         ("No video capture devices found"), (NULL));
      goto openFailed;
    }
  } else {
    NSArray *devices = [QTCaptureDevice inputDevicesWithMediaType:mediaType];
    if (deviceIndex >= [devices count]) {
      GST_ELEMENT_ERROR (element, RESOURCE, NOT_FOUND,
                         ("Invalid video capture device index"), (NULL));
      goto openFailed;
    }
    device = [devices objectAtIndex:deviceIndex];
  }
  [device retain];

  GST_INFO ("Opening '%s'", [[device localizedDisplayName] UTF8String]);

  if (![device open:&error]) {
    GST_ELEMENT_ERROR (element, RESOURCE, NOT_FOUND,
        ("Failed to open device '%s'",
            [[device localizedDisplayName] UTF8String]), (NULL));
    goto openFailed;
  }

  return YES;

  /* ERRORS */
openFailed:
  {
    [device release];
    device = nil;

    return NO;
  }
}

- (void)closeDevice
{
  g_assert (![session isRunning]);

  [session release];
  session = nil;

  [input release];
  input = nil;

  [output release];
  output = nil;

  [device release];
  device = nil;
}

- (BOOL)setCaps:(GstCaps *)caps
{
  GstStructure *s;
  NSDictionary *outputAttrs;
  BOOL success;
  NSTimeInterval interval;

  g_assert (device != nil);

  GST_INFO ("setting up session");

  s = gst_caps_get_structure (caps, 0);
  gst_structure_get_int (s, "width", &width);
  gst_structure_get_int (s, "height", &height);
  if (!gst_structure_get_fraction (s, "framerate", &fps_n, &fps_d)) {
    fps_n = DEVICE_FPS_N;
    fps_d = DEVICE_FPS_D;
  }

  GST_INFO ("got caps %dx%d %d/%d", width, height, fps_n, fps_d);
  input = [[QTCaptureDeviceInput alloc] initWithDevice:device];

  output = [[QTCaptureDecompressedVideoOutput alloc] init];
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1060
  [output setAutomaticallyDropsLateVideoFrames:YES];
#endif
  outputAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithUnsignedInt:k2vuyPixelFormat],
          (id)kCVPixelBufferPixelFormatTypeKey,
      [NSNumber numberWithUnsignedInt:width],
          (id)kCVPixelBufferWidthKey,
      [NSNumber numberWithUnsignedInt:height],
          (id)kCVPixelBufferHeightKey,
      nil
  ];
  [output setPixelBufferAttributes:outputAttrs];

  if (fps_n != 0) {
    duration = gst_util_uint64_scale (GST_SECOND, fps_d, fps_n);
    gst_util_fraction_to_double (fps_d, fps_n, (gdouble *) &interval);
  } else {
    duration = GST_CLOCK_TIME_NONE;
    interval = 0;
  }

  [output setMinimumVideoFrameInterval:interval];

  session = [[QTCaptureSession alloc] init];
  success = [session addInput:input
                        error:nil];
  g_assert (success);
  success = [session addOutput:output
                         error:nil];
  g_assert (success);

  [output setDelegate:self];
  [session startRunning];

  return YES;
}

- (BOOL)start
{
  NSRunLoop *mainRunLoop;

  queueLock = [[NSConditionLock alloc] initWithCondition:NO_FRAMES];
  queue = [[NSMutableArray alloc] initWithCapacity:FRAME_QUEUE_SIZE];
  stopRequest = NO;

  offset = 0;
  width = height = 0;
  fps_n = 0;
  fps_d = 1;
  duration = GST_CLOCK_TIME_NONE;

  /* this will trigger negotiation and open the device in setCaps */
  gst_base_src_start_complete (baseSrc, GST_FLOW_OK);

  mainRunLoop = [NSRunLoop mainRunLoop];
  if ([mainRunLoop currentMode] == nil) {
    /* QTCaptureSession::addInput and QTCaptureSession::addOutput, called from
     * setCaps, call NSObject::performSelectorOnMainThread internally. If the
     * mainRunLoop is not running we need to run it for a while for those
     * methods to complete.
     */
    GST_INFO ("mainRunLoop not running");
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
  }


  return YES;
}

- (BOOL)stop
{
  [session stopRunning];
  [output setDelegate:nil];

  [queueLock release];
  queueLock = nil;
  [queue release];
  queue = nil;

  return YES;
}

- (BOOL)query:(GstQuery *)query
{
  BOOL result = NO;

  if (GST_QUERY_TYPE (query) == GST_QUERY_LATENCY) {
    if (device != nil) {
      GstClockTime min_latency, max_latency;

      min_latency = max_latency = duration; /* for now */
      result = YES;

      GST_DEBUG_OBJECT (element, "reporting latency of min %" GST_TIME_FORMAT
          " max %" GST_TIME_FORMAT,
          GST_TIME_ARGS (min_latency), GST_TIME_ARGS (max_latency));
      gst_query_set_latency (query, TRUE, min_latency, max_latency);
    }
  } else {
    result = GST_BASE_SRC_CLASS (gst_qtkit_video_src_parent_class)->query (baseSrc, query);
  }

  return result;
}

- (BOOL)unlock
{
  [queueLock lock];
  stopRequest = YES;
  [queueLock unlockWithCondition:HAS_FRAME_OR_STOP_REQUEST];

  return YES;
}

- (BOOL)unlockStop
{
  [queueLock lock];
  stopRequest = NO;
  [queueLock unlockWithCondition:NO_FRAMES];

  return YES;
}

- (GstCaps *)fixate:(GstCaps *)caps
{
  GstStructure *structure;

  caps = gst_caps_truncate (caps);
  structure = gst_caps_get_structure (caps, 0);
  if (gst_structure_has_field (structure, "framerate")) {
    gst_structure_fixate_field_nearest_fraction (structure, "framerate",
        DEVICE_FPS_N, DEVICE_FPS_D);
  }

  return caps;
}

- (GstStateChangeReturn)changeState:(GstStateChange)transition
{
  GstStateChangeReturn ret;

  if (transition == GST_STATE_CHANGE_NULL_TO_READY) {
    if (![self openDevice])
      return GST_STATE_CHANGE_FAILURE;
  }

  ret = GST_ELEMENT_CLASS (gst_qtkit_video_src_parent_class)->change_state (element, transition);

  if (transition == GST_STATE_CHANGE_READY_TO_NULL)
    [self closeDevice];

  return ret;
}

- (void)captureOutput:(QTCaptureOutput *)captureOutput
  didOutputVideoFrame:(CVImageBufferRef)videoFrame
     withSampleBuffer:(QTSampleBuffer *)sampleBuffer
       fromConnection:(QTCaptureConnection *)connection
{
  [queueLock lock];

  if (stopRequest) {
    [queueLock unlock];
    return;
  }

  GST_INFO ("got new frame");

  if ([queue count] == FRAME_QUEUE_SIZE)
    [queue removeLastObject];

  [queue insertObject:(id)videoFrame
              atIndex:0];

  [queueLock unlockWithCondition:HAS_FRAME_OR_STOP_REQUEST];
}

- (GstFlowReturn)create:(GstBuffer **)buf
{
  CVPixelBufferRef frame;

  [queueLock lockWhenCondition:HAS_FRAME_OR_STOP_REQUEST];
  if (stopRequest) {
    [queueLock unlock];
    return GST_FLOW_FLUSHING;
  }

  frame = (CVPixelBufferRef) [queue lastObject];
  CVBufferRetain (frame);
  [queue removeLastObject];
  [queueLock unlockWithCondition:
      ([queue count] == 0) ? NO_FRAMES : HAS_FRAME_OR_STOP_REQUEST];

  *buf = gst_core_video_buffer_new ((CVBufferRef)frame, NULL);
  CVBufferRelease (frame);

  [self timestampBuffer:*buf];

  return GST_FLOW_OK;
}

- (void)timestampBuffer:(GstBuffer *)buf
{
  GstClock *clock;
  GstClockTime timestamp;

  GST_OBJECT_LOCK (element);
  clock = GST_ELEMENT_CLOCK (element);
  if (clock != NULL) {
    gst_object_ref (clock);
    timestamp = element->base_time;
  } else {
    timestamp = GST_CLOCK_TIME_NONE;
  }
  GST_OBJECT_UNLOCK (element);

  if (clock != NULL) {
    timestamp = gst_clock_get_time (clock) - timestamp;
    if (timestamp > duration)
      timestamp -= duration;
    else
      timestamp = 0;

    gst_object_unref (clock);
    clock = NULL;
  }

  GST_BUFFER_OFFSET (buf) = offset++;
  GST_BUFFER_OFFSET_END (buf) = GST_BUFFER_OFFSET (buf) + 1;
  GST_BUFFER_TIMESTAMP (buf) = timestamp;
  GST_BUFFER_DURATION (buf) = duration;
}

@end

/*
 * Glue code
 */

enum
{
  PROP_0,
  PROP_DEVICE_INDEX
};

static void gst_qtkit_video_src_finalize (GObject * obj);
static void gst_qtkit_video_src_get_property (GObject * object, guint prop_id,
    GValue * value, GParamSpec * pspec);
static void gst_qtkit_video_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec);
static GstStateChangeReturn gst_qtkit_video_src_change_state (
    GstElement * element, GstStateChange transition);
static gboolean gst_qtkit_video_src_set_caps (GstBaseSrc * basesrc,
    GstCaps * caps);
static gboolean gst_qtkit_video_src_start (GstBaseSrc * basesrc);
static gboolean gst_qtkit_video_src_stop (GstBaseSrc * basesrc);
static gboolean gst_qtkit_video_src_query (GstBaseSrc * basesrc,
    GstQuery * query);
static gboolean gst_qtkit_video_src_unlock (GstBaseSrc * basesrc);
static gboolean gst_qtkit_video_src_unlock_stop (GstBaseSrc * basesrc);
static GstFlowReturn gst_qtkit_video_src_create (GstPushSrc * pushsrc,
    GstBuffer ** buf);
static GstCaps * gst_qtkit_video_src_fixate (GstBaseSrc * basesrc, GstCaps * caps);

static void
gst_qtkit_video_src_class_init (GstQTKitVideoSrcClass * klass)
{
  GObjectClass *gobject_class = G_OBJECT_CLASS (klass);
  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (klass);
  GstBaseSrcClass *gstbasesrc_class = GST_BASE_SRC_CLASS (klass);
  GstPushSrcClass *gstpushsrc_class = GST_PUSH_SRC_CLASS (klass);

  gst_element_class_set_metadata (gstelement_class,
      "Video Source (QTKit)", "Source/Video",
      "Reads frames from a Mac OS X QTKit device",
      "Ole André Vadla Ravnås <oleavr@soundrop.com>");

  gst_element_class_add_pad_template (gstelement_class,
      gst_static_pad_template_get (&src_template));

  gobject_class->finalize = gst_qtkit_video_src_finalize;
  gobject_class->get_property = gst_qtkit_video_src_get_property;
  gobject_class->set_property = gst_qtkit_video_src_set_property;

  gstelement_class->change_state = gst_qtkit_video_src_change_state;

  gstbasesrc_class->set_caps = gst_qtkit_video_src_set_caps;
  gstbasesrc_class->start = gst_qtkit_video_src_start;
  gstbasesrc_class->stop = gst_qtkit_video_src_stop;
  gstbasesrc_class->query = gst_qtkit_video_src_query;
  gstbasesrc_class->unlock = gst_qtkit_video_src_unlock;
  gstbasesrc_class->unlock_stop = gst_qtkit_video_src_unlock_stop;
  gstbasesrc_class->fixate = gst_qtkit_video_src_fixate;

  gstpushsrc_class->create = gst_qtkit_video_src_create;

  g_object_class_install_property (gobject_class, PROP_DEVICE_INDEX,
      g_param_spec_int ("device-index", "Device Index",
          "The zero-based device index",
          -1, G_MAXINT, DEFAULT_DEVICE_INDEX,
          G_PARAM_READWRITE | G_PARAM_STATIC_STRINGS));

  GST_DEBUG_CATEGORY_INIT (gst_qtkit_video_src_debug, "qtkitvideosrc",
      0, "Mac OS X QTKit video source");
}

#define OBJC_CALLOUT_BEGIN() \
  NSAutoreleasePool *pool; \
  \
  pool = [[NSAutoreleasePool alloc] init]
#define OBJC_CALLOUT_END() \
  [pool release]

static void
gst_qtkit_video_src_init (GstQTKitVideoSrc * src)
{
  OBJC_CALLOUT_BEGIN ();
  src->impl = [[GstQTKitVideoSrcImpl alloc] initWithSrc:GST_PUSH_SRC (src)];
  OBJC_CALLOUT_END ();

  /* pretend to be async so we can spin the mainRunLoop from the main thread if
   * needed (see ::start) */
  gst_base_src_set_async (GST_BASE_SRC (src), TRUE);
}

static void
gst_qtkit_video_src_finalize (GObject * obj)
{
  OBJC_CALLOUT_BEGIN ();
  [GST_QTKIT_VIDEO_SRC_IMPL (obj) release];
  OBJC_CALLOUT_END ();

  G_OBJECT_CLASS (gst_qtkit_video_src_parent_class)->finalize (obj);
}

static void
gst_qtkit_video_src_get_property (GObject * object, guint prop_id, GValue * value,
    GParamSpec * pspec)
{
  GstQTKitVideoSrcImpl *impl = GST_QTKIT_VIDEO_SRC_IMPL (object);

  switch (prop_id) {
    case PROP_DEVICE_INDEX:
      g_value_set_int (value, impl.deviceIndex);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static void
gst_qtkit_video_src_set_property (GObject * object, guint prop_id,
    const GValue * value, GParamSpec * pspec)
{
  GstQTKitVideoSrcImpl *impl = GST_QTKIT_VIDEO_SRC_IMPL (object);

  switch (prop_id) {
    case PROP_DEVICE_INDEX:
      impl.deviceIndex = g_value_get_int (value);
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
  }
}

static GstStateChangeReturn
gst_qtkit_video_src_change_state (GstElement * element, GstStateChange transition)
{
  GstStateChangeReturn ret;

  OBJC_CALLOUT_BEGIN ();
  ret = [GST_QTKIT_VIDEO_SRC_IMPL (element) changeState: transition];
  OBJC_CALLOUT_END ();

  return ret;
}

static gboolean
gst_qtkit_video_src_set_caps (GstBaseSrc * basesrc, GstCaps * caps)
{
  gboolean ret;

  OBJC_CALLOUT_BEGIN ();
  ret = [GST_QTKIT_VIDEO_SRC_IMPL (basesrc) setCaps:caps];
  OBJC_CALLOUT_END ();

  return ret;
}

static gboolean
gst_qtkit_video_src_start (GstBaseSrc * basesrc)
{
  gboolean ret;

  OBJC_CALLOUT_BEGIN ();
  ret = [GST_QTKIT_VIDEO_SRC_IMPL (basesrc) start];
  OBJC_CALLOUT_END ();

  return ret;
}

static gboolean
gst_qtkit_video_src_stop (GstBaseSrc * basesrc)
{
  gboolean ret;

  OBJC_CALLOUT_BEGIN ();
  ret = [GST_QTKIT_VIDEO_SRC_IMPL (basesrc) stop];
  OBJC_CALLOUT_END ();

  return ret;
}

static gboolean
gst_qtkit_video_src_query (GstBaseSrc * basesrc, GstQuery * query)
{
  gboolean ret;

  OBJC_CALLOUT_BEGIN ();
  ret = [GST_QTKIT_VIDEO_SRC_IMPL (basesrc) query:query];
  OBJC_CALLOUT_END ();

  return ret;
}

static gboolean
gst_qtkit_video_src_unlock (GstBaseSrc * basesrc)
{
  gboolean ret;

  OBJC_CALLOUT_BEGIN ();
  ret = [GST_QTKIT_VIDEO_SRC_IMPL (basesrc) unlock];
  OBJC_CALLOUT_END ();

  return ret;
}

static gboolean
gst_qtkit_video_src_unlock_stop (GstBaseSrc * basesrc)
{
  gboolean ret;

  OBJC_CALLOUT_BEGIN ();
  ret = [GST_QTKIT_VIDEO_SRC_IMPL (basesrc) unlockStop];
  OBJC_CALLOUT_END ();

  return ret;
}

static GstFlowReturn
gst_qtkit_video_src_create (GstPushSrc * pushsrc, GstBuffer ** buf)
{
  GstFlowReturn ret;

  OBJC_CALLOUT_BEGIN ();
  ret = [GST_QTKIT_VIDEO_SRC_IMPL (pushsrc) create: buf];
  OBJC_CALLOUT_END ();

  return ret;
}

static GstCaps *
gst_qtkit_video_src_fixate (GstBaseSrc * basesrc, GstCaps * caps)
{
  GstCaps *ret;

  OBJC_CALLOUT_BEGIN ();
  ret = [GST_QTKIT_VIDEO_SRC_IMPL (basesrc) fixate: caps];
  OBJC_CALLOUT_END ();

  return ret;
}
