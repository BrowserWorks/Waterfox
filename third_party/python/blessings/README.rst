=========
Blessings
=========

Coding with Blessings looks like this... ::

    from blessings import Terminal

    t = Terminal()

    print t.bold('Hi there!')
    print t.bold_red_on_bright_green('It hurts my eyes!')

    with t.location(0, t.height - 1):
        print 'This is at the bottom.'

Or, for byte-level control, you can drop down and play with raw terminal
capabilities::

    print '{t.bold}All your {t.red}bold and red base{t.normal}'.format(t=t)
    print t.wingo(2)

The Pitch
=========

Blessings lifts several of curses_' limiting assumptions, and it makes your
code pretty, too:

* Use styles, color, and maybe a little positioning without clearing the whole
  screen first.
* Leave more than one screenful of scrollback in the buffer after your program
  exits, like a well-behaved command-line app should.
* Get rid of all those noisy, C-like calls to ``tigetstr`` and ``tparm``, so
  your code doesn't get crowded out by terminal bookkeeping.
* Act intelligently when somebody redirects your output to a file, omitting the
  terminal control codes the user doesn't want to see (optional).

.. _curses: http://docs.python.org/library/curses.html

Before And After
----------------

Without Blessings, this is how you'd print some underlined text at the bottom
of the screen::

    from curses import tigetstr, setupterm, tparm
    from fcntl import ioctl
    from os import isatty
    import struct
    import sys
    from termios import TIOCGWINSZ

    # If we want to tolerate having our output piped to other commands or
    # files without crashing, we need to do all this branching:
    if hasattr(sys.stdout, 'fileno') and isatty(sys.stdout.fileno()):
        setupterm()
        sc = tigetstr('sc')
        cup = tigetstr('cup')
        rc = tigetstr('rc')
        underline = tigetstr('smul')
        normal = tigetstr('sgr0')
    else:
        sc = cup = rc = underline = normal = ''
    print sc  # Save cursor position.
    if cup:
        # tigetnum('lines') doesn't always update promptly, hence this:
        height = struct.unpack('hhhh', ioctl(0, TIOCGWINSZ, '\000' * 8))[0]
        print tparm(cup, height - 1, 0)  # Move cursor to bottom.
    print 'This is {under}underlined{normal}!'.format(under=underline,
                                                      normal=normal)
    print rc  # Restore cursor position.

Phew! That was long and full of incomprehensible trash! Let's try it again,
this time with Blessings::

    from blessings import Terminal

    term = Terminal()
    with term.location(0, term.height - 1):
        print 'This is', term.underline('pretty!')

Much better.

What It Provides
================

Blessings provides just one top-level object: ``Terminal``. Instantiating a
``Terminal`` figures out whether you're on a terminal at all and, if so, does
any necessary terminal setup. After that, you can proceed to ask it all sorts
of things about the terminal. Terminal terminal terminal.

Simple Formatting
-----------------

Lots of handy formatting codes ("capabilities" in low-level parlance) are
available as attributes on a ``Terminal``. For example::

    from blessings import Terminal

    term = Terminal()
    print 'I am ' + term.bold + 'bold' + term.normal + '!'

You can also use them as wrappers so you don't have to say ``normal``
afterward::

    print 'I am', term.bold('bold') + '!'

Or, if you want fine-grained control while maintaining some semblance of
brevity, you can combine it with Python's string formatting, which makes
attributes easy to access::

    print 'All your {t.red}base {t.underline}are belong to us{t.normal}'.format(t=term)

Simple capabilities of interest include...

* ``bold``
* ``reverse``
* ``underline``
* ``no_underline`` (which turns off underlining)
* ``blink``
* ``normal`` (which turns off everything, even colors)
* ``clear_eol`` (clear to the end of the line)
* ``clear_bol`` (clear to beginning of line)
* ``clear_eos`` (clear to end of screen)

Here are a few more which are less likely to work on all terminals:

* ``dim``
* ``italic`` and ``no_italic``
* ``shadow`` and ``no_shadow``
* ``standout`` and ``no_standout``
* ``subscript`` and ``no_subscript``
* ``superscript`` and ``no_superscript``
* ``flash`` (which flashes the screen once)

