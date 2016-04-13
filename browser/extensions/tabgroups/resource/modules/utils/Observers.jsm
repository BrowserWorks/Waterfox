// VERSION 2.3.0
Modules.UTILS = true;
Modules.BASEUTILS = true;

// Observers - Helper for adding and removing observers
// add(anObserver, aTopic, ownsWeak) - Create the observer object from a function if that is what is provided and registers it
//	anObserver - (nsIObserver) to be registered, (function) creates a (nsIObserver){ observe: anObserver } and registers it
//	aTopic - (string) notification to be observed by anObserver
//	(optional) ownsWeak - defaults to false, recommended in MDN, have never seen any case where it is true anyway
// remove(anObserver, aTopic) - unregisters anObserver from watching aTopic
//	see add()
// observing(anObserver, aTopic) - returns (obj) of corresponding stored observer item if anObserver has been registered for aTopic, returns null otherwise
//	see add()
// notify(aTopic, aSubject, aData) - notifies observers of a particular topic
//	aTopic - (string) The notification topic
//	(optional) aSubject - (object) usually where the notification originated from, can be (bool) null; if undefined, it is set to self
//	(optional) aData - (object) varies with the notification topic as needed
this.Observers = {
	observers: new Set(),
	hasQuit: false,

	observe: function() {
		this.hasQuit = true;
	},

	createObject: function(anObserver) {
		return (typeof(anObserver) == 'function') ? { observe: anObserver } : anObserver;
	},

	add: function(anObserver, aTopic, ownsWeak) {
		var observer = this.createObject(anObserver);

		if(this.observing(observer, aTopic)) {
			return false;
		}

		this.observers.add({ topic: aTopic, observer: observer });
		Services.obs.addObserver(observer, aTopic, ownsWeak);
		return true;
	},

	remove: function(anObserver, aTopic) {
		var observer = this.createObject(anObserver);

		var handler = this.observing(observer, aTopic);
		if(handler) {
			Services.obs.removeObserver(handler.observer, handler.topic);
			this.observers.delete(handler);
			return true;
		}
		return null;
	},

	observing: function(anObserver, aTopic) {
		for(let handler of this.observers) {
			if((handler.observer == anObserver || handler.observer.observe == anObserver.observe) && handler.topic == aTopic) {
				return handler;
			}
		}
		return null;
	},

	// this forces the observers for quit-application to trigger before I remove them
	callQuits: function() {
		if(this.hasQuit) { return false; }
		for(let handler of this.observers) {
			if(handler.topic == 'quit-application') {
				handler.observer.observe(null, 'quit-application', null);
			}
		}
		return true;
	},

	clean: function() {
		for(let handler of this.observers) {
			Services.obs.removeObserver(handler.observer, handler.topic);
		}
		this.observers = new Set();
	},

	notify: function(aTopic, aSubject, aData) {
		if(aSubject == undefined) {
			aSubject = self;
		}
		Services.obs.notifyObservers(aSubject, aTopic, aData);
	}
};

Modules.LOADMODULE = function() {
	// This is so the observers aren't called twice on quitting sometimes
	Observers.add(Observers, 'quit-application');

	alwaysRunOnShutdown.push(() => { Observers.callQuits(); });
};

Modules.UNLOADMODULE = function() {
	Observers.clean();
};
