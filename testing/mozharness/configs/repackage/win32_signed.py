import os

platform = "win32"

config = {
    "locale": os.environ.get("LOCALE"),

    # ToolTool
    'tooltool_url': 'https://tooltool.mozilla-releng.net/',
    'tooltool_cache': os.environ.get('TOOLTOOL_CACHE'),

    'run_configure': False,
}
