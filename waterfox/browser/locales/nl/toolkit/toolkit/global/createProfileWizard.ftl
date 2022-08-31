# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Wizard Profiel aanmaken
    .style = width: 50em; height: 37em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Introductie
       *[other] Welkom bij de { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } slaat informatie over uw instellingen en voorkeuren op in uw persoonlijke profiel.

profile-creation-explanation-2 = Als u deze kopie van { -brand-short-name } deelt met andere gebruikers, kunt u profielen gebruiken om de informatie van alle gebruikers gescheiden te houden. Om dit te bereiken, moet elke gebruiker zijn of haar eigen profiel aanmaken.

profile-creation-explanation-3 = Als u de enige bent die deze kopie van { -brand-short-name } gebruikt, moet u minstens één profiel hebben. Als u wilt, kunt u meerdere profielen voor uzelf aanmaken om verschillende sets van instellingen en voorkeuren op te slaan. U zou bijvoorbeeld aparte profielen kunnen hebben voor zakelijk en persoonlijk gebruik.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Klik op Doorgaan om te beginnen met het aanmaken van uw profiel.
       *[other] Klik op Volgende om te beginnen met het aanmaken van uw profiel.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Afronding
       *[other] Voltooien van { create-profile-window.title }
    }

profile-creation-intro = Als u meerdere profielen aanmaakt, kunt u ze onderscheiden door de profielnamen. U kunt de naam hieronder gebruiken of een eigen naam kiezen.

profile-prompt = Voer een nieuwe profielnaam in:
    .accesskey = V

profile-default-name =
    .value = Standaardgebruiker

profile-directory-explanation = Uw instellingen, voorkeuren en andere gebruikersgegevens zullen worden opgeslagen in:

create-profile-choose-folder =
    .label = Map kiezen…
    .accesskey = k

create-profile-use-default =
    .label = Standaardmap gebruiken
    .accesskey = S
