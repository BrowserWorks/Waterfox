# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-not-set =
    .value = (není nastaveno)

failed-pp-change = Nelze změnit hlavní heslo.
incorrect-pp = Nezadali jste správné hlavní heslo. Zkuste to prosím znovu.
pp-change-ok = Hlavní heslo bylo úspěšně změněno.

settings-pp-erased-ok =
    { -brand-short-name.case-status ->
        [with-cases] Smazali jste své hlavní heslo. Uložená hesla a soukromé klíče certifikátů spravované { -brand-short-name(case: "ins") } nebudou chráněné.
       *[no-cases] Smazali jste své hlavní heslo. Uložená hesla a soukromé klíče certifikátů spravované aplikací { -brand-short-name } nebudou chráněné.
    }
settings-pp-not-wanted =
    { -brand-short-name.case-status ->
        [with-cases] Pozor! Rozhodli jste se nepoužít hlavní heslo. Uložená hesla a soukromé klíče certifikátů spravované { -brand-short-name(case: "ins") } nebudou chráněné.
       *[no-cases] Pozor! Rozhodli jste se nepoužít hlavní heslo. Uložená hesla a soukromé klíče certifikátů spravované aplikací { -brand-short-name } nebudou chráněné.
    }

pp-change2empty-in-fips-mode = Momentálně jste v režimu FIPS, který vyžaduje neprázdné hlavní heslo.
pw-change-success-title = Úspěšná změna hesla
pw-change-failed-title = Neúspěšná změna hesla
pw-remove-button =
    .label = Odstranit

primary-password-dialog =
    .title = Hlavní heslo
set-password-old-password = Současné heslo:
set-password-new-password = Zadejte nové heslo:
set-password-reenter-password = Zopakujte heslo:
set-password-meter = Kvalita hesla
set-password-meter-loading = Načítání
primary-password-admin = Správce vašeho systému vyžaduje před ukládání hesel nastavení hlavního hesla.
primary-password-description = Hlavní heslo slouží k ochraně citlivých údajů, jako jsou třeba hesla k webovým účtům. Pokud si vytvoříte hlavní heslo, budete na něj dotázáni jednou během každé relace, pokud bude { -brand-short-name } potřebovat pracovat s uloženými údaji chráněnými tímto heslem.
primary-password-warning = Ujistěte se, že si toto hlavní heslo opravdu pamatujete. Bez jeho znalosti nebudete moci přistupovat k uloženým údajům chráněným tímto heslem.

remove-primary-password =
    .title = Odstranit hlavní heslo
remove-info =
    .value = Pro pokračování zadejte hlavní heslo:
remove-primary-password-warning1 = Vaše hlavní heslo slouží k ochraně citlivých údajů, jako jsou třeba hesla k webovým účtům.
remove-primary-password-warning2 = Pokud odstraníte své hlavní heslo, vaše soukromé údaje nebudou v případě průniku do vašeho počítače chráněny.
remove-password-old-password =
    .value = Současné heslo:
