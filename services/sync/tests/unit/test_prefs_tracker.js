/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

Cu.import("resource://gre/modules/Preferences.jsm");
Cu.import("resource://services-common/utils.js");
Cu.import("resource://services-sync/constants.js");
Cu.import("resource://services-sync/engines/prefs.js");
Cu.import("resource://services-sync/service.js");
Cu.import("resource://services-sync/util.js");

add_task(async function run_test() {
  let engine = Service.engineManager.get("prefs");
  let tracker = engine._tracker;

  // Don't write out by default.
  tracker.persistChangedIDs = false;

  let prefs = new Preferences();

  try {

    _("tracker.modified corresponds to preference.");
    do_check_eq(Svc.Prefs.get("engine.prefs.modified"), undefined);
    do_check_false(tracker.modified);

    tracker.modified = true;
    do_check_eq(Svc.Prefs.get("engine.prefs.modified"), true);
    do_check_true(tracker.modified);

    _("Engine's getChangedID() just returns the one GUID we have.");
    let changedIDs = await engine.getChangedIDs();
    let ids = Object.keys(changedIDs);
    do_check_eq(ids.length, 1);
    do_check_eq(ids[0], CommonUtils.encodeBase64URL(Services.appinfo.ID));

    Svc.Prefs.set("engine.prefs.modified", false);
    do_check_false(tracker.modified);

    _("No modified state, so no changed IDs.");
    do_check_empty((await engine.getChangedIDs()));

    _("Initial score is 0");
    do_check_eq(tracker.score, 0);

    _("Test fixtures.");
    Svc.Prefs.set("prefs.sync.testing.int", true);

    _("Test fixtures haven't upped the tracker score yet because it hasn't started tracking yet.");
    do_check_eq(tracker.score, 0);

    _("Tell the tracker to start tracking changes.");
    Svc.Obs.notify("weave:engine:start-tracking");
    prefs.set("testing.int", 23);
    do_check_eq(tracker.score, SCORE_INCREMENT_XLARGE);
    do_check_eq(tracker.modified, true);

    _("Clearing changed IDs reset modified status.");
    tracker.clearChangedIDs();
    do_check_eq(tracker.modified, false);

    _("Resetting a pref ups the score, too.");
    prefs.reset("testing.int");
    do_check_eq(tracker.score, SCORE_INCREMENT_XLARGE * 2);
    do_check_eq(tracker.modified, true);
    tracker.clearChangedIDs();

    _("So does changing a pref sync pref.");
    Svc.Prefs.set("prefs.sync.testing.int", false);
    do_check_eq(tracker.score, SCORE_INCREMENT_XLARGE * 3);
    do_check_eq(tracker.modified, true);
    tracker.clearChangedIDs();

    _("Now that the pref sync pref has been flipped, changes to it won't be picked up.");
    prefs.set("testing.int", 42);
    do_check_eq(tracker.score, SCORE_INCREMENT_XLARGE * 3);
    do_check_eq(tracker.modified, false);
    tracker.clearChangedIDs();

    _("Changing some other random pref won't do anything.");
    prefs.set("testing.other", "blergh");
    do_check_eq(tracker.score, SCORE_INCREMENT_XLARGE * 3);
    do_check_eq(tracker.modified, false);

  } finally {
    Svc.Obs.notify("weave:engine:stop-tracking");
    prefs.resetBranch("");
  }
});
