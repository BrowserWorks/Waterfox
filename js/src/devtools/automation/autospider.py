#!/usr/bin/env python3
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.


import argparse
import json
import logging
import multiprocessing
import re
import os
import platform
import posixpath
import shutil
import subprocess
import sys

from collections import Counter, namedtuple
from logging import info
from os import environ as env
from subprocess import Popen
from threading import Timer

Dirs = namedtuple('Dirs', ['scripts', 'js_src', 'source', 'tooltool', 'fetches'])


def directories(pathmodule, cwd, fixup=lambda s: s):
    scripts = pathmodule.join(fixup(cwd), fixup(pathmodule.dirname(__file__)))
    js_src = pathmodule.abspath(pathmodule.join(scripts, "..", ".."))
    source = pathmodule.abspath(pathmodule.join(js_src, "..", ".."))
    tooltool = pathmodule.abspath(env.get('TOOLTOOL_CHECKOUT',
                                          pathmodule.join(source, "..", "..")))
    fetches = pathmodule.abspath(env.get('MOZ_FETCHES_DIR',
                                         pathmodule.join(source, "..", "..")))
    return Dirs(scripts, js_src, source, tooltool, fetches)


# Some scripts will be called with sh, which cannot use backslashed
# paths. So for direct subprocess.* invocation, use normal paths from
# DIR, but when running under the shell, use POSIX style paths.
DIR = directories(os.path, os.getcwd())
PDIR = directories(posixpath, os.environ["PWD"],
                   fixup=lambda s: re.sub(r'^(\w):', r'/\1', s))
env['CPP_UNIT_TESTS_DIR_JS_SRC'] = DIR.js_src

AUTOMATION = env.get('AUTOMATION', False)

parser = argparse.ArgumentParser(
    description='Run a spidermonkey shell build job')
parser.add_argument('--verbose', action='store_true', default=AUTOMATION,
                    help="display additional logging info")
parser.add_argument('--dep', action='store_true',
                    help='do not clobber the objdir before building')
parser.add_argument('--keep', action='store_true',
                    help='do not delete the sanitizer output directory (for testing)')
parser.add_argument('--platform', '-p', type=str, metavar='PLATFORM',
                    default='', help='build platform, including a suffix ("-debug" or "") used '
                    'by buildbot to override the variant\'s "debug" setting. The platform can be '
                    'used to specify 32 vs 64 bits.')
parser.add_argument('--timeout', '-t', type=int, metavar='TIMEOUT',
                    default=12600,
                    help='kill job after TIMEOUT seconds')
parser.add_argument('--objdir', type=str, metavar='DIR',
                    default=env.get('OBJDIR', os.path.join(DIR.source, 'obj-spider')),
                    help='object directory')
group = parser.add_mutually_exclusive_group()
group.add_argument('--optimize', action='store_true',
                   help='generate an optimized build. Overrides variant setting.')
group.add_argument('--no-optimize', action='store_false',
                   dest='optimize',
                   help='generate a non-optimized build. Overrides variant setting.')
group.set_defaults(optimize=None)
group = parser.add_mutually_exclusive_group()
group.add_argument('--debug', action='store_true',
                   help='generate a debug build. Overrides variant setting.')
group.add_argument('--no-debug', action='store_false',
                   dest='debug',
                   help='generate a non-debug build. Overrides variant setting.')
group.set_defaults(debug=None)
group = parser.add_mutually_exclusive_group()
group.add_argument('--jemalloc', action='store_true',
                   dest='jemalloc',
                   help='use mozilla\'s jemalloc instead of the default allocator')
group.add_argument('--no-jemalloc', action='store_false',
                   dest='jemalloc',
                   help='use the default allocator instead of mozilla\'s jemalloc')
group.set_defaults(jemalloc=None)
parser.add_argument('--run-tests', '--tests', type=str, metavar='TESTSUITE',
                    default='',
                    help="comma-separated set of test suites to add to the variant's default set")
parser.add_argument('--skip-tests', '--skip', type=str, metavar='TESTSUITE',
                    default='',
                    help="comma-separated set of test suites to remove from the variant's default "
                    "set")
parser.add_argument('--build-only', '--build',
                    dest='skip_tests', action='store_const', const='all',
                    help="only do a build, do not run any tests")
