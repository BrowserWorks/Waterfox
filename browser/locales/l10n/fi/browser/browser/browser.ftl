# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Yksityinen selaus)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Yksityinen selaus)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (Yksityinen selaus)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Yksityinen selaus)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Näytä sivuston tiedot

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Avaa asentamisen viestipaneeli
urlbar-web-notification-anchor =
    .tooltiptext = Muuta sitä, voitko saada ilmoituksia tältä sivustolta
urlbar-midi-notification-anchor =
    .tooltiptext = Avaa MIDI-paneeli
urlbar-eme-notification-anchor =
    .tooltiptext = Hallinnoi DRM-ohjelmiston käyttöä
urlbar-web-authn-anchor =
    .tooltiptext = Avaa verkkotodennuksen paneeli
urlbar-canvas-notification-anchor =
    .tooltiptext = Hallinnoi kanvaksen sisällön lukemisen oikeutta
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Hallinnoi mikrofonin jakamista sivustolle
urlbar-default-notification-anchor =
    .tooltiptext = Avaa viestipaneeli
urlbar-geolocation-notification-anchor =
    .tooltiptext = Avaa paikannustietojen pyyntöpaneeli
urlbar-xr-notification-anchor =
    .tooltiptext = Avaa virtuaalitodellisuuden käyttöoikeuspaneeli
urlbar-storage-access-anchor =
    .tooltiptext = Avaa selaamisen seuraamisoikeuden paneeli
urlbar-translate-notification-anchor =
    .tooltiptext = Käännä sivu
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Hallinnoi ikkunoiden tai näytön jakamista sivustolle
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Avaa verkkoyhteydettömän tilan tietovaraston viestipaneeli
urlbar-password-notification-anchor =
    .tooltiptext = Avaa salasanan tallentamisen viestipaneeli
urlbar-translated-notification-anchor =
    .tooltiptext = Hallinnoi sivun kääntämistä toiselle kielelle
urlbar-plugins-notification-anchor =
    .tooltiptext = Hallinnoi liitännäisen käyttöä
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Hallinnoi kameran tai mikrofonin jakamista sivustolle
urlbar-autoplay-notification-anchor =
    .tooltiptext = Avaa automaattisen toiston paneeli
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Tallenna tietoja pysyvään tallennustilaan
urlbar-addons-notification-anchor =
    .tooltiptext = Avaa lisäosan asentamisen viestipaneeli
urlbar-tip-help-icon =
    .title = Apua ongelmiin
urlbar-search-tips-confirm = Selvä
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Vinkki:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Kirjoita vähemmän, löydä enemmän: Hae hakukoneella { $engineName } suoraan osoitepalkista.
urlbar-search-tips-redirect-2 = Aloita hakeminen osoitepalkista, niin näet ehdotukset palvelusta { $engineName } ja selaushistoriastasi.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Kirjanmerkit
urlbar-search-mode-tabs = Välilehdet
urlbar-search-mode-history = Historia

##

urlbar-geolocation-blocked =
    .tooltiptext = Olet estänyt sijaintitiedot tältä sivustolta.
urlbar-xr-blocked =
    .tooltiptext = Olet estänyt virtuaalitodellisuuslaitteen käytön tältä sivustolta.
urlbar-web-notifications-blocked =
    .tooltiptext = Olet estänyt ilmoitukset tältä sivustolta.
urlbar-camera-blocked =
    .tooltiptext = Olet estänyt kameran tältä sivustolta.
urlbar-microphone-blocked =
    .tooltiptext = Olet estänyt mikrofonin tältä sivustolta.
urlbar-screen-blocked =
    .tooltiptext = Olet estänyt tämän sivuston jakamasta näyttöäsi.
urlbar-persistent-storage-blocked =
    .tooltiptext = Olet estänyt pysyvän tallennustilan käytön tältä sivustolta.
urlbar-popup-blocked =
    .tooltiptext = Olet estänyt ponnahdusikkunat tältä sivustolta.
urlbar-autoplay-media-blocked =
    .tooltiptext = Olet estänyt äänellisen median automaattisen toistamisen tältä sivustolta.
urlbar-canvas-blocked =
    .tooltiptext = Olet estänyt kanvaksen sisällön lukemisen tältä sivustolta.
urlbar-midi-blocked =
    .tooltiptext = Olet estänyt MIDI-käytön tältä sivustolta.
