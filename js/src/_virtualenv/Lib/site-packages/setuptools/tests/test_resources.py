#!/usr/bin/python
# -*- coding: utf-8 -*-
# NOTE: the shebang and encoding lines are for TestScriptHeader do not remove

import os
import sys
import tempfile
import shutil

import pytest

import pkg_resources
from pkg_resources import (parse_requirements, VersionConflict, parse_version,
    Distribution, EntryPoint, Requirement, safe_version, safe_name,
    WorkingSet)

packaging = pkg_resources.packaging

from setuptools.command.easy_install import (get_script_header, is_sh,
    nt_quote_arg)
from setuptools.compat import StringIO, iteritems, PY3

def safe_repr(obj, short=False):
    """ copied from Python2.7"""
    try:
        result = repr(obj)
    except Exception:
        result = object.__repr__(obj)
    if not short or len(result) < pkg_resources._MAX_LENGTH:
        return result
    return result[:pkg_resources._MAX_LENGTH] + ' [truncated]...'

class Metadata(pkg_resources.EmptyProvider):
    """Mock object to return metadata as if from an on-disk distribution"""

    def __init__(self,*pairs):
        self.metadata = dict(pairs)

    def has_metadata(self,name):
        return name in self.metadata

    def get_metadata(self,name):
        return self.metadata[name]

    def get_metadata_lines(self,name):
        return pkg_resources.yield_lines(self.get_metadata(name))

dist_from_fn = pkg_resources.Distribution.from_filename