parser.add_argument('--noconf', action='store_true',
                    help="skip running configure when doing a build")
parser.add_argument('--nobuild', action='store_true',
                    help='Do not do a build. Rerun tests on existing build.')
parser.add_argument('variant', type=str,
                    help='type of job requested, see variants/ subdir')
args = parser.parse_args()

logging.basicConfig(level=logging.INFO, format='%(message)s')

OBJDIR = args.objdir
OUTDIR = os.path.join(OBJDIR, "out")
POBJDIR = posixpath.join(PDIR.source, args.objdir)
MAKE = env.get('MAKE', 'make')
MAKEFLAGS = env.get('MAKEFLAGS', '-j6' + ('' if AUTOMATION else ' -s'))
PYTHON = sys.executable

for d in ('scripts', 'js_src', 'source', 'tooltool', 'fetches'):
    info("DIR.{name} = {dir}".format(name=d, dir=getattr(DIR, d)))


def set_vars_from_script(script, vars):
    '''Run a shell script, then dump out chosen environment variables. The build
       system uses shell scripts to do some configuration that we need to
       borrow. On Windows, the script itself must output the variable settings
       (in the form "export FOO=<value>"), since otherwise there will be
       problems with mismatched Windows/POSIX formats.
    '''
    script_text = 'source %s' % script
    if platform.system() == 'Windows':
        parse_state = 'parsing exports'
    else:
        script_text += '; echo VAR SETTINGS:; '
        script_text += '; '.join('echo $' + var for var in vars)
        parse_state = 'scanning'
    stdout = subprocess.check_output(['sh', '-x', '-c', script_text]).decode()
    tograb = vars[:]
    for line in stdout.splitlines():
        if parse_state == 'scanning':
            if line == 'VAR SETTINGS:':
                parse_state = 'grabbing'
        elif parse_state == 'grabbing':
            var = tograb.pop(0)
            env[var] = line
        elif parse_state == 'parsing exports':
            m = re.match(r'export (\w+)=(.*)', line)
            if m:
                var, value = m.groups()
                if var in tograb:
                    env[var] = value
                    info("Setting %s = %s" % (var, value))


def ensure_dir_exists(name, clobber=True, creation_marker_filename="CREATED-BY-AUTOSPIDER"):
    if creation_marker_filename is None:
        marker = None
    else:
        marker = os.path.join(name, creation_marker_filename)
    if clobber:
        if not AUTOMATION and marker and os.path.exists(name) and not os.path.exists(marker):
            raise Exception(
                "Refusing to delete objdir %s because it was not created by autospider" % name)
        shutil.rmtree(name, ignore_errors=True)
    try:
        os.mkdir(name)
        if marker:
            open(marker, 'a').close()
    except OSError:
        if clobber:
            raise


with open(os.path.join(DIR.scripts, "variants", args.variant)) as fh:
    variant = json.load(fh)

if args.variant == 'nonunified':
    # Rewrite js/src/**/moz.build to replace UNIFIED_SOURCES to SOURCES.
    # Note that this modifies the current checkout.
    for dirpath, dirnames, filenames in os.walk(DIR.js_src):
        if 'moz.build' in filenames:
            in_place = ['-i']
            if platform.system() == 'Darwin':
                in_place.append('')
            subprocess.check_call(['sed'] + in_place + ['s/UNIFIED_SOURCES/SOURCES/',
                                                        os.path.join(dirpath, 'moz.build')])

CONFIGURE_ARGS = variant['configure-args']

opt = args.optimize
if opt is None:
    opt = variant.get('optimize')
if opt is not None:
    CONFIGURE_ARGS += (" --enable-optimize" if opt else " --disable-optimize")

opt = args.debug
if opt is None:
    opt = variant.get('debug')
if opt is not None:
    CONFIGURE_ARGS += (" --enable-debug" if opt else " --disable-debug")

opt = args.jemalloc
if opt is not None:
    CONFIGURE_ARGS += (" --enable-jemalloc" if opt else " --disable-jemalloc")

# Some of the variants request a particular word size (eg ARM simulators).
word_bits = variant.get('bits')

# On Linux and Windows, we build 32- and 64-bit versions on a 64 bit
# host, so the caller has to specify what is desired.
if word_bits is None and args.platform:
    platform_arch = args.platform.split('-')[0]
    if platform_arch in ('win32', 'linux'):
        word_bits = 32
    elif platform_arch in ('win64', 'linux64'):
        word_bits = 64

