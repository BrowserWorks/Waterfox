# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Headers used in the webextension permissions dialog,
## See https://bug1308309.bmoattachments.org/attachment.cgi?id=8814612
## for an example of the full dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension.

webext-perms-header = Ajouter { $extension } ?
webext-perms-header-with-perms = Ajouter { $extension } ? Cette extension aura l’autorisation de :
webext-perms-header-unsigned = Ajouter { $extension } ? Cette extension n’a pas été vérifiée. Les extensions malveillantes peuvent voler vos informations personnelles ou compromettre votre ordinateur. Ne l’ajoutez que si vous faites confiance à la source.
webext-perms-header-unsigned-with-perms = Ajouter { $extension } ? Cette extension n’a pas été vérifiée. Les extensions malveillantes peuvent voler vos informations personnelles ou compromettre votre ordinateur. Ne l’ajoutez que si vous faites confiance à la source. Cette extension aura l’autorisation de :
webext-perms-sideload-header = { $extension } a été ajouté
webext-perms-optional-perms-header = { $extension } demande des permissions supplémentaires.

##

webext-perms-add =
    .label = Ajouter
    .accesskey = A
webext-perms-cancel =
    .label = Annuler
    .accesskey = n

webext-perms-sideload-text = Un programme de votre ordinateur a installé un module complémentaire qui pourrait affecter votre navigateur. Veuillez prendre connaissance des permissions que demande ce module et décider de l’activer ou d’annuler (afin de le laisser désactivé).
webext-perms-sideload-text-no-perms = Un programme de votre ordinateur a installé un module complémentaire qui pourrait affecter votre navigateur. Veuillez décider de l’activer ou d’annuler (afin de le laisser désactivé).
webext-perms-sideload-enable =
    .label = Activer
    .accesskey = A
webext-perms-sideload-cancel =
    .label = Annuler
    .accesskey = n

# Variables:
#   $extension (String): replaced with the localized name of the extension.
webext-perms-update-text = { $extension } a été mis à jour. Vous devez approuver les nouvelles autorisations avant que la version mise à jour ne soit installée. Sélectionner « Annuler » conservera la version actuelle de l’extension. Cette extension aura l’autorisation de :
webext-perms-update-accept =
    .label = Mettre à jour
    .accesskey = M

webext-perms-optional-perms-list-intro = L’extension souhaite :
webext-perms-optional-perms-allow =
    .label = Autoriser
    .accesskey = A
webext-perms-optional-perms-deny =
    .label = Refuser
    .accesskey = R

webext-perms-host-description-all-urls = Accéder à vos données pour tous les sites web

# Variables:
#   $domain (String): will be replaced by the DNS domain for which a webextension is requesting access (e.g., mozilla.org)
webext-perms-host-description-wildcard = Accéder à vos données pour les sites du domaine { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-wildcards =
    { $domainCount ->
        [one] Accéder à vos données pour { $domainCount } autre domaine
       *[other] Accéder à vos données pour { $domainCount } autres domaines
    }
# Variables:
#   $domain (String): will be replaced by the DNS host name for which a webextension is requesting access (e.g., www.mozilla.org)
webext-perms-host-description-one-site = Accéder à vos données pour { $domain }

# Variables:
#   $domainCount (Number): Integer indicating the number of additional
#     hosts for which this webextension is requesting permission.
webext-perms-host-description-too-many-sites =
    { $domainCount ->
        [one] Accéder à vos données sur { $domainCount } autre site
       *[other] Accéder à vos données sur { $domainCount } autres sites
    }

## Headers used in the webextension permissions dialog for synthetic add-ons.
## The part of the string describing what privileges the extension gives should be consistent
## with the value of webext-site-perms-description-gated-perms-{sitePermission}.
## Note, this string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $hostname (String): the hostname of the site the add-on is being installed from.

webext-site-perms-header-with-gated-perms-midi = Ce module complémentaire donne accès aux périphériques MIDI à { $hostname }.
webext-site-perms-header-with-gated-perms-midi-sysex = Ce module complémentaire donne accès aux périphériques MIDI (avec la prise en charge de SysEx) à { $hostname }.

##

# This string is used as description in the webextension permissions dialog for synthetic add-ons.
# Note, the empty line is used to create a line break between the two sections.
# Note, this string will be used as raw markup. Avoid characters like <, >, &
webext-site-perms-description-gated-perms-midi =
    Ces périphériques sont habituellement branchés à votre ordinateur, comme par exemple un synthétiseur audio, mais ils peuvent aussi être intégrés à votre ordinateur.
    
    Les sites web ne sont normalement pas autorisés à accéder aux périphériques MIDI. Une utilisation incorrecte pourrait provoquer des dommages ou compromettre la sécurité.

## Headers used in the webextension permissions dialog.
## Note: This string will be used as raw markup. Avoid characters like <, >, &
## Variables:
##   $extension (String): replaced with the localized name of the extension being installed.
##   $hostname (String): will be replaced by the DNS host name for which a webextension enables permissions.

webext-site-perms-header-with-perms = Ajouter { $extension } ? Cette extension donne les capacités suivantes à { $hostname } :
webext-site-perms-header-unsigned-with-perms = Ajouter { $extension } ? Cette extension n’a pas été vérifiée. Une extension malveillante peut voler vos informations personnelles ou compromettre votre ordinateur. Ne l’ajoutez que si vous faites confiance à sa source. Cette extension donne les capacités suivantes à { $hostname } :

## These should remain in sync with permissions.NAME.label in sitePermissions.properties

webext-site-perms-midi = Accéder aux appareils MIDI
webext-site-perms-midi-sysex = Accéder aux appareils MIDI prenant en charge SysEx
