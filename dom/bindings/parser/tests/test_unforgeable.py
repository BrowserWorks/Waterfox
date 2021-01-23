def WebIDLTest(parser, harness):
    parser.parse("""
            interface Child : Parent {
            };
            interface Parent {
              [Unforgeable] readonly attribute long foo;
            };
        """)

    results = parser.finish()
    harness.check(len(results), 2,
                  "Should be able to inherit from an interface with "
                  "[Unforgeable] properties.")

    parser = parser.reset();
    parser.parse("""
            interface Child : Parent {
              const short foo = 10;
            };
            interface Parent {
              [Unforgeable] readonly attribute long foo;
            };
        """)

    results = parser.finish()
    harness.check(len(results), 2,
                  "Should be able to inherit from an interface with "
                  "[Unforgeable] properties even if we have a constant with "
                  "the same name.")

    parser = parser.reset();
    parser.parse("""
            interface Child : Parent {
              static attribute short foo;
            };
            interface Parent {
              [Unforgeable] readonly attribute long foo;
            };
        """)

    results = parser.finish()
    harness.check(len(results), 2,
                  "Should be able to inherit from an interface with "
                  "[Unforgeable] properties even if we have a static attribute "
                  "with the same name.")

    parser = parser.reset();
    parser.parse("""
            interface Child : Parent {
              static void foo();
            };
            interface Parent {
              [Unforgeable] readonly attribute long foo;
            };
        """)

    results = parser.finish()
    harness.check(len(results), 2,
                  "Should be able to inherit from an interface with "
                  "[Unforgeable] properties even if we have a static operation "
                  "with the same name.")

    parser = parser.reset();
    threw = False
    try:
        parser.parse("""
            interface Child : Parent {
              void foo();
            };
            interface Parent {
              [Unforgeable] readonly attribute long foo;
            };
        """)

        results = parser.finish()
    except:
        threw = True
    harness.ok(threw,
               "Should have thrown when shadowing unforgeable attribute on "
               "parent with operation.")

    parser = parser.reset();
    threw = False
    try:
        parser.parse("""
            interface Child : Parent {
              void foo();
            };
            interface Parent {
              [Unforgeable] void foo();
            };
        """)

        results = parser.finish()
    except:
        threw = True
    harness.ok(threw,
               "Should have thrown when shadowing unforgeable operation on "
               "parent with operation.")

    parser = parser.reset();
    threw = False
    try:
        parser.parse("""
            interface Child : Parent {
              attribute short foo;
            };
            interface Parent {
              [Unforgeable] readonly attribute long foo;
            };
        """)

        results = parser.finish()
    except Exception as x:
        threw = True
    harness.ok(threw,
               "Should have thrown when shadowing unforgeable attribute on "
               "parent with attribute.")

    parser = parser.reset();
    threw = False
    try:
        parser.parse("""
            interface Child : Parent {
              attribute short foo;
            };
            interface Parent {
              [Unforgeable] void foo();
            };
        """)

        results = parser.finish()
    except Exception as x:
        threw = True
    harness.ok(threw,
               "Should have thrown when shadowing unforgeable operation on "
               "parent with attribute.")

    parser = parser.reset();
    parser.parse("""
            interface Child : Parent {
            };
            interface Parent {};
            interface mixin Mixin {
              [Unforgeable] readonly attribute long foo;
            };
            Parent includes Mixin;
        """)

    results = parser.finish()
    harness.check(len(results), 4,
                  "Should be able to inherit from an interface with a "
                  "mixin with [Unforgeable] properties.")

    parser = parser.reset();
    threw = False
    try:
        parser.parse("""
            interface Child : Parent {
              void foo();
            };
            interface Parent {};
            interface mixin Mixin {
              [Unforgeable] readonly attribute long foo;
            };
            Parent includes Mixin;
        """)

        results = parser.finish()
    except:
        threw = True

    harness.ok(threw,
               "Should have thrown when shadowing unforgeable attribute "
               "of parent's consequential interface.")

    parser = parser.reset();
    threw = False
    try:
        parser.parse("""
            interface Child : Parent {
            };
            interface Parent : GrandParent {};
            interface GrandParent {};
            interface mixin Mixin {
              [Unforgeable] readonly attribute long foo;
            };
            GrandParent includes Mixin;
            interface mixin ChildMixin {
              void foo();
            };
            Child includes ChildMixin;
        """)

        results = parser.finish()
    except:
        threw = True

    harness.ok(threw,
               "Should have thrown when our consequential interface shadows unforgeable attribute "
               "of ancestor's consequential interface.")

    parser = parser.reset();
    threw = False
    try:
        parser.parse("""
            interface Child : Parent {
            };
            interface Parent : GrandParent {};
            interface GrandParent {};
            interface mixin Mixin {
              [Unforgeable] void foo();
            };
            GrandParent includes Mixin;
            interface mixin ChildMixin {
              void foo();
            };
            Child includes ChildMixin;
        """)

        results = parser.finish()
    except:
        threw = True

    harness.ok(threw,
               "Should have thrown when our consequential interface shadows unforgeable operation "
               "of ancestor's consequential interface.")

    parser = parser.reset();
    parser.parse("""
        interface iface {
          [Unforgeable] attribute long foo;
        };
    """)

    results = parser.finish()
    harness.check(len(results), 1,
                  "Should allow writable [Unforgeable] attribute.")

    parser = parser.reset();
    threw = False
    try:
        parser.parse("""
            interface iface {
              [Unforgeable] static readonly attribute long foo;
            };
        """)

        results = parser.finish()
    except:
        threw = True

    harness.ok(threw, "Should have thrown for static [Unforgeable] attribute.")
