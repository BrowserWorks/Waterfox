# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Profil Oluşturma Sihirbazı
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Giriş
       *[other] { create-profile-window.title } bölümüne hoş geldiniz
    }

profile-creation-explanation-1 = { -brand-short-name }, ayarlarınız ve tercihlerinizle ilgili bilgileri kişisel profilinizde saklar.

profile-creation-explanation-2 = Bu { -brand-short-name } tarayıcısını başka kullanıcılarla ortak kullanıyorsanız her kullanıcının bilgilerini birbirinden ayrı tutmak için profilleri kullanabilirsiniz. Bunun için her kullanıcı kendi profilini oluşturmalıdır.

profile-creation-explanation-3 = Bu { -brand-short-name } tarayıcısını kullanan tek kişiyseniz en azından bir profil sahibi olmanız gerekir. İsterseniz farklı zamanlarda kullandığınız farklı ayar ve tercihleri saklamak için birden fazla profil oluşturabilirsiniz. Örneğin iş için ayrı, ev için ayrı birer profil oluşturabilirsiniz.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Profilinizi oluşturmak için Devam düğmesine basın.
       *[other] Profilinizi oluşturmaya başlamak için İleri düğmesine tıklayın.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Bitiş
       *[other] { create-profile-window.title } tamamlanıyor
    }

profile-creation-intro = Birden fazla profil oluşturursanız bunları profil adlarıyla ayırabilirsiniz. Burada sunulan adı veya kendi seçtiğiniz bir adı kullanabilirsiniz.

profile-prompt = Yeni profil adını yazın:
    .accesskey = e

profile-default-name =
    .value = Varsayılan kullanıcı

profile-directory-explanation = Kullanıcı ayarlarınız, yer imleriniz ve parolalarınız burada kayıtlı olacak:

create-profile-choose-folder =
    .label = Klasör seç…
    .accesskey = s

create-profile-use-default =
    .label = Varsayılan klasörü kullan
    .accesskey = k
