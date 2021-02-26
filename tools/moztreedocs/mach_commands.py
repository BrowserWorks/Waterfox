# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, # You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import, print_function, unicode_literals


import fnmatch
import multiprocessing
import os
import re
import subprocess
import sys
import time
import yaml

from functools import partial
from pprint import pprint

from mozbuild.base import MachCommandBase
from mach.decorators import (
    Command,
    CommandArgument,
    CommandProvider,
)

here = os.path.abspath(os.path.dirname(__file__))
topsrcdir = os.path.abspath(os.path.dirname(os.path.dirname(here)))
DOC_ROOT = os.path.join(topsrcdir, 'docs')
JSDOC_NOT_FOUND = """\
JSDoc==3.5.5 is required to build the docs but was not found on your system.
Please install it globally by running:

    $ npm install -g jsdoc@3.5.5

Bug 1498604 tracks bootstrapping jsdoc properly.
Bug 1556460 tracks supporting newer versions of jsdoc.
"""


@CommandProvider
class Documentation(MachCommandBase):
    """Helps manage in-tree documentation."""

    def __init__(self, *args, **kwargs):
        super(Documentation, self).__init__(*args, **kwargs)

        self._manager = None
        self._project = None
        self._version = None

    @Command('doc', category='devenv',
             description='Generate and serve documentation from the tree.')
    @CommandArgument('path', default=None, metavar='DIRECTORY', nargs='?',
                     help='Path to documentation to build and display.')
    @CommandArgument('--format', default='html', dest='fmt',
                     help='Documentation format to write.')
    @CommandArgument('--outdir', default=None, metavar='DESTINATION',
                     help='Where to write output.')
    @CommandArgument('--archive', action='store_true',
                     help='Write a gzipped tarball of generated docs.')
    @CommandArgument('--no-open', dest='auto_open', default=True,
                     action='store_false',
                     help="Don't automatically open HTML docs in a browser.")
    @CommandArgument('--no-serve', dest='serve', default=True, action='store_false',
                     help="Don't serve the generated docs after building.")
    @CommandArgument('--http', default='localhost:5500', metavar='ADDRESS',
                     help='Serve documentation on the specified host and port, '
                          'default "localhost:5500".')
    @CommandArgument('--upload', action='store_true',
                     help='Upload generated files to S3.')
    @CommandArgument('-j', '--jobs', default=str(multiprocessing.cpu_count()), dest='jobs',
                     help='Distribute the build over N processes in parallel.')
    def build_docs(self, path=None, fmt='html', outdir=None, auto_open=True,
                   serve=True, http=None, archive=False, upload=False, jobs=None):
        if self.check_jsdoc():
            return die(JSDOC_NOT_FOUND)

        self.activate_pipenv(os.path.join(here, 'Pipfile'))

        import webbrowser
        from livereload import Server
        from moztreedocs.package import create_tarball

        outdir = outdir or os.path.join(self.topobjdir, 'docs')
        savedir = os.path.join(outdir, fmt)

        path = path or self.topsrcdir
        path = os.path.normpath(os.path.abspath(path))

        docdir = self._find_doc_dir(path)
        if not docdir:
            print(self._dump_sphinx_backtrace())
            return die('failed to generate documentation:\n'
                       '%s: could not find docs at this location' % path)

        result = self._run_sphinx(docdir, savedir, fmt=fmt, jobs=jobs)
        if result != 0:
            print(self._dump_sphinx_backtrace())
            return die('failed to generate documentation:\n'
                       '%s: sphinx return code %d' % (path, result))
        else:
            print('\nGenerated documentation:\n%s' % savedir)

        print('Post processing HTML files')
        self._post_process_html(savedir)

        if archive:
            archive_path = os.path.join(outdir, '%s.tar.gz' % self.project)
            create_tarball(archive_path, savedir)
            print('Archived to %s' % archive_path)

        if upload:
            self._s3_upload(savedir, self.project, self.version)

        if not serve:
            index_path = os.path.join(savedir, 'index.html')
            if auto_open and os.path.isfile(index_path):
                webbrowser.open(index_path)
            return

        # Create livereload server. Any files modified in the specified docdir
        # will cause a re-build and refresh of the browser (if open).
        try:
            host, port = http.split(':', 1)
            port = int(port)
        except ValueError:
            return die('invalid address: %s' % http)

        server = Server()

        sphinx_trees = self.manager.trees or {savedir: docdir}
        for _, src in sphinx_trees.items():
            run_sphinx = partial(self._run_sphinx, src, savedir, fmt=fmt, jobs=jobs)
            server.watch(src, run_sphinx)
        server.serve(host=host, port=port, root=savedir,
                     open_url_delay=0.1 if auto_open else None)

    def _dump_sphinx_backtrace(self):
        """
            If there is a sphinx dump file, read and return
            its content.
            By default, it isn't displayed.
        """
        pattern = "sphinx-err-*"
        output = ""
        tmpdir = "/tmp"

        if not os.path.isdir(tmpdir):
            # Only run it on Linux
            return
        files = os.listdir(tmpdir)
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                pathFile = os.path.join(tmpdir, name)
                stat = os.stat(pathFile)
                output += "Name: {0} / Creation date: {1}\n".format(
                    pathFile, time.ctime(stat.st_mtime))
                with open(pathFile) as f:
                    output += f.read()
        return output

    def _run_sphinx(self, docdir, savedir, config=None, fmt='html', jobs=None):
        import sphinx.cmd.build
        config = config or self.manager.conf_py_path
        args = [
            '-b', fmt,
            '-c', os.path.dirname(config),
            docdir,
            savedir,
        ]
        if jobs:
            args.extend(['-j', jobs])
        return sphinx.cmd.build.build_main(args)

    def _post_process_html(self, savedir):
        """
            Perform some operations on the generated html to fix some URL
        """
        MERMAID_VERSION = "8.4.4"
        for root, _, files in os.walk(savedir):
            for file in files:
                if file.endswith(".html"):
                    p = os.path.join(root, file)

                    with open(p, 'r') as file:
                        filedata = file.read()

                    # Workaround https://bugzilla.mozilla.org/show_bug.cgi?id=1607143
                    # to avoid a CSP error
                    # This method should be removed once
                    # https://github.com/mgaitan/sphinxcontrib-mermaid/pull/37 is merged
                    # As sphinx-mermaid currently uses an old version, also force
                    # a more recent version
                    filedata = re.sub(r'https://unpkg.com/mermaid@.*/dist',
                                      r'https://cdnjs.cloudflare.com/ajax/libs/mermaid/{}'
                                      .format(MERMAID_VERSION), filedata)

                    with open(p, 'w') as file:
                        file.write(filedata)

    @property
    def manager(self):
        if not self._manager:
            from moztreedocs import manager
            self._manager = manager
        return self._manager

    def _read_project_properties(self):
        import imp
        path = os.path.normpath(self.manager.conf_py_path)
        with open(path, 'r') as fh:
            conf = imp.load_module('doc_conf', fh, path,
                                   ('.py', 'r', imp.PY_SOURCE))

        # Prefer the Mozilla project name, falling back to Sphinx's
        # default variable if it isn't defined.
        project = getattr(conf, 'moz_project_name', None)
        if not project:
            project = conf.project.replace(' ', '_')

        self._project = project
        self._version = getattr(conf, 'version', None)

    @property
    def project(self):
        if not self._project:
            self._read_project_properties()
        return self._project

    @property
    def version(self):
        if not self._version:
            self._read_project_properties()
        return self._version

    def _find_doc_dir(self, path):
        if os.path.isfile(path):
            return

        valid_doc_dirs = ('doc', 'docs')
        if os.path.basename(path) in valid_doc_dirs:
            return path

        for d in valid_doc_dirs:
            p = os.path.join(path, d)
            if os.path.isdir(p):
                return p

    def _s3_upload(self, root, project, version=None):
        from moztreedocs.package import distribution_files
        from moztreedocs.upload import s3_upload, s3_set_redirects

        # Files are uploaded to multiple locations:
        #
        # <project>/latest
        # <project>/<version>
        #
        # This allows multiple projects and versions to be stored in the
        # S3 bucket.

        files = list(distribution_files(root))
        key_prefixes = ['%s/latest' % project]
        if version:
            key_prefixes.append('%s/%s' % (project, version))

        # Until we redirect / to main/latest, upload the main docs
        # to the root.
        if project == 'main':
            key_prefixes.append('')

        with open(os.path.join(DOC_ROOT, 'config.yml'), 'r') as fh:
            redirects = yaml.safe_load(fh)['redirects']

        redirects = {k.strip("/"): v.strip("/") for k, v in redirects.items()}

        all_redirects = {}

        for prefix in key_prefixes:
            s3_upload(files, prefix)

            # Don't setup redirects for the "version" prefix since we are
            # exceeding a 50 redirect limit and external things are unlikely to
            # link there anyway (see bug 1614908).
            if version and prefix.endswith(version):
                continue

            if prefix:
                prefix += '/'
            all_redirects.update({prefix + k: prefix + v for k, v in redirects.items()})

        print("Redirects currently staged")
        pprint(all_redirects, indent=1)

        s3_set_redirects(all_redirects)

    def check_jsdoc(self):
        try:
            from mozfile import which
            exe_name = which('jsdoc')
            if not exe_name:
                return 1
            out = subprocess.check_output([exe_name, '--version'])
            version = out.split()[1]
        except subprocess.CalledProcessError:
            version = None

        if not version or not version.startswith(b'3.5'):
            return 1


def die(msg, exit_code=1):
    msg = '%s: %s' % (sys.argv[0], msg)
    print(msg, file=sys.stderr)
    return exit_code