urlbar-install-blocked =
    .tooltiptext = Olet estänyt lisäosien asennuksen tältä sivustolta.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Muokkaa kirjanmerkkiä ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Lisää kirjanmerkki ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Lisää osoitepalkkiin
page-action-manage-extension =
    .label = Hallitse laajennusta…
page-action-remove-from-urlbar =
    .label = Poista osoitepalkista
page-action-remove-extension =
    .label = Poista laajennus

## Auto-hide Context Menu

full-screen-autohide =
    .label = Piilota työkalupalkit
    .accesskey = P
full-screen-exit =
    .label = Poistu kokoruututilasta
    .accesskey = o

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Tällä kertaa käytä hakuun:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Muuta hakuasetuksia
search-one-offs-change-settings-compact-button =
    .tooltiptext = Muuta hakuasetuksia
search-one-offs-context-open-new-tab =
    .label = Etsi uudessa välilehdessä
    .accesskey = E
search-one-offs-context-set-as-default =
    .label = Aseta oletushakukoneeksi
    .accesskey = A
search-one-offs-context-set-as-default-private =
    .label = Aseta oletushakukoneeksi yksityisissä ikkunoissa
    .accesskey = A
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Kirjanmerkit ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Välilehdet ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historia ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Näytä muokkaus tallennettaessa
    .accesskey = m
bookmark-panel-done-button =
    .label = Valmis
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Yhteys ei ole suojattu
identity-connection-secure = Yhteys on suojattu
identity-connection-internal = Tämä on suojattu { -brand-short-name }-sivu.
identity-connection-file = Sivu on tallennettu tietokoneellesi.
identity-extension-page = Tämän sivun latasi laajennus.
identity-active-blocked = { -brand-short-name } on estänyt suojaamattoman sisällön näyttämisen.
identity-custom-root = Yhteys on suojattu varmenteella, jonka myöntäjää Mozilla ei tunnista.
identity-passive-loaded = Tällä sivulla on suojaamatonta sisältöä (kuten kuvia).
identity-active-loaded = Suojaamattoman sisällön estäminen on otettu pois päältä sivustolla.
identity-weak-encryption = Sivusto käyttää heikkoa salausta.
identity-insecure-login-forms = Tälle sivulle kirjoitettujen kirjautumistietojen turvallisuus voi vaarantua.
identity-permissions =
    .value = Käyttöoikeudet
identity-permissions-reload-hint = Sivu tarvitsee ehkä päivittää, jotta muutokset tulevat voimaan.
identity-permissions-empty = Sivustolle ei ole myönnetty mitään erityisoikeuksia.
identity-clear-site-data =
    .label = Poista evästeet ja sivustotiedot…
identity-connection-not-secure-security-view = Yhteytesi tähän sivustoon ei ole suojattu.
identity-connection-verified = Yhteytesi tähän sivustoon on suojattu.
identity-ev-owner-label = Varmenne myönnetty taholle:
identity-description-custom-root = Mozilla ei tunnista tämän varmenteen myöntäjää. Se on voitu lisätä käyttöjärjestelmästä tai järjestelmänvalvojan toimesta. <label data-l10n-name="link">Lue lisää</label>
identity-remove-cert-exception =
    .label = Poista poikkeus
    .accesskey = s
identity-description-insecure = Yhteytesi verkkosivustoon ei ole yksityinen. Sivullisten on mahdollista tarkastella antamiasi tietoja (esim. salasanoja, viestejä, luottokorttitietoja).
identity-description-insecure-login-forms = Kirjautumistiedot, jotka kirjoitat tälle sivulle, eivät ole suojassa ja voidaan murtaa.
identity-description-weak-cipher-intro = Yhteytesi verkkosivustoon käyttää heikkoa salausta eikä sen takia ole yksityinen.
identity-description-weak-cipher-risk = Sivullisten on mahdollista tarkastella antamiasi tietoja tai vaikuttaa sivuston toimintaan.
identity-description-active-blocked = { -brand-short-name } on estänyt suojaamattoman sisällön näyttämisen. <label data-l10n-name="link">Lue lisää</label>
identity-description-passive-loaded = Yhteytesi verkkosivustoon ei ole yksityinen ja sivullisten on mahdollista tarkastella tietoja, joita lähetät sivustolle.
identity-description-passive-loaded-insecure = Tällä sivulla on suojaamatonta sisältöä (kuten kuvia). <label data-l10n-name="link">Lue lisää</label>
identity-description-passive-loaded-mixed = Vaikka { -brand-short-name } on osittain estänyt suojaamattoman sisällön, osa näkyvästä sisällöstä on edelleen suojaamatonta (kuten kuvat). <label data-l10n-name="link">Lue lisää</label>
identity-description-active-loaded = Tällä sivulla on suojaamatonta sisältöä (kuten komentosarjoja) eikä yhteytesi sivustoon ei ole yksityinen.
identity-description-active-loaded-insecure = Sivullisten on mahdollista tarkastella antamiasi tietoja (esim. salasanoja, viestejä, luottokorttitietoja).
identity-learn-more =
    .value = Lue lisää
