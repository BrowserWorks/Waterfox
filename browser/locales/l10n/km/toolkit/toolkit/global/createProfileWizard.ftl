# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = អ្នក​ជំនួយ​ការ​បង្កើត​ទម្រង់​
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] សេចក្ដីផ្ដើម
       *[other] ស្វាគមន៍​មក​កាន់ { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } រក្សា​ទុក​ព័ត៌មាន​អំពី​ការ​កំណត់​ និង ចំណង់​ចំណូល​ចិត្ត​របស់​អ្នក​ ក្នុង​ទម្រង់​ផ្ទាល់​ខ្លួន​របស់​អ្នក ។

profile-creation-explanation-2 = ប្រសិនបើ​អ្នក​ចែក​រំលែក​ច្បាប់​ចម្លង​ { -brand-short-name } នេះ​ទៅឲ្យ​អ្នក​ដទៃ អ្នក​អាច​ប្រើ​ទម្រង់​ ដើម្បី​រក្សា​ព័ត៌មាន​អ្នក​ប្រើ​និមួយៗ​ដោយឡែក​ពីគ្នា ។​ ដើម្បី​ធ្វើ​ដូច្នេះ អ្នក​ប្រើ​និមួយៗគួរ​បង្កើត​ទម្រង់​របស់​គាត់​ផ្ទាល់​ ។

profile-creation-explanation-3 = បើ​អ្នក​ជា​បុគ្គល​តែម្នាក់ដែល​ប្រើ​ច្បាប់​ចម្លងរបស់​ { -brand-short-name } នេះ អ្នក​ត្រូវ​តែ​មាន​ទម្រង់​មួយ​យ៉ាង​តិច ។ អ្នក​​អាច​បង្កើត​ទម្រង់​ច្រើន​សម្រាប់​ខ្លួន​អ្នក​ ដើម្បី​ផ្ទុក​សំណុំ​នៃ​ការ​កំណត់​ និង​ ចំណង់​ចំណូល​ចិត្ត​ខុសៗគ្នា ប្រសិន​បើអ្នក​ចង់ ។ ឧទាហរណ៍ អ្នក​ប្រហែល​ចង់​មាន​ទម្រង់​ដាច់​ដោយ​ឡែក​ពី​គ្នា​ សម្រាប់​ជំនួញ និង ផ្ទាល់​ខ្លួន ។

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] ដើម្បី​ចាប់ផ្ដើម​បង្កើត​ទម្រង់​របស់​អ្នក ចុច បន្ត ។
       *[other] ដើម្បី​ចាប់​ផ្ដើម​​បង្កើត​ទម្រង់​របស់​អ្នក​សូម​ចុច បន្ទាប់ ។
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] សេចក្ដីបញ្ចប់
       *[other] កំពុង​បញ្ចប់ { create-profile-window.title }
    }

profile-creation-intro = ប្រសិន​​បើ​​អ្នក​​បង្កើត​​ទម្រង់​​ច្រើន​ អ្នក​អាច​​បញ្ជាក់​​ពួក​វា​​ដោយ​​ឡែក​​ដោយ​​ឈ្មោះ​របស់​ទម្រង់ ។ អ្នក​​អាច​​ប្រើ​​ឈ្មោះ​​ដែល​បាន​ផ្តល់​ទី​នេះ​ ឬ​​ ឈ្មោះ​ផ្សេង​ដែល​​អ្នក​​ចង់​​បាន ។

profile-prompt = បញ្ចូល​ឈ្មោះ​ប្រវត្តិរូប​ថ្មី៖
    .accesskey = E

profile-default-name =
    .value = អ្នក​ប្រើ​លំនាំ​ដើម

profile-directory-explanation = ការ​កំណត់​អ្នក​ប្រើ ចំណូល​ចិត្ត និង​ទិន្នន័យ​ដែល​ទាក់ទង​អ្នក​ប្រើ​ផ្សេង​ទៀត​នឹង​ត្រូវ​បាន​រក្សា​ទុក​ក្នុង ៖

create-profile-choose-folder =
    .label = ជ្រើស​ថត…
    .accesskey = C

create-profile-use-default =
    .label = ប្រើ​ថត​លំនាំ​ដើម
    .accesskey = U
