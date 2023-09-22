# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Accessibility panel.

accessibility-learn-more = اطّلع على المزيد

accessibility-text-label-header = تسميات النصوص والأسماء

accessibility-keyboard-header = لوحة المفاتيح

## Text entries that are used as text alternative for icons that depict accessibility isses.


## These strings are used in the overlay displayed when running an audit in the accessibility panel

accessibility-progress-initializing = يُمهّد…
    .aria-valuetext = يُمهّد…

# This string is displayed in the audit progress bar in the accessibility panel.
# Variables:
#   $nodeCount (Integer) - The number of nodes for which the audit was run so far.
accessibility-progress-progressbar =
    { $nodeCount ->
        [zero] لا يفحص أي عقدة
        [one] يفحص عقدة واحدة
        [two] يفحص عقدتين اثنتين
        [few] يفحص { $nodeCount } عقد
        [many] يفحص { $nodeCount } عقدة
       *[other] يفحص { $nodeCount } عقدة
    }

accessibility-progress-finishing = يُنهي العمل…
    .aria-valuetext = يُنهي العمل…

## Text entries that are used as text alternative for icons that depict accessibility issues.

accessibility-warning =
    .alt = تحذير

accessibility-fail =
    .alt = خطأ

accessibility-best-practices =
    .alt = أفضل الممارسات

## Text entries for a paragraph used in the accessibility panel sidebar's checks section
## that describe that currently selected accessible object has an accessibility issue
## with its text label or accessible name.

accessibility-text-label-issue-area = استعمل السمة <code>alt</code> لتُسمّي أيّ عناصر <div>area</div> تحتوي على سمة <span>href</span>. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-dialog = عليك تسمية الحوارات. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-document-title = يجب أن يكون للمستندات <code>عنوان/title</code>. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-embed = عليك تسمية المحتوى المضمّن. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-figure = عليك تسمية الأشكال التي لها شروحات اختيارية. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-fieldset = عليك تسمية عناصر <code>fieldset</code>. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-fieldset-legend2 = استعمل عنصر <code>legend</code> لتسمية <span>fieldset</span>.  <a>اطّلع على المزيد</a>

accessibility-text-label-issue-form = عليك تسمية عناصر الاستمارات. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-form-visible = يجب أن يكون لعناصر الاستمارات تسمية نصوص واضحة. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-frame = عليك تسمية عناصر <code>frame</code>. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-glyph = استعمل صفة <code>alt</code> لتسمية عناصر <span>mglyph</span>. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-heading = عليك تسمية العناوين. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-iframe = استعمل صفة <code>title</code> لوصف محتوى<span>iframe</span>. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-image = عليك تسمية المحتوى الذي فيه صور. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-interactive = عليك تسمية العناصر التفاعلية. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-optgroup-label2 = استعمل صفة <code>label</code> لتسمية <span>optgroup</span>. <a>اطّلع على المزيد</a>

accessibility-text-label-issue-toolbar = عليك تسمية أشرطة الأدوات إن كان هناك أكثر من واحد. <a>اطّلع على المزيد</a>

## Text entries for a paragraph used in the accessibility panel sidebar's checks section
## that describe that currently selected accessible object has a keyboard accessibility
## issue.

accessibility-keyboard-issue-tabindex = تجّب استعمال صفة <code>tabindex</code> تزيد عن الصفر. <a>اطّلع على المزيد</a>

