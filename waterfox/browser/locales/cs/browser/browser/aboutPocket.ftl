# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Pocket button panel strings for about:pocket-saved, about:pocket-signup, and about:pocket-home


## about:pocket-saved panel

# Placeholder text for tag input
pocket-panel-saved-add-tags =
    .placeholder = Přidat štítky
pocket-panel-saved-error-generic = Při pokusu o uložení do { -pocket-brand-name(case: "gen") } došlo k chybě.
pocket-panel-saved-error-tag-length = Štítky jsou omezeny na 25 znaků
pocket-panel-saved-error-only-links = Ukládat můžete jenom odkazy
pocket-panel-saved-error-not-saved = Stránka nebyla uložena
pocket-panel-saved-error-no-internet = Abyste mohli ukládat obsah do { -pocket-brand-name(case: "gen") }, musíte být připojeni k internetu. Zkontrolujte prosím své připojení a zkuste to znovu.
pocket-panel-saved-error-remove = Při pokusu o odstranění této stránky došlo k chybě.
pocket-panel-saved-page-removed = Stránka byla odstraněna
pocket-panel-saved-page-saved = Uloženo do { -pocket-brand-name(case: "gen") }
pocket-panel-saved-page-saved-b = Uloženo do { -pocket-brand-name(case: "gen") }
pocket-panel-saved-processing-remove = Odstraňování stránky…
pocket-panel-saved-removed = Stránka odstraněna z vašeho seznamu
pocket-panel-saved-processing-tags = Přidávání štítků…
pocket-panel-saved-remove-page = Odstranit stránku
pocket-panel-saved-save-tags = Uložit
pocket-panel-saved-saving-tags = Ukládání…
pocket-panel-saved-suggested-tags = Doporučené štítky
pocket-panel-saved-tags-saved = Štítky přidány
pocket-panel-signup-view-list = Zobrazit seznam
# This is displayed above a field where the user can add tags
pocket-panel-signup-add-tags = Přidat štítky:

## about:pocket-signup panel

pocket-panel-signup-already-have = Používáte už { -pocket-brand-name(case: "acc") }?
pocket-panel-signup-learn-more = Zjistit více
pocket-panel-signup-login = Přihlaste se
pocket-panel-signup-signup-email = Registrace e-mailem
pocket-panel-signup-signup-cta = Zaregistrujte si { -pocket-brand-name(case: "acc") }. Je zdarma.
pocket-panel-signup-signup-firefox =
    Registrace pomocí { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "gen") }
        [feminine] { -brand-product-name(case: "gen") }
        [neuter] { -brand-product-name(case: "gen") }
       *[other] aplikace { -brand-product-name }
    }
pocket-panel-signup-tagline =
    Ukládejte si články a videa z { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "gen") }
        [feminine] { -brand-product-name(case: "gen") }
        [neuter] { -brand-product-name(case: "gen") }
       *[other] aplikace { -brand-product-name }
    } do { -pocket-brand-name(case: "gen") } pro zobrazení kdykoliv a na jakémkoli zařízení.
pocket-panel-signup-tagline-story-one =
    Klepněte na tlačítko { -pocket-brand-name(case: "gen") } pro uložení jakéhokoliv článku, videa nebo stránky přímo z { -brand-product-name.gender ->
        [masculine] { -brand-product-name(case: "gen") }
        [feminine] { -brand-product-name(case: "gen") }
        [neuter] { -brand-product-name(case: "gen") }
       *[other] aplikace { -brand-product-name }
    }.
pocket-panel-signup-tagline-story-two = Zobrazení v { -pocket-brand-name(case: "loc") } kdykoliv a na jakémkoliv zařízení.
pocket-panel-signup-cta-a-fix = Vaše tlačítko „uložit“ pro internet
pocket-panel-signup-cta-b = Klepnutím na tlačítko { -pocket-brand-name } můžete ukládat články, videa nebo odkazy. Seznam si můžete kdykoliv zobrazit na kterémkoliv svém zařízení.
pocket-panel-signup-cta-b-short = Klepnutím na tlačítko { -pocket-brand-name } můžete ukládat články, videa nebo odkazy.
pocket-panel-signup-cta-c = Zobrazte svůj seznam na jakémkoliv zařítení, kdykoliv.

## about:pocket-home panel

pocket-panel-home-my-list = Můj seznam
pocket-panel-home-welcome-back = Vítejte zpátky
pocket-panel-home-paragraph = { -pocket-brand-name(case: "acc") } můžete použít k objevování a ukládání webových stránek, článků, videí a podcastů, a také k pozdějšímu návratu k rozečtenému obsahu.
pocket-panel-home-explore-popular-topics = Podívejte se na oblíbená témata
pocket-panel-home-discover-more = Objevte více
pocket-panel-home-explore-more = Procházet
pocket-panel-home-most-recent-saves = Váš nedávno uložený obsah:
pocket-panel-home-most-recent-saves-loading = Načítání nedávno uloženého obsahu…
pocket-panel-home-new-user-cta = Klepnutím na tlačítko { -pocket-brand-name } můžete ukládat články, videa nebo odkazy.
pocket-panel-home-new-user-message = Váš nedávno uložený obsah se zobrazí tady.

## Pocket panel header component

pocket-panel-header-my-list = Zobrazit Můj seznam
pocket-panel-header-sign-in = Přihlásit se

## Pocket panel buttons

pocket-panel-button-show-all = Zobrazit vše
pocket-panel-button-activate =
    { -pocket-brand-name.gender ->
        [masculine] Aktivovat { -pocket-brand-name(case: "acc") }
        [feminine] Aktivovat { -pocket-brand-name(case: "acc") }
        [neuter] Aktivovat { -pocket-brand-name(case: "acc") }
       *[other] Aktivovat službu { -pocket-brand-name }
    } { -brand-product-name.gender ->
        [masculine] ve { -brand-product-name(case: "loc") }
        [feminine] v { -brand-product-name(case: "loc") }
        [neuter] v { -brand-product-name(case: "loc") }
       *[other] v aplikaci { -brand-product-name }
    }
pocket-panel-button-remove = Odstranit
