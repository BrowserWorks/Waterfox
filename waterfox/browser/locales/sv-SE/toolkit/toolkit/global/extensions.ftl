# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Lägg till { $extension }?
webext-perms-header-with-perms = Lägg till { $extension }? Det här tillägget har tillstånd att:
webext-perms-header-unsigned = Lägg till { $extension }? Det här tillägget är inte verifierat. Skadliga tillägg kan stjäla din privata information eller äventyra din dator. Lägg bara till det om du litar på källan.
webext-perms-header-unsigned-with-perms = Lägg till { $extension }? Det här tillägget är inte verifierat. Skadliga tillägg kan stjäla din privata information eller äventyra din dator. Lägg bara till det om du litar på källan. Det här tillägget har tillstånd att:
webext-perms-sideload-header = { $extension } har lagts till
webext-perms-optional-perms-header = { $extension } begär ytterligare behörigheter.

##

webext-perms-add =
    .label = Lägg till
    .accesskey = L
webext-perms-cancel =
    .label = Avbryt
    .accesskey = A

webext-perms-sideload-text = Ett annat program på datorn har installerat ett tillägg som kan påverka din webbläsare. Vänligen granska detta tilläggs behörighetsförfrågningar och välj att Aktivera eller Avbryt (för att lämna det inaktiverat).
webext-perms-sideload-text-no-perms = Ett annat program på datorn har installerat ett tillägg som kan påverka din webbläsare. Vänligen välj att Aktivera eller Avbryt (för att lämna det inaktiverat).
webext-perms-sideload-enable =
    .label = Aktivera
    .accesskey = A
webext-perms-sideload-cancel =
    .label = Avbryt
    .accesskey = A

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = { $extension } har uppdaterats. Du måste godkänna nya behörigheter innan den uppdaterade versionen installeras. Om du väljer "Avbryt" behålls din nuvarande tilläggsversion. Det här tillägget har tillstånd att:
webext-perms-update-accept =
    .label = Uppdatera
    .accesskey = U

webext-perms-optional-perms-list-intro = Den vill:
webext-perms-optional-perms-allow =
    .label = Tillåt
    .accesskey = T
webext-perms-optional-perms-deny =
    .label = Neka
    .accesskey = N

webext-perms-host-description-all-urls = Åtkomst till dina data för alla webbplatser

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Åtkomst till dina data för platser i domänen { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards =
    { $domainCount ->
        [one] Åtkomst till dina data i { $domainCount } annan domän
       *[other] Åtkomst till dina data i { $domainCount } andra domäner
    }
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Åtkomst till dina data för { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites =
    { $domainCount ->
        [one] Åtkomst till dina data på { $domainCount } annan plats
       *[other] Åtkomst till dina data på { $domainCount } andra platser
    }

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = Detta tillägg ger { $hostname } åtkomst till dina MIDI-enheter.
webext-site-perms-header-with-gated-perms-midi-sysex = Detta tillägg ger { $hostname } åtkomst till dina MIDI-enheter (med SysEx-stöd).

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    Dessa är vanligtvis plugin-enheter som ljudsyntar, men de kan också vara inbyggda i din dator.
    
    Webbplatser har normalt inte tillgång till MIDI-enheter. Felaktig användning kan orsaka skada eller äventyra säkerheten.

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Vill du lägga till { $extension }? Det här tillägget ger { $hostname } följande funktioner:
webext-site-perms-header-unsigned-with-perms = Vill du lägga till { $extension }? Det här tillägget är overifierat. Skadliga tillägg kan stjäla din privata information eller äventyra din dator. Lägg bara till det om du litar på källan. Det här tillägget ger { $hostname } följande funktioner:

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = Åtkomst till MIDI-enheter
webext-site-perms-midi-sysex = Åtkomst till MIDI-enheter med SysEx-stöd
