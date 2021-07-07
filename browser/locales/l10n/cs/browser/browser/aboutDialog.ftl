# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title =
        O { -brand-full-name.gender ->
            [masculine] { -brand-full-name(case: "loc") }
            [feminine] { -brand-full-name(case: "loc") }
            [neuter] { -brand-full-name(case: "loc") }
           *[other] aplikaci { -brand-full-name }
        }

releaseNotes-link = Co je nového

update-checkForUpdatesButton =
    .label = Zkontrolovat aktualizace
    .accesskey = Z

update-updateButton =
    .label =
        Restartovat a aktualizovat { -brand-shorter-name.gender ->
            [masculine] { -brand-shorter-name(case: "acc") }
            [feminine] { -brand-shorter-name(case: "acc") }
            [neuter] { -brand-shorter-name(case: "acc") }
           *[other] aplikaci { -brand-shorter-name }
        }
    .accesskey = R

update-checkingForUpdates = Kontrola aktualizací…
update-downloading = <img data-l10n-name="icon"/>Stahování aktualizace — <label data-l10n-name="download-status"/>
update-downloading-message = Stahování aktualizace — <label data-l10n-name="download-status"/>
update-applying = Probíhá aktualizace…

update-failed = Aktualizace selhala. <label data-l10n-name="failed-link">Stáhnout nejnovější verzi</label>
update-failed-main = Aktualizace selhala. <a data-l10n-name="failed-link-main">Stáhnout nejnovější verzi</a>

update-adminDisabled = Aktualizace jsou zakázány správcem
update-noUpdatesFound = { -brand-short-name } je aktuální
update-otherInstanceHandlingUpdates =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } je aktualizován jinou instancí
        [feminine] { -brand-short-name } je aktualizována jinou instancí
        [neuter] { -brand-short-name } je aktualizováno jinou instancí
       *[other] Aplikace { -brand-short-name } je aktualizována jinou instancí
    }

update-manual = Aktualizace jsou dostupné na <label data-l10n-name="manual-link"/>

update-unsupported = Na tomto systému nelze provádět další aktualizace. <label data-l10n-name="unsupported-link">Zjistit více</label>

update-restarting = Restartování…

channel-description = Používáte aktualizační kanál <label data-l10n-name="current-channel"></label>.

warningDesc-version = { -brand-short-name } je experimentální verze a může být nestabilní.

aboutdialog-help-user =
    Nápověda { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "gen") }
        [feminine] { -brand-product-name(case: "gen") }
        [neuter] { -brand-product-name(case: "gen") }
       *[other] aplikace { -brand-product-name }
    }
aboutdialog-submit-feedback = Odeslat zpětnou vazbu

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> je <label data-l10n-name="community-exp-creditsLink">celosvětová komunita</label> snažící se o zachování veřejně dostupného, otevřeného a všem přístupného webu.

community-2 =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } byl vytvořen organizací <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>.
        [feminine] { -brand-short-name } byla vytvořena organizací <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>.
        [neuter] { -brand-short-name } bylo vytvořeno organizací <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>.
       *[other] Aplikace { -brand-short-name } byla vytvořena organizací <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>.
    } Jsme <label data-l10n-name="community-creditsLink">celosvětová komunita</label> snažící se o zachování veřejně dostupného, otevřeného a všem přístupného webu.

helpus = Chcete pomoci? <label data-l10n-name="helpus-donateLink">Darujte příspěvek</label> nebo <label data-l10n-name="helpus-getInvolvedLink">se zapojte!</label>

bottomLinks-license = Licence
bottomLinks-rights = Vaše práva
bottomLinks-privacy = Zásady ochrany osobních údajů

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits } bitů)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits } bitů)
