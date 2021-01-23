=====================
Default Browser Agent
=====================

The Default Browser Agent is a Windows-only scheduled task which runs in the background to collect and submit data about the browser that the user has set as their OS default (that is, the browser that will be invoked by the operating system to open web links that the user clicks on in other programs). Its purpose is to help Mozilla understand user's default browser choices and, in the future, to engage with users at a time when they may not be actively running Firefox.

For information about the specific data that the agent sends, see :doc:`the ping documentation </toolkit/components/telemetry/data/default-browser-ping>`.


Scheduled Task
==============

The agent runs as a `Windows scheduled task <https://docs.microsoft.com/en-us/windows/win32/taskschd/about-the-task-scheduler>`_. The scheduled task executes all of the agent's primary functions; all of its other functions relate to managing the task. The Windows installer is responsible for creating (and the uninstaller for removing) the agent's task entry, but the code for actually doing this resides in the agent itself, and the installers simply call it using dedicated command line parameters (``register-task`` and ``uninstall``). The :doc:`PostUpdate </browser/installer/windows/installer/Helper>` code also calls the agent to update any properties of an existing task registration that need to be updated, or to create one during an application update if none exists.

The tasks are normal entries in the Windows Task Scheduler, managed using `its Win32 API <https://docs.microsoft.com/en-us/windows/win32/api/_taskschd/>`_. They're created in a tasks folder called "Mozilla" (or whatever the application's vendor name is), and there's one for each installation of Firefox (or other Mozilla application). The task is set to run automatically every 24 hours starting at the time it's registered (with the first run being 24 hours after that), or the nearest time after that the computer is awake. The task is configured with one action, which is to run the agent binary with the command line parameter ``do-task``, the command that invokes the actual agent functionality.

The default browser agent needs to run as some OS-level user, as opposed to, say, ``LOCAL SERVICE``, in order to read the user's default browser setting. Therefore, the default browser agent runs as the user that ran the Firefox installer (although always without elevation, whether the installer had it or not).


Data Management
===============

The default browser agent has to be able to work with settings at several different levels: a Firefox profile, an OS user, a Firefox installation, and the entire system. This need creates an information architecture mismatch between all of those things, mostly because no Firefox profile is available to the agent while it's running; it's not really feasible to either directly use or to clone Firefox's profile selection functionality, and even if we could select a profile, whatever code we might use to actually work with it would have the same problems. So, in order to allow for controlling the agent from Firefox, certain settings are mirrored from Firefox to a location where the agent can read them. Since the agent operates in the context only of an OS-level user, that means that in this situation a single OS-level user who uses multiple Firefox profiles may be able to observe the agent's settings changing as the different profiles race to be the active mirror, without them knowingly taking any action.


Pref Reflection
---------------

The agent needs to be able to read (but not set) values that have their canonical representation in the form of Firefox prefs. This means those pref values have to be copied out to a place where the agent can read them. The Windows registry was chosen as that place; it's easier to use than a file, and we already have keys there which are reserved by Firefox. Specifically, the subkey used for these prefs is ``HKEY_CURRENT_USER\Software\[app vendor name]\[app name]\Default Browser Agent\``. During Firefox startup, the values of the prefs that control the agent are reflected to this key, and those values are updated whenever the prefs change after that.

The list of reflected prefs includes the global telemetry opt-out pref ``datareporting.healthreport.uploadEnabled`` and a pref called ``default-browser-agent.enabled``, which can enable or disable the entire agent. The agent checks these registry-reflected pref values when its scheduled task runs, they do not actually prevent the scheduled task from running.

Enterprise policies also exist to perform the same functions as these prefs. These work the same way as all other Firefox policies and `the documentation for those <https://github.com/mozilla/policy-templates/blob/master/README.md>`_ explains how to use them.


Default Browser Setting
-----------------------

The agent is responsible for reporting both the user's current default browser and their previous default browser. Nothing in the operating system records past associations, so the agent must do this for itself. First, it gets the current default browser by calling `IApplicationAssociationRegistration::QueryCurrentDefault <https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-iapplicationassociationregistration-querycurrentdefault>`_ for the ``http`` protocol. It then checks that against a value stored in its own registry key and, if those are different, it knows that the default browser has changed, and records the new and old defaults.