class TestDistro:

    def testCollection(self):
        # empty path should produce no distributions
        ad = pkg_resources.Environment([], platform=None, python=None)
        assert list(ad) == []
        assert ad['FooPkg'] == []
        ad.add(dist_from_fn("FooPkg-1.3_1.egg"))
        ad.add(dist_from_fn("FooPkg-1.4-py2.4-win32.egg"))
        ad.add(dist_from_fn("FooPkg-1.2-py2.4.egg"))

        # Name is in there now
        assert ad['FooPkg']
        # But only 1 package
        assert list(ad) == ['foopkg']

        # Distributions sort by version
        assert [dist.version for dist in ad['FooPkg']] == ['1.4','1.3-1','1.2']

        # Removing a distribution leaves sequence alone
        ad.remove(ad['FooPkg'][1])
        assert [dist.version for dist in ad['FooPkg']] == ['1.4','1.2']

        # And inserting adds them in order
        ad.add(dist_from_fn("FooPkg-1.9.egg"))
        assert [dist.version for dist in ad['FooPkg']] == ['1.9','1.4','1.2']

        ws = WorkingSet([])
        foo12 = dist_from_fn("FooPkg-1.2-py2.4.egg")
        foo14 = dist_from_fn("FooPkg-1.4-py2.4-win32.egg")
        req, = parse_requirements("FooPkg>=1.3")

        # Nominal case: no distros on path, should yield all applicable
        assert ad.best_match(req, ws).version == '1.9'
        # If a matching distro is already installed, should return only that
        ws.add(foo14)
        assert ad.best_match(req, ws).version == '1.4'

        # If the first matching distro is unsuitable, it's a version conflict
        ws = WorkingSet([])
        ws.add(foo12)
        ws.add(foo14)
        with pytest.raises(VersionConflict):
            ad.best_match(req, ws)

        # If more than one match on the path, the first one takes precedence
        ws = WorkingSet([])
        ws.add(foo14)
        ws.add(foo12)
        ws.add(foo14)
        assert ad.best_match(req, ws).version == '1.4'

    def checkFooPkg(self,d):
        assert d.project_name == "FooPkg"
        assert d.key == "foopkg"
        assert d.version == "1.3.post1"
        assert d.py_version == "2.4"
        assert d.platform == "win32"
        assert d.parsed_version == parse_version("1.3-1")

    def testDistroBasics(self):
        d = Distribution(
            "/some/path",
            project_name="FooPkg",version="1.3-1",py_version="2.4",platform="win32"
        )
        self.checkFooPkg(d)

        d = Distribution("/some/path")
        assert d.py_version == sys.version[:3]
        assert d.platform == None

    def testDistroParse(self):
        d = dist_from_fn("FooPkg-1.3.post1-py2.4-win32.egg")
        self.checkFooPkg(d)
        d = dist_from_fn("FooPkg-1.3.post1-py2.4-win32.egg-info")
        self.checkFooPkg(d)

    def testDistroMetadata(self):
        d = Distribution(
            "/some/path", project_name="FooPkg", py_version="2.4", platform="win32",
            metadata = Metadata(
                ('PKG-INFO',"Metadata-Version: 1.0\nVersion: 1.3-1\n")
            )
        )
        self.checkFooPkg(d)

    def distRequires(self, txt):
        return Distribution("/foo", metadata=Metadata(('depends.txt', txt)))

    def checkRequires(self, dist, txt, extras=()):
        assert list(dist.requires(extras)) == list(parse_requirements(txt))

    def testDistroDependsSimple(self):
        for v in "Twisted>=1.5", "Twisted>=1.5\nZConfig>=2.0":
            self.checkRequires(self.distRequires(v), v)

    def testResolve(self):
        ad = pkg_resources.Environment([])
        ws = WorkingSet([])
        # Resolving no requirements -> nothing to install
        assert list(ws.resolve([], ad)) == []
        # Request something not in the collection -> DistributionNotFound
        with pytest.raises(pkg_resources.DistributionNotFound):
            ws.resolve(parse_requirements("Foo"), ad)

        Foo = Distribution.from_filename(
            "/foo_dir/Foo-1.2.egg",
            metadata=Metadata(('depends.txt', "[bar]\nBaz>=2.0"))
        )
        ad.add(Foo)
        ad.add(Distribution.from_filename("Foo-0.9.egg"))

        # Request thing(s) that are available -> list to activate
        for i in range(3):
            targets = list(ws.resolve(parse_requirements("Foo"), ad))
            assert targets == [Foo]
            list(map(ws.add,targets))
        with pytest.raises(VersionConflict):
            ws.resolve(parse_requirements("Foo==0.9"), ad)
        ws = WorkingSet([]) # reset

        # Request an extra that causes an unresolved dependency for "Baz"
        with pytest.raises(pkg_resources.DistributionNotFound):
            ws.resolve(parse_requirements("Foo[bar]"), ad)
        Baz = Distribution.from_filename(
            "/foo_dir/Baz-2.1.egg", metadata=Metadata(('depends.txt', "Foo"))
        )
        ad.add(Baz)

        # Activation list now includes resolved dependency
        assert list(ws.resolve(parse_requirements("Foo[bar]"), ad)) ==[Foo,Baz]
        # Requests for conflicting versions produce VersionConflict
        with pytest.raises(VersionConflict):
            ws.resolve(parse_requirements("Foo==1.2\nFoo!=1.2"), ad)

    def testDistroDependsOptions(self):
        d = self.distRequires("""
            Twisted>=1.5
            [docgen]
            ZConfig>=2.0
            docutils>=0.3
            [fastcgi]
            fcgiapp>=0.1""")
        self.checkRequires(d,"Twisted>=1.5")
        self.checkRequires(
            d,"Twisted>=1.5 ZConfig>=2.0 docutils>=0.3".split(), ["docgen"]
        )
        self.checkRequires(
            d,"Twisted>=1.5 fcgiapp>=0.1".split(), ["fastcgi"]
        )
        self.checkRequires(
            d,"Twisted>=1.5 ZConfig>=2.0 docutils>=0.3 fcgiapp>=0.1".split(),
            ["docgen","fastcgi"]
        )
        self.checkRequires(
            d,"Twisted>=1.5 fcgiapp>=0.1 ZConfig>=2.0 docutils>=0.3".split(),
            ["fastcgi", "docgen"]
        )
        with pytest.raises(pkg_resources.UnknownExtra):
            d.requires(["foo"])