# Fall back to the word size of the host.
if word_bits is None:
    word_bits = 64 if platform.architecture()[0] == '64bit' else 32

if 'compiler' in variant:
    compiler = variant['compiler']
elif platform.system() == 'Darwin':
    compiler = 'clang'
elif platform.system() == 'Windows':
    compiler = 'cl'
else:
    compiler = 'gcc'

# Need a platform name to use as a key in variant files.
if args.platform:
    variant_platform = args.platform.split("-")[0]
elif platform.system() == 'Windows':
    variant_platform = 'win64' if word_bits == 64 else 'win32'
elif platform.system() == 'Linux':
    variant_platform = 'linux64' if word_bits == 64 else 'linux'
elif platform.system() == 'Darwin':
    variant_platform = 'macosx64'
else:
    variant_platform = 'other'


info("using compiler '{}'".format(compiler))

cxx = {'clang': 'clang++', 'gcc': 'g++', 'cl': 'cl'}.get(compiler)

compiler_dir = env.get('GCCDIR', os.path.join(DIR.fetches, compiler))
info("looking for compiler under {}/".format(compiler_dir))
compiler_libdir = None
if os.path.exists(os.path.join(compiler_dir, 'bin', compiler)):
    env.setdefault('CC', os.path.join(compiler_dir, 'bin', compiler))
    env.setdefault('CXX', os.path.join(compiler_dir, 'bin', cxx))
    if compiler == 'clang':
        platlib = 'lib'
    else:
        platlib = 'lib64' if word_bits == 64 else 'lib'
    compiler_libdir = os.path.join(compiler_dir, platlib)
else:
    env.setdefault('CC', compiler)
    env.setdefault('CXX', cxx)

bindir = os.path.join(OBJDIR, 'dist', 'bin')
env['LD_LIBRARY_PATH'] = ':'.join(
    p for p in (bindir, compiler_libdir, env.get('LD_LIBRARY_PATH')) if p)

for v in ('CC', 'CXX', 'LD_LIBRARY_PATH'):
    info("default {name} = {value}".format(name=v, value=env[v]))

rust_dir = os.path.join(DIR.fetches, 'rustc')
if os.path.exists(os.path.join(rust_dir, 'bin', 'rustc')):
    env.setdefault('RUSTC', os.path.join(rust_dir, 'bin', 'rustc'))
    env.setdefault('CARGO', os.path.join(rust_dir, 'bin', 'cargo'))
else:
    env.setdefault('RUSTC', 'rustc')
    env.setdefault('CARGO', 'cargo')

if platform.system() == 'Darwin':
    os.environ['SOURCE'] = DIR.source
    set_vars_from_script(os.path.join(DIR.scripts, 'macbuildenv.sh'),
                         ['CC', 'CXX'])
elif platform.system() == 'Windows':
    MAKE = env.get('MAKE', 'mozmake')
    os.environ['SOURCE'] = DIR.source
    if word_bits == 64:
        os.environ['USE_64BIT'] = '1'
    set_vars_from_script(posixpath.join(PDIR.scripts, 'winbuildenv.sh'),
                         ['PATH', 'VC_PATH', 'DIA_SDK_PATH', 'CC', 'CXX',
                          'WINDOWSSDKDIR'])

# Configure flags, based on word length and cross-compilation
if word_bits == 32:
    if platform.system() == 'Windows':
        CONFIGURE_ARGS += ' --target=i686-pc-mingw32'
    elif platform.system() == 'Linux':
        if not platform.machine().startswith('arm'):
            CONFIGURE_ARGS += ' --target=i686-pc-linux'

    # Add SSE2 support for x86/x64 architectures.
    if not platform.machine().startswith('arm'):
        if platform.system() == 'Windows':
            sse_flags = '-arch:SSE2'
        else:
            sse_flags = '-msse -msse2 -mfpmath=sse'
        env['CCFLAGS'] = '{0} {1}'.format(env.get('CCFLAGS', ''), sse_flags)
        env['CXXFLAGS'] = '{0} {1}'.format(env.get('CXXFLAGS', ''), sse_flags)
else:
    if platform.system() == 'Windows':
        CONFIGURE_ARGS += ' --target=x86_64-pc-mingw32'

