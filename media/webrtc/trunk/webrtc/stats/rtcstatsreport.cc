/*
 *  Copyright 2016 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/api/stats/rtcstatsreport.h"

#include <sstream>

namespace webrtc {

RTCStatsReport::ConstIterator::ConstIterator(
    const rtc::scoped_refptr<const RTCStatsReport>& report,
    StatsMap::const_iterator it)
    : report_(report),
      it_(it) {
}

RTCStatsReport::ConstIterator::ConstIterator(const ConstIterator&& other)
    : report_(std::move(other.report_)),
      it_(std::move(other.it_)) {
}

RTCStatsReport::ConstIterator::~ConstIterator() {
}

RTCStatsReport::ConstIterator& RTCStatsReport::ConstIterator::operator++() {
  ++it_;
  return *this;
}

RTCStatsReport::ConstIterator& RTCStatsReport::ConstIterator::operator++(int) {
  return ++(*this);
}

const RTCStats& RTCStatsReport::ConstIterator::operator*() const {
  return *it_->second.get();
}

const RTCStats* RTCStatsReport::ConstIterator::operator->() const {
  return it_->second.get();
}

bool RTCStatsReport::ConstIterator::operator==(
    const RTCStatsReport::ConstIterator& other) const {
  return it_ == other.it_;
}

bool RTCStatsReport::ConstIterator::operator!=(
    const RTCStatsReport::ConstIterator& other) const {
  return !(*this == other);
}

rtc::scoped_refptr<RTCStatsReport> RTCStatsReport::Create(
    int64_t timestamp_us) {
  return rtc::scoped_refptr<RTCStatsReport>(
      new rtc::RefCountedObject<RTCStatsReport>(timestamp_us));
}

RTCStatsReport::RTCStatsReport(int64_t timestamp_us)
    : timestamp_us_(timestamp_us) {
}

RTCStatsReport::~RTCStatsReport() {
}

void RTCStatsReport::AddStats(std::unique_ptr<const RTCStats> stats) {
  auto result = stats_.insert(std::make_pair(std::string(stats->id()),
                              std::move(stats)));
  RTC_DCHECK(result.second) <<
      "A stats object with ID " << result.first->second->id() << " is already "
      "present in this stats report.";
}

const RTCStats* RTCStatsReport::Get(const std::string& id) const {
  StatsMap::const_iterator it = stats_.find(id);
  if (it != stats_.cend())
    return it->second.get();
  return nullptr;
}

void RTCStatsReport::TakeMembersFrom(
    rtc::scoped_refptr<RTCStatsReport> victim) {
  for (StatsMap::iterator it = victim->stats_.begin();
       it != victim->stats_.end(); ++it) {
    AddStats(std::unique_ptr<const RTCStats>(it->second.release()));
  }
  victim->stats_.clear();
}

RTCStatsReport::ConstIterator RTCStatsReport::begin() const {
  return ConstIterator(rtc::scoped_refptr<const RTCStatsReport>(this),
                       stats_.cbegin());
}

RTCStatsReport::ConstIterator RTCStatsReport::end() const {
  return ConstIterator(rtc::scoped_refptr<const RTCStatsReport>(this),
                       stats_.cend());
}

std::string RTCStatsReport::ToString() const {
  std::ostringstream oss;
  ConstIterator it = begin();
  if (it != end()) {
    oss << it->ToString();
    for (++it; it != end(); ++it) {
      oss << '\n' << it->ToString();
    }
  }
  return oss.str();
}

}  // namespace webrtc
