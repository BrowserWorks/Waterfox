/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ArrayUtils.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/TextEvents.h"

#include "NativeKeyBindings.h"
#include "nsString.h"
#include "nsMemory.h"
#include "nsGtkKeyUtils.h"

#include <gtk/gtk.h>
#include <gdk/gdkkeysyms.h>
#include <gdk/gdk.h>

namespace mozilla {
namespace widget {

static nsTArray<CommandInt>* gCurrentCommands = nullptr;
static bool gHandled = false;

inline void AddCommand(Command aCommand) {
  MOZ_ASSERT(gCurrentCommands);
  gCurrentCommands->AppendElement(static_cast<CommandInt>(aCommand));
}

// Common GtkEntry and GtkTextView signals
static void copy_clipboard_cb(GtkWidget* w, gpointer user_data) {
  AddCommand(Command::Copy);
  g_signal_stop_emission_by_name(w, "copy_clipboard");
  gHandled = true;
}

static void cut_clipboard_cb(GtkWidget* w, gpointer user_data) {
  AddCommand(Command::Cut);
  g_signal_stop_emission_by_name(w, "cut_clipboard");
  gHandled = true;
}

// GTK distinguishes between display lines (wrapped, as they appear on the
// screen) and paragraphs, which are runs of text terminated by a newline.
// We don't have this distinction, so we always use editor's notion of
// lines, which are newline-terminated.

static const Command sDeleteCommands[][2] = {
    // backward, forward
    // CHARS
    {Command::DeleteCharBackward, Command::DeleteCharForward},
    // WORD_ENDS
    {Command::DeleteWordBackward, Command::DeleteWordForward},
    // WORDS
    {Command::DeleteWordBackward, Command::DeleteWordForward},
    // LINES
    {Command::DeleteToBeginningOfLine, Command::DeleteToEndOfLine},
    // LINE_ENDS
    {Command::DeleteToBeginningOfLine, Command::DeleteToEndOfLine},
    // PARAGRAPH_ENDS
    {Command::DeleteToBeginningOfLine, Command::DeleteToEndOfLine},
    // PARAGRAPHS
    {Command::DeleteToBeginningOfLine, Command::DeleteToEndOfLine},
    // This deletes from the end of the previous word to the beginning of the
    // next word, but only if the caret is not in a word.
    // XXX need to implement in editor
    {Command::DoNothing, Command::DoNothing}  // WHITESPACE
};

static void delete_from_cursor_cb(GtkWidget* w, GtkDeleteType del_type,
                                  gint count, gpointer user_data) {
  g_signal_stop_emission_by_name(w, "delete_from_cursor");
  if (count == 0) {
    // Nothing to do.
    return;
  }

  bool forward = count > 0;

  // Ignore GTK's Ctrl-K keybinding introduced in GTK 3.14 and removed in
  // 3.18 if the user has custom bindings set. See bug 1176929.
  if (del_type == GTK_DELETE_PARAGRAPH_ENDS && forward && GTK_IS_ENTRY(w) &&
      !gtk_check_version(3, 14, 1) && gtk_check_version(3, 17, 9)) {
    GtkStyleContext* context = gtk_widget_get_style_context(w);
    GtkStateFlags flags = gtk_widget_get_state_flags(w);

    GPtrArray* array;
    gtk_style_context_get(context, flags, "gtk-key-bindings", &array, nullptr);
    if (!array) return;
    g_ptr_array_unref(array);
  }

  gHandled = true;
  if (uint32_t(del_type) >= ArrayLength(sDeleteCommands)) {
    // unsupported deletion type
    return;
  }

  if (del_type == GTK_DELETE_WORDS) {
    // This works like word_ends, except we first move the caret to the
    // beginning/end of the current word.
    if (forward) {
      AddCommand(Command::WordNext);
      AddCommand(Command::WordPrevious);
    } else {
      AddCommand(Command::WordPrevious);
      AddCommand(Command::WordNext);
    }
  } else if (del_type == GTK_DELETE_DISPLAY_LINES ||
             del_type == GTK_DELETE_PARAGRAPHS) {
    // This works like display_line_ends, except we first move the caret to the
    // beginning/end of the current line.
    if (forward) {
      AddCommand(Command::BeginLine);
    } else {
      AddCommand(Command::EndLine);
    }
  }

  Command command = sDeleteCommands[del_type][forward];
  if (command == Command::DoNothing) {
    return;
  }

  unsigned int absCount = Abs(count);
  for (unsigned int i = 0; i < absCount; ++i) {
    AddCommand(command);
  }
}

static const Command sMoveCommands[][2][2] = {
    // non-extend { backward, forward }, extend { backward, forward }
    // GTK differentiates between logical position, which is prev/next,
    // and visual position, which is always left/right.
    // We should fix this to work the same way for RTL text input.
    {// LOGICAL_POSITIONS
     {Command::CharPrevious, Command::CharNext},
     {Command::SelectCharPrevious, Command::SelectCharNext}},
    {// VISUAL_POSITIONS
     {Command::CharPrevious, Command::CharNext},
     {Command::SelectCharPrevious, Command::SelectCharNext}},
    {// WORDS
     {Command::WordPrevious, Command::WordNext},
     {Command::SelectWordPrevious, Command::SelectWordNext}},
    {// DISPLAY_LINES
     {Command::LinePrevious, Command::LineNext},
     {Command::SelectLinePrevious, Command::SelectLineNext}},
    {// DISPLAY_LINE_ENDS
     {Command::BeginLine, Command::EndLine},
     {Command::SelectBeginLine, Command::SelectEndLine}},
    {// PARAGRAPHS
     {Command::LinePrevious, Command::LineNext},
     {Command::SelectLinePrevious, Command::SelectLineNext}},
    {// PARAGRAPH_ENDS
     {Command::BeginLine, Command::EndLine},
     {Command::SelectBeginLine, Command::SelectEndLine}},
    {// PAGES
     {Command::MovePageUp, Command::MovePageDown},
     {Command::SelectPageUp, Command::SelectPageDown}},
    {// BUFFER_ENDS
     {Command::MoveTop, Command::MoveBottom},
     {Command::SelectTop, Command::SelectBottom}},
    {// HORIZONTAL_PAGES (unsupported)
     {Command::DoNothing, Command::DoNothing},
     {Command::DoNothing, Command::DoNothing}}};

static void move_cursor_cb(GtkWidget* w, GtkMovementStep step, gint count,
                           gboolean extend_selection, gpointer user_data) {
  g_signal_stop_emission_by_name(w, "move_cursor");
  if (count == 0) {
    // Nothing to do.
    return;
  }

  gHandled = true;
  bool forward = count > 0;
  if (uint32_t(step) >= ArrayLength(sMoveCommands)) {
    // unsupported movement type
    return;
  }

  Command command = sMoveCommands[step][extend_selection][forward];
  if (command == Command::DoNothing) {
    return;
  }

  unsigned int absCount = Abs(count);
  for (unsigned int i = 0; i < absCount; ++i) {
    AddCommand(command);
  }
}

static void paste_clipboard_cb(GtkWidget* w, gpointer user_data) {
  AddCommand(Command::Paste);
  g_signal_stop_emission_by_name(w, "paste_clipboard");
  gHandled = true;
}

// GtkTextView-only signals
static void select_all_cb(GtkWidget* w, gboolean select, gpointer user_data) {
  AddCommand(Command::SelectAll);
  g_signal_stop_emission_by_name(w, "select_all");
  gHandled = true;
}

NativeKeyBindings* NativeKeyBindings::sInstanceForSingleLineEditor = nullptr;
NativeKeyBindings* NativeKeyBindings::sInstanceForMultiLineEditor = nullptr;

// static
NativeKeyBindings* NativeKeyBindings::GetInstance(NativeKeyBindingsType aType) {
  switch (aType) {
    case nsIWidget::NativeKeyBindingsForSingleLineEditor:
      if (!sInstanceForSingleLineEditor) {
        sInstanceForSingleLineEditor = new NativeKeyBindings();
        sInstanceForSingleLineEditor->Init(aType);
      }
      return sInstanceForSingleLineEditor;

    default:
      // fallback to multiline editor case in release build
      MOZ_FALLTHROUGH_ASSERT("aType is invalid or not yet implemented");
    case nsIWidget::NativeKeyBindingsForMultiLineEditor:
    case nsIWidget::NativeKeyBindingsForRichTextEditor:
      if (!sInstanceForMultiLineEditor) {
        sInstanceForMultiLineEditor = new NativeKeyBindings();
        sInstanceForMultiLineEditor->Init(aType);
      }
      return sInstanceForMultiLineEditor;
  }
}

// static
void NativeKeyBindings::Shutdown() {
  delete sInstanceForSingleLineEditor;
  sInstanceForSingleLineEditor = nullptr;
  delete sInstanceForMultiLineEditor;
  sInstanceForMultiLineEditor = nullptr;
}

void NativeKeyBindings::Init(NativeKeyBindingsType aType) {
  switch (aType) {
    case nsIWidget::NativeKeyBindingsForSingleLineEditor:
      mNativeTarget = gtk_entry_new();
      break;
    default:
      mNativeTarget = gtk_text_view_new();
      if (gtk_major_version > 2 ||
          (gtk_major_version == 2 &&
           (gtk_minor_version > 2 ||
            (gtk_minor_version == 2 && gtk_micro_version >= 2)))) {
        // select_all only exists in gtk >= 2.2.2.  Prior to that,
        // ctrl+a is bound to (move to beginning, select to end).
        g_signal_connect(mNativeTarget, "select_all", G_CALLBACK(select_all_cb),
                         this);
      }
      break;
  }

  g_object_ref_sink(mNativeTarget);

  g_signal_connect(mNativeTarget, "copy_clipboard",
                   G_CALLBACK(copy_clipboard_cb), this);
  g_signal_connect(mNativeTarget, "cut_clipboard", G_CALLBACK(cut_clipboard_cb),
                   this);
  g_signal_connect(mNativeTarget, "delete_from_cursor",
                   G_CALLBACK(delete_from_cursor_cb), this);
  g_signal_connect(mNativeTarget, "move_cursor", G_CALLBACK(move_cursor_cb),
                   this);
  g_signal_connect(mNativeTarget, "paste_clipboard",
                   G_CALLBACK(paste_clipboard_cb), this);
}

NativeKeyBindings::~NativeKeyBindings() {
  gtk_widget_destroy(mNativeTarget);
  g_object_unref(mNativeTarget);
}

void NativeKeyBindings::GetEditCommands(const WidgetKeyboardEvent& aEvent,
                                        nsTArray<CommandInt>& aCommands) {
  // If the native key event is set, it must be synthesized for tests.
  // We just ignore such events because this behavior depends on system
  // settings.
  if (!aEvent.mNativeKeyEvent) {
    // It must be synthesized event or dispatched DOM event from chrome.
    return;
  }

  guint keyval;

  if (aEvent.mCharCode) {
    keyval = gdk_unicode_to_keyval(aEvent.mCharCode);
  } else {
    keyval = static_cast<GdkEventKey*>(aEvent.mNativeKeyEvent)->keyval;
  }

  if (GetEditCommandsInternal(aEvent, aCommands, keyval)) {
    return;
  }

  for (uint32_t i = 0; i < aEvent.mAlternativeCharCodes.Length(); ++i) {
    uint32_t ch = aEvent.IsShift()
                      ? aEvent.mAlternativeCharCodes[i].mShiftedCharCode
                      : aEvent.mAlternativeCharCodes[i].mUnshiftedCharCode;
    if (ch && ch != aEvent.mCharCode) {
      keyval = gdk_unicode_to_keyval(ch);
      if (GetEditCommandsInternal(aEvent, aCommands, keyval)) {
        return;
      }
    }
  }

  /*
  gtk_bindings_activate_event is preferable, but it has unresolved bug:
  http://bugzilla.gnome.org/show_bug.cgi?id=162726
  The bug was already marked as FIXED.  However, somebody reports that the
  bug still exists.
  Also gtk_bindings_activate may work with some non-shortcuts operations
  (todo: check it). See bug 411005 and bug 406407.

  Code, which should be used after fixing GNOME bug 162726:

    gtk_bindings_activate_event(GTK_OBJECT(mNativeTarget),
      static_cast<GdkEventKey*>(aEvent.mNativeKeyEvent));
  */
}

bool NativeKeyBindings::GetEditCommandsInternal(
    const WidgetKeyboardEvent& aEvent, nsTArray<CommandInt>& aCommands,
    guint aKeyval) {
  guint modifiers = static_cast<GdkEventKey*>(aEvent.mNativeKeyEvent)->state;

  gCurrentCommands = &aCommands;

  gHandled = false;
  gtk_bindings_activate(G_OBJECT(mNativeTarget), aKeyval,
                        GdkModifierType(modifiers));

  gCurrentCommands = nullptr;

  MOZ_ASSERT(!gHandled || !aCommands.IsEmpty());

  return gHandled;
}

}  // namespace widget
}  // namespace mozilla
