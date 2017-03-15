# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import unicode_literals

import os
import re
import sys

from datetime import datetime

# Set up Python environment to load build system packages.
OUR_DIR = os.path.dirname(__file__)
topsrcdir = os.path.normpath(os.path.join(OUR_DIR, '..', '..'))

EXTRA_PATHS = (
    'layout/tools/reftest',
    'python/futures',
    'python/jsmin',
    'python/mach',
    'python/mozbuild',
    'python/mozversioncontrol',
    'python/which',
    'testing/mozbase/manifestparser',
    'testing/mozbase/mozfile',
    'testing/mozbase/mozprocess',
)

sys.path[:0] = [os.path.join(topsrcdir, p) for p in EXTRA_PATHS]

sys.path.insert(0, OUR_DIR)

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.graphviz',
    'sphinx.ext.todo',
    'mozbuild.sphinx',
]

templates_path = ['_templates']
source_suffix = '.rst'
master_doc = 'index'
project = u'Mozilla Source Tree Docs'
year = datetime.now().year

# Grab the version from the source tree's milestone.
# FUTURE Use Python API from bug 941299.
with open(os.path.join(topsrcdir, 'config', 'milestone.txt'), 'rt') as fh:
    for line in fh:
        line = line.strip()

        if not line or line.startswith('#'):
            continue

        release = line
        break

version = re.sub(r'[ab]\d+$', '', release)

exclude_patterns = ['_build', '_staging', '_venv']
pygments_style = 'sphinx'

# We need to perform some adjustment of the settings and environment
# when running on Read The Docs.
on_rtd = os.environ.get('READTHEDOCS', None) == 'True'

if on_rtd:
    # SHELL isn't set on RTD and mach.mixin.process's import raises if a
    # shell-related environment variable can't be found. Set the variable here
    # to hack us into working on RTD.
    assert 'SHELL' not in os.environ
    os.environ['SHELL'] = '/bin/bash'
else:
    # We only need to set the RTD theme when not on RTD because the RTD
    # environment handles this otherwise.
    import sphinx_rtd_theme
    html_theme = 'sphinx_rtd_theme'
    html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]


html_static_path = ['_static']
htmlhelp_basename = 'MozillaTreeDocs'
