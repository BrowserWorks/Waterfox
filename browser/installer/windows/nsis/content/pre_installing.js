window.attachEvent("onload", function() {
    // Set text direction.
    var direction = external.getTextDirection();
    var Checkbox = document.getElementById("Checkbox");
    var Form = document.getElementById("Form");
    Form.style.direction = direction;
    var CheckboxLabel = document.getElementById("CheckboxLabel");
    CheckboxLabel.className += " CheckboxLabel-" + direction;

    Checkbox.attachEvent("onclick", function() {
      if (document.getElementById("Checkbox").checked) {
        document.getElementById("Button").disabled = false;
      } else {
        document.getElementById("Button").disabled = true;
      }
    });

    Form.attachEvent("onsubmit", function() {
      external.gotoInstallPage(false);
      return false;
    });

    document.getElementById("Button").focus();
  });