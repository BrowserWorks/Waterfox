# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Empfohlene Erweiterung
cfr-doorhanger-feature-heading = Empfohlene Funktion
cfr-doorhanger-pintab-heading = Probieren Sie es aus: Tab anheften

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Warum wird das angezeigt?
cfr-doorhanger-extension-cancel-button = Nicht jetzt
    .accesskey = N
cfr-doorhanger-extension-ok-button = Jetzt hinzufügen
    .accesskey = h
cfr-doorhanger-pintab-ok-button = Diesen Tab anheften
    .accesskey = a
cfr-doorhanger-extension-manage-settings-button = Einstellungen für Empfehlungen verwalten
    .accesskey = E
cfr-doorhanger-extension-never-show-recommendation = Diese Empfehlung nicht anzeigen
    .accesskey = D
cfr-doorhanger-extension-learn-more-link = Weitere Informationen
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = von { $name }
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Empfehlung
cfr-doorhanger-extension-notification2 = Empfehlung
    .tooltiptext = Erweiterungsempfehlung
    .a11y-announcement = Erweiterungsempfehlung verfügbar
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Empfehlung
    .tooltiptext = Funktionsempfehlung
    .a11y-announcement = Funktionsempfehlung verfügbar

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
            [one] { $total } Stern
           *[other] { $total } Sterne
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
        [one] { $total } Benutzer
       *[other] { $total } Benutzer
    }
cfr-doorhanger-pintab-description = Schneller Zugriff auf die meistverwendeten Seiten. Seiten bleiben geöffnet, selbst nach einem Neustart.

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = Klicken Sie mit der <b>rechten Maustaste</b> auf den anzuheftenden Tab.
cfr-doorhanger-pintab-step2 = Wählen Sie <b>Tab anheften</b> aus dem Menü.
cfr-doorhanger-pintab-step3 = Falls die Seite auf eine Aktualisierung aufmerksam machen will, wird ein blauer Punkt auf dem angehefteten Tab angezeigt.
cfr-doorhanger-pintab-animation-pause = Anhalten
cfr-doorhanger-pintab-animation-resume = Fortfahren

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Synchronisieren Sie Ihre Lesezeichen, um sie überall verfügbar zu haben.
cfr-doorhanger-bookmark-fxa-body = Jederzeit Zugriff auf dieses Lesezeichen - auch auf mobilen Geräten. Nutzen Sie dafür ein { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Lesezeichen jetzt synchronisieren…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Schließen-Schaltfläche
    .title = Schließen

## Protections panel

cfr-protections-panel-header = Surfen ohne verfolgt zu werden
cfr-protections-panel-body = Behalten Sie die Kontrolle über Ihre Daten. { -brand-short-name } schützt Sie vor den verbreitetsten Skripten, welche Ihre Online-Aktivitäten verfolgen.
cfr-protections-panel-link-text = Weitere Informationen

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Neue Funktion:
cfr-whatsnew-button =
    .label = Neue Funktionen und Änderungen
    .tooltiptext = Neue Funktionen und Änderungen
cfr-whatsnew-panel-header = Neue Funktionen und Änderungen
cfr-whatsnew-release-notes-link-text = Release Notes lesen
cfr-whatsnew-fx70-title = { -brand-short-name } kämpft noch stärker für deine Privatsphäre
cfr-whatsnew-fx70-body =
    Das neueste Update verbessert den Tracking-Schutz und macht es
    dir einfacher denn je, sichere Passwörter für jede Webseite zu erstellen.
cfr-whatsnew-tracking-protect-title = Schütze dich vor Online-Tracking
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } blockt gängige Online-Tracker sozialer Plattformen und anderer Webseiten,
    die dir durchs Web folgen wollen.
cfr-whatsnew-tracking-protect-link-text = Deinen Bericht anzeigen
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
        [one] Tracker geblockt
       *[other] Tracker geblockt
    }
