# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title.
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Nahlášení rozšíření { $addon-name }

abuse-report-title-extension =
    Nahlásit toto rozšíření { -vendor-short-name.gender ->
        [masculine] { -vendor-short-name(case: "dat") }
        [feminine] { -vendor-short-name(case: "dat") }
        [neuter] { -vendor-short-name(case: "dat") }
       *[other] organizaci { -vendor-short-name }
    }
abuse-report-title-theme =
    Nahlásit tento vzhled { -vendor-short-name.gender ->
        [masculine] { -vendor-short-name(case: "dat") }
        [feminine] { -vendor-short-name(case: "dat") }
        [neuter] { -vendor-short-name(case: "dat") }
       *[other] organizaci { -vendor-short-name }
    }
abuse-report-subtitle = Jaký je problém?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = od <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Nevíte, který problém vybrat?
    Podívejte se na <a data-l10n-name="learnmore-link">informace o hlášení rozšíření a doplňků</a>

abuse-report-submit-description = Popis problému (nepovinný)
abuse-report-textarea =
    .placeholder = Pokud podrobně popíšete, jaký problém pozorujete, je pro nás snazší ho vyřešit. Děkujeme vám za hlášení a pomoc.
abuse-report-submit-note = Poznámka: nezadávejte prosím žádné osobní informace jako jméno, e-mailovou adresu, telefonní číslo ani poštovní adresu. { -vendor-short-name } si tato hlášení trvale ukládá.

## Panel buttons.

abuse-report-cancel-button = Zrušit
abuse-report-next-button = Další
abuse-report-goback-button = Zpět
abuse-report-submit-button = Odeslat

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on


## Message bars descriptions.
##
## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Nahlášení doplňku <span data-l10n-name="addon-name">{ $addon-name }</span> bylo zrušeno.
abuse-report-messagebar-submitting = Odesílání hlášení doplňku <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Děkujeme za nahlášení. Chcete doplněk <span data-l10n-name="addon-name">{ $addon-name }</span> odebrat?
abuse-report-messagebar-submitted-noremove = Děkujeme vám za hlášení.
abuse-report-messagebar-removed-extension = Děkujeme za nahlášení. Rozšíření <span data-l10n-name="addon-name">{ $addon-name }</span> bylo odebráno.
abuse-report-messagebar-removed-theme = Děkujeme za nahlášení. Vzhled <span data-l10n-name="addon-name">{ $addon-name }</span> byl odebrán.
abuse-report-messagebar-error = Při odesílání hlášení pro <span data-l10n-name="addon-name">{ $addon-name }</span> došlo k chybě.
abuse-report-messagebar-error-recent-submit = Doplněk <span data-l10n-name="addon-name">{ $addon-name }</span> nebyl nahlášen, protože jste ho už nedávno nahlásili.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Ano, odebrat
abuse-report-messagebar-action-keep-extension = Ne, ponechat
abuse-report-messagebar-action-remove-theme = Ano, odebrat
abuse-report-messagebar-action-keep-theme = Ne, ponechat
abuse-report-messagebar-action-retry = Zkusit znovu
abuse-report-messagebar-action-cancel = Zrušit

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Poškozuje můj počítač nebo data
abuse-report-damage-example = Příklad: malware či krádež dat

abuse-report-spam-reason-v2 = Obsahuje spam nebo vkládá nevyžádané reklamy
abuse-report-spam-example = Příklad: vkládání reklam do webových stránek

abuse-report-settings-reason-v2 = Mění nastavení vyhledávače, domovské stránky nebo nového panelu bez předchozího dotazu
abuse-report-settings-suggestions = Před nahlášením tohoto rozšíření prosím zkontrolujte tato nastavení:
abuse-report-settings-suggestions-search = nastavení výchozího vyhledávače
abuse-report-settings-suggestions-homepage = nastavení domovské stránky a nového panelu

abuse-report-deceptive-reason-v2 = Vydává se za něco jiného
abuse-report-deceptive-example = Příklad: zavádějící popis nebo náhledy

abuse-report-broken-reason-extension-v2 =
    Nefunguje, rozbíjí webové stránky nebo zpomaluje{ -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "acc") }
        [feminine] { -brand-product-name(case: "acc") }
        [neuter] { -brand-product-name(case: "acc") }
       *[other] aplikaci { -brand-product-name }
    }
abuse-report-broken-reason-theme-v2 = Nefunguje nebo robíjí rozhraní prohlížeče
abuse-report-broken-example = Příklad: funkce je pomalá, špatně se používá, vůbec nefunguje, nebo omezuje funkčnost a zobrazení webových stránek
abuse-report-broken-suggestions-extension = Zdá se, že jste objevili chybu. Kromě odeslání hlášení nám v řešení problému pomůže, pokud kontaktujete i autora rozšíření. <a data-l10n-name="support-link">Navštivte stránky rozšíření</a>, kde na autora najdete kontakt.
abuse-report-broken-suggestions-theme = Zdá se, že jste objevili chybu. Kromě odeslání hlášení nám v řešení problému pomůže, pokud kontaktujete i autora vzhledu. <a data-l10n-name="support-link">Navštivte stránky vzhledu</a>, kde na autora najdete kontakt.

abuse-report-policy-reason-v2 = Obsahuje nenávistný, násilný nebo nelegální obsah
abuse-report-policy-suggestions = Poznámka: Problémy s autorskými právy prosím hlaste podle <a data-l10n-name="report-infringement-link">tohoto návodu</a>.

abuse-report-unwanted-reason-v2 = Toto rozšíření jsem nechtěl(a) instalovat a nevím, jak ho odebrat
abuse-report-unwanted-example = Příklad: nainstalováno cizí aplikací bez vašeho svolení

abuse-report-other-reason = Něco jiného