class TestEntryPoints:

    def assertfields(self, ep):
        assert ep.name == "foo"
        assert ep.module_name == "setuptools.tests.test_resources"
        assert ep.attrs == ("TestEntryPoints",)
        assert ep.extras == ("x",)
        assert ep.load() is TestEntryPoints
        assert (
            str(ep) ==
            "foo = setuptools.tests.test_resources:TestEntryPoints [x]"
        )

    def setup_method(self, method):
        self.dist = Distribution.from_filename(
            "FooPkg-1.2-py2.4.egg", metadata=Metadata(('requires.txt','[x]')))

    def testBasics(self):
        ep = EntryPoint(
            "foo", "setuptools.tests.test_resources", ["TestEntryPoints"],
            ["x"], self.dist
        )
        self.assertfields(ep)

    def testParse(self):
        s = "foo = setuptools.tests.test_resources:TestEntryPoints [x]"
        ep = EntryPoint.parse(s, self.dist)
        self.assertfields(ep)

        ep = EntryPoint.parse("bar baz=  spammity[PING]")
        assert ep.name == "bar baz"
        assert ep.module_name == "spammity"
        assert ep.attrs == ()
        assert ep.extras == ("ping",)

        ep = EntryPoint.parse(" fizzly =  wocka:foo")
        assert ep.name == "fizzly"
        assert ep.module_name == "wocka"
        assert ep.attrs == ("foo",)
        assert ep.extras == ()

        # plus in the name
        spec = "html+mako = mako.ext.pygmentplugin:MakoHtmlLexer"
        ep = EntryPoint.parse(spec)
        assert ep.name == 'html+mako'

    def testRejects(self):
        for ep in [
            "foo", "x=1=2", "x=a:b:c", "q=x/na", "fez=pish:tush-z", "x=f[a]>2",
        ]:
            try: EntryPoint.parse(ep)
            except ValueError: pass
            else: raise AssertionError("Should've been bad", ep)

    def checkSubMap(self, m):
        assert len(m) == len(self.submap_expect)
        for key, ep in iteritems(self.submap_expect):
            assert repr(m.get(key)) == repr(ep)

    submap_expect = dict(
        feature1=EntryPoint('feature1', 'somemodule', ['somefunction']),
        feature2=EntryPoint('feature2', 'another.module', ['SomeClass'], ['extra1','extra2']),
        feature3=EntryPoint('feature3', 'this.module', extras=['something'])
    )
    submap_str = """
            # define features for blah blah
            feature1 = somemodule:somefunction
            feature2 = another.module:SomeClass [extra1,extra2]
            feature3 = this.module [something]
    """

    def testParseList(self):
        self.checkSubMap(EntryPoint.parse_group("xyz", self.submap_str))
        with pytest.raises(ValueError):
            EntryPoint.parse_group("x a", "foo=bar")
        with pytest.raises(ValueError):
            EntryPoint.parse_group("x", ["foo=baz", "foo=bar"])

    def testParseMap(self):
        m = EntryPoint.parse_map({'xyz':self.submap_str})
        self.checkSubMap(m['xyz'])
        assert list(m.keys()) == ['xyz']
        m = EntryPoint.parse_map("[xyz]\n"+self.submap_str)
        self.checkSubMap(m['xyz'])
        assert list(m.keys()) == ['xyz']
        with pytest.raises(ValueError):
            EntryPoint.parse_map(["[xyz]", "[xyz]"])
        with pytest.raises(ValueError):
            EntryPoint.parse_map(self.submap_str)

