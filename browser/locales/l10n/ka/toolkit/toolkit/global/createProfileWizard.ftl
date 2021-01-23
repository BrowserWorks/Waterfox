# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = პროფილის შექმნის მეგზური
    .style = width: 55em; height: 40em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] შესავალი
       *[other] მოგესალმებათ { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } ინახავს მონაცემებს თქვენი პარამეტრების, მახასიათებლების და სანიშნების შესახებ თქვენს პირად პროფილში.

profile-creation-explanation-2 = თუ ეს { -brand-short-name } თქვენ გარდა სხვა მომხმარებლების განკარგულებაშიცაა, შეგიძლიათ პროფილები გამოიყენოთ მონაცემების განსაცალკევებლად. ამისთვის თითოეულმა მომხმარებელმა საკუთარი პროფილი უნდა შექმნას.

profile-creation-explanation-3 = თუ ეს { -brand-short-name } მხოლოდ თქვენს განკარგულებაშია, უნდა გაგაჩნდეთ ერთი პროფილი მაინც. სურვილისამებრ შეგიძლიათ შექმნათ სხვადასხვა პროფილებიც განსხვავებული პარამეტრებით. მაგალითად, სამუშაოდ და პირადი სარგებლობისთვის.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] თქვენი პროფილის შესაქმნელად დააწკაპეთ „გაგრძელებას“.
       *[other] პროფილის შესაქმნელად დააწკაპეთ „შემდეგს“.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] დასკვნა
       *[other] სრულდება – { create-profile-window.title }
    }

profile-creation-intro = რამდენიმე პროფილის შექმნის შემთხვევაში მათ სხვადასხვა სახელი უნდა მიანიჭოთ. შეგიძლიათ გამოიყენოთ ქვემოთ მოყვანილი ან მოიფიქროთ და დაარქვათ თქვენ თვითონ.

profile-prompt = მიუთითეთ პროფილის ახალი სახელი:
    .accesskey = მ

profile-default-name =
    .value = ნაგულისხმევი მომხმარებელი

profile-directory-explanation = თქვენი პარამეტრები და დანარჩენი მონაცემები აქ შეინახება:

create-profile-choose-folder =
    .label = საქაღალდის არჩევა…
    .accesskey = ს

create-profile-use-default =
    .label = ნაგულისხმევი საქაღალდის გამოყენება
    .accesskey = ნ
