/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */
/* This Source Code is subject to the terms of the Mozilla Public License
 * version 2.0 (the "License"). You can obtain a copy of the License at
 * http://mozilla.org/MPL/2.0/. */

/* rendering object for CSS "display: ruby-base" */

#include "nsRubyBaseFrame.h"

#include "mozilla/WritingModes.h"
#include "nsLineLayout.h"
#include "nsPresContext.h"
#include "nsStyleContext.h"

using namespace mozilla;

//----------------------------------------------------------------------

// Frame class boilerplate
// =======================

NS_QUERYFRAME_HEAD(nsRubyBaseFrame)
  NS_QUERYFRAME_ENTRY(nsRubyBaseFrame)
NS_QUERYFRAME_TAIL_INHERITING(nsRubyContentFrame)

NS_IMPL_FRAMEARENA_HELPERS(nsRubyBaseFrame)

nsContainerFrame*
NS_NewRubyBaseFrame(nsIPresShell* aPresShell,
                    nsStyleContext* aContext)
{
  return new (aPresShell) nsRubyBaseFrame(aContext);
}


//----------------------------------------------------------------------

// nsRubyBaseFrame Method Implementations
// ======================================

#ifdef DEBUG_FRAME_DUMP
nsresult
nsRubyBaseFrame::GetFrameName(nsAString& aResult) const
{
  return MakeFrameName(NS_LITERAL_STRING("RubyBase"), aResult);
}
#endif
