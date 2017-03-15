/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "AudioEventTimeline.h"
#include <sstream>
#include <limits>
#include "gtest/gtest.h"

// Mock the MediaStream class
namespace mozilla {
class MediaStream
{
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(MediaStream)
private:
  ~MediaStream() {
  };
};
}

using namespace mozilla;
using namespace mozilla::dom;
using std::numeric_limits;

// Some simple testing primitives
void ok(bool val, const char* msg)
{
  if (!val) {
    fprintf(stderr, "failure: %s", msg);
  }
  ASSERT_TRUE(val);
}

namespace std {

template <class T>
basic_ostream<T, char_traits<T> >&
operator<<(basic_ostream<T, char_traits<T> >& os, nsresult rv)
{
  os << static_cast<uint32_t>(rv);
  return os;
}

} // namespace std

template <class T, class U>
void is(const T& a, const U& b, const char* msg)
{
  std::stringstream ss;
  ss << msg << ", Got: " << a << ", expected: " << b << std::endl;
  ok(a == b, ss.str().c_str());
}

template <>
void is(const float& a, const float& b, const char* msg)
{
  // stupidly high, since we mostly care about the correctness of the algorithm
  const float kEpsilon = 0.00001f;

  std::stringstream ss;
  ss << msg << ", Got: " << a << ", expected: " << b << std::endl;
  ok(fabsf(a - b) < kEpsilon, ss.str().c_str());
}

class ErrorResultMock
{
public:
  ErrorResultMock()
    : mRv(NS_OK)
  {
  }
  void Throw(nsresult aRv)
  {
    mRv = aRv;
  }

  operator nsresult() const
  {
    return mRv;
  }

  ErrorResultMock& operator=(nsresult aRv)
  {
    mRv = aRv;
    return *this;
  }

private:
  nsresult mRv;
};

typedef AudioEventTimeline Timeline;

TEST(AudioEventTimeline, SpecExample)
{
  // First, run the basic tests
  Timeline timeline(10.0f);
  is(timeline.Value(), 10.0f, "Correct default value returned");

  ErrorResultMock rv;

  uint32_t curveLength = 44100;
  float* curve = new float[curveLength];
  for (uint32_t i = 0; i < curveLength; ++i) {
    curve[i] = sin(M_PI * i / float(curveLength));
  }

  // This test is copied from the example in the Web Audio spec
  const double t0 = 0.0,
               t1 = 0.1,
               t2 = 0.2,
               t3 = 0.3,
               t4 = 0.4,
               t5 = 0.6,
               t6 = 0.7,
               t7 = 1.0;
  timeline.SetValueAtTime(0.2f, t0, rv);
  is(rv, NS_OK, "SetValueAtTime succeeded");
  timeline.SetValueAtTime(0.3f, t1, rv);
  is(rv, NS_OK, "SetValueAtTime succeeded");
  timeline.SetValueAtTime(0.4f, t2, rv);
  is(rv, NS_OK, "SetValueAtTime succeeded");
  timeline.LinearRampToValueAtTime(1.0f, t3, rv);
  is(rv, NS_OK, "LinearRampToValueAtTime succeeded");
  timeline.LinearRampToValueAtTime(0.15f, t4, rv);
  is(rv, NS_OK, "LinearRampToValueAtTime succeeded");
  timeline.ExponentialRampToValueAtTime(0.75f, t5, rv);
  is(rv, NS_OK, "ExponentialRampToValueAtTime succeeded");
  timeline.ExponentialRampToValueAtTime(0.05f, t6, rv);
  is(rv, NS_OK, "ExponentialRampToValueAtTime succeeded");
  timeline.SetValueCurveAtTime(curve, curveLength, t6, t7 - t6, rv);
  is(rv, NS_OK, "SetValueCurveAtTime succeeded");

  is(timeline.GetValueAtTime(0.0), 0.2f, "Correct value");
  is(timeline.GetValueAtTime(0.05), 0.2f, "Correct value");
  is(timeline.GetValueAtTime(0.1), 0.3f, "Correct value");
  is(timeline.GetValueAtTime(0.15), 0.3f, "Correct value");
  is(timeline.GetValueAtTime(0.2), 0.4f, "Correct value");
  is(timeline.GetValueAtTime(0.25), (0.4f + 1.0f) / 2, "Correct value");
  is(timeline.GetValueAtTime(0.3), 1.0f, "Correct value");
  is(timeline.GetValueAtTime(0.35), (1.0f + 0.15f) / 2, "Correct value");
  is(timeline.GetValueAtTime(0.4), 0.15f, "Correct value");
  is(timeline.GetValueAtTime(0.45), (0.15f * powf(0.75f / 0.15f, 0.05f / 0.2f)), "Correct value");
  is(timeline.GetValueAtTime(0.5), (0.15f * powf(0.75f / 0.15f, 0.5f)), "Correct value");
  is(timeline.GetValueAtTime(0.55), (0.15f * powf(0.75f / 0.15f, 0.15f / 0.2f)), "Correct value");
  is(timeline.GetValueAtTime(0.6), 0.75f, "Correct value");
  is(timeline.GetValueAtTime(0.65), (0.75f * powf(0.05f / 0.75f, 0.5f)), "Correct value");
  is(timeline.GetValueAtTime(0.7), 0.0f, "Correct value");
  is(timeline.GetValueAtTime(0.85), 1.0f, "Correct value");
  is(timeline.GetValueAtTime(1.0), curve[curveLength - 1], "Correct value");

  delete[] curve;
}