if platform.system() == 'Linux' and AUTOMATION:
    CONFIGURE_ARGS = '--enable-stdcxx-compat --disable-gold ' + CONFIGURE_ARGS

# Override environment variant settings conditionally.
CONFIGURE_ARGS = "{} {}".format(
    variant.get('conditional-configure-args', {}).get(variant_platform, ''),
    CONFIGURE_ARGS
)

# Timeouts.
ACTIVE_PROCESSES = set()


def killall():
    for proc in ACTIVE_PROCESSES:
        proc.kill()
    ACTIVE_PROCESSES.clear()


timer = Timer(args.timeout, killall)
timer.daemon = True
timer.start()

ensure_dir_exists(OBJDIR, clobber=not args.dep and not args.nobuild)
ensure_dir_exists(OUTDIR, clobber=not args.keep)

# Any jobs that wish to produce additional output can save them into the upload
# directory if there is such a thing, falling back to OBJDIR.
env.setdefault('MOZ_UPLOAD_DIR', OBJDIR)
ensure_dir_exists(env['MOZ_UPLOAD_DIR'], clobber=False, creation_marker_filename=None)
info("MOZ_UPLOAD_DIR = {}".format(env['MOZ_UPLOAD_DIR']))


def run_command(command, check=False, **kwargs):
    kwargs.setdefault('cwd', OBJDIR)
    info("in directory {}, running {}".format(kwargs['cwd'], command))
    proc = Popen(command, **kwargs)
    ACTIVE_PROCESSES.add(proc)
    stdout, stderr = None, None
    try:
        stdout, stderr = proc.communicate()
    finally:
        ACTIVE_PROCESSES.discard(proc)
    status = proc.wait()
    if check and status != 0:
        raise subprocess.CalledProcessError(status, command, output=stderr)
    return stdout, stderr, status


# Replacement strings in environment variables.
REPLACEMENTS = {
    'DIR': DIR.scripts,
    'TOOLTOOL_CHECKOUT': DIR.tooltool,
    'MOZ_FETCHES_DIR': DIR.fetches,
    'MOZ_UPLOAD_DIR': env['MOZ_UPLOAD_DIR'],
    'OUTDIR': OUTDIR,
}

# Add in environment variable settings for this variant. Normally used to
# modify the flags passed to the shell or to set the GC zeal mode.
for k, v in variant.get('env', {}).items():
    env[k] = v.format(**REPLACEMENTS)

if AUTOMATION:
    # Currently only supported on linux64.
    if platform.system() == 'Linux' and platform.machine() == 'x86_64':
        use_minidump = variant.get('use_minidump', True)
    else:
        use_minidump = False
else:
    use_minidump = False

if use_minidump:
    env.setdefault('MINIDUMP_SAVE_PATH', env['MOZ_UPLOAD_DIR'])
    injector_lib = None
    if platform.system() == 'Linux':
        injector_lib = os.path.join(DIR.tooltool, 'breakpad-tools', 'libbreakpadinjector.so')
        env.setdefault('MINIDUMP_STACKWALK',
                       os.path.join(DIR.tooltool, 'breakpad-tools', 'minidump_stackwalk'))
    elif platform.system() == 'Darwin':
        injector_lib = os.path.join(DIR.tooltool, 'breakpad-tools', 'breakpadinjector.dylib')
    if not injector_lib or not os.path.exists(injector_lib):
        use_minidump = False

    info("use_minidump is {}".format(use_minidump))
    info("  MINIDUMP_SAVE_PATH={}".format(env['MINIDUMP_SAVE_PATH']))
    info("  injector lib is {}".format(injector_lib))
    info("  MINIDUMP_STACKWALK={}".format(env.get('MINIDUMP_STACKWALK')))


def need_updating_configure(configure):
    if not os.path.exists(configure):
        return True

    dep_files = [
        os.path.join(DIR.js_src, 'configure.in'),
        os.path.join(DIR.js_src, 'old-configure.in'),
    ]
    for file in dep_files:
        if os.path.getmtime(file) > os.path.getmtime(configure):
            return True

    return False