identity-disable-mixed-content-blocking =
    .label = Poista suojaus käytöstä
    .accesskey = P
identity-enable-mixed-content-blocking =
    .label = Ota suojaus käyttöön
    .accesskey = O
identity-more-info-link-text =
    .label = Lisätietoja

## Window controls

browser-window-minimize-button =
    .tooltiptext = Pienennä ikkuna
browser-window-maximize-button =
    .tooltiptext = Suurenna
browser-window-restore-down-button =
    .tooltiptext = Palauta pienemmäksi ikkunaksi
browser-window-close-button =
    .tooltiptext = Sulje

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Jaettava kamera:
    .accesskey = k
popup-select-microphone =
    .value = Jaettava mikrofoni:
    .accesskey = m
popup-all-windows-shared = Kaikki näkyvissä olevat ikkunat jaetaan.
popup-screen-sharing-not-now =
    .label = Ei nyt
    .accesskey = E
popup-screen-sharing-never =
    .label = Älä salli koskaan
    .accesskey = Ä
popup-silence-notifications-checkbox = Ei ilmoituksia { -brand-short-name(case: "elative") } jakamisen aikana
popup-silence-notifications-checkbox-warning = { -brand-short-name } ei näytä ilmoituksia, kun jaat näyttöä tai ikkunaa.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Jaat parhailleen { -brand-short-name }-ikkunaa. Muut näkevät, kun vaihdat uuteen välilehteen.
sharing-warning-screen = Jaat parhaillaan koko näyttöäsi. Muut näkevät, kun vaihdat uuteen välilehteen.
sharing-warning-proceed-to-tab =
    .label = Jatka välilehteen
sharing-warning-disable-for-session =
    .label = Poista jakamisen suojaus tästä istunnosta

## DevTools F12 popup

enable-devtools-popup-description = Voit käyttää F12-pikanäppäintä, kun olet ensin avannut työkalut Web-työkalut-valikosta.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Kirjoita osoite tai hakutermi
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Kirjoita osoite tai hakutermi
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Hae verkosta
    .aria-label = Hae hakukoneella { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Kirjoita hakuehdot
    .aria-label = Hae sivustosta { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Kirjoita hakuehdot
    .aria-label = Hae kirjanmerkeistä
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Kirjoita hakuehdot
    .aria-label = Hae historiasta
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Kirjoita hakuehdot
    .aria-label = Hae välilehdistä
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Hae hakukoneella { $name } tai kirjoita osoite
urlbar-remote-control-notification-anchor =
    .tooltiptext = Selain on kauko-ohjauksessa
urlbar-permissions-granted =
    .tooltiptext = Olet myöntänyt tälle sivustolle lisäoikeuksia.
urlbar-switch-to-tab =
    .value = Siirry välilehteen:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Laajennus:
urlbar-go-button =
    .tooltiptext = Siirry osoitepalkissa olevaan osoitteeseen
urlbar-page-action-button =
    .tooltiptext = Sivun toiminnot
urlbar-pocket-button =
    .tooltiptext = Tallenna { -pocket-brand-name }-palveluun

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> on nyt kokoruututilassa
fullscreen-warning-no-domain = Dokumentti on nyt kokoruututilassa
fullscreen-exit-button = Poistu kokoruututilasta (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Poistu kokoruututilasta (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = Sivusto <span data-l10n-name="domain">{ $domain }</span> hallitsee hiiren osoitinta. Voit ottaa osoittimen hallintaasi painamalla Esc.
pointerlock-warning-no-domain = Tämä sivu hallitsee hiiren osoitinta. Voit ottaa osoittimen hallintaasi painamalla Esc.