TEST(AudioEventTimeline, InvalidEvents)
{
  static_assert(numeric_limits<float>::has_quiet_NaN, "Platform must have a quiet NaN");
  const float NaN = numeric_limits<float>::quiet_NaN();
  const float Infinity = numeric_limits<float>::infinity();
  Timeline timeline(10.0f);

  float curve[] = { -1.0f, 0.0f, 1.0f };
  float badCurve1[] = { -1.0f, NaN, 1.0f };
  float badCurve2[] = { -1.0f, Infinity, 1.0f };
  float badCurve3[] = { -1.0f, -Infinity, 1.0f };

  ErrorResultMock rv;

  timeline.SetValueAtTime(NaN, 0.1, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueAtTime(Infinity, 0.1, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueAtTime(-Infinity, 0.1, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.LinearRampToValueAtTime(NaN, 0.2, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.LinearRampToValueAtTime(Infinity, 0.2, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.LinearRampToValueAtTime(-Infinity, 0.2, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.ExponentialRampToValueAtTime(NaN, 0.3, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.ExponentialRampToValueAtTime(Infinity, 0.3, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.ExponentialRampToValueAtTime(-Infinity, 0.4, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.ExponentialRampToValueAtTime(0, 0.5, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetTargetAtTime(NaN, 0.4, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetTargetAtTime(Infinity, 0.4, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetTargetAtTime(-Infinity, 0.4, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetTargetAtTime(0.4f, NaN, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetTargetAtTime(0.4f, Infinity, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetTargetAtTime(0.4f, -Infinity, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(nullptr, 0, 1.0, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(badCurve1, ArrayLength(badCurve1), 1.0, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(badCurve2, ArrayLength(badCurve2), 1.0, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(badCurve3, ArrayLength(badCurve3), 1.0, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(curve, ArrayLength(curve), NaN, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(curve, ArrayLength(curve), Infinity, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(curve, ArrayLength(curve), -Infinity, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(curve, ArrayLength(curve), 1.0, NaN, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(curve, ArrayLength(curve), 1.0, Infinity, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValueCurveAtTime(curve, ArrayLength(curve), 1.0, -Infinity, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
}

TEST(AudioEventTimeline, EventReplacement)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  is(timeline.GetEventCount(), 0u, "No events yet");
  timeline.SetValueAtTime(10.0f, 0.1, rv);
  is(timeline.GetEventCount(), 1u, "One event scheduled now");
  timeline.SetValueAtTime(20.0f, 0.1, rv);
  is(rv, NS_OK, "Event scheduling should be successful");
  is(timeline.GetEventCount(), 1u, "Event should be replaced");
  is(timeline.GetValueAtTime(0.1), 20.0f, "The first event should be overwritten");
  timeline.LinearRampToValueAtTime(30.0f, 0.1, rv);
  is(rv, NS_OK, "Event scheduling should be successful");
  is(timeline.GetEventCount(), 2u, "Different event type should be appended");
  is(timeline.GetValueAtTime(0.1), 30.0f, "The first event should be overwritten");
}

TEST(AudioEventTimeline, EventRemoval)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.SetValueAtTime(10.0f, 0.1, rv);
  timeline.SetValueAtTime(15.0f, 0.15, rv);
  timeline.SetValueAtTime(20.0f, 0.2, rv);
  timeline.LinearRampToValueAtTime(30.0f, 0.3, rv);
  is(timeline.GetEventCount(), 4u, "Should have three events initially");
  timeline.CancelScheduledValues(0.4);
  is(timeline.GetEventCount(), 4u, "Trying to delete past the end of the array should have no effect");
  timeline.CancelScheduledValues(0.3);
  is(timeline.GetEventCount(), 3u, "Should successfully delete one event");
  timeline.CancelScheduledValues(0.12);
  is(timeline.GetEventCount(), 1u, "Should successfully delete two events");
  timeline.CancelAllEvents();
  ok(timeline.HasSimpleValue(), "No event should remain scheduled");
}

TEST(AudioEventTimeline, BeforeFirstEventSetValue)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.SetValueAtTime(20.0f, 1.0, rv);
  is(timeline.GetValueAtTime(0.5), 10.0f, "Retrun the default value before the first event");
}

TEST(AudioEventTimeline, BeforeFirstEventSetTarget)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.SetTargetAtTime(20.0f, 1.0, 5.0, rv);
  is(timeline.GetValueAtTime(0.5), 10.0f, "Retrun the default value before the first event");
}

TEST(AudioEventTimeline, BeforeFirstEventLinearRamp)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.LinearRampToValueAtTime(20.0f, 1.0, rv);
  is(timeline.GetValueAtTime(0.5), 10.0f, "Retrun the default value before the first event");
}

TEST(AudioEventTimeline, BeforeFirstEventExponentialRamp)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.ExponentialRampToValueAtTime(20.0f, 1.0, rv);
  is(timeline.GetValueAtTime(0.5), 10.0f, "Retrun the default value before the first event");
}

TEST(AudioEventTimeline, AfterLastValueEvent)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.SetValueAtTime(20.0f, 1.0, rv);
  is(timeline.GetValueAtTime(1.5), 20.0f, "Return the last value after the last SetValue event");
}

TEST(AudioEventTimeline, AfterLastTargetValueEvent)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.SetTargetAtTime(20.0f, 1.0, 5.0, rv);
  is(timeline.GetValueAtTime(10.), (20.f + (10.f - 20.f) * expf(-9.0f / 5.0f)), "Return the value after the last SetTarget event based on the curve");
}

TEST(AudioEventTimeline, AfterLastTargetValueEventWithValueSet)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.SetValue(50.f);
  timeline.SetTargetAtTime(20.0f, 1.0, 5.0, rv);

  // When using SetTargetValueAtTime, Timeline become stateful: the value for
  // time t may depend on the time t-1, so we can't just query the value at a
  // time and get the right value. We have to call GetValueAtTime for the
  // previous times.
  for (double i = 0.0; i < 9.99; i+=0.01) {
    timeline.GetValueAtTime(i);
  }

  is(timeline.GetValueAtTime(10.), (20.f + (50.f - 20.f) * expf(-9.0f / 5.0f)), "Return the value after SetValue and the last SetTarget event based on the curve");
}

TEST(AudioEventTimeline, Value)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  is(timeline.Value(), 10.0f, "value should initially match the default value");
  timeline.SetValue(20.0f);
  is(timeline.Value(), 20.0f, "Should be able to set the value");
  timeline.SetValueAtTime(20.0f, 1.0, rv);
  // TODO: The following check needs to change when we compute the value based on the current time of the context
  is(timeline.Value(), 20.0f, "TODO...");
  timeline.SetValue(30.0f);
  is(timeline.Value(), 20.0f, "Should not be able to set the value");
}

TEST(AudioEventTimeline, LinearRampAtZero)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.LinearRampToValueAtTime(20.0f, 0.0, rv);
  is(timeline.GetValueAtTime(0.0), 20.0f, "Should get the correct value when t0 == t1 == 0");
}

TEST(AudioEventTimeline, ExponentialRampAtZero)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.ExponentialRampToValueAtTime(20.0f, 0.0, rv);
  is(timeline.GetValueAtTime(0.0), 20.0f, "Should get the correct value when t0 == t1 == 0");
}

TEST(AudioEventTimeline, LinearRampAtSameTime)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.SetValueAtTime(5.0f, 1.0, rv);
  timeline.LinearRampToValueAtTime(20.0f, 1.0, rv);
  is(timeline.GetValueAtTime(1.0), 20.0f, "Should get the correct value when t0 == t1");
}

TEST(AudioEventTimeline, ExponentialRampAtSameTime)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.SetValueAtTime(5.0f, 1.0, rv);
  timeline.ExponentialRampToValueAtTime(20.0f, 1.0, rv);
  is(timeline.GetValueAtTime(1.0), 20.0f, "Should get the correct value when t0 == t1");
}

TEST(AudioEventTimeline, SetTargetZeroTimeConstant)
{
  Timeline timeline(10.0f);

  ErrorResultMock rv;

  timeline.SetTargetAtTime(20.0f, 1.0, 0.0, rv);
  is(timeline.GetValueAtTime(1.0), 20.0f, "Should get the correct value when t0 == t1");
}

TEST(AudioEventTimeline, ExponentialInvalidPreviousZeroValue)
{
  Timeline timeline(0.f);

  ErrorResultMock rv;

  timeline.ExponentialRampToValueAtTime(1.f, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.SetValue(1.f);
  rv = NS_OK;
  timeline.ExponentialRampToValueAtTime(1.f, 1.0, rv);
  is(rv, NS_OK, "Should succeed this time");
  timeline.CancelScheduledValues(0.0);
  is(timeline.GetEventCount(), 0u, "Should have no events scheduled");
  rv = NS_OK;
  timeline.SetValueAtTime(0.f, 0.5, rv);
  is(rv, NS_OK, "Should succeed");
  timeline.ExponentialRampToValueAtTime(1.f, 1.0, rv);
  is(rv, NS_ERROR_DOM_SYNTAX_ERR, "Correct error code returned");
  timeline.CancelScheduledValues(0.0);
  is(timeline.GetEventCount(), 0u, "Should have no events scheduled");
  rv = NS_OK;
  timeline.ExponentialRampToValueAtTime(1.f, 1.0, rv);
  is(rv, NS_OK, "Should succeed this time");
}

TEST(AudioEventTimeline, SettingValueCurveTwice)
{
  Timeline timeline(0.f);
  float curve[] = { -1.0f, 0.0f, 1.0f };

  ErrorResultMock rv;

  timeline.SetValueCurveAtTime(curve, ArrayLength(curve), 0.0f, 0.3f, rv);
  timeline.SetValueCurveAtTime(curve, ArrayLength(curve), 0.0f, 0.3f, rv);
  is(rv, NS_OK, "SetValueCurveAtTime succeeded");
}