cfr-whatsnew-tracking-blocked-subtitle = Seit { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Bericht anzeigen
cfr-whatsnew-lockwise-backup-title = Speichere deine Passwörter ab
cfr-whatsnew-lockwise-backup-body = Generiere jetzt sichere Passwörter, auf die du mit deinem Konto von überall aus zugreifen kannst.
cfr-whatsnew-lockwise-backup-link-text = Backups einschalten
cfr-whatsnew-lockwise-take-title = Nimm deine Passwörter mit
cfr-whatsnew-lockwise-take-body =
    Mit der { -lockwise-brand-short-name } App für mobile Geräte kannst du von überall aus sicher auf deine
    gespeicherten Passwörter zugreifen.
cfr-whatsnew-lockwise-take-link-text = Hol dir die App

## Search Bar

cfr-whatsnew-searchbar-title = Weniger Tippen und mehr Finden mit der Adressleiste
cfr-whatsnew-searchbar-body-topsites = Klicken Sie einfach in die Adressleiste, um ein Auswahlmenü mit Ihren „Wichtigen Seiten“ anzuzeigen.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Lupensymbol

## Picture-in-Picture

cfr-whatsnew-pip-header = Schaue Videos während du surfst
cfr-whatsnew-pip-body = Bild-in-Bild zeigt das Video in einem schwebenden Fenster an, damit du in anderen Tabs surfen und dennoch das Video anschauen kannst.
cfr-whatsnew-pip-cta = Weitere Informationen

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Weniger nervige Pop-ups durch Websites
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } hindert Websites nun daran, automatisch nach der Berechtigung zum Anzeigen von Pop-up-Nachrichten zu fragen.
cfr-whatsnew-permission-prompt-cta = Weitere Informationen

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
        [one] Identifizierer (Fingerprinter) blockiert
       *[other] Identifizierer (Fingerprinter) blockiert
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } blockiert viele Identifizierer (Fingerprinter), welche sonst heimlich Informationen über dein Gerät und deine Aktivitäten sammeln, um ein Werbeprofil über dich zu erstellen.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Identifizierer (Fingerprinter)
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } kann Identifizierer (Fingerprinter) blockieren, die sonst heimlich Informationen über dein Gerät und deine Aktivitäten sammeln, um ein Werbeprofil über dich zu erstellen.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Auf dieses Lesezeichen auf dem Handy zugreifen
cfr-doorhanger-sync-bookmarks-body = Haben Sie Ihre Lesezeichen, Passwörter, Chronik und mehr überall griffbereit, wo Sie mit { -brand-product-name } angemeldet sind.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } aktivieren
    .accesskey = a

## Login Sync

cfr-doorhanger-sync-logins-header = Nie wieder ein Passwort verlieren
cfr-doorhanger-sync-logins-body = Speichern Sie Ihre Passwörter sicher und synchronisieren Sie diese mit allen Ihren Geräten.
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } aktivieren
    .accesskey = a

## Send Tab

cfr-doorhanger-send-tab-header = Das unterwegs lesen
cfr-doorhanger-send-tab-recipe-header = Dieses Rezept in die Küche mitnehmen
cfr-doorhanger-send-tab-body = Die Funktion "Tab senden" ermöglicht es, diesen Link ganz einfach mit Ihrem Handy oder einem anderen mit { -brand-product-name } verbundenen Gerät zu teilen.
cfr-doorhanger-send-tab-ok-button = "Tab senden" ausprobieren
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Diese PDF-Datei sicher teilen
cfr-doorhanger-firefox-send-body = Schützen Sie Ihre Dokumente vor neugierigen Blicken mittels Ende-zu-Ende-Verschlüsselung und Links, welche nach der Benutzung ungültig werden.
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } ausprobieren
    .accesskey = p

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Schutzmaßnahmen anzeigen
    .accesskey = M
cfr-doorhanger-socialtracking-close-button = Schließen
    .accesskey = c
cfr-doorhanger-socialtracking-dont-show-again = Ähnliche Nachrichten nicht mehr anzeigen
    .accesskey = n
