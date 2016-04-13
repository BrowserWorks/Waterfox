// VERSION 1.0.0

Modules.LOADMODULE = function() {
	AddonManager.getAddonByID('bug566510@vovcacik.addons.mozilla.org', function(addon) {
		Modules.loadIf('compatibilityFix/bug566510', (addon && addon.isActive));
	});
};

Modules.UNLOADMODULE = function() {
	Modules.unload('compatibilityFix/bug566510');
};
