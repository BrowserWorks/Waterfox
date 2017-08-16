Adding a New Linter to the Tree
===============================

A linter is a yaml file with a ``.yml`` extension. Depending on how the type of linter, there may
be python code alongside the definition, pointed to by the 'payload' attribute.

Here's a trivial example:

no-eval.yml

.. code-block::

    EvalLinter:
        description: Ensures the string eval doesn't show up.
        include:
            - "**/*.js"
        type: string
        payload: eval

Now ``no-eval.yml`` gets passed into :func:`LintRoller.read`.


Linter Types
------------

There are four types of linters, though more may be added in the future.

1. string - fails if substring is found
2. regex - fails if regex matches
3. external - fails if a python function returns a non-empty result list
4. structured_log - fails if a mozlog logger emits any lint_error or lint_warning log messages

As seen from the example above, string and regex linters are very easy to create, but they
should be avoided if possible. It is much better to use a context aware linter for the language you
are trying to lint. For example, use eslint to lint JavaScript files, use flake8 to lint python
files, etc.

Which brings us to the third and most interesting type of linter,
external.  External linters call an arbitrary python function which is
responsible for not only running the linter, but ensuring the results
are structured properly. For example, an external type could shell out
to a 3rd party linter, collect the output and format it into a list of
:class:`ResultContainer` objects. The signature for this python
function is ``lint(files, config, **kwargs)``, where ``files`` is a list of
files to lint and ``config`` is the linter definition defined in the ``.yml``
file.

Structured log linters are much like external linters, but suitable
for cases where the linter code is using mozlog and emits
``lint_error`` or ``lint_warning`` logging messages when the lint
fails. This is recommended for writing novel gecko-specific lints. In
this case the signature for lint functions is ``lint(files, config, logger,
**kwargs)``.


Linter Definition
-----------------

Each ``.yml`` file must have at least one linter defined in it. Here are the supported keys:

* description - A brief description of the linter's purpose (required)
* type - One of 'string', 'regex' or 'external' (required)
* payload - The actual linting logic, depends on the type (required)
* include - A list of glob patterns that must be matched (optional)
* exclude - A list of glob patterns that must not be matched (optional)
* extensions - A list of file extensions to be considered (optional)
* setup - A function that sets up external dependencies (optional)

In addition to the above, some ``.yml`` files correspond to a single lint rule. For these, the
following additional keys may be specified:

* message - A string to print on infraction (optional)
* hint - A string with a clue on how to fix the infraction (optional)
* rule - An id string for the lint rule (optional)
* level - The severity of the infraction, either 'error' or 'warning' (optional)

For structured_log lints the following additional keys apply:

* logger - A StructuredLog object to use for logging. If not supplied
  one will be created (optional)


Example
-------

Here is an example of an external linter that shells out to the python flake8 linter,
let's call the file ``flake8_lint.py``:

.. code-block:: python

    import json
    import os
    import subprocess
    from collections import defaultdict

    from mozlint import result


    FLAKE8_NOT_FOUND = """
    Could not find flake8! Install flake8 and try again.
    """.strip()


    def lint(files, config, **lintargs):
        import which

        binary = os.environ.get('FLAKE8')
        if not binary:
            try:
                binary = which.which('flake8')
            except which.WhichError:
                print(FLAKE8_NOT_FOUND)
                return 1

        # Flake8 allows passing in a custom format string. We use
        # this to help mold the default flake8 format into what
        # mozlint's ResultContainer object expects.
        cmdargs = [
            binary,
            '--format',
            '{"path":"%(path)s","lineno":%(row)s,"column":%(col)s,"rule":"%(code)s","message":"%(text)s"}',
        ] + files

        proc = subprocess.Popen(cmdargs, stdout=subprocess.PIPE, env=os.environ)
        output = proc.communicate()[0]

        # all passed
        if not output:
            return []

        results = []
        for line in output.splitlines():
            # res is a dict of the form specified by --format above
            res = json.loads(line)

            # parse level out of the id string
            if 'code' in res and res['code'].startswith('W'):
                res['level'] = 'warning'

            # result.from_linter is a convenience method that
            # creates a ResultContainer using a LINTER definition
            # to populate some defaults.
            results.append(result.from_config(config, **res))

        return results

Now here is the linter definition that would call it:

.. code-block::

    flake8:
        description: Python linter
        include:
            - '**/*.py'
        type: external
        payload: flake8_lint:lint

Notice the payload has two parts, delimited by ':'. The first is the module path, which
``mozlint`` will attempt to import (e.g, the name of a function to call). The second is
the object path within that module. It is up to consumers of ``mozlint`` to ensure the
module is in ``sys.path``. Structured log linters use the same import mechanism.
