# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

download-ui-confirm-title = أتريد إلغاء كلّ التّنزيلات؟

## Variables:
##   $downloadsCount (Number): The current downloads count.

download-ui-confirm-quit-cancel-downloads =
    { $downloadsCount ->
        [1] إذا خرجت الآن، سيُلغى تنزيل واحد. أمتأكّد أنّك تريد الخروج؟
       *[other] إذا خرجت الآن، ستُلغى { $downloadsCount } من التنزيلات. أمتأكّد أنّك تريد الخروج؟
    }
download-ui-confirm-quit-cancel-downloads-mac =
    { $downloadsCount ->
        [1] إذا أنهيت الآن، سيُلغى تنزيل واحد. أمتأكّد أنّك تريد الإنهاء؟
       *[other] إذا أنهيت الآن، ستُلغى من { $downloadsCount } التنزيلات. أمتأكّد أنّك تريد الإنهاء؟
    }
download-ui-dont-quit-button =
    { PLATFORM() ->
        [mac] لا تُنهِ
       *[other] لا تخرج
    }

download-ui-confirm-offline-cancel-downloads =
    { $downloadsCount ->
        [1] إذا انتقلت إلى العمل دون اتصال الآن، سيُلغى تنزيل واحد. أمتأكّد أنّك تريد الانتقال إلى العمل دون اتصال؟
       *[other] إذا انتقلت إلى العمل دون اتصال الآن، ستُُلغى { $downloadsCount } من التنزيلات. أمتأكّد أنّك تريد الانتقال إلى العمل دون اتصال؟
    }
download-ui-dont-go-offline-button = ابقَ متّصلا

download-ui-confirm-leave-private-browsing-windows-cancel-downloads =
    { $downloadsCount ->
        [1] إن أغلقت كل نوافذ التصفح الخاص الآن، فسيُلغى تنزيل واحد. هل أنت متأكد أنك تريد مغادرة التصفح الخاص؟
       *[other] إن أغلقت كل نوافذ التصفح الخاص الآن، فسيُلغى { $downloadsCount } من التنزيلات. هل أنت متأكد أنك تريد مغادرة التصفح الخاص؟
    }
download-ui-dont-leave-private-browsing-button = ابقَ في التصفح الخاص

download-ui-cancel-downloads-ok =
    { $downloadsCount ->
        [1] ألغِ تنزيلًا واحدًا
       *[other] ألغِ { $downloadsCount } من التنزيلات
    }

##

download-ui-file-executable-security-warning-title = هل تريد فتح الملفّ التّنفيذيّ؟
# Variables:
#   $executable (String): The executable file to be opened.
download-ui-file-executable-security-warning = ‏”{ $executable }“ ملفّ تنفيذيّ. قد تتضمّن الملفّات التّنفيذيّة فيروسات أو برامج خبيثة أخرى يمكن أن تضرّ بالحاسوب. خذ الحذر عند فتح هذا الملفّ. أمتأكّد أنّك تريد بدأ ”{ $executable }“؟