class TestRequirements:

    def testBasics(self):
        r = Requirement.parse("Twisted>=1.2")
        assert str(r) == "Twisted>=1.2"
        assert repr(r) == "Requirement.parse('Twisted>=1.2')"
        assert r == Requirement("Twisted", [('>=','1.2')], ())
        assert r == Requirement("twisTed", [('>=','1.2')], ())
        assert r != Requirement("Twisted", [('>=','2.0')], ())
        assert r != Requirement("Zope", [('>=','1.2')], ())
        assert r != Requirement("Zope", [('>=','3.0')], ())
        assert r != Requirement.parse("Twisted[extras]>=1.2")

    def testOrdering(self):
        r1 = Requirement("Twisted", [('==','1.2c1'),('>=','1.2')], ())
        r2 = Requirement("Twisted", [('>=','1.2'),('==','1.2c1')], ())
        assert r1 == r2
        assert str(r1) == str(r2)
        assert str(r2) == "Twisted==1.2c1,>=1.2"

    def testBasicContains(self):
        r = Requirement("Twisted", [('>=','1.2')], ())
        foo_dist = Distribution.from_filename("FooPkg-1.3_1.egg")
        twist11 = Distribution.from_filename("Twisted-1.1.egg")
        twist12 = Distribution.from_filename("Twisted-1.2.egg")
        assert parse_version('1.2') in r
        assert parse_version('1.1') not in r
        assert '1.2' in r
        assert '1.1' not in r
        assert foo_dist not in r
        assert twist11 not in r
        assert twist12 in r

    def testOptionsAndHashing(self):
        r1 = Requirement.parse("Twisted[foo,bar]>=1.2")
        r2 = Requirement.parse("Twisted[bar,FOO]>=1.2")
        assert r1 == r2
        assert r1.extras == ("foo","bar")
        assert r2.extras == ("bar","foo")  # extras are normalized
        assert hash(r1) == hash(r2)
        assert (
            hash(r1)
            ==
            hash((
                "twisted",
                packaging.specifiers.SpecifierSet(">=1.2"),
                frozenset(["foo","bar"]),
            ))
        )

    def testVersionEquality(self):
        r1 = Requirement.parse("foo==0.3a2")
        r2 = Requirement.parse("foo!=0.3a4")
        d = Distribution.from_filename

        assert d("foo-0.3a4.egg") not in r1
        assert d("foo-0.3a1.egg") not in r1
        assert d("foo-0.3a4.egg") not in r2

        assert d("foo-0.3a2.egg") in r1
        assert d("foo-0.3a2.egg") in r2
        assert d("foo-0.3a3.egg") in r2
        assert d("foo-0.3a5.egg") in r2

    def testSetuptoolsProjectName(self):
        """
        The setuptools project should implement the setuptools package.
        """

        assert (
            Requirement.parse('setuptools').project_name == 'setuptools')
        # setuptools 0.7 and higher means setuptools.
        assert (
            Requirement.parse('setuptools == 0.7').project_name == 'setuptools')
        assert (
            Requirement.parse('setuptools == 0.7a1').project_name == 'setuptools')
        assert (
            Requirement.parse('setuptools >= 0.7').project_name == 'setuptools')


