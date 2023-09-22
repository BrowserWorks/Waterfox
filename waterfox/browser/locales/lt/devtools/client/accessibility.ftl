# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Accessibility panel.

accessibility-learn-more = Sužinoti daugiau

accessibility-text-label-header = Tekstinės žymės ir pavadinimai

accessibility-keyboard-header = Klaviatūra

## Text entries that are used as text alternative for icons that depict accessibility isses.


## These strings are used in the overlay displayed when running an audit in the accessibility panel

accessibility-progress-initializing = Pradedama…
    .aria-valuetext = Pradedama…

# This string is displayed in the audit progress bar in the accessibility panel.
# Variables:
#   $nodeCount (Integer) - The number of nodes for which the audit was run so far.
accessibility-progress-progressbar =
    { $nodeCount ->
        [one] Tikrinamas { $nodeCount } elementas
        [few] Tikrinama { $nodeCount } elementų
       *[other] Tikrinami { $nodeCount } elementai
    }

accessibility-progress-finishing = Baigiama…
    .aria-valuetext = Baigiama…

## Text entries that are used as text alternative for icons that depict accessibility issues.

accessibility-warning =
    .alt = Įspėjimas

accessibility-fail =
    .alt = Klaida

accessibility-best-practices =
    .alt = Geriausios praktikos

## Text entries for a paragraph used in the accessibility panel sidebar's checks section
## that describe that currently selected accessible object has an accessibility issue
## with its text label or accessible name.

accessibility-text-label-issue-area = Naudokite <code>alt</code> atributą, norėdami pažymėti <div>area</div> elementus, kurie turi <span>href</span> atributą. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-dialog = Dialogai turėtų būti sužymėti. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-document-title = Dokumentai privalo turėti <code>title</code> atributą. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-embed = Įterptas turinys privalo būti sužymėtas. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-figure = Figūros su neprivalomomis antraštėmis turėtų būti sužymėtos. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-fieldset = <code>fieldset</code> elementai privalo būti sužymėti. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-fieldset-legend2 = Naudokite <code>legend</code> elementą, norėdami pažymėti <span>fieldset</span>. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-form = Formų lementai privalo būti sužymėti. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-form-visible = Formų elementai turėtų turėti matomą tekstinę žymą. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-frame = <code>frame</code> elementai privalo būti sužymėti. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-glyph = Naudokite <code>alt</code> atributą <span>mglyph</span> elementų žymėjimui. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-heading = Antraštės privalo būti sužymėtos. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-heading-content = Antraštės turėtų turėti matomą tekstinį turinį. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-iframe = Naudokite <code>title</code> atributą <span>iframe</span> turinio apibūdinimui. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-image = Turinys su paveikslais privalo būti sužymėtas. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-interactive = Interaktyvūs elementai privalo būti sužymėti. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-optgroup-label2 = Naudokite <code>label</code> atributą, norėdami pažymėti <span>optgroup</span>. <a>Sužinoti daugiau</a>

accessibility-text-label-issue-toolbar = Priemonių juostos privalo būti sužymėtos, jeigu yra daugiau nei viena. <a>Sužinoti daugiau</a>

## Text entries for a paragraph used in the accessibility panel sidebar's checks section
## that describe that currently selected accessible object has a keyboard accessibility
## issue.

accessibility-keyboard-issue-semantics = Fokusuojami elementai turėtų turėti interaktyvias semantikas. <a>Sužinoti daugiau</a>

accessibility-keyboard-issue-tabindex = Venkite <code>tabindex</code> atributo, didesnio negu nulis, naudojimo. <a>Sužinoti daugiau</a>

accessibility-keyboard-issue-action = Interaktyvūs elementai privalo turėti galimybę būti aktyvuojami klaviatūra. <a>Sužinoti daugiau</a>

accessibility-keyboard-issue-focusable = Interaktyvūs elementai privalo būti fokusuojami. <a>Sužinoti daugiau</a>

accessibility-keyboard-issue-focus-visible = Fokusuojamas elementas galimai neturi „focus“ stiliaus taisyklių. <a>Sužinoti daugiau</a>

accessibility-keyboard-issue-mouse-only = Paspaudžiami elementai privalo būti fokusuojami ir turėtų turėti interaktyvias semantikas. <a>Sužinoti daugiau</a>
