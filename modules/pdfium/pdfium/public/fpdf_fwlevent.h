// Copyright 2014 PDFium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original code copyright 2014 Foxit Software Inc. http://www.foxitsoftware.com

#ifndef PUBLIC_FPDF_FWLEVENT_H_
#define PUBLIC_FPDF_FWLEVENT_H_

// NOLINTNEXTLINE(build/include)
#include "fpdfview.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

typedef int FPDF_INT32;
typedef unsigned int FPDF_UINT32;
typedef float FPDF_FLOAT;

// Event types.
typedef enum {
  FWL_EVENTTYPE_Mouse = 0,
  FWL_EVENTTYPE_MouseWheel,
  FWL_EVENTTYPE_Key,
} FWL_EVENTTYPE;

// Key flags.
typedef enum {
  FWL_EVENTFLAG_ShiftKey = 1 << 0,
  FWL_EVENTFLAG_ControlKey = 1 << 1,
  FWL_EVENTFLAG_AltKey = 1 << 2,
  FWL_EVENTFLAG_MetaKey = 1 << 3,
  FWL_EVENTFLAG_KeyPad = 1 << 4,
  FWL_EVENTFLAG_AutoRepeat = 1 << 5,
  FWL_EVENTFLAG_LeftButtonDown = 1 << 6,
  FWL_EVENTFLAG_MiddleButtonDown = 1 << 7,
  FWL_EVENTFLAG_RightButtonDown = 1 << 8,
} FWL_EVENTFLAG;

// Mouse messages.
typedef enum {
  FWL_EVENTMOUSECMD_LButtonDown = 1,
  FWL_EVENTMOUSECMD_LButtonUp,
  FWL_EVENTMOUSECMD_LButtonDblClk,
  FWL_EVENTMOUSECMD_RButtonDown,
  FWL_EVENTMOUSECMD_RButtonUp,
  FWL_EVENTMOUSECMD_RButtonDblClk,
  FWL_EVENTMOUSECMD_MButtonDown,
  FWL_EVENTMOUSECMD_MButtonUp,
  FWL_EVENTMOUSECMD_MButtonDblClk,
  FWL_EVENTMOUSECMD_MouseMove,
  FWL_EVENTMOUSECMD_MouseEnter,
  FWL_EVENTMOUSECMD_MouseHover,
  FWL_EVENTMOUSECMD_MouseLeave,
} FWL_EVENT_MOUSECMD;

// Mouse events.
struct FWL_EVENT_MOUSE {
  FPDF_UINT32 command;
  FPDF_DWORD flag;
  FPDF_FLOAT x;
  FPDF_FLOAT y;
};

// Mouse wheel events.
struct FWL_EVENT_MOUSEWHEEL {
  FPDF_DWORD flag;
  FPDF_FLOAT x;
  FPDF_FLOAT y;
  FPDF_FLOAT deltaX;
  FPDF_FLOAT deltaY;
};