class TestParsing:

    def testEmptyParse(self):
        assert list(parse_requirements('')) == []

    def testYielding(self):
        for inp,out in [
            ([], []), ('x',['x']), ([[]],[]), (' x\n y', ['x','y']),
            (['x\n\n','y'], ['x','y']),
        ]:
            assert list(pkg_resources.yield_lines(inp)) == out

    def testSplitting(self):
        sample = """
                    x
                    [Y]
                    z

                    a
                    [b ]
                    # foo
                    c
                    [ d]
                    [q]
                    v
                    """
        assert (
            list(pkg_resources.split_sections(sample))
                ==
            [
                (None, ["x"]),
                ("Y", ["z", "a"]),
                ("b", ["c"]),
                ("d", []),
                ("q", ["v"]),
            ]
        )
        with pytest.raises(ValueError):
            list(pkg_resources.split_sections("[foo"))

    def testSafeName(self):
        assert safe_name("adns-python") == "adns-python"
        assert safe_name("WSGI Utils") == "WSGI-Utils"
        assert safe_name("WSGI  Utils") == "WSGI-Utils"
        assert safe_name("Money$$$Maker") == "Money-Maker"
        assert safe_name("peak.web") != "peak-web"

    def testSafeVersion(self):
        assert safe_version("1.2-1") == "1.2.post1"
        assert safe_version("1.2 alpha") == "1.2.alpha"
        assert safe_version("2.3.4 20050521") == "2.3.4.20050521"
        assert safe_version("Money$$$Maker") == "Money-Maker"
        assert safe_version("peak.web") == "peak.web"

    def testSimpleRequirements(self):
        assert (
            list(parse_requirements('Twis-Ted>=1.2-1'))
            ==
            [Requirement('Twis-Ted',[('>=','1.2-1')], ())]
        )
        assert (
            list(parse_requirements('Twisted >=1.2, \ # more\n<2.0'))
            ==
            [Requirement('Twisted',[('>=','1.2'),('<','2.0')], ())]
        )
        assert (
            Requirement.parse("FooBar==1.99a3")
            ==
            Requirement("FooBar", [('==','1.99a3')], ())
        )
        with pytest.raises(ValueError):
            Requirement.parse(">=2.3")
        with pytest.raises(ValueError):
            Requirement.parse("x\\")
        with pytest.raises(ValueError):
            Requirement.parse("x==2 q")
        with pytest.raises(ValueError):
            Requirement.parse("X==1\nY==2")
        with pytest.raises(ValueError):
            Requirement.parse("#")

    def testVersionEquality(self):
        def c(s1,s2):
            p1, p2 = parse_version(s1),parse_version(s2)
            assert p1 == p2, (s1,s2,p1,p2)

        c('1.2-rc1', '1.2rc1')
        c('0.4', '0.4.0')
        c('0.4.0.0', '0.4.0')
        c('0.4.0-0', '0.4-0')
        c('0post1', '0.0post1')
        c('0pre1', '0.0c1')
        c('0.0.0preview1', '0c1')
        c('0.0c1', '0-rc1')
        c('1.2a1', '1.2.a.1')
        c('1.2.a', '1.2a')

    def testVersionOrdering(self):
        def c(s1,s2):
            p1, p2 = parse_version(s1),parse_version(s2)
            assert p1<p2, (s1,s2,p1,p2)

        c('2.1','2.1.1')
        c('2a1','2b0')
        c('2a1','2.1')
        c('2.3a1', '2.3')
        c('2.1-1', '2.1-2')
        c('2.1-1', '2.1.1')
        c('2.1', '2.1post4')
        c('2.1a0-20040501', '2.1')
        c('1.1', '02.1')
        c('3.2', '3.2.post0')
        c('3.2post1', '3.2post2')
        c('0.4', '4.0')
        c('0.0.4', '0.4.0')
        c('0post1', '0.4post1')
        c('2.1.0-rc1','2.1.0')
        c('2.1dev','2.1a0')

        torture ="""
        0.80.1-3 0.80.1-2 0.80.1-1 0.79.9999+0.80.0pre4-1
        0.79.9999+0.80.0pre2-3 0.79.9999+0.80.0pre2-2
        0.77.2-1 0.77.1-1 0.77.0-1
        """.split()

        for p,v1 in enumerate(torture):
            for v2 in torture[p+1:]:
                c(v2,v1)

    def testVersionBuildout(self):
        """
        Buildout has a function in it's bootstrap.py that inspected the return
        value of parse_version. The new parse_version returns a Version class
        which needs to support this behavior, at least for now.
        """
        def buildout(parsed_version):
            _final_parts = '*final-', '*final'

            def _final_version(parsed_version):
                for part in parsed_version:
                    if (part[:1] == '*') and (part not in _final_parts):
                        return False
                return True
            return _final_version(parsed_version)

        assert buildout(parse_version("1.0"))
        assert not buildout(parse_version("1.0a1"))

    def testVersionIndexable(self):
        """
        Some projects were doing things like parse_version("v")[0], so we'll
        support indexing the same as we support iterating.
        """
        assert parse_version("1.0")[0] == "00000001"

    def testVersionTupleSort(self):
        """
        Some projects expected to be able to sort tuples against the return
        value of parse_version. So again we'll add a warning enabled shim to
        make this possible.
        """
        assert parse_version("1.0") < tuple(parse_version("2.0"))
        assert parse_version("1.0") <= tuple(parse_version("2.0"))
        assert parse_version("1.0") == tuple(parse_version("1.0"))
        assert parse_version("3.0") > tuple(parse_version("2.0"))
        assert parse_version("3.0") >= tuple(parse_version("2.0"))
        assert parse_version("3.0") != tuple(parse_version("2.0"))
        assert not (parse_version("3.0") != tuple(parse_version("3.0")))

    def testVersionHashable(self):
        """
        Ensure that our versions stay hashable even though we've subclassed
        them and added some shim code to them.
        """
        assert (
            hash(parse_version("1.0"))
            ==
            hash(parse_version("1.0"))
        )


