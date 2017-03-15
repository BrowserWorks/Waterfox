function check(aBrowser, aElementName, aBarred, aType) {
  return ContentTask.spawn(aBrowser, [aElementName, aBarred, aType], function*([aElementName, aBarred, aType]) {
    let e = content.document.createElement(aElementName);
    let contentElement = content.document.getElementById('content');
    contentElement.appendChild(e);

    if (aType) {
      e.type = aType;
    }

    let tttp = Cc["@mozilla.org/embedcomp/default-tooltiptextprovider;1"]
               .getService(Ci.nsITooltipTextProvider);
    ok(!tttp.getNodeText(e, {}, {}),
       "No tooltip should be shown when the element is valid");

    e.setCustomValidity('foo');
    if (aBarred) {
      ok(!tttp.getNodeText(e, {}, {}),
         "No tooltip should be shown when the element is barred from constraint validation");
    } else {
      ok(tttp.getNodeText(e, {}, {}),
         e.tagName + " " +"A tooltip should be shown when the element isn't valid");
    }

    e.setAttribute('title', '');
    ok (!tttp.getNodeText(e, {}, {}),
        "No tooltip should be shown if the title attribute is set");

    e.removeAttribute('title');
    contentElement.setAttribute('novalidate', '');
    ok (!tttp.getNodeText(e, {}, {}),
        "No tooltip should be shown if the novalidate attribute is set on the form owner");
    contentElement.removeAttribute('novalidate');

    e.remove();
  });
}

function todo_check(aBrowser, aElementName, aBarred) {
  return ContentTask.spawn(aBrowser, [aElementName, aBarred], function*([aElementName, aBarred]) {
    let e = content.document.createElement(aElementName);
    let contentElement = content.document.getElementById('content');
    contentElement.appendChild(e);

    let caught = false;
    try {
      e.setCustomValidity('foo');
    } catch (e) {
      caught = true;
    }

    todo(!caught, "setCustomValidity should exist for " + aElementName);

    e.remove();
  });
}

add_task(function*() {
  yield BrowserTestUtils.withNewTab({
    gBrowser,
    url: "data:text/html,<!DOCTYPE html><html><body><form id='content'></form></body></html>",
  }, function*(browser) {
    let testData = [
    /* element name, barred */
      [ 'input',    false,  null],
      [ 'textarea', false,  null],
      [ 'button',   true,  'button'],
      [ 'button',   false, 'submit'],
      [ 'select',   false,  null],
      [ 'output',   true,   null],
      [ 'fieldset', true,   null],
      [ 'object',   true,   null],
    ];

    for (let data of testData) {
      yield check(browser, data[0], data[1], data[2]);
    }

    let todo_testData = [
      [ 'keygen', 'false' ],
    ];

    for (let data of todo_testData) {
      yield todo_check(browser, data[0], data[1]);
    }
  });
});
