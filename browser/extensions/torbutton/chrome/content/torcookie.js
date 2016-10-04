// Bug 1506 P2: I think cookie protections is a neat feature.

var cookiesTree = null;
var prefs = null;
var cookies = [];
var protectedCookies = [];
var deletedCookies       = [];
var lastCookieSortColumn = "";
var lastCookieSortAscending = false;
var cookiemanager = null;
var selector = null;
//custom tree view, this is how we dynamically add the cookies
var cookiesTreeView = {
  rowCount : 0,
  setTree : function(tree){},
  getImageSrc : function(row,column) {},
  getProgressMode : function(row,column) {},
  getCellValue : function(row,column) {},
  getCellText : function(row,column){
    var rv="";
    switch (column.id) {
      case "domainCol" : rv = cookies[row].rawHost; break;
      case "nameCol"   : rv = cookies[row].name; break;
      case "lockCol"   : rv = cookies[row].isProtected; break;
      case "pathCol"   : rv = cookies[row].path; break;
    }
    return rv;
  },
  isSeparator : function(index) {return false;},
  isSorted: function() { return false; },
  isContainer : function(index) {return false;},
  cycleHeader : function(column, aElt) {},
  getRowProperties : function(row,column,prop){},
  getColumnProperties : function(column,columnElement,prop){},
  getCellProperties : function(row,column,prop) {}
 };

// XXX: Must match the definition in cookie-jar-selector :/
function Cookie(number,name,value,isDomain,host,rawHost,HttpOnly,path,isSecure,isSession,
                expires,isProtected) {
  this.number = number;
  this.name = name;
  this.value = value;
  this.isDomain = isDomain;
  this.host = host;
  this.rawHost = rawHost;
  this.isHttpOnly = HttpOnly;
  this.path = path;
  this.isSecure = isSecure;
  this.isSession = isSession;
  this.expires = expires;
  this.isProtected = isProtected;
}

function initDialog() {
  cookiesTree = document.getElementById("cookiesTree");
  prefs =Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefBranch);
  selector = Components.classes["@torproject.org/cookie-jar-selector;1"]
                    .getService(Components.interfaces.nsISupports)
                    .wrappedJSObject;
  //init cookie manager
  cookiemanager = Components.classes["@mozilla.org/cookiemanager;1"].getService();
    cookiemanager = cookiemanager.QueryInterface(Components.interfaces.nsICookieManager);
  var enumerator = cookiemanager.enumerator;
  var count = 0;
  getProtectedCookies();
  while (enumerator.hasMoreElements()) {
    var nextCookie = enumerator.getNext();
    if (!nextCookie) break;
    nextCookie = nextCookie.QueryInterface(Components.interfaces.nsICookie);
    var host = nextCookie.host;
    var isProt = checkIfProtected(nextCookie.name, host, nextCookie.path);
    //populate list
    cookies[count] =
      new Cookie(count++, nextCookie.name, nextCookie.value, nextCookie.isDomain, host,
                   (host.charAt(0)==".") ? host.substring(1,host.length) : host, nextCookie.isHttpOnly,
                   nextCookie.path, nextCookie.isSecure, nextCookie.isSession, nextCookie.expires,
                   isProt);
  }
  //apply custom view
  cookiesTreeView.rowCount = cookies.length;
  cookiesTree.treeBoxObject.view = cookiesTreeView;    
  document.getElementById('defaultCookieGroup').selectedIndex = prefs.getBoolPref("extensions.torbutton.cookie_auto_protect")? 0 : 1;
}
function protectCookie()
{
  ProtectInTree(cookiesTree, cookiesTreeView,
                        cookies, "protectCookie", "unprotectCookie", "removeCookie");
}
function unprotectCookie() {
  UnProtectInTree(cookiesTree, cookiesTreeView,
                        cookies, "protectCookie", "unprotectCookie", "removeCookie");
}
function checkIfProtected(name, host, path)
{
  for (var i = 0; i < protectedCookies.length; i++)
  {
    var cookie = protectedCookies[i];
    if (cookie.name == name && cookie.host == host && cookie.path == path)
      return true;
  }
  return false;
}
function itemSelected() {
  var selections = getTreeSelections(cookiesTree);
  if (selections.length) {

//DY - check if (the last in list) selection is protected/unprotected, set buttons
    if (cookies[selections[(selections.length)-1]].isProtected) {
        document.getElementById("removeCookie").disabled = true;
        document.getElementById("unprotectCookie").disabled = false;
        document.getElementById("protectCookie").disabled = true;
    } else {
        document.getElementById("removeCookie").disabled = false;
        document.getElementById("unprotectCookie").disabled = true;
        document.getElementById("protectCookie").disabled = false;
    }

  }
}
function acceptDialog() {
  
  FinalizeCookieDeletions();
  var protectedcount = 0;
  var protcookies = [];
  for (var i = 0; i < cookies.length; i++)
  {
    if (cookies[i].isProtected)
    {
      protcookies[protectedcount] = cookies[i];
      protectedcount++;
    }
  }
  selector.protectCookies(protcookies);
  //output protected cookies
  prefs.setBoolPref("extensions.torbutton.cookie_auto_protect",document.getElementById('saveAllCookies').selected);
}
function CookieColumnSort(column) {
  lastCookieSortAscending =
    SortTree(cookiesTree, cookiesTreeView, cookies,
                 column, lastCookieSortColumn, lastCookieSortAscending);
  lastCookieSortColumn = column;
}
function DeleteCookie() {
//DY - check if any selection is protected
  var selections = getTreeSelections(cookiesTree);
  var protect = false;
  var i;
  for (i=0; i<selections.length; i++) {
    if (cookies[selections[i]].isProtected) {
      protect = true;
    }
  }
  if (!protect && i>0 ) {
    DeleteSelectedItemFromTree(cookiesTree, cookiesTreeView,
                               cookies, deletedCookies,
                               "removeCookie", "removeAllCookies",
                               "protectCookie", "unprotectCookie");
    if (!cookies.length) {
      ;//ClearCookieProperties();
    }

  }
}