cfr-doorhanger-socialtracking-heading = { -brand-short-name } hat ein soziales Netzwerk daran gehindert, deine Aktivitäten hier zu verfolgen.
cfr-doorhanger-socialtracking-description = Deine Privatsphäre ist wichtig. { -brand-short-name } blockiert jetzt auch bekannte Skripte zur Aktivitätenverfolgung durch soziale Netzwerke und begrenzt damit, wie viel Informationen diese über deine Online-Aktivitäten sammeln können.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } hat einen Fingerabdruck auf dieser Seite blockiert
cfr-doorhanger-fingerprinters-description = Deine Privatsphäre ist uns wichtig. { -brand-short-name } blockiert jetzt Fingerabdrücke, die eindeutig identifizierbare Informationen zu deinem Gerät sammeln, um dich zu tracken.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } hat einen Fingerabdruck auf dieser Seite blockiert
cfr-doorhanger-cryptominers-description = Deine Privatsphäre ist uns wichtig. { -brand-short-name } blockiert jetzt Krypto-Miner, die die Rechenleistung deines Systems nutzen wollen, um digitale Währungen zu schürfen.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
        [one] { -brand-short-name } hat seit { $date } mehr als <b>{ $blockedCount }</b> Element zur Aktivitätenverfolgung blockiert!
       *[other] { -brand-short-name } hat seit { $date } mehr als <b>{ $blockedCount }</b> Elemente zur Aktivitätenverfolgung blockiert!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
        [one] { -brand-short-name } hat seit { DATETIME($date, month: "long", year: "numeric") } mehr als <b>{ $blockedCount }</b> Element zur Aktivitätenverfolgung blockiert!
       *[other] { -brand-short-name } hat seit { DATETIME($date, month: "long", year: "numeric") } mehr als <b>{ $blockedCount }</b> Elemente zur Aktivitätenverfolgung blockiert!
    }
cfr-doorhanger-milestone-ok-button = Alle anzeigen
    .accesskey = A

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Sichere Passwörter ganz einfach erstellen
cfr-whatsnew-lockwise-body = Es ist schwierig, sich für jedes Benutzerkonto im Internet ein neues und sicheres Passwort auszudenken. Wenn du in Zukunft ein neues Passwort eingeben sollst, wähle das Eingabefeld für das Passwort, um ein sicheres Passwort durch { -brand-shorter-name } erstellen zu lassen.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name }-Symbol

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Warnungen für gefährdete Passwörter erhalten
cfr-whatsnew-passwords-body = Hacker wissen, dass Menschen Passwörter auf verschiedenen Seiten wiederverwenden. Falls du das gleiche Passwort auf mehreren Seiten verwendest und eine dieser Seiten von einem Datenleck betroffen ist, erhältst du eine Warnung in { -lockwise-brand-short-name }, die Passwörter für diese Websites zu ändern.
cfr-whatsnew-passwords-icon-alt = Symbol für gefährdetes Passwort

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Vom Bild-im-Bild-Modus zum Vollbild wechseln
cfr-whatsnew-pip-fullscreen-body = Nachdem du ein Video in ein schwebendes Bild-im-Bild-Fenster umgewandelt hast, kannst du auch jederzeit per Doppelklick auf das Video in den Vollbild-Modus wechseln.
cfr-whatsnew-pip-fullscreen-icon-alt = Bild-im-Bild-Symbol

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Schließen
    .accesskey = c

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Schutzmaßnahmen auf einen Blick
cfr-whatsnew-protections-body = Die Schutzmaßnahmen-Übersicht fasst Informationen über Datenlecks und die Passwortverwaltung zusammen. Sie können jetzt sehen, wie viele Probleme aus Datenlecks Sie behoben haben und ob einige Ihrer Passwörter in Datenlecks offengelegt wurden.
cfr-whatsnew-protections-cta-link = Schutzmaßnahmen-Übersicht anzeigen
cfr-whatsnew-protections-icon-alt = Schild-Symbol

## Better PDF message

cfr-whatsnew-better-pdf-header = Besseres PDF-Erlebnis
cfr-whatsnew-better-pdf-body = PDF-Dokumente werden jetzt direkt in { -brand-short-name } geöffnet, damit Sie ohne ein Wechseln der Anwendung weiterarbeiten können.

## DOH Message

