# How actors are organized

To start with, actors are living within /devtools/server/actors/ folder.
They are organized in a hierarchy for easier lifecycle/memory management:
once a parent is removed from the pool, its children are removed as well.
(See actor-registration.md for more information about how to implement one)

The overall hierarchy of actors looks like this:

```
RootActor: First one, automatically instantiated when we start connecting.
   |         Mostly meant to instantiate new actors.
   |
   |--> Global-scoped actors:
   |    Actors exposing features related to the main process,
   |    that are not specific to any particular context (document, tab, app,
   |    add-on, or worker).
   |    A good example is the preference actor.
   |
   \--> "TabActor" (or alike):
          |    Actors meant to designate one context (document, tab, app,
          |    add-on, or worker) and track its lifetime.  Generally, there is
          |    one of these for each thing you can point a toolbox at.
          |
          \--> Tab-scoped actors:
               Actors exposing one particular feature set, this time,
               specific to a given context (document, tab, app, add-on, or
               worker).  Examples include the console and inspector actors.
               These actors may extend this hierarchy by having their
               own children, like LongStringActor, WalkerActor, etc.
```

## RootActor

The root actor is special. It is automatically created when a client connects.
It has a special `actorID` which is unique and is "root".
All other actors have an `actorID` which is computed dynamically,
so that you need to ask an existing actor to create an Actor
and returns its `actorID`. That's the main role of RootActor.

```
RootActor (root.js)
   |
   |-- BrowserTabActor (webbrowser.js)
   |   Targets tabs living in the parent or child process. Note that this is
   |   just a proxy for ContentActor, which is loaded via the tab's message
   |   manager as a frame script in the process containing the tab. This proxy
   |   via message manager is always used, even when e10s is disabled.
   |   Returned by "listTabs" or "getTab" requests.
   |   |
   |   \-> ContentActor (childtab.js)
   |       The "real" actor for a tab, which runs in whichever process holds the
   |       content.  BrowserTabActor communicates with this via the tab's
   |       message manager.
   |       Returned by "connect" on BrowserTabActor.
   |
   |-- WorkerActor (worker.js)
   |   Targets a worker (applies to various kinds like web worker, service
   |   worker, etc.).
   |   Returned by "listWorkers" request to the root actor to get all workers.
   |   Returned by "listWorkers" request to a BrowserTabActor to get workers for
   |   a specific tab.
   |   Returned by "listWorkers" request to a ChildProcessActor to get workers
   |   for the chrome of the child process.
   |
   |-- WindowActor (window.js)
   |   Targets a single window, such as a browser window in Firefox, but it can
   |   be used to reach any window in the parent process.
   |   Returned by "getWindow" request to the root actor.
   |
   |-- ChromeActor (chrome.js)
   |   Targets all resources in the parent process of firefox
   |   (chrome documents, JSM, JS XPCOM, etc.).
   |   Returned by "getProcess" request without any argument.
   |
   |-- ChildProcessActor (child-process.js)
   |   Targets the chrome of the child process (e10s).
   |   Returned by "getProcess" request with a id argument,
   |   matching the targeted process.
   |
   \-- BrowserAddonActor (addon.js)
       Targets the javascript of add-ons.
       Returned by "listAddons" request.
```

## "TabActor"

Those are the actors exposed by the root actors which are meant to track the
lifetime of a given context: tab, app, process, add-on, or worker. It also
allows to fetch the tab-scoped actors connected to this context. Actors like
console, inspector, thread (for debugger), styleinspector, etc. Most of them
inherit from TabActor (defined in tab.js) which is document centric. It
automatically tracks the lifetime of the targeted document, but it also tracks
its iframes and allows switching the context to one of its iframes. For
historical reasons, these actors also handle creating the ThreadActor, used to
manage breakpoints in the debugger. All the other tab-scoped actors are created
when we access the TabActor's grip. We return the tab-scoped actors `actorID` in
it. Actors inheriting from TabActor expose `attach`/`detach` requests, that
allows to start/stop the ThreadActor.

The tab-scoped actors expect to find the following properties on the "TabActor":
 - threadActor:
   ThreadActor instance for the given context,
   only defined once `attach` request is called, or on construction.
 - isRootActor: (historical name)
   Always false, except on ChromeActor.
   Despite the attribute name, it is being used to accept all resources
   (like chrome one) instead of limiting only to content resources.
 - makeDebugger:
   Helper function used to create Debugger object for the targeted context.
   (See actors/utils/make-debugger.js for more info)

In addition to this, the actors inheriting from TabActor, expose many other
attributes and events:
 - window:
   Reference to the window global object currently targeted.
   It can change over time if we switch context to an iframe, so it
   shouldn't be stored in a variable, but always retrieved from the actor.
 - windows:
   List of all document globals including the main window object and all iframes.
 - docShell:
   DocShell reference for the targeted context.
 - docShells:
   List of all docshells for the targeted document and all its iframes.
 - chromeEventHandler:
   The chrome event handler for the current context. Allows to listen to events
   that can be missing/cancelled on this document itself.

See TabActor documentation for events definition.

## Tab-scoped actors

Each of these actors focuses on providing one particular feature set, specific
to one context, that can be a web page, an app, a top level firefox window, a
process, an add-on, or a worker.
