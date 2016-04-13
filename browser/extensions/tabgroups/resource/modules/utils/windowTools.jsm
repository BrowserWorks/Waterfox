// VERSION 2.1.1
Modules.UTILS = true;
Modules.BASEUTILS = true;

// aSync(aFunc, aDelay) - lets me run aFunc asynchronously, basically it's a one shot timer with a delay of aDelay msec
//	aFunc - (function) to be called asynchronously
//	(optional) aDelay - (int) msec to set the timer, defaults to 0msec
this.aSync = function(aFunc, aDelay) {
	return Timers.create(aFunc, (!aDelay) ? 0 : aDelay);
};