cfr-doorhanger-doh-body = Ihre Privatsphäre ist uns wichtig. { -brand-short-name } leitet Ihre DNS-Anfragen jetzt falls möglich sicher an einen Partnerdienst weiter, um Sie beim Surfen zu schützen.
cfr-doorhanger-doh-header = Sicherere, verschlüsselte DNS-Anfragen
cfr-doorhanger-doh-primary-button-2 = OK
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Deaktivieren
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Ihre Privatsphäre ist wichtig. { -brand-short-name } isoliert jetzt Websites voneinander, was es Hackern erschwert, Passwörter, Kreditkartendaten und andere vertrauliche Informationen zu stehlen.
cfr-doorhanger-fission-header = Seitenisolierung
cfr-doorhanger-fission-primary-button = Ok, verstanden
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Weitere Informationen
    .accesskey = W

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Automatischer Schutz vor hinterhältigen Tracking-Taktiken
cfr-whatsnew-clear-cookies-body = Einige Skripte zur Aktivitätenverfolgung leiten Sie auf andere Websites weiter, welche dann heimlich Cookies anlegen. { -brand-short-name } entfernt diese Cookies von nun an automatisch, damit Ihre Online-Aktivitäten nicht verfolgt werden können.
cfr-whatsnew-clear-cookies-image-alt = Illustration für blockierten Cookie

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Mehr Mediensteuerung
cfr-whatsnew-media-keys-body = Spielen Sie Audio oder Video direkt von Ihrer Tastatur oder Ihrem Headset ab und halten Sie sie an. So können Sie Medien ganz einfach aus einem anderen Tab, einem anderen Programm oder sogar bei gesperrtem Computer steuern. Sie können auch mit der Vorwärts- und der Rückwärts-Taste zwischen den Liedern wechseln.
cfr-whatsnew-media-keys-button = Weitere Informationen

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Suchmaschinen-Schlüsselwörter in der Adressleiste
cfr-whatsnew-search-shortcuts-body = Wenn Sie nun eine Suchmaschine oder eine bestimmte Website in die Adressleiste eingeben, wird in den Suchvorschlägen unten ein blaues Schlüsselwort angezeigt. Wählen Sie dieses Schlüsselwort aus, um Ihre Suche direkt in der Adressleiste abzuschließen.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Schutz vor böswilligen Supercookies
cfr-whatsnew-supercookies-body = Websites können Ihrem Browser heimlich einen "Supercookie" hinzufügen, der Sie im Internet verfolgen kann, selbst nachdem Sie Ihre Cookies gelöscht haben. { -brand-short-name } bietet jetzt einen starken Schutz vor Supercookies, damit diese nicht verwendet werden können, um Ihre Online-Aktivitäten von einer Website zur nächsten zu verfolgen.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Bessere Lesezeichen-Verwaltung
cfr-whatsnew-bookmarking-body = Es ist einfacher, Ihre Lieblingsseiten im Auge zu behalten. { -brand-short-name } merkt sich jetzt Ihren bevorzugten Ort für gespeicherte Lesezeichen, zeigt die Lesezeichen-Symbolleiste standardmäßig in neuen Tabs an und verschafft Ihnen über einen Symbolleisten-Ordner einfachen Zugang zu Ihren übrigen Lesezeichen.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Umfassender Schutz vor seitenübergreifender Cookie-Aktivitätenverfolgung
cfr-whatsnew-cross-site-tracking-body = Sie können sich jetzt für einen besseren Schutz vor Cookie-Aktivitätenverfolgung entscheiden. { -brand-short-name } kann Ihre Aktivitäten und Daten auf der Website isolieren, auf der Sie sich gerade befinden, sodass im Browser gespeicherte Informationen nicht zwischen Websites geteilt werden.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Videos auf dieser Website werden in dieser Version von { -brand-short-name } möglicherweise nicht richtig wiedergegeben. Aktualisieren Sie { -brand-short-name } jetzt für volle Videounterstützung.
cfr-doorhanger-video-support-header = { -brand-short-name } aktualisieren, um Videos abzuspielen
cfr-doorhanger-video-support-primary-button = Jetzt aktualisieren
    .accesskey = a
