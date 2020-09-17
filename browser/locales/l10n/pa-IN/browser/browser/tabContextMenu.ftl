# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = ਟੈਬ ਨੂੰ ਮੁੜ-ਲੋਡ ਕਰੋ
    .accesskey = R
select-all-tabs =
    .label = ਸਾਰੀਆਂ ਟੈਬਾਂ ਚੁਣੋ
    .accesskey = S
duplicate-tab =
    .label = ਡੁਪਲੀਕੇਟ ਟੈਬ
    .accesskey = D
duplicate-tabs =
    .label = ਡੁਪਲੀਕੇਟ ਟੈਬਾਂ
    .accesskey = D
close-tabs-to-the-end =
    .label = ਸੱਜੇ ਪਾਸੇ ਵਾਲੀਆਂ ਟੈਬਾਂ ਨੂੰ ਬੰਦ ਕਰੋ
    .accesskey = i
close-other-tabs =
    .label = ਹੋਰ ਟੈਬਾਂ ਨੂੰ ਬੰਦ ਕਰੋ
    .accesskey = o
reload-tabs =
    .label = ਟੈਬਾਂ ਮੁੜ-ਲੋਡ ਕਰੋ
    .accesskey = R
pin-tab =
    .label = ਟੈਬ ਨੂੰ ਪਿੰਨ ਕਰੋ
    .accesskey = P
unpin-tab =
    .label = ਟੈਬ ਨੂੰ ਅਣ-ਪਿੰਨ ਕਰੋ
    .accesskey = b
pin-selected-tabs =
    .label = ਟੈਬਾਂ ਟੰਗੋ
    .accesskey = P
unpin-selected-tabs =
    .label = ਟੈਬਾਂ ਲਾਹੋ
    .accesskey = p
bookmark-selected-tabs =
    .label = …ਟੈਬਾਂ ਬੁੱਕਮਾਰਕ ਕਰੋ
    .accesskey = B
bookmark-tab =
    .label = ਟੈਬ ਬੁੱਕਮਾਰਕ ਕਰੋ
    .accesskey = B
reopen-in-container =
    .label = ਕਨਟਰੇਨਰ ਵਿੱਚ ਮੁੜ-ਖੋਲ੍ਹੋ
    .accesskey = e
move-to-start =
    .label = ਸ਼ੁਰੂ 'ਤੇ ਭੇਜੋ
    .accesskey = S
move-to-end =
    .label = ਅੰਤ 'ਤੇ ਭੇਜੋ
    .accesskey = E
move-to-new-window =
    .label = ਨਵੀਂ ਵਿੰਡੋ 'ਚ ਭੇਜੋ
    .accesskey = W
tab-context-close-multiple-tabs =
    .label = ਕਈ ਟੈਬਾਂ ਬੰਦ ਕਰੋ
    .accesskey = M

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] ਬੰਦ ਕੀਤੀ ਟੈਬ ਵਾਪਸ ਲਵੋ
            [one] ਬੰਦ ਕੀਤੀ ਟੈਬ ਵਾਪਸ ਲਵੋ
           *[other] ਬੰਦ ਕੀਤੀਆਂ ਟੈਬਾਂ ਵਾਪਸ ਲਵੋ
        }
    .accesskey = U
close-tab =
    .label = ਟੈਬ ਨੂੰ ਬੰਦ ਕਰੋ
    .accesskey = c
close-tabs =
    .label = ਟੈਬਾਂ ਬੰਦ ਕਰੋ
    .accesskey = S
move-tabs =
    .label = ਟੈਬਾਂ ਭੇਜੋ
    .accesskey = v
move-tab =
    .label = ਟੈਬ ਭੇਜੋ
    .accesskey = v
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] ਟੈਬ ਬੰਦ ਕਰੋ
            [one] ਟੈਬ ਬੰਦ ਕਰੋ
           *[other] ਟੈਬਾਂ ਬੰਦ ਕਰੋ
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] ਟੈਬ ਭੇਜੋ
            [one] ਟੈਬ ਭੇਜੋ
           *[other] ਟੈਬਾਂ ਭੇਜੋ
        }
    .accesskey = v
