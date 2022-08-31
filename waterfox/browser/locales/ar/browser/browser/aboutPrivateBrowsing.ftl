# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = افتح نافذة خاصة
    .accesskey = خ
about-private-browsing-search-placeholder = ابحث في الوِب
about-private-browsing-info-title = أنت في نافذة خاصة
about-private-browsing-search-btn =
    .title = ابحث في الوِب
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = ‫ابحث مستعملًا { $engine } أو أدخِل عنوانا
about-private-browsing-handoff-no-engine =
    .title = ابحث أو أدخِل عنوانا
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = ‫ابحث مستعملًا { $engine } أو أدخِل عنوانا
about-private-browsing-handoff-text-no-engine = ابحث أو أدخِل عنوانا
about-private-browsing-not-private = لستَ حاليا في نافذة خاصة.
about-private-browsing-info-description-private-window = نافذة خاصة: يمسح { -brand-short-name } تأريخ البحث والتصفح عند إغلاق جميع النوافذ الخاصة. هذا لا يجعلك مجهول الهوية.
about-private-browsing-info-description-simplified = يمسح { -brand-short-name } تأريخ البحث والتصفح عند إغلاق جميع النوافذ الخاصة، ولكن هذا لا يجعلك مجهول الهوية.
about-private-browsing-learn-more-link = اطّلع على المزيد
about-private-browsing-hide-activity = أخفِ نشاطك وموقعك أينما ذهبت
about-private-browsing-get-privacy = احمِ خصوصيتك أينما تصفّحت
about-private-browsing-hide-activity-1 = أخفِ نشاط التصفح ومكانك باستعمال { -mozilla-vpn-brand-name }. يمكنك بنقرة واحدة إنشاء اتصال آمن، حتى على الشبكات اللاسلكية العمومية.
about-private-browsing-prominent-cta = احفظ خصوصيتك دومًا عبر { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = نزّل { -focus-brand-name }
about-private-browsing-focus-promo-header = ‏{ -focus-brand-name }: التصفّح الخاص أينما كنت
about-private-browsing-focus-promo-text = يمسح تطبيق الهاتف للتصفح الخاص كل التأريخ والكعكات في كل مرة.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = جرّب التصفح الخاص من هاتفك
about-private-browsing-focus-promo-text-b = استعمل { -focus-brand-name } كي تبحث عما تريد بخصوصية ولا تريد لمتصفّح الهاتف الرئيس أن يرى ما تفعل.
about-private-browsing-focus-promo-text-c = يمسح { -focus-brand-name } تأريخ التصفّح في كل مرة، وفي نفس الوقت يمنع الإعلانات والمتعقّبات.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = محرّك { $engineName } هو محرّك البحث المبدئي في النوافذ الخاصة
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] انتقل إلى <a data-l10n-name="link-options">الخيارات</a> لاختيار محرّك بحث آخر
       *[other] انتقل إلى <a data-l10n-name="link-options">التفضيلات</a> لاختيار محرّك بحث آخر
    }
about-private-browsing-search-banner-close-button =
    .aria-label = أغلِق
about-private-browsing-promo-close-button =
    .title = أغلِق

## Strings used in a “pin promotion” message, which prompts users to pin a private window

