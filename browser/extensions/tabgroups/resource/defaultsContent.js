// VERSION 1.0.0

Services.scriptloader.loadSubScript("resource://tabgroups/modules/utils/content.js", this);

this.tabGroups = this.__contentEnvironment;
delete this.__contentEnvironment;

this.tabGroups.objName = 'tabGroups';
this.tabGroups.objPathString = 'tabgroups';
this.tabGroups.init();
