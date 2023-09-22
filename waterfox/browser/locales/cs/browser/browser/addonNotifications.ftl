# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zabránil této stránce v dotazu na instalaci softwaru do vašeho počítače.
        [feminine] { -brand-short-name } zabránila této stránce v dotazu na instalaci softwaru do vašeho počítače.
        [neuter] { -brand-short-name } zabránilo této stránce v dotazu na instalaci softwaru do vašeho počítače.
       *[other] Aplikace { -brand-short-name } zabránila této stránce v dotazu na instalaci softwaru do vašeho počítače.
    }

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = Chcete nainstalovat doplněk ze serveru { $host }?
xpinstall-prompt-message = Pokoušíte se nainstalovat doplněk ze serveru { $host }. Ujistěte se prosím, že tomuto serveru můžete věřit.

##

xpinstall-prompt-header-unknown = Chcete nainstalovat doplněk z neznámého serveru?
xpinstall-prompt-message-unknown = Pokoušíte se nainstalovat doplněk z neznámého serveru. Ujistěte se prosím, že mu můžete věřit.

xpinstall-prompt-dont-allow =
    .label = Nepovolit
    .accesskey = N
xpinstall-prompt-never-allow =
    .label = Nikdy nepovolovat
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = Nahlásit podezřelou stránku
    .accesskey = N
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = Nainstalovat
    .accesskey = N

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = Tato stránka požaduje přístup k vašim MIDI (Musical Instrument Digital Interface) zařízením. Přístup k zařízení lze povolit instalací doplňku.
site-permission-install-first-prompt-midi-message = Tento přístup nemusí být vždy bezpečný. Pokračujte jen pokud tomuto serveru důvěřujete.

##

xpinstall-disabled-locked = Instalace softwaru byla zakázána správcem vašeho systému.
xpinstall-disabled = Instalace softwaru je v současnosti zakázána. Klepněte na Povolit a zkuste to prosím znovu.
xpinstall-disabled-button =
    .label = Povolit
    .accesskey = P

# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = Doplněk { $addonName } ({ $addonId }) byl zablokován správcem vašeho počítače.
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = Nastavení od správce vašeho systému zabránilo této stránce v dotazu na instalaci softwaru do vašeho počítače.
addon-install-full-screen-blocked = V režimu celé obrazovky nebo těsně před jeho zapnutím není instalace doplňků povolena.

# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item =
    { -brand-short-name.case-status ->
        [with-cases] Doplněk { $addonName } byl přidán do { -brand-short-name(case: "gen") }
       *[no-cases] Doplněk { $addonName } byl přidán do aplikace { -brand-short-name }
    }
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = Doplněk { $addonName } vyžaduje nová oprávnění

# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons =
    { -brand-short-name.case-status ->
        [with-cases] Dokončete instalaci rozšíření importovaných do { -brand-short-name(case: "gen") }
       *[no-cases] Dokončete instalaci rozšíření importovaných do aplikace { -brand-short-name }
    }

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = Opravdu chcete odebrat rozšíření { $name }?
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message =
    { -brand-shorter-name.case-status ->
        [with-cases] Odebrat doplněk { $name } z { -brand-shorter-name(case: "gen") }?
       *[no-cases] Odebrat doplněk { $name } z aplikace { -brand-shorter-name }?
    }
addon-removal-button = Odebrat
addon-removal-abuse-report-checkbox =
    { -vendor-short-name.case-status ->
        [with-cases] Nahlásit toto rozšíření { -vendor-short-name(case: "dat") }
       *[no-cases] Nahlásit toto rozšíření organizaci { -vendor-short-name }
    }

# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying =
    { $addonCount ->
        [one] Stahování a ověřování doplňku…
        [few] Stahování a ověřování { $addonCount } doplňků…
       *[other] Stahování a ověřování { $addonCount } doplňků…
    }
addon-download-verifying = Ověřování

addon-install-cancel-button =
    .label = Zrušit
    .accesskey = Z
addon-install-accept-button =
    .label = Přidat
    .accesskey = a

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message =
    { $addonCount ->
        [one]
            { -brand-short-name.case-status ->
                [with-cases] Tato stránka chce nainstalovat doplněk do { -brand-short-name(case: "gen") }:
               *[no-cases] Tato stránka chce nainstalovat doplněk do aplikace { -brand-short-name }:
            }
        [few]
            { -brand-short-name.case-status ->
                [with-cases] Tato stránka chce nainstalovat { $addonCount } doplňky do { -brand-short-name(case: "gen") }:
               *[no-cases] Tato stránka chce nainstalovat { $addonCount } doplňky do aplikace { -brand-short-name }:
            }
       *[other]
            { -brand-short-name.case-status ->
                [with-cases] Tato stránka chce nainstalovat { $addonCount } doplňků do { -brand-short-name(case: "gen") }:
               *[no-cases] Tato stránka chce nainstalovat { $addonCount } doplňků do aplikace { -brand-short-name }:
            }
    }
