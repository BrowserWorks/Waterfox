# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = مددگار پروفائل بنائیں
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] تعارف
       *[other] { create-profile-window.title } میں خوش آمدید
    }

profile-creation-explanation-1 = { -brand-short-name } آپ کی سیٹکگیں اور ترجیحات کی معلومات آپ کی ذاتی پروفائل میں ذخیرہ کرتا ہے۔

profile-creation-explanation-2 = اگر آپ دیگر صارفین کے ساتھ { -brand-short-name } کی اس نقل کی حصہ داری کر رہے ہیں تو آپ ہر صارف کی معلومات الگ رکھنے کے لیے پروفائل استعمال کر سکتے ہیں۔ ایسا کرنے کے لیے، ہر صارف کو اپنی ذاتی پروفائل بنانی چاہیے۔

profile-creation-explanation-3 = اگر آپ { -brand-short-name } کی اس نقل کو استعمال کرنے والے اکیلے فرد ہیں تو آپ کے پاس کم از کم ایک پروفائل ہونی چاہیے۔ اگر آپ چاہیں، تو آپ سیٹنگوں کے مختلف سیٹ اور ترجیحات کو ذخیرہ کرنے کے لیے اپنے لیے کثیر پروفائلیں بنا سکتے ہیں۔ مثلاً آپ کاروبار اور ذاتی استعمال کے لیے علیحدہ پروفائلیں رکھ سکتے ہیں۔

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] اپنی پروفائل بنانے کی شروعات کرنے کے لیے جاری رکھیی پر کلک کریں۔
       *[other] اپنی پروفائل بنانے کی شروعات کرنے کے لیے، اگلا پر کلک کریں۔
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] ماحصل
       *[other] { create-profile-window.title } مکمل ہو رہا ہے
    }

profile-creation-intro = اگر آپ متعدد پروفائل بناتے ہیں تو آپ پروفائل ناموں کے ذریعے ان میں فرق کر سکتے ہیں۔ آپ یہاں مہیا کیا گیا نام استعمال کرسکتے ہیں یا اپنا کوئی نام استعمال کرسکتے ہیں۔

profile-prompt = نیا پروفائل نام داخل کریں:
    .accesskey = د

profile-default-name =
    .value = طے شدہ صارف

profile-directory-explanation = آپ کی سیٹنگز، ترجیحات اور دیگر متعلقہ کوائف اس جگح محفوظ ہوں گی:

create-profile-choose-folder =
    .label = پوشہ انتخاب کریں…
    .accesskey = ا

create-profile-use-default =
    .label = طے شدہ پوشہ استعمال کریں
    .accesskey = ا