class TestScriptHeader:
    non_ascii_exe = '/Users/José/bin/python'
    exe_with_spaces = r'C:\Program Files\Python33\python.exe'

    def test_get_script_header(self):
        if not sys.platform.startswith('java') or not is_sh(sys.executable):
            # This test is for non-Jython platforms
            expected = '#!%s\n' % nt_quote_arg(os.path.normpath(sys.executable))
            assert get_script_header('#!/usr/local/bin/python') == expected
            expected = '#!%s  -x\n' % nt_quote_arg(os.path.normpath(sys.executable))
            assert get_script_header('#!/usr/bin/python -x') == expected
            candidate = get_script_header('#!/usr/bin/python',
                executable=self.non_ascii_exe)
            assert candidate == '#!%s -x\n' % self.non_ascii_exe
            candidate = get_script_header('#!/usr/bin/python',
                executable=self.exe_with_spaces)
            assert candidate == '#!"%s"\n' % self.exe_with_spaces

    def test_get_script_header_jython_workaround(self):
        # This test doesn't work with Python 3 in some locales
        if PY3 and os.environ.get("LC_CTYPE") in (None, "C", "POSIX"):
            return

        class java:
            class lang:
                class System:
                    @staticmethod
                    def getProperty(property):
                        return ""
        sys.modules["java"] = java

        platform = sys.platform
        sys.platform = 'java1.5.0_13'
        stdout, stderr = sys.stdout, sys.stderr
        try:
            # A mock sys.executable that uses a shebang line (this file)
            exe = os.path.normpath(os.path.splitext(__file__)[0] + '.py')
            assert (
                get_script_header('#!/usr/local/bin/python', executable=exe)
                ==
                '#!/usr/bin/env %s\n' % exe
            )

            # Ensure we generate what is basically a broken shebang line
            # when there's options, with a warning emitted
            sys.stdout = sys.stderr = StringIO()
            candidate = get_script_header('#!/usr/bin/python -x',
                executable=exe)
            assert candidate == '#!%s  -x\n' % exe
            assert 'Unable to adapt shebang line' in sys.stdout.getvalue()
            sys.stdout = sys.stderr = StringIO()
            candidate = get_script_header('#!/usr/bin/python',
                executable=self.non_ascii_exe)
            assert candidate == '#!%s -x\n' % self.non_ascii_exe
            assert 'Unable to adapt shebang line' in sys.stdout.getvalue()
        finally:
            del sys.modules["java"]
            sys.platform = platform
            sys.stdout, sys.stderr = stdout, stderr


class TestNamespaces:

    def setup_method(self, method):
        self._ns_pkgs = pkg_resources._namespace_packages.copy()
        self._tmpdir = tempfile.mkdtemp(prefix="tests-setuptools-")
        os.makedirs(os.path.join(self._tmpdir, "site-pkgs"))
        self._prev_sys_path = sys.path[:]
        sys.path.append(os.path.join(self._tmpdir, "site-pkgs"))

    def teardown_method(self, method):
        shutil.rmtree(self._tmpdir)
        pkg_resources._namespace_packages = self._ns_pkgs.copy()
        sys.path = self._prev_sys_path[:]

    @pytest.mark.skipif(os.path.islink(tempfile.gettempdir()),
        reason="Test fails when /tmp is a symlink. See #231")
    def test_two_levels_deep(self):
        """
        Test nested namespace packages
        Create namespace packages in the following tree :
            site-packages-1/pkg1/pkg2
            site-packages-2/pkg1/pkg2
        Check both are in the _namespace_packages dict and that their __path__
        is correct
        """
        sys.path.append(os.path.join(self._tmpdir, "site-pkgs2"))
        os.makedirs(os.path.join(self._tmpdir, "site-pkgs", "pkg1", "pkg2"))
        os.makedirs(os.path.join(self._tmpdir, "site-pkgs2", "pkg1", "pkg2"))
        ns_str = "__import__('pkg_resources').declare_namespace(__name__)\n"
        for site in ["site-pkgs", "site-pkgs2"]:
            pkg1_init = open(os.path.join(self._tmpdir, site,
                             "pkg1", "__init__.py"), "w")
            pkg1_init.write(ns_str)
            pkg1_init.close()
            pkg2_init = open(os.path.join(self._tmpdir, site,
                             "pkg1", "pkg2", "__init__.py"), "w")
            pkg2_init.write(ns_str)
            pkg2_init.close()
        import pkg1
        assert "pkg1" in pkg_resources._namespace_packages
        try:
            import pkg1.pkg2
        except ImportError:
            self.fail("Setuptools tried to import the parent namespace package")
        # check the _namespace_packages dict
        assert "pkg1.pkg2" in pkg_resources._namespace_packages
        assert pkg_resources._namespace_packages["pkg1"] == ["pkg1.pkg2"]
        # check the __path__ attribute contains both paths
        expected = [
            os.path.join(self._tmpdir, "site-pkgs", "pkg1", "pkg2"),
            os.path.join(self._tmpdir, "site-pkgs2", "pkg1", "pkg2"),
        ]
        assert pkg1.pkg2.__path__ == expected