if not args.nobuild:
    CONFIGURE_ARGS += ' --enable-nspr-build'
    CONFIGURE_ARGS += ' --prefix={OBJDIR}/dist'.format(OBJDIR=POBJDIR)

    # Generate a configure script from configure.in.
    configure = os.path.join(DIR.js_src, 'configure')
    if need_updating_configure(configure):
        shutil.copyfile(configure + ".in", configure)
        os.chmod(configure, 0o755)

    # Run configure
    if not args.noconf:
        run_command(['sh', '-c', posixpath.join(PDIR.js_src, 'configure') + ' ' + CONFIGURE_ARGS],
                    check=True)

    # Run make
    run_command('%s -w %s' % (MAKE, MAKEFLAGS), shell=True, check=True)

    if use_minidump:
        # Convert symbols to breakpad format.
        hostdir = os.path.join(OBJDIR, "dist", "host", "bin")
        if not os.path.isdir(hostdir):
            os.makedirs(hostdir)
        shutil.copy(os.path.join(DIR.tooltool, "breakpad-tools", "dump_syms"),
                    os.path.join(hostdir, 'dump_syms'))
        run_command([
            'make',
            'recurse_syms',
            'MOZ_SOURCE_REPO=file://' + DIR.source,
            'RUSTC_COMMIT=0',
            'MOZ_CRASHREPORTER=1',
            'MOZ_AUTOMATION_BUILD_SYMBOLS=1',
        ], check=True)

COMMAND_PREFIX = []
# On Linux, disable ASLR to make shell builds a bit more reproducible.
if subprocess.call("type setarch >/dev/null 2>&1", shell=True) == 0:
    COMMAND_PREFIX.extend(['setarch', platform.machine(), '-R'])


def run_test_command(command, **kwargs):
    _, _, status = run_command(COMMAND_PREFIX + command, check=False, **kwargs)
    return status


default_test_suites = frozenset(['jstests', 'jittest', 'jsapitests', 'checks'])
nondefault_test_suites = frozenset(['gdb'])
all_test_suites = default_test_suites | nondefault_test_suites

test_suites = set(default_test_suites)


def normalize_tests(tests):
    if 'all' in tests:
        return default_test_suites
    return tests


# Override environment variant settings conditionally.
for k, v in variant.get('conditional-env', {}).get(variant_platform, {}).items():
    env[k] = v.format(**REPLACEMENTS)

# Skip any tests that are not run on this platform (or the 'all' platform).
test_suites -= set(normalize_tests(variant.get('skip-tests', {}).get(variant_platform, [])))
test_suites -= set(normalize_tests(variant.get('skip-tests', {}).get('all', [])))

# Add in additional tests for this platform (or the 'all' platform).
test_suites |= set(normalize_tests(variant.get('extra-tests', {}).get(variant_platform, [])))
test_suites |= set(normalize_tests(variant.get('extra-tests', {}).get('all', [])))

# Now adjust the variant's default test list with command-line arguments.
test_suites |= set(normalize_tests(args.run_tests.split(",")))
test_suites -= set(normalize_tests(args.skip_tests.split(",")))
if 'all' in args.skip_tests.split(","):
    test_suites = []

# Bug 1391877 - Windows test runs are getting mysterious timeouts when run
# through taskcluster, but only when running multiple jit-test jobs in
# parallel. Work around them for now.
if platform.system() == 'Windows':
    env['JITTEST_EXTRA_ARGS'] = "-j1 " + env.get('JITTEST_EXTRA_ARGS', '')

# Bug 1557130 - Atomics tests can create many additional threads which can
# lead to resource exhaustion, resulting in intermittent failures. This was
# only seen on beefy machines (> 32 cores), so limit the number of parallel
# workers for now.
if platform.system() == 'Windows':
    worker_count = min(multiprocessing.cpu_count(), 16)
    env['JSTESTS_EXTRA_ARGS'] = "-j{} ".format(worker_count) + env.get('JSTESTS_EXTRA_ARGS', '')

if use_minidump:
    # Set up later js invocations to run with the breakpad injector loaded.
    # Originally, I intended for this to be used with LD_PRELOAD, but when
    # cross-compiling from 64- to 32-bit, that will fail and produce stderr
    # output when running any 64-bit commands, which breaks eg mozconfig
    # processing. So use the --dll command line mechanism universally.
    for v in ('JSTESTS_EXTRA_ARGS', 'JITTEST_EXTRA_ARGS'):
        env[v] = "--args='--dll %s' %s" % (injector_lib, env.get(v, ''))

