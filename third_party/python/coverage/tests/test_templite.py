# coding: utf-8
# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests for coverage.templite."""

import re

from coverage.templite import Templite, TempliteSyntaxError, TempliteValueError

from tests.coveragetest import CoverageTest

# pylint: disable=possibly-unused-variable

class AnyOldObject(object):
    """Simple testing object.

    Use keyword arguments in the constructor to set attributes on the object.

    """
    def __init__(self, **attrs):
        for n, v in attrs.items():
            setattr(self, n, v)


class TempliteTest(CoverageTest):
    """Tests for Templite."""

    run_in_temp_dir = False

    def try_render(self, text, ctx=None, result=None):
        """Render `text` through `ctx`, and it had better be `result`.

        Result defaults to None so we can shorten the calls where we expect
        an exception and never get to the result comparison.

        """
        actual = Templite(text).render(ctx or {})
        # If result is None, then an exception should have prevented us getting
        # to here.
        assert result is not None
        self.assertEqual(actual, result)

    def assertSynErr(self, msg):
        """Assert that a `TempliteSyntaxError` will happen.

        A context manager, and the message should be `msg`.

        """
        pat = "^" + re.escape(msg) + "$"
        return self.assertRaisesRegex(TempliteSyntaxError, pat)

    def test_passthrough(self):
        # Strings without variables are passed through unchanged.
        self.assertEqual(Templite("Hello").render(), "Hello")
        self.assertEqual(
            Templite("Hello, 20% fun time!").render(),
            "Hello, 20% fun time!"
            )

    def test_variables(self):
        # Variables use {{var}} syntax.
        self.try_render("Hello, {{name}}!", {'name':'Ned'}, "Hello, Ned!")

    def test_undefined_variables(self):
        # Using undefined names is an error.
        with self.assertRaisesRegex(Exception, "'name'"):
            self.try_render("Hi, {{name}}!")

    def test_pipes(self):
        # Variables can be filtered with pipes.
        data = {
            'name': 'Ned',
            'upper': lambda x: x.upper(),
            'second': lambda x: x[1],
            }
        self.try_render("Hello, {{name|upper}}!", data, "Hello, NED!")

        # Pipes can be concatenated.
        self.try_render("Hello, {{name|upper|second}}!", data, "Hello, E!")

    def test_reusability(self):
        # A single Templite can be used more than once with different data.
        globs = {
            'upper': lambda x: x.upper(),
            'punct': '!',
            }

        template = Templite("This is {{name|upper}}{{punct}}", globs)
        self.assertEqual(template.render({'name':'Ned'}), "This is NED!")
        self.assertEqual(template.render({'name':'Ben'}), "This is BEN!")

    def test_attribute(self):
        # Variables' attributes can be accessed with dots.
        obj = AnyOldObject(a="Ay")
        self.try_render("{{obj.a}}", locals(), "Ay")

        obj2 = AnyOldObject(obj=obj, b="Bee")
        self.try_render("{{obj2.obj.a}} {{obj2.b}}", locals(), "Ay Bee")

    def test_member_function(self):
        # Variables' member functions can be used, as long as they are nullary.
        class WithMemberFns(AnyOldObject):
            """A class to try out member function access."""
            def ditto(self):
                """Return twice the .txt attribute."""
                return self.txt + self.txt
        obj = WithMemberFns(txt="Once")
        self.try_render("{{obj.ditto}}", locals(), "OnceOnce")

    def test_item_access(self):
        # Variables' items can be used.
        d = {'a':17, 'b':23}
        self.try_render("{{d.a}} < {{d.b}}", locals(), "17 < 23")

    def test_loops(self):
        # Loops work like in Django.
        nums = [1,2,3,4]
        self.try_render(
            "Look: {% for n in nums %}{{n}}, {% endfor %}done.",
            locals(),
            "Look: 1, 2, 3, 4, done."
            )
        # Loop iterables can be filtered.
        def rev(l):
            """Return the reverse of `l`."""
            l = l[:]
            l.reverse()
            return l

        self.try_render(
            "Look: {% for n in nums|rev %}{{n}}, {% endfor %}done.",
            locals(),
            "Look: 4, 3, 2, 1, done."
            )

    def test_empty_loops(self):
        self.try_render(
            "Empty: {% for n in nums %}{{n}}, {% endfor %}done.",
            {'nums':[]},
            "Empty: done."
            )

    def test_multiline_loops(self):
        self.try_render(
            "Look: \n{% for n in nums %}\n{{n}}, \n{% endfor %}done.",
            {'nums':[1,2,3]},
            "Look: \n\n1, \n\n2, \n\n3, \ndone."
            )

    def test_multiple_loops(self):
        self.try_render(
            "{% for n in nums %}{{n}}{% endfor %} and "
                                    "{% for n in nums %}{{n}}{% endfor %}",
            {'nums': [1,2,3]},
            "123 and 123"
            )

    def test_comments(self):
        # Single-line comments work:
        self.try_render(
            "Hello, {# Name goes here: #}{{name}}!",
            {'name':'Ned'}, "Hello, Ned!"
            )
        # and so do multi-line comments:
        self.try_render(
            "Hello, {# Name\ngoes\nhere: #}{{name}}!",
            {'name':'Ned'}, "Hello, Ned!"
            )

    def test_if(self):
        self.try_render(
            "Hi, {% if ned %}NED{% endif %}{% if ben %}BEN{% endif %}!",
            {'ned': 1, 'ben': 0},
            "Hi, NED!"
            )
        self.try_render(
            "Hi, {% if ned %}NED{% endif %}{% if ben %}BEN{% endif %}!",
            {'ned': 0, 'ben': 1},
            "Hi, BEN!"
            )
        self.try_render(
            "Hi, {% if ned %}NED{% if ben %}BEN{% endif %}{% endif %}!",
            {'ned': 0, 'ben': 0},
            "Hi, !"
            )
        self.try_render(
            "Hi, {% if ned %}NED{% if ben %}BEN{% endif %}{% endif %}!",
            {'ned': 1, 'ben': 0},
            "Hi, NED!"
            )
        self.try_render(
            "Hi, {% if ned %}NED{% if ben %}BEN{% endif %}{% endif %}!",
            {'ned': 1, 'ben': 1},
            "Hi, NEDBEN!"
            )

    def test_complex_if(self):
        class Complex(AnyOldObject):
            """A class to try out complex data access."""
            def getit(self):
                """Return it."""
                return self.it
        obj = Complex(it={'x':"Hello", 'y': 0})
        self.try_render(
            "@"
            "{% if obj.getit.x %}X{% endif %}"
            "{% if obj.getit.y %}Y{% endif %}"
            "{% if obj.getit.y|str %}S{% endif %}"
            "!",
            { 'obj': obj, 'str': str },
            "@XS!"
            )

    def test_loop_if(self):
        self.try_render(
            "@{% for n in nums %}{% if n %}Z{% endif %}{{n}}{% endfor %}!",
            {'nums': [0,1,2]},
            "@0Z1Z2!"
            )
        self.try_render(
            "X{%if nums%}@{% for n in nums %}{{n}}{% endfor %}{%endif%}!",
            {'nums': [0,1,2]},
            "X@012!"
            )
        self.try_render(
            "X{%if nums%}@{% for n in nums %}{{n}}{% endfor %}{%endif%}!",
            {'nums': []},
            "X!"
            )

    def test_nested_loops(self):
        self.try_render(
            "@"
            "{% for n in nums %}"
                "{% for a in abc %}{{a}}{{n}}{% endfor %}"
            "{% endfor %}"
            "!",
            {'nums': [0,1,2], 'abc': ['a', 'b', 'c']},
            "@a0b0c0a1b1c1a2b2c2!"
            )

    def test_whitespace_handling(self):
        self.try_render(
            "@{% for n in nums %}\n"
            " {% for a in abc %}{{a}}{{n}}{% endfor %}\n"
            "{% endfor %}!\n",
            {'nums': [0, 1, 2], 'abc': ['a', 'b', 'c']},
            "@\n a0b0c0\n\n a1b1c1\n\n a2b2c2\n!\n"
            )
        self.try_render(
            "@{% for n in nums -%}\n"
            " {% for a in abc -%}\n"
            "  {# this disappears completely -#}\n"
            "  {{a-}}\n"
            "  {{n -}}\n"
            "  {{n    -}}\n"
            " {% endfor %}\n"
            "{% endfor %}!\n",
            {'nums': [0, 1, 2], 'abc': ['a', 'b', 'c']},
            "@a00b00c00\na11b11c11\na22b22c22\n!\n"
            )
        self.try_render(
            "@{% for n in nums -%}\n"
            "  {{n -}}\n"
            "  x\n"
            "{% endfor %}!\n",
            {'nums': [0, 1, 2]},
            "@0x\n1x\n2x\n!\n"
            )
        self.try_render("  hello  ", {}, "  hello  ")

    def test_eat_whitespace(self):
        self.try_render(
            "Hey!\n"
            "{% joined %}\n"
            "@{% for n in nums %}\n"
            " {% for a in abc %}\n"
            "  {# this disappears completely #}\n"
            "  X\n"
            "  Y\n"
            "  {{a}}\n"
            "  {{n }}\n"
            " {% endfor %}\n"
            "{% endfor %}!\n"
            "{% endjoined %}\n",
            {'nums': [0, 1, 2], 'abc': ['a', 'b', 'c']},
            "Hey!\n@XYa0XYb0XYc0XYa1XYb1XYc1XYa2XYb2XYc2!\n"
            )

    def test_non_ascii(self):
        self.try_render(
            u"{{where}} ollǝɥ",
            { 'where': u'ǝɹǝɥʇ' },
            u"ǝɹǝɥʇ ollǝɥ"
        )

    def test_exception_during_evaluation(self):
        # TypeError: Couldn't evaluate {{ foo.bar.baz }}:
        regex = "^Couldn't evaluate None.bar$"
        with self.assertRaisesRegex(TempliteValueError, regex):
            self.try_render(
                "Hey {{foo.bar.baz}} there", {'foo': None}, "Hey ??? there"
            )

    def test_bad_names(self):
        with self.assertSynErr("Not a valid name: 'var%&!@'"):
            self.try_render("Wat: {{ var%&!@ }}")
        with self.assertSynErr("Not a valid name: 'filter%&!@'"):
            self.try_render("Wat: {{ foo|filter%&!@ }}")
        with self.assertSynErr("Not a valid name: '@'"):
            self.try_render("Wat: {% for @ in x %}{% endfor %}")

    def test_bogus_tag_syntax(self):
        with self.assertSynErr("Don't understand tag: 'bogus'"):
            self.try_render("Huh: {% bogus %}!!{% endbogus %}??")

    def test_malformed_if(self):
        with self.assertSynErr("Don't understand if: '{% if %}'"):
            self.try_render("Buh? {% if %}hi!{% endif %}")
        with self.assertSynErr("Don't understand if: '{% if this or that %}'"):
            self.try_render("Buh? {% if this or that %}hi!{% endif %}")

    def test_malformed_for(self):
        with self.assertSynErr("Don't understand for: '{% for %}'"):
            self.try_render("Weird: {% for %}loop{% endfor %}")
        with self.assertSynErr("Don't understand for: '{% for x from y %}'"):
            self.try_render("Weird: {% for x from y %}loop{% endfor %}")
        with self.assertSynErr("Don't understand for: '{% for x, y in z %}'"):
            self.try_render("Weird: {% for x, y in z %}loop{% endfor %}")

    def test_bad_nesting(self):
        with self.assertSynErr("Unmatched action tag: 'if'"):
            self.try_render("{% if x %}X")
        with self.assertSynErr("Mismatched end tag: 'for'"):
            self.try_render("{% if x %}X{% endfor %}")
        with self.assertSynErr("Too many ends: '{% endif %}'"):
            self.try_render("{% if x %}{% endif %}{% endif %}")

    def test_malformed_end(self):
        with self.assertSynErr("Don't understand end: '{% end if %}'"):
            self.try_render("{% if x %}X{% end if %}")
        with self.assertSynErr("Don't understand end: '{% endif now %}'"):
            self.try_render("{% if x %}X{% endif now %}")
