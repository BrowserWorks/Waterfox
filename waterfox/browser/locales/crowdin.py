# Automatically build out fluent files with translations from Crowdin.
# Order of lines is important, so add new strings to Crowdin in the correct
# order, with tooltip lines added as {string_id}.tooltip and complex
# behaviour should be thought about carefully before adding.

import os
import sys
import logging
import json
import concurrent.futures
import requests

from typing import Tuple, List, Dict


# Set up logging
class StructuredMessage(object):
    def __init__(self, message, **kwargs):
        self.message = message
        self.kwargs = kwargs

    def __str__(self):
        return '%s >>> %s' % (self.message, json.dumps(self.kwargs))


m = StructuredMessage
logging.basicConfig(level=logging.ERROR, format='%(message)s')


# Get env vars
token = os.environ.get("CROWDIN_AUTH_TOKEN")

# Declare consts
TOKEN = f"Bearer {token}"
BASE_URL = "https://waterfox.crowdin.com/api/v2"
LOCALE_MAP = {
    "ar": "ar",
    "cs": "cs",
    "da": "da",
    "de": "de",
    "el": "el",
    "en-GB": "en-GB",
    "es-MX": "es-MX",
    "es": "es-ES",
    "fr": "fr",
    "hu": "hu",
    "id": "id",
    "it": "it",
    "ja": "ja",
    "ko": "ko",
    "lt": "lt",
    "nl": "nl",
    "no": "nn-NO",
    "pl": "pl",
    "pt-BR": "pt-BR",
    "pt": "pt-PT",
    "ru": "ru",
    "sv": "sv-SE",
    "th": "th",
    "vi": "vi",
    "zh-CN": "zh-CN",
    "zh-TW": "zh-TW",
}

# We could have ftl naming convention to remove requirement for this
DIRECT_L10N = (
    "restart-prompt-title",
    "restart-prompt-question",
    "tab-position-header",
    "tab-additional-header",
    "dynamic-theme-header",
    "restart-header",
    "tab-feature-header",
    "statusbar-header",
    "bookmarks-bar-position-header",
    "geolocation-api-header",
    "geolocation-description",
    "webrtc-header",
    "ref-header",
)
COMPLEX_L10N = (
    "private-tab.true",
    "private-tab.false",
)


def get_json(endpoint: str, attempts: int = 1):
    """Helper method to simplify GET requests to Crowdin."""
    try:
        res = requests.get(
            BASE_URL + endpoint,
            headers={
                "Authorization": TOKEN
            }
        )
        res.raise_for_status
        return res.json()
    except requests.exceptions.HTTPError as e:
        if attempts > 3:
            logging.error(
                m(f'Maximum retries exceeded for endpoint: {BASE_URL + endpoint}', error=e))
            sys.exit(1)
        # Retry 3 times
        logging.error(m(f'Error with request to Crowdin. Retrying {attempts}/3', error=e))
        attempts += 1
        return get_json(endpoint, attempts)


def get_project_and_language_ids() -> Tuple[str, List[str]]:
    """Get the projectId and ids for all target languages."""

    endpoint = "/projects"
    data = get_json(endpoint)
    project_id = data["data"][0]["data"]["id"]
    language_ids = data["data"][0]["data"]["targetLanguageIds"]
    return (project_id, language_ids)


def get_string_ids_and_identifiers(project_id: str) -> Tuple[Tuple[int, str]]:
    """Get string data for all strings in the Browser L10n
       project on Crowdin.
       If we exceed 200 total strings we will need to build
       in pagination using the provided offset.
    """

    endpoint = f"/projects/{project_id}/strings?limit=200"
    data = get_json(endpoint)
    return tuple(map(lambda x: (x["data"]["id"], x["data"]["identifier"]), data["data"]))


def get_l10n(project_id: int, string_id: int, language_id: int, string_identifier: str) -> str:
    """Request a specific string translation from Crowdin.
       If there is no translation available we just return
       an empty string."""

    endpoint = f"/projects/{str(project_id)}/translations?stringId={str(string_id)}&languageId={str(language_id)}"
    data = get_json(endpoint)
    try:
        # Note: This just gives us the first translations, should do a piece
        # to ensure we get the **best** translations.
        language_id = LOCALE_MAP[language_id]
        return (language_id, string_identifier, data["data"][0]["data"]["text"])
    except IndexError:
        return ""


def append_l10n(idx: int, res: Tuple[int, str, str], num_strings: int, l10n_dict: Dict[str, List[Tuple[str, str]]]) -> Dict[str, List[Tuple[str, str]]]:
    """Assign translation lines to the correct position.
       We need to maintain order so that merges don't get
       messy.
    """

    prealloc = [""] * num_strings
    if res[0] not in l10n_dict.keys():
        l10n_dict[res[0]] = prealloc
    l10n_dict[res[0]][idx] = build_lines(res[1], res[2])
    return l10n_dict


def build_lines(identifier: str, translation: str) -> str:
    """Build lines of the extensibles fluent file.
       Note: The order that strings are added to Crowdin
       will dictate the order lines are added to the file.
       For complex or tooltip lines ensure strings are added
       in the correct order. A tooltip must be accompanied by
       a prior direct or label translation.
    """

    if identifier in DIRECT_L10N:
        lines = f"{identifier} = {translation}"
    elif identifier in COMPLEX_L10N:
        if "private-tab" in identifier:
            lines = build_private_lines(identifier, translation)
        else:
            lines = ""
    elif ".tooltiptext" in identifier:
        # Will need to develop a method to add this to the identifier lines
        # at some point
        lines = f"    .tooltiptext = {translation}"
    else:
        lines = f"{identifier} = \n    .label = {translation}"
    return lines


def build_private_lines(identifier: str, translation: str) -> str:
    """Build out complex private-tab fluent lines.
       Note: Order that strings were added to Crowdin is important.
    """

    if identifier == "private-tab.true":
        return "private-tab =\n    .label =\n        { $isPrivate ->\n            [true] " + translation
    elif identifier == "private-tab.false":
        return "            *[false] " + translation + "\n        }"


def main():
    project_id, language_ids = get_project_and_language_ids()
    string_ids_identifiers = get_string_ids_and_identifiers(project_id)
    string_ids = list(map(lambda x: x[1], string_ids_identifiers))
    args = []
    for language_id in language_ids:
        args.extend(
            list(map(lambda x: (project_id, x[0], language_id, x[1]), string_ids_identifiers)))

    # Rate limit is 20 simultaneous API calls, so limit to 20 workers
    with concurrent.futures.ThreadPoolExecutor(max_workers=20) as executor:
        l10n_dict = {}
        num_strings = len(string_ids)

        # Need to unpack the args, so using lambda for that
        for res in executor.map(lambda p: get_l10n(*p), args):
            # res is (language_id, string_identifier, translation)
            # Build ordered list languages > translations based on string_identifier
            if res != "":
                idx = string_ids.index(res[1])
                # Get a dict of langs and an array of lines
                l10n_dict = append_l10n(idx, res, num_strings, l10n_dict)
    print(l10n_dict.keys())
    # Write all lines for each language to relevant location
    for language in l10n_dict.keys():
        with open(f"waterfox/browser/locales/{language}/browser/browser/waterfox.ftl", "w") as outfile:
            outfile.write("\n".join(l10n_dict[language]))


if __name__ == "__main__":
    main()
