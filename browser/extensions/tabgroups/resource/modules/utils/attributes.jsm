// VERSION 2.2.2
Modules.UTILS = true;
Modules.BASEUTILS = true;

// setAttribute(obj, attr, val) - helper me that saves me the trouble of checking if the obj exists first everywhere in my scripts; yes I'm that lazy
//	obj - (xul element) to set the attribute
//	attr - (str) attribute to set
//	val - (str) value to set for attr
this.setAttribute = function(obj, attr, val) {
	if(!obj || !obj.setAttribute) { return; }
	obj.setAttribute(attr, val);
};

// removeAttribute(obj, attr) - helper me that saves me the trouble of checking if the obj exists first everywhere in my scripts; yes I'm that lazy
//	see setAttribute()
this.removeAttribute = function(obj, attr) {
	if(!obj || !obj.removeAttribute) { return; }
	obj.removeAttribute(attr);
};

// toggleAttribute(obj, attr, condition, val) - sets attr on obj if condition is true; I'm uber lazy
//	see setAttribute()
//	condition - when true, attr is set with value (str) true, otherwise it removes the attribute
//	(optional) trueval - (str) value to set attr to if condition is true, defaults to (str) true
//	(optional) falseval - (str) value to set attr to if condition is false, if not set the attr is removed
this.toggleAttribute = function(obj, attr, condition, trueval, falseval) {
	if(!obj || !obj.setAttribute || !obj.removeAttribute) { return; }

	if(condition) {
		if(trueval === undefined) { trueval = 'true'; }
		obj.setAttribute(attr, trueval);
	} else if(falseval !== undefined) {
		obj.setAttribute(attr, falseval);
	} else {
		obj.removeAttribute(attr);
	}
};

// trueAttribute(obj, attr) - checks whether attribute attr in obj has value "true"
//	see setAttribute()
this.trueAttribute = function(obj, attr) {
	if(!obj || !obj.getAttribute) { return false; }

	return (obj.getAttribute(attr) == 'true');
};