Note that, while the inverse of ``underline`` is ``no_underline``, the only way
to turn off ``bold`` or ``reverse`` is ``normal``, which also cancels any
custom colors. This is because there's no way to tell the terminal to undo
certain pieces of formatting, even at the lowest level.

You might notice that the above aren't the typical incomprehensible terminfo
capability names; we alias a few of the harder-to-remember ones for
readability. However, you aren't limited to these: you can reference any
string-returning capability listed on the `terminfo man page`_ by the name
under the "Cap-name" column: for example, ``term.rum``.

.. _`terminfo man page`: http://www.manpagez.com/man/5/terminfo/

Color
-----

16 colors, both foreground and background, are available as easy-to-remember
attributes::

    from blessings import Terminal

    term = Terminal()
    print term.red + term.on_green + 'Red on green? Ick!' + term.normal
    print term.bright_red + term.on_bright_blue + 'This is even worse!' + term.normal

You can also call them as wrappers, which sets everything back to normal at the
end::

    print term.red_on_green('Red on green? Ick!')
    print term.yellow('I can barely see it.')

The available colors are...

* ``black``
* ``red``
* ``green``
* ``yellow``
* ``blue``
* ``magenta``
* ``cyan``
* ``white``

You can set the background color instead of the foreground by prepending
``on_``, as in ``on_blue``. There is also a ``bright`` version of each color:
for example, ``on_bright_blue``.

There is also a numerical interface to colors, which takes an integer from
0-15::

    term.color(5) + 'Hello' + term.normal
    term.on_color(3) + 'Hello' + term.normal

    term.color(5)('Hello')
    term.on_color(3)('Hello')

If some color is unsupported (for instance, if only the normal colors are
available, not the bright ones), trying to use it will, on most terminals, have
no effect: the foreground and background colors will stay as they were. You can
get fancy and do different things depending on the supported colors by checking
`number_of_colors`_.

.. _`number_of_colors`: http://packages.python.org/blessings/#blessings.Terminal.number_of_colors

Compound Formatting
-------------------

If you want to do lots of crazy formatting all at once, you can just mash it
all together::

    from blessings import Terminal

    term = Terminal()
    print term.bold_underline_green_on_yellow + 'Woo' + term.normal

Or you can use your newly coined attribute as a wrapper, which implicitly sets
everything back to normal afterward::

    print term.bold_underline_green_on_yellow('Woo')

This compound notation comes in handy if you want to allow users to customize
the formatting of your app: just have them pass in a format specifier like
"bold_green" on the command line, and do a quick ``getattr(term,
that_option)('Your text')`` when you do your formatting.

I'd be remiss if I didn't credit couleur_, where I probably got the idea for
all this mashing.

.. _couleur: http://pypi.python.org/pypi/couleur

Parametrized Capabilities
-------------------------

Some capabilities take parameters. Rather than making you dig up ``tparm()``
all the time, we simply make such capabilities into callable strings. You can
pass the parameters right in::

    from blessings import Terminal

    term = Terminal()
    print term.move(10, 1)

Here are some of interest:

``move``
  Position the cursor elsewhere. Parameters are y coordinate, then x
  coordinate.
``move_x``
  Move the cursor to the given column.
``move_y``
  Move the cursor to the given row.

You can also reference any other string-returning capability listed on the
`terminfo man page`_ by its name under the "Cap-name" column.

.. _`terminfo man page`: http://www.manpagez.com/man/5/terminfo/

Height and Width
----------------

It's simple to get the height and width of the terminal, in characters::

    from blessings import Terminal

    term = Terminal()
    height = term.height
    width = term.width

These are newly updated each time you ask for them, so they're safe to use from
SIGWINCH handlers.

Temporary Repositioning
-----------------------

Sometimes you need to flit to a certain location, print something, and then
return: for example, when updating a progress bar at the bottom of the screen.
``Terminal`` provides a context manager for doing this concisely::

    from blessings import Terminal

    term = Terminal()
    with term.location(0, term.height - 1):
        print 'Here is the bottom.'
    print 'This is back where I came from.'

Parameters to ``location()`` are ``x`` and then ``y``, but you can also pass
just one of them, leaving the other alone. For example... ::

    with term.location(y=10):
        print 'We changed just the row.'