// Virtual keycodes.
typedef enum {
  FWL_VKEY_Back = 0x08,
  FWL_VKEY_Tab = 0x09,
  FWL_VKEY_NewLine = 0x0A,
  FWL_VKEY_Clear = 0x0C,
  FWL_VKEY_Return = 0x0D,
  FWL_VKEY_Shift = 0x10,
  FWL_VKEY_Control = 0x11,
  FWL_VKEY_Menu = 0x12,
  FWL_VKEY_Pause = 0x13,
  FWL_VKEY_Capital = 0x14,
  FWL_VKEY_Kana = 0x15,
  FWL_VKEY_Hangul = 0x15,
  FWL_VKEY_Junja = 0x17,
  FWL_VKEY_Final = 0x18,
  FWL_VKEY_Hanja = 0x19,
  FWL_VKEY_Kanji = 0x19,
  FWL_VKEY_Escape = 0x1B,
  FWL_VKEY_Convert = 0x1C,
  FWL_VKEY_NonConvert = 0x1D,
  FWL_VKEY_Accept = 0x1E,
  FWL_VKEY_ModeChange = 0x1F,
  FWL_VKEY_Space = 0x20,
  FWL_VKEY_Prior = 0x21,
  FWL_VKEY_Next = 0x22,
  FWL_VKEY_End = 0x23,
  FWL_VKEY_Home = 0x24,
  FWL_VKEY_Left = 0x25,
  FWL_VKEY_Up = 0x26,
  FWL_VKEY_Right = 0x27,
  FWL_VKEY_Down = 0x28,
  FWL_VKEY_Select = 0x29,
  FWL_VKEY_Print = 0x2A,
  FWL_VKEY_Execute = 0x2B,
  FWL_VKEY_Snapshot = 0x2C,
  FWL_VKEY_Insert = 0x2D,
  FWL_VKEY_Delete = 0x2E,
  FWL_VKEY_Help = 0x2F,
  FWL_VKEY_0 = 0x30,
  FWL_VKEY_1 = 0x31,
  FWL_VKEY_2 = 0x32,
  FWL_VKEY_3 = 0x33,
  FWL_VKEY_4 = 0x34,
  FWL_VKEY_5 = 0x35,
  FWL_VKEY_6 = 0x36,
  FWL_VKEY_7 = 0x37,
  FWL_VKEY_8 = 0x38,
  FWL_VKEY_9 = 0x39,
  FWL_VKEY_A = 0x41,
  FWL_VKEY_B = 0x42,
  FWL_VKEY_C = 0x43,
  FWL_VKEY_D = 0x44,
  FWL_VKEY_E = 0x45,
  FWL_VKEY_F = 0x46,
  FWL_VKEY_G = 0x47,
  FWL_VKEY_H = 0x48,
  FWL_VKEY_I = 0x49,
  FWL_VKEY_J = 0x4A,
  FWL_VKEY_K = 0x4B,
  FWL_VKEY_L = 0x4C,
  FWL_VKEY_M = 0x4D,
  FWL_VKEY_N = 0x4E,
  FWL_VKEY_O = 0x4F,
  FWL_VKEY_P = 0x50,
  FWL_VKEY_Q = 0x51,
  FWL_VKEY_R = 0x52,
  FWL_VKEY_S = 0x53,
  FWL_VKEY_T = 0x54,
  FWL_VKEY_U = 0x55,
  FWL_VKEY_V = 0x56,
  FWL_VKEY_W = 0x57,
  FWL_VKEY_X = 0x58,
  FWL_VKEY_Y = 0x59,
  FWL_VKEY_Z = 0x5A,
  FWL_VKEY_LWin = 0x5B,
  FWL_VKEY_Command = 0x5B,
  FWL_VKEY_RWin = 0x5C,
  FWL_VKEY_Apps = 0x5D,
  FWL_VKEY_Sleep = 0x5F,
  FWL_VKEY_NumPad0 = 0x60,
  FWL_VKEY_NumPad1 = 0x61,
  FWL_VKEY_NumPad2 = 0x62,
  FWL_VKEY_NumPad3 = 0x63,
  FWL_VKEY_NumPad4 = 0x64,
  FWL_VKEY_NumPad5 = 0x65,
  FWL_VKEY_NumPad6 = 0x66,
  FWL_VKEY_NumPad7 = 0x67,
  FWL_VKEY_NumPad8 = 0x68,
  FWL_VKEY_NumPad9 = 0x69,
  FWL_VKEY_Multiply = 0x6A,
  FWL_VKEY_Add = 0x6B,
  FWL_VKEY_Separator = 0x6C,
  FWL_VKEY_Subtract = 0x6D,
  FWL_VKEY_Decimal = 0x6E,
  FWL_VKEY_Divide = 0x6F,
  FWL_VKEY_F1 = 0x70,
  FWL_VKEY_F2 = 0x71,
  FWL_VKEY_F3 = 0x72,
  FWL_VKEY_F4 = 0x73,
  FWL_VKEY_F5 = 0x74,
  FWL_VKEY_F6 = 0x75,
  FWL_VKEY_F7 = 0x76,
  FWL_VKEY_F8 = 0x77,
  FWL_VKEY_F9 = 0x78,
  FWL_VKEY_F10 = 0x79,
  FWL_VKEY_F11 = 0x7A,
  FWL_VKEY_F12 = 0x7B,
  FWL_VKEY_F13 = 0x7C,
  FWL_VKEY_F14 = 0x7D,
  FWL_VKEY_F15 = 0x7E,
  FWL_VKEY_F16 = 0x7F,
  FWL_VKEY_F17 = 0x80,
  FWL_VKEY_F18 = 0x81,
  FWL_VKEY_F19 = 0x82,
  FWL_VKEY_F20 = 0x83,
  FWL_VKEY_F21 = 0x84,
  FWL_VKEY_F22 = 0x85,
  FWL_VKEY_F23 = 0x86,
  FWL_VKEY_F24 = 0x87,
  FWL_VKEY_NunLock = 0x90,
  FWL_VKEY_Scroll = 0x91,
  FWL_VKEY_LShift = 0xA0,
  FWL_VKEY_RShift = 0xA1,
  FWL_VKEY_LControl = 0xA2,
  FWL_VKEY_RControl = 0xA3,
  FWL_VKEY_LMenu = 0xA4,
  FWL_VKEY_RMenu = 0xA5,
  FWL_VKEY_BROWSER_Back = 0xA6,
  FWL_VKEY_BROWSER_Forward = 0xA7,
  FWL_VKEY_BROWSER_Refresh = 0xA8,
  FWL_VKEY_BROWSER_Stop = 0xA9,
  FWL_VKEY_BROWSER_Search = 0xAA,
  FWL_VKEY_BROWSER_Favorites = 0xAB,
  FWL_VKEY_BROWSER_Home = 0xAC,
  FWL_VKEY_VOLUME_Mute = 0xAD,
  FWL_VKEY_VOLUME_Down = 0xAE,
  FWL_VKEY_VOLUME_Up = 0xAF,
  FWL_VKEY_MEDIA_NEXT_Track = 0xB0,
  FWL_VKEY_MEDIA_PREV_Track = 0xB1,
  FWL_VKEY_MEDIA_Stop = 0xB2,
  FWL_VKEY_MEDIA_PLAY_Pause = 0xB3,
  FWL_VKEY_MEDIA_LAUNCH_Mail = 0xB4,
  FWL_VKEY_MEDIA_LAUNCH_MEDIA_Select = 0xB5,
  FWL_VKEY_MEDIA_LAUNCH_APP1 = 0xB6,
  FWL_VKEY_MEDIA_LAUNCH_APP2 = 0xB7,
  FWL_VKEY_OEM_1 = 0xBA,
  FWL_VKEY_OEM_Plus = 0xBB,
  FWL_VKEY_OEM_Comma = 0xBC,
  FWL_VKEY_OEM_Minus = 0xBD,
  FWL_VKEY_OEM_Period = 0xBE,
  FWL_VKEY_OEM_2 = 0xBF,
  FWL_VKEY_OEM_3 = 0xC0,
  FWL_VKEY_OEM_4 = 0xDB,
  FWL_VKEY_OEM_5 = 0xDC,
  FWL_VKEY_OEM_6 = 0xDD,
  FWL_VKEY_OEM_7 = 0xDE,
  FWL_VKEY_OEM_8 = 0xDF,
  FWL_VKEY_OEM_102 = 0xE2,
  FWL_VKEY_ProcessKey = 0xE5,
  FWL_VKEY_Packet = 0xE7,
  FWL_VKEY_Attn = 0xF6,
  FWL_VKEY_Crsel = 0xF7,
  FWL_VKEY_Exsel = 0xF8,
  FWL_VKEY_Ereof = 0xF9,
  FWL_VKEY_Play = 0xFA,
  FWL_VKEY_Zoom = 0xFB,
  FWL_VKEY_NoName = 0xFC,
  FWL_VKEY_PA1 = 0xFD,
  FWL_VKEY_OEM_Clear = 0xFE,
  FWL_VKEY_Unknown = 0,
} FWL_VKEYCODE;

// Key event commands.
typedef enum {
  FWL_EVENTKEYCMD_KeyDown = 1,
  FWL_EVENTKEYCMD_KeyUp,
  FWL_EVENTKEYCMD_Char,
} FWL_EVENTKEYCMD;

// Key events.
struct FWL_EVENT_KEY {
  FPDF_UINT32 command;
  FPDF_DWORD flag;
  union {
    // Virtual key code.
    FPDF_UINT32 vkcode;
    // Character code.
    FPDF_DWORD charcode;
  } code;
};

// Event types.
struct FWL_EVENT {
  // Structure size.
  FPDF_UINT32 size;
  // FWL_EVENTTYPE.
  FPDF_UINT32 type;
  union {
    struct FWL_EVENT_MOUSE mouse;
    struct FWL_EVENT_MOUSEWHEEL wheel;
    struct FWL_EVENT_KEY key;
  } s;
};

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // PUBLIC_FPDF_FWLEVENT_H_