# Always run all enabled tests, even if earlier ones failed. But return the
# first failed status.
results = [('(make-nonempty)', 0)]

if 'checks' in test_suites:
    results.append(('make check', run_test_command([MAKE, 'check'])))

if 'jittest' in test_suites:
    results.append(('make check-jit-test', run_test_command([MAKE, 'check-jit-test'])))
if 'jsapitests' in test_suites:
    jsapi_test_binary = os.path.join(OBJDIR, 'dist', 'bin', 'jsapi-tests')
    test_env = env.copy()
    test_env['TOPSRCDIR'] = DIR.source
    if use_minidump and platform.system() == 'Linux':
        test_env['LD_PRELOAD'] = injector_lib
    st = run_test_command([jsapi_test_binary], env=test_env)
    if st < 0:
        print("PROCESS-CRASH | jsapi-tests | application crashed")
        print("Return code: {}".format(st))
    results.append(('jsapi-tests', st))
if 'jstests' in test_suites:
    results.append(('jstests', run_test_command([MAKE, 'check-jstests'])))
if 'gdb' in test_suites:
    test_script = os.path.join(DIR.js_src, "gdb", "run-tests.py")
    auto_args = ["-s", "-o", "--no-progress"] if AUTOMATION else []
    extra_args = env.get('GDBTEST_EXTRA_ARGS', '').split(' ')
    results.append((
        'gdb',
        run_test_command([PYTHON, test_script, *auto_args, *extra_args, OBJDIR])
    ))

# FIXME bug 1291449: This would be unnecessary if we could run msan with -mllvm
# -msan-keep-going, but in clang 3.8 it causes a hang during compilation.
if variant.get('ignore-test-failures'):
    logging.warning("Ignoring test results %s" % (results,))
    results = [('ignored', 0)]

if args.variant == 'msan':
    files = filter(lambda f: f.startswith("sanitize_log."), os.listdir(OUTDIR))
    fullfiles = [os.path.join(OUTDIR, f) for f in files]

    # Summarize results
    sites = Counter()
    errors = Counter()
    for filename in fullfiles:
        with open(os.path.join(OUTDIR, filename), 'rb') as fh:
            for line in fh:
                m = re.match(r'^SUMMARY: \w+Sanitizer: (?:data race|use-of-uninitialized-value) (.*)',  # NOQA: E501
                             line.strip())
                if m:
                    # Some reports include file:line:column, some just
                    # file:line. Just in case it's nondeterministic, we will
                    # canonicalize to just the line number.
                    site = re.sub(r'^(\S+?:\d+)(:\d+)* ', r'\1 ', m.group(1))
                    sites[site] += 1

    # Write a summary file and display it to stdout.
    summary_filename = os.path.join(env['MOZ_UPLOAD_DIR'], "%s_summary.txt" % args.variant)
    with open(summary_filename, 'wb') as outfh:
        for location, count in sites.most_common():
            print >> outfh, "%d %s" % (count, location)
    print(open(summary_filename, 'rb').read())

    if 'max-errors' in variant:
        max_allowed = variant['max-errors']
        print("Found %d errors out of %d allowed" % (len(sites), max_allowed))
        if len(sites) > max_allowed:
            results.append(('too many msan errors', 1))

    # Gather individual results into a tarball. Note that these are
    # distinguished only by pid of the JS process running within each test, so
    # given the 16-bit limitation of pids, it's totally possible that some of
    # these files will be lost due to being overwritten.
    command = ['tar', '-C', OUTDIR, '-zcf',
               os.path.join(env['MOZ_UPLOAD_DIR'], '%s.tar.gz' % args.variant)]
    command += files
    subprocess.call(command)

# Generate stacks from minidumps.
if use_minidump:
    venv_python = os.path.join(OBJDIR, "_virtualenvs", "init_py3", "bin", "python3")
    run_command([
        venv_python,
        os.path.join(DIR.source, "testing/mozbase/mozcrash/mozcrash/mozcrash.py"),
        os.getenv("TMPDIR", "/tmp"),
        os.path.join(OBJDIR, "dist/crashreporter-symbols"),
    ])

for name, st in results:
    print("exit status %d for '%s'" % (st, name))

sys.exit(max(st for _, st in results))
