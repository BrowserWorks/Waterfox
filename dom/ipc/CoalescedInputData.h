/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_CoalescedInputData_h
#define mozilla_dom_CoalescedInputData_h

#include "mozilla/UniquePtr.h"
#include "mozilla/layers/ScrollableLayerGuid.h"
#include "nsRefreshObservers.h"

class nsRefreshDriver;

namespace mozilla::dom {

class BrowserChild;

template <class InputEventType>
class CoalescedInputData {
 protected:
  using ScrollableLayerGuid = mozilla::layers::ScrollableLayerGuid;

  UniquePtr<InputEventType> mCoalescedInputEvent;
  ScrollableLayerGuid mGuid;
  uint64_t mInputBlockId = 0;
  uint32_t mGeneration = 0;

  void AdvanceGeneration() {
    if (!IsEmpty()) {
      mGeneration++;
    }
  }

 public:
  CoalescedInputData() = default;

  void RetrieveDataFrom(CoalescedInputData& aSource) {
    aSource.AdvanceGeneration();
    AdvanceGeneration();
    mCoalescedInputEvent = std::move(aSource.mCoalescedInputEvent);
    mGuid = aSource.mGuid;
    mInputBlockId = aSource.mInputBlockId;
  }

  bool IsEmpty() { return !mCoalescedInputEvent; }

  bool CanCoalesce(const InputEventType& aEvent,
                   const ScrollableLayerGuid& aGuid,
                   const uint64_t& aInputBlockId);

  UniquePtr<InputEventType> TakeCoalescedEvent() {
    AdvanceGeneration();
    return std::move(mCoalescedInputEvent);
  }

  ScrollableLayerGuid GetScrollableLayerGuid() { return mGuid; }

  uint64_t GetInputBlockId() { return mInputBlockId; }

  /**
   * The generation number of the latest state stored by the instance.
   * It'll be incremented when the coalesced event data is retrieved or taken.
   * So, this is useful to avoid handling same coalesced events twice when
   * a nested event loop may handle this.
   * NOTE: You should compare the value only with `==` or `!=`.  Do not use
   * `<` nor `>` because the value may circulate to 0 from UINT32_MAX.
   */
  [[nodiscard]] uint32_t Generation() const { return mGeneration; }
};

class CoalescedInputFlusher : public nsARefreshObserver {
 public:
  explicit CoalescedInputFlusher(BrowserChild* aBrowserChild);

  virtual void WillRefresh(mozilla::TimeStamp aTime) override = 0;

  NS_INLINE_DECL_REFCOUNTING(CoalescedInputFlusher, override)

  void StartObserver();
  void RemoveObserver();

  /**
   * Return a refresh driver which is proper one for BrowserChild.
   * Note that this is not a getter of mRefreshDriver.
   */
  [[nodiscard]] nsRefreshDriver* GetRefreshDriver();

 protected:
  virtual ~CoalescedInputFlusher();

  // BrowserChild owns us and unregisters us from the refresh driver in
  // DestroyWindow() before it can go away.
  BrowserChild* mBrowserChild;
  // A refresh driver which this instance waits for the next refresh of.
  RefPtr<nsRefreshDriver> mRefreshDriver;
};
}  // namespace mozilla::dom

#endif  // mozilla_dom_CoalescedInputData_h