function getProtectedCookies()
{
  var gotCookies = selector.getProtectedCookies("tor");
  if (gotCookies == null)
    return;
  protectedCookies = gotCookies;
}

//Tree Utils

function SortTree(tree, view, table, column, lastSortColumn, lastSortAscending, updateSelection) {

  // remember which item was selected so we can restore it after the sort
  var selections = getTreeSelections(tree);
  var selectedNumber = selections.length ? table[selections[0]].number : -1;

  // determine if sort is to be ascending or descending
  var ascending = (column == lastSortColumn) ? !lastSortAscending : true;

  // do the sort or re-sort
  var compareFunc = function compare(first, second) {
    if (column=="isProtected") {
       return second[column].toString().localeCompare(first[column].toString());
    } else {
       return first[column].toLowerCase().localeCompare(second[column].toLowerCase());
    }
  }
  table.sort(compareFunc);
  if (!ascending)
    table.reverse();

  // restore the selection
  var selectedRow = -1;
  if (selectedNumber>=0 && updateSelection) {
    for (var s=0; s<table.length; s++) {
      if (table[s].number == selectedNumber) {
        // update selection
        // note: we need to deselect before reselecting in order to trigger ...Selected()
        tree.view.selection.select(-1);
        tree.view.selection.select(s);
        selectedRow = s;
        break;
      }
    }
  }

  // display the results
  tree.treeBoxObject.invalidate();
  if (selectedRow >= 0) {
    tree.treeBoxObject.ensureRowIsVisible(selectedRow)
  }

  return ascending;
}
function FinalizeCookieDeletions() {
  for (var c=0; c<deletedCookies.length; c++) {
    cookiemanager.remove(deletedCookies[c].host,
                         deletedCookies[c].name,
                         deletedCookies[c].path,
                         false);
  }
  deletedCookies.length = 0;
}
function getTreeSelections(tree) {
  var selections = [];
  var select;
  
  select = tree.view.selection;
  if (select) {
    var count = select.getRangeCount();
    var min = new Object();
    var max = new Object();
    for (var i=0; i<count; i++) {
      select.getRangeAt(i, min, max);
      for (var k=min.value; k<=max.value; k++) {
        if (k != -1) {
          selections[selections.length] = k;
        }
      }
    }
  }
  return selections;
}
function ProtectInTree
    (tree, view, table, protButton, unprotButton, removeButton) {

  var selections = getTreeSelections(tree);
  for (var s=selections.length-1; s>= 0; s--) {
    var i = selections[s];
    table[i].isProtected = true;
  }

  //update tree view
  tree.treeBoxObject.invalidate();
//DY - Update selections
  tree.treeBoxObject.ensureRowIsVisible(selections[0]);
  // disable/enable buttons
  document.getElementById(unprotButton).disabled = false;
  document.getElementById(protButton).disabled = true;
  document.getElementById(removeButton).disabled = true;
}
function UnProtectInTree
    (tree, view, table, protButton, unprotButton, removeButton) {

  var selections = getTreeSelections(tree);
  for (var s=selections.length-1; s>= 0; s--) {
    var i = selections[s];
    table[i].isProtected = false;
  }

  //update tree view
  tree.treeBoxObject.invalidate();
//DY - Update selections
  tree.treeBoxObject.ensureRowIsVisible(selections[0]);
  // disable/enable buttons
  document.getElementById(unprotButton).disabled = true;
  document.getElementById(protButton).disabled = false;
  document.getElementById(removeButton).disabled = false;
}
function DeleteAllCookies() {

  DeleteAllFromTree(cookiesTree, cookiesTreeView,
                        cookies, deletedCookies,
                        "removeCookie", "removeAllCookies",
                        "protectCookie", "unprotectCookie");

}
function DeleteSelectedItemFromTree
    (tree, view, table, deletedTable, removeButton, removeAllButton, protButton, unprotButton) {

  var selections = getTreeSelections(tree);

  tree.view.selection.clearSelection();
  

  // remove selected items from list (by setting them to null) and place in deleted list
  for (var s=selections.length-1; s>= 0; s--) {
    var i = selections[s];
    deletedTable[deletedTable.length] = table[i];
    table[i] = null;
  }
  // collapse list by removing all the null entries
  for (var j=0; j<table.length; j++) {
    if (table[j] == null) {
      var k = j;
      while ((k < table.length) && (table[k] == null)) {
        k++;
      }
      table.splice(j, k-j);
      view.rowCount -= k - j;
      tree.treeBoxObject.rowCountChanged(j, j - k);
    }
  }
//DY - update selection and/or buttons
  if (table.length) {

//DY - update selection to previous (first of) selected position or bottom
    var nextSelection = (selections[0] < table.length) ? selections[0] : table.length-1;

   	tree.view.selection.select(nextSelection);
    tree.treeBoxObject.ensureRowIsVisible(nextSelection);
    if (table[nextSelection].isProtected) {
        document.getElementById(unprotButton).disabled = false;
        document.getElementById(protButton).disabled = true;
    } else {
        document.getElementById(unprotButton).disabled = true;
        document.getElementById(protButton).disabled = false;
    }
  } else {
    // disable buttons
    document.getElementById(removeButton).disabled = true;
    document.getElementById(removeAllButton).disabled = true;
    document.getElementById(unprotButton).disabled = true;
    document.getElementById(protButton).disabled = true;
  }
}
function DeleteAllFromTree
    (tree, view, table, deletedTable, removeButton, removeAllButton, protButton, unprotButton) {

  // remove items from table and place in deleted table
  for (var i=0; i<table.length; i++) {
//DY - only if unprotected
    if (!table[i].isProtected) {
      deletedTable[deletedTable.length] = table[i];
      table[i] = null;
    }
  }
  
	tree.view.selection.clearSelection();
  
//DY - fix up tree
  // collapse list by removing all the null entries
  for (var j=0; j<table.length; j++) {
    if (table[j] == null) {
      var k = j;
      while ((k < table.length) && (table[k] == null)) {
        k++;
      }
      table.splice(j, k-j);
      view.rowCount -= k - j;
      tree.treeBoxObject.rowCountChanged(j, j - k);
    }
  }
  // update selection and/or buttons
  if (table.length) {
    // update selection to top
    tree.view.selection.select(0);
    tree.treeBoxObject.ensureRowIsVisible(0);
    //if it exists is must already be protected
        document.getElementById(unprotButton).disabled = false;
        document.getElementById(protButton).disabled = true;
  } else {
    // disable all buttons
    document.getElementById(removeButton).disabled = true;
    document.getElementById(removeAllButton).disabled = true;
    document.getElementById(unprotButton).disabled = true;
    document.getElementById(protButton).disabled = true;
  }
}
