import os

platform = "win32"

config = {
    "repack_id": os.environ.get("REPACK_ID"),

    # ToolTool
    'tooltool_cache': os.environ.get('TOOLTOOL_CACHE'),

    'run_configure': False,
}
