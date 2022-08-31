# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Shortcuts

# Variables:
#  $key (String) - The shortcut key.
shortcut-key = { $key }

meta-shortcut-key =
    { PLATFORM() ->
        [macos] ⌘ { $key }
       *[other] Meta+{ $key }
    }

ctrl-shortcut-key =
    { PLATFORM() ->
        [macos] ⌃ { $key }
       *[other] Ctrl+{ $key }
    }

shift-shortcut-key =
    { PLATFORM() ->
        [macos] ⇧ { $key }
       *[other] Maiusc+{ $key }
    }

alt-shortcut-key =
    { PLATFORM() ->
        [macos] ⌥ { $key }
       *[other] Alt+{ $key }
    }

meta-ctrl-shortcut-key =
    { PLATFORM() ->
        [macos] ⌃ ⌘ { $key }
       *[other] Meta+Ctrl+{ $key }
    }

meta-alt-shortcut-key =
    { PLATFORM() ->
        [macos] ⌥ ⌘ { $key }
       *[other] Meta+Alt+{ $key }
    }

ctrl-alt-shortcut-key =
    { PLATFORM() ->
        [macos] ⌃ ⌥ { $key }
       *[other] Ctrl+Alt+{ $key }
    }

meta-ctrl-alt-shortcut-key =
    { PLATFORM() ->
        [macos] ⌃ ⌥ ⌘ { $key }
       *[other] Meta+Ctrl+Alt+{ $key }
    }

meta-shift-shortcut-key =
    { PLATFORM() ->
        [macos] ⇧ ⌘ { $key }
       *[other] Meta+Maiusc+{ $key }
    }

ctrl-shift-shortcut-key =
    { PLATFORM() ->
        [macos] ⌃ ⇧ { $key }
       *[other] Ctrl+Maiusc+{ $key }
    }

meta-ctrl-shift-shortcut-key =
    { PLATFORM() ->
        [macos] ⌃ ⇧ ⌘ { $key }
       *[other] Meta+Ctrl+Maiusc+{ $key }
    }

alt-shift-shortcut-key =
    { PLATFORM() ->
        [macos] ⌥ ⇧ { $key }
       *[other] Alt+Maiusc+{ $key }
    }

meta-shift-alt-shortcut-key2 =
    { PLATFORM() ->
        [macos] ⌥ ⇧ ⌘ { $key }
       *[other] Meta+Alt+Maiusc+{ $key }
    }

ctrl-shift-alt-shortcut-key2 =
    { PLATFORM() ->
        [macos] ⌃ ⌥ ⇧ { $key }
       *[other] Ctrl+Alt+Maiusc+{ $key }
    }

meta-ctrl-shift-alt-shortcut-key2 =
    { PLATFORM() ->
        [macos] ⌃ ⌥ ⇧ ⌘ { $key }
       *[other] Meta+Ctrl+Alt+Maiusc+{ $key }
    }

# Variables:
#  $title (String): The title coming from the original element.
#  $shortcut (String): The shortcut generated from the keystroke combination.
button-shortcut-string =
    .title = { $title } ({ $shortcut })

# Variables:
#  $label (String): The text label coming from the original element.
#  $shortcut (String): The shortcut generated from the keystroke combination.
menuitem-shortcut-string =
    .label = { $label }
    .acceltext = { $shortcut }