addon-confirm-install-unsigned-message =
    { $addonCount ->
        [one]
            { -brand-short-name.case-status ->
                [with-cases] Upozornění: Tato stránka chce nainstalovat neověřený doplněk do { -brand-short-name(case: "gen") }. Pokračujte na vlastní riziko.
               *[no-cases] Upozornění: Tato stránka chce nainstalovat neověřený doplněk do aplikace { -brand-short-name }. Pokračujte na vlastní riziko.
            }
        [few]
            { -brand-short-name.case-status ->
                [with-cases] Upozornění: Tato stránka chce nainstalovat { $addonCount } neověřené doplňky do { -brand-short-name(case: "gen") }. Pokračujte na vlastní riziko.
               *[no-cases] Upozornění: Tato stránka chce nainstalovat { $addonCount } neověřené doplňky do aplikace { -brand-short-name }. Pokračujte na vlastní riziko.
            }
       *[other]
            { -brand-short-name.case-status ->
                [with-cases] Upozornění: Tato stránka chce nainstalovat { $addonCount } neověřených doplňků do { -brand-short-name(case: "gen") }. Pokračujte na vlastní riziko.
               *[no-cases] Upozornění: Tato stránka chce nainstalovat { $addonCount } neověřených doplňků do aplikace { -brand-short-name }. Pokračujte na vlastní riziko.
            }
    }
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message =
    { $addonCount ->
        [one]
            { -brand-short-name.case-status ->
                [with-cases] Upozornění: Tato stránka chce do { -brand-short-name(case: "gen") } nainstalovat nověřený doplněk. Pokračujte na vlastní riziko.
               *[no-cases] Upozornění: Tato stránka chce do aplikace { -brand-short-name } nainstalovat nověřený doplněk. Pokračujte na vlastní riziko.
            }
        [few]
            { -brand-short-name.case-status ->
                [with-cases] Upozornění: Tato stránka chce do { -brand-short-name(case: "gen") } nainstalovat { $addonCount } doplňky, z nichž některé jsou neověřené. Pokračujte na vlastní riziko.
               *[no-cases] Upozornění: Tato stránka chce do aplikace { -brand-short-name } nainstalovat { $addonCount } doplňky, z nichž některé jsou neověřené. Pokračujte na vlastní riziko.
            }
       *[other]
            { -brand-short-name.case-status ->
                [with-cases] Upozornění: Tato stránka chce do { -brand-short-name(case: "gen") } nainstalovat { $addonCount } doplňků, z nichž některé jsou neověřené. Pokračujte na vlastní riziko.
               *[no-cases] Upozornění: Tato stránka chce do aplikace { -brand-short-name } nainstalovat { $addonCount } doplňků, z nichž některé jsou neověřené. Pokračujte na vlastní riziko.
            }
    }

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = Doplněk nemohl být stažen z důvodu selhání připojení.
addon-install-error-incorrect-hash = Doplněk nemohl být nainstalován, protože neodpovídá doplňku, který { -brand-short-name } očekává.
addon-install-error-corrupt-file = Doplněk stažený z tohoto serveru nemohl být nainstalován, protože je poškozený.
addon-install-error-file-access = Doplněk { $addonName } nemohl být nainstalován, protože { -brand-short-name } nemůže upravit potřebný soubor.
addon-install-error-not-signed =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } zabránil tomuto serveru v instalaci neověřeného doplňku.
        [feminine] { -brand-short-name } zabránila tomuto serveru v instalaci neověřeného doplňku.
        [neuter] { -brand-short-name } zabránilo tomuto serveru v instalaci neověřeného doplňku.
       *[other] Aplikace { -brand-short-name } zabránila tomuto serveru v instalaci neověřeného doplňku.
    }
addon-install-error-invalid-domain = Doplněk { $addonName } nelze z této adresy nainstalovat.
addon-local-install-error-network-failure = Tento doplněk nemohl být nainstalován z důvodu chyby souborového systému.
addon-local-install-error-incorrect-hash = Tento doplněk nemohl být nainstalován, protože neodpovídá doplňku, který { -brand-short-name } očekává.
addon-local-install-error-corrupt-file = Tento doplněk nemohl být nainstalován, protože je poškozený.
addon-local-install-error-file-access = Doplněk { $addonName } nemohl být nainstalován, protože { -brand-short-name } nemůže upravit potřebný soubor.
addon-local-install-error-not-signed = Tento doplněk nemohl být nainstalován, protože nebyl ověřen.
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible =
    { -brand-short-name.case-status ->
        [with-cases] Doplněk { $addonName } nemohl být nainstalován, protože není kompatibilní s { -brand-short-name(case: "ins") } { $appVersion }.
       *[no-cases] Doplněk { $addonName } nemohl být nainstalován, protože není kompatibilní s aplikací { -brand-short-name } { $appVersion }.
    }
addon-install-error-blocklisted = Doplněk { $addonName } nemohl být nainstalován, protože přináší vysoké riziko nestability nebo bezpečnostních problémů.