If you want to reposition permanently, see ``move``, in an example above.

Pipe Savvy
----------

If your program isn't attached to a terminal, like if it's being piped to
another command or redirected to a file, all the capability attributes on
``Terminal`` will return empty strings. You'll get a nice-looking file without
any formatting codes gumming up the works.

If you want to override this--like if you anticipate your program being piped
through ``less -r``, which handles terminal escapes just fine--pass
``force_styling=True`` to the ``Terminal`` constructor.

In any case, there is an ``is_a_tty`` attribute on ``Terminal`` that lets you
see whether the attached stream seems to be a terminal. If it's false, you
might refrain from drawing progress bars and other frippery, since you're
apparently headed into a pipe::

    from blessings import Terminal

    term = Terminal()
    if term.is_a_tty:
        with term.location(0, term.height - 1):
            print 'Progress: [=======>   ]'
    print term.bold('Important stuff')

Shopping List
=============

There are decades of legacy tied up in terminal interaction, so attention to
detail and behavior in edge cases make a difference. Here are some ways
Blessings has your back:

* Uses the terminfo database so it works with any terminal type
* Provides up-to-the-moment terminal height and width, so you can respond to
  terminal size changes (SIGWINCH signals). (Most other libraries query the
  ``COLUMNS`` and ``LINES`` environment variables or the ``cols`` or ``lines``
  terminal capabilities, which don't update promptly, if at all.)
* Avoids making a mess if the output gets piped to a non-terminal
* Works great with standard Python string templating
* Provides convenient access to all terminal capabilities, not just a sugared
  few
* Outputs to any file-like object, not just stdout
* Keeps a minimum of internal state, so you can feel free to mix and match with
  calls to curses or whatever other terminal libraries you like

Blessings does not provide...

* Native color support on the Windows command prompt. However, it should work
  when used in concert with colorama_.

.. _colorama: http://pypi.python.org/pypi/colorama/0.2.4

Bugs
====

Bugs or suggestions? Visit the `issue tracker`_.

.. _`issue tracker`: https://github.com/erikrose/blessings/issues/new

License
=======

Blessings is under the MIT License. See the LICENSE file.

Version History
===============

1.3
  * Add ``number_of_colors``, which tells you how many colors the terminal
    supports.
  * Made ``color(n)`` and ``on_color(n)`` callable to wrap a string, like the
    named colors can. Also, make them both fall back to the ``setf`` and
    ``setb`` capabilities (like the named colors do) if the ANSI ``setaf`` and
    ``setab`` aren't available.
  * Allow ``color`` attr to act as an unparametrized string, not just a
    callable.
  * Make ``height`` and ``width`` examine any passed-in stream before falling
    back to stdout. (This rarely if ever affects actual behavior; it's mostly
    philosophical.)
  * Make caching simpler and slightly more efficient.
  * Get rid of a reference cycle between Terminals and FormattingStrings.
  * Update docs to reflect that terminal addressing (as in ``location()``) is
    0-based.

1.2
  * Added support for Python 3! We need 3.2.3 or greater, because the curses
    library couldn't decide whether to accept strs or bytes before that
    (http://bugs.python.org/issue10570).
  * Everything that comes out of the library is now unicode. This lets us
    support Python 3 without making a mess of the code, and Python 2 should
    continue to work unless you were testing types (and badly). Please file a
    bug if this causes trouble for you.
  * Changed to the MIT License for better world domination.
  * Added Sphinx docs.

1.1
  * Added nicely named attributes for colors.
  * Introduced compound formatting.
  * Added wrapper behavior for styling and colors.
  * Let you force capabilities to be non-empty, even if the output stream is
    not a terminal.
  * Added the ``is_a_tty`` attribute for telling whether the output stream is a
    terminal.
  * Sugared the remaining interesting string capabilities.
  * Let ``location()`` operate on just an x *or* y coordinate.

1.0
  * Extracted Blessings from nose-progressive, my `progress-bar-having,
    traceback-shortcutting, rootin', tootin' testrunner`_. It provided the
    tootin' functionality.

.. _`progress-bar-having, traceback-shortcutting, rootin', tootin' testrunner`: http://pypi.python.org/pypi/nose-progressive/
