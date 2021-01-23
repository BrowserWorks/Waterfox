/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * Machine learning model for identifying new password input elements
 * using Fathom.
 */

const EXPORTED_SYMBOLS = ["NewPasswordModel"];

ChromeUtils.defineModuleGetter(
  this,
  "fathom",
  "resource://gre/modules/third_party/fathom/fathom.jsm"
);

const {
  dom,
  element,
  out,
  rule,
  ruleset,
  score,
  type,
  utils: { identity, isVisible, min, setDefault },
  clusters: { euclidean },
} = fathom;

/**
 * ----- Start of model -----
 *
 * Everything below this comment up to the "End of model" comment is copied from:
 * https://github.com/mozilla-services/fathom-login-forms/blob/3a2f8806cc8c3716be2aa426a6e9a6d2bebd737d/new-password/rulesets.js#L14-L540
 * Deviations from that file:
 *   - Remove import statements, instead using ``ChromeUtils.defineModuleGetter`` and destructuring assignments above.
 *   - Set ``DEVELOPMENT`` constant to ``false``.
 */

// Whether this is running in the Vectorizer, rather than in-application, in a
// privileged Chrome context
const DEVELOPMENT = false;

// Run me with confidence cutoff = 0.75.
const coefficients = {
  new: [
    ["hasNewLabel", 2.531618356704712],
    ["hasConfirmLabel", 1.9212454557418823],
    ["hasCurrentLabel", -1.5062531232833862],
    ["closestLabelMatchesNew", 2.4905529022216797],
    ["closestLabelMatchesConfirm", 2.188796281814575],
    ["closestLabelMatchesCurrent", -2.5512311458587646],
    ["hasNewAriaLabel", 1.9324924945831299],
    ["hasConfirmAriaLabel", 1.7427018880844116],
    ["hasCurrentAriaLabel", -0.45434775948524475],
    ["hasNewPlaceholder", 1.3900811672210693],
    ["hasConfirmPlaceholder", 2.120662212371826],
    ["hasCurrentPlaceholder", -2.464745283126831],
    ["forgotPasswordInFormLinkTextContent", -0.34269317984580994],
    ["forgotPasswordInFormLinkHref", -1.100291132926941],
    ["forgotPasswordInFormLinkTitle", -2.5948476791381836],
    ["forgotInFormLinkTextContent", -1.104567050933838],
    ["forgotInFormLinkHref", 0.43580958247184753],
    ["forgotPasswordInFormButtonTextContent", -2.2410218715667725],
    ["forgotPasswordOnPageLinkTextContent", -0.7233141660690308],
    ["forgotPasswordOnPageLinkHref", -0.3587746322154999],
    ["forgotPasswordOnPageLinkTitle", 0.5892723798751831],
    ["forgotPasswordOnPageButtonTextContent", -0.0006637098849751055],
    ["elementAttrsMatchNew", 2.36958646774292],
    ["elementAttrsMatchConfirm", 1.79710853099823],
    ["elementAttrsMatchCurrent", -2.0240602493286133],
    ["elementAttrsMatchPassword1", 1.9658048152923584],
    ["elementAttrsMatchPassword2", 1.6933585405349731],
    ["elementAttrsMatchLogin", 1.1432386636734009],
    ["formAttrsMatchRegister", 1.8227713108062744],
    ["formHasRegisterAction", 1.9209907054901123],
    ["formButtonIsRegister", 2.889024496078491],
    ["formAttrsMatchLogin", -1.166875958442688],
    ["formHasLoginAction", -0.4696630537509918],
    ["formButtonIsLogin", -2.284656524658203],
    ["hasAutocompleteCurrentPassword", -0.04689808934926987],
    ["formHasRememberMeCheckbox", 0.5008370280265808],
    ["formHasRememberMeLabel", -0.022740153595805168],
    ["formHasNewsletterCheckbox", 1.5111156702041626],
    ["formHasNewsletterLabel", 2.277301549911499],
    ["closestHeaderAboveIsLoginy", -2.2182235717773438],
    ["closestHeaderAboveIsRegistery", 1.930107593536377],
    ["nextInputIsConfirmy", 2.5108766555786133],
  ],
};

const biases = [["new", 0.08310158550739288]];

const passwordStringRegex = /password|passwort|رمز عبور|mot de passe|パスワード|비밀번호|암호|wachtwoord|senha|Пароль|parol|密码|contraseña|heslo|كلمة السر|kodeord|Κωδικός|pass code|Kata sandi|hasło|รหัสผ่าน|Şifre/i;
const passwordAttrRegex = /pw|pwd|passwd|pass/i;
const newStringRegex = /new|erstellen|create|choose|設定|신규/i;
const newAttrRegex = /new/i;
const confirmStringRegex = /wiederholen|wiederholung|confirm|repeat|confirmation|verify|retype|repite|確認|の確認|تکرار|re-enter|확인|bevestigen|confirme|Повторите|tassyklamak|再次输入|ještě jednou|gentag|re-type|confirmar|Répéter|conferma|Repetaţi|again|reenter/i;
const confirmAttrRegex = /confirm|retype/i;
const currentAttrAndStringRegex = /current|old/i;
const forgotStringRegex = /vergessen|vergeten|forgot|oublié|dimenticata|Esqueceu|esqueci|Забыли|忘记|找回|Zapomenuté|lost|忘れた|忘れられた|忘れの方|재설정|찾기|help|فراموشی| را فراموش کرده اید|Восстановить|Unuttu|perdus|重新設定|reset|recover|change|remind|find|request|restore|trouble/i;
const forgotHrefRegex = /forgot|reset|recover|change|lost|remind|find|request|restore/i;
const password1Regex = /pw1|pwd1|pass1|passwd1|password1|pwone|pwdone|passone|passwdone|passwordone|pwfirst|pwdfirst|passfirst|passwdfirst|passwordfirst/i;
const password2Regex = /pw2|pwd2|pass2|passwd2|password2|pwtwo|pwdtwo|passtwo|passwdtwo|passwordtwo|pwsecond|pwdsecond|passsecond|passwdsecond|passwordsecond/i;
const loginRegex = /login|log in|log on|log-on|Войти|sign in|sigin|sign\/in|sign-in|sign on|sign-on|ورود|登录|Přihlásit se|Přihlaste|Авторизоваться|Авторизация|entrar|ログイン|로그인|inloggen|Συνδέσου|accedi|ログオン|Giriş Yap|登入|connecter|connectez-vous|Connexion|Вход/i;
const loginFormAttrRegex = /login|log in|log on|log-on|sign in|sigin|sign\/in|sign-in|sign on|sign-on/i;
const registerStringRegex = /create[a-zA-Z\s]+account|Zugang anlegen|Angaben prüfen|Konto erstellen|register|sign up|ثبت نام|登録|注册|cadastr|Зарегистрироваться|Регистрация|Bellige alynmak|تسجيل|ΕΓΓΡΑΦΗΣ|Εγγραφή|Créer mon compte|Mendaftar|가입하기|inschrijving|Zarejestruj się|Deschideți un cont|Создать аккаунт|ร่วม|Üye Ol|registr|new account|ساخت حساب کاربری|Schrijf je/i;
const registerActionRegex = /register|signup|sign-up|create-account|account\/create|join|new_account|user\/create|sign\/up|membership\/create/i;
const registerFormAttrRegex = /signup|join|register|regform|registration|new_user|AccountCreate|create_customer|CreateAccount|CreateAcct|create-account|reg-form|newuser|new-reg|new-form|new_membership/i;
const rememberMeAttrRegex = /remember|auto_login|auto-login|save_mail|save-mail|ricordami|manter|mantenha|savelogin|auto login/i;
const rememberMeStringRegex = /remember me|keep me logged in|keep me signed in|save email address|save id|stay signed in|ricordami|次回からログオンIDの入力を省略する|メールアドレスを保存する|を保存|아이디저장|아이디 저장|로그인 상태 유지|lembrar|manter conectado|mantenha-me conectado|Запомни меня|запомнить меня|Запомните меня|Не спрашивать в следующий раз|下次自动登录|记住我/i;
const newsletterStringRegex = /newsletter|ニュースレター/i;
const passwordStringAndAttrRegex = new RegExp(
  passwordStringRegex.source + "|" + passwordAttrRegex.source,
  "i"
);

function makeRuleset(coeffs, biases) {
  // HTMLElement => (selector => Array<HTMLElement>) nested map to cache querySelectorAll calls.
  let elementToSelectors;
  // We want to clear the cache each time the model is executed to get the latest DOM snapshot
  // for each classification.
  function clearCache() {
    // WeakMaps do not have a clear method
    elementToSelectors = new WeakMap();
  }

  function hasLabelMatchingRegex(element, regex) {
    // Check element.labels
    const labels = element.labels;
    // TODO: Should I be concerned with multiple labels?
    if (labels !== null && labels.length) {
      return regex.test(labels[0].textContent);
    }

    // Check element.aria-labelledby
    let labelledBy = element.getAttribute("aria-labelledby");
    if (labelledBy !== null) {
      labelledBy = labelledBy
        .split(" ")
        .map(id => element.getRootNode().getElementById(id))
        .filter(el => el);
      if (labelledBy.length === 1) {
        return regex.test(labelledBy[0].textContent);
      } else if (labelledBy.length > 1) {
        return regex.test(
          min(labelledBy, node => euclidean(node, element)).textContent
        );
      }
    }

    const parentElement = element.parentElement;
    // Bug 1634819: element.parentElement is null if element.parentNode is a ShadowRoot
    if (!parentElement) {
      return false;
    }
    // Check if the input is in a <td>, and, if so, check the textContent of the containing <tr>
    if (parentElement.tagName === "TD" && parentElement.parentElement) {
      // TODO: How bad is the assumption that the <tr> won't be the parent of the <td>?
      return regex.test(parentElement.parentElement.textContent);
    }

    // Check if the input is in a <dd>, and, if so, check the textContent of the preceding <dt>
    if (
      parentElement.tagName === "DD" &&
      // previousElementSibling can be null
      parentElement.previousElementSibling
    ) {
      return regex.test(parentElement.previousElementSibling.textContent);
    }
    return false;
  }

  function closestLabelMatchesRegex(element, regex) {
    const previousElementSibling = element.previousElementSibling;
    if (
      previousElementSibling !== null &&
      previousElementSibling.tagName === "LABEL"
    ) {
      return regex.test(previousElementSibling.textContent);
    }

    const nextElementSibling = element.nextElementSibling;
    if (nextElementSibling !== null && nextElementSibling.tagName === "LABEL") {
      return regex.test(nextElementSibling.textContent);
    }

    const closestLabelWithinForm = closestSelectorElementWithinElement(
      element,
      element.form,
      "label"
    );
    return containsRegex(
      regex,
      closestLabelWithinForm,
      closestLabelWithinForm => closestLabelWithinForm.textContent
    );
  }

  function containsRegex(regex, thingOrNull, thingToString = identity) {
    return thingOrNull !== null && regex.test(thingToString(thingOrNull));
  }

  function closestSelectorElementWithinElement(
    toElement,
    withinElement,
    querySelector
  ) {
    if (withinElement !== null) {
      let nodeList = Array.from(withinElement.querySelectorAll(querySelector));
      if (nodeList.length) {
        return min(nodeList, node => euclidean(node, toElement));
      }
    }
    return null;
  }

  function hasAriaLabelMatchingRegex(element, regex) {
    return containsRegex(regex, element.getAttribute("aria-label"));
  }

  function hasPlaceholderMatchingRegex(element, regex) {
    return containsRegex(regex, element.getAttribute("placeholder"));
  }

  function testRegexesAgainstAnchorPropertyWithinElement(
    property,
    element,
    ...regexes
  ) {
    return hasSomeMatchingPredicateForSelectorWithinElement(
      element,
      "a",
      anchor => {
        const propertyValue = anchor[property];
        return regexes.every(regex => regex.test(propertyValue));
      }
    );
  }

  function testFormButtonsAgainst(element, stringRegex) {
    const form = element.form;
    if (form !== null) {
      let inputs = Array.from(
        form.querySelectorAll("input[type=submit],input[type=button]")
      );
      inputs = inputs.filter(input => {
        return stringRegex.test(input.value);
      });
      if (inputs.length) {
        return true;
      }

      return hasSomeMatchingPredicateForSelectorWithinElement(
        form,
        "button",
        button => {
          return (
            stringRegex.test(button.value) ||
            stringRegex.test(button.textContent) ||
            stringRegex.test(button.id) ||
            stringRegex.test(button.title)
          );
        }
      );
    }
    return false;
  }

  function hasAutocompleteCurrentPassword(fnode) {
    return fnode.element.autocomplete === "current-password";
  }

  // Check cache before calling querySelectorAll on element
  function getElementDescendants(element, selector) {
    // Use the element to look up the selector map:
    const selectorToDescendants = setDefault(
      elementToSelectors,
      element,
      () => new Map()
    );

    // Use the selector to grab the descendants:
    return setDefault(
      selectorToDescendants, // eslint-disable-line prettier/prettier
      selector,
      () => Array.from(element.querySelectorAll(selector))
    );
  }

  /**
   * Return whether the form element directly after this one looks like a
   * confirm-password input.
   */
  function nextInputIsConfirmy(fnode) {
    const form = fnode.element.form;
    const me = fnode.element;
    if (form !== null) {
      let afterMe = false;
      for (const formEl of form.elements) {
        if (formEl === me) {
          afterMe = true;
        } else if (afterMe) {
          if (
            formEl.type === "password" &&
            !formEl.disabled &&
            formEl.getAttribute("aria-hidden") !== "true"
          ) {
            // Now we're looking at a passwordy, visible input[type=password]
            // directly after me.
            return elementAttrsMatchRegex(formEl, confirmAttrRegex);
            // We could check other confirmy smells as well. Balance accuracy
            // against time and complexity.
          }
          // We look only at the very next element, so we may be thrown off by
          // Hide buttons and such.
          break;
        }
      }
    }
    return false;
  }

  function hasSomeMatchingPredicateForSelectorWithinElement(
    element,
    selector,
    matchingPredicate
  ) {
    if (element === null) {
      return false;
    }
    const elements = getElementDescendants(element, selector);
    return elements.some(matchingPredicate);
  }

  function textContentMatchesRegexes(element, ...regexes) {
    const textContent = element.textContent;
    return regexes.every(regex => regex.test(textContent));
  }

  function closestHeaderAboveMatchesRegex(element, regex) {
    const closestHeader = closestHeaderAbove(element);
    if (closestHeader !== null) {
      return regex.test(closestHeader.textContent);
    }
    return false;
  }

  function closestHeaderAbove(element) {
    let headers = Array.from(
      element.ownerDocument.querySelectorAll(
        "h1,h2,h3,h4,h5,h6,div[class*=heading],div[class*=header],div[class*=title],legend"
      )
    );
    for (let i = headers.length - 1; i >= 0; --i) {
      const header = headers[i];
      if (
        element.compareDocumentPosition(header) &
        Node.DOCUMENT_POSITION_PRECEDING
      ) {
        return header;
      }
    }
    return null;
  }

  function elementAttrsMatchRegex(element, regex) {
    if (element !== null) {
      return (
        regex.test(element.id) ||
        regex.test(element.name) ||
        regex.test(element.className)
      );
    }
    return false;
  }

  /**
   * Let us compactly represent a collection of rules that all take a single
   * type with no .when() clause and have only a score() call on the right-hand
   * side.
   */
  function* simpleScoringRulesTakingType(inType, ruleMap) {
    for (const [name, scoringCallback] of Object.entries(ruleMap)) {
      yield rule(type(inType), score(scoringCallback), { name });
    }
  }

  return ruleset(
    [
      rule(
        DEVELOPMENT
          ? dom(
              "input[type=password]:not([disabled]):not([aria-hidden=true]"
            ).when(isVisible)
          : element("input"),
        type("new").note(clearCache)
      ),
      ...simpleScoringRulesTakingType("new", {
        hasNewLabel: fnode =>
          hasLabelMatchingRegex(fnode.element, newStringRegex),
        hasConfirmLabel: fnode =>
          hasLabelMatchingRegex(fnode.element, confirmStringRegex),
        hasCurrentLabel: fnode =>
          hasLabelMatchingRegex(fnode.element, currentAttrAndStringRegex),
        closestLabelMatchesNew: fnode =>
          closestLabelMatchesRegex(fnode.element, newStringRegex),
        closestLabelMatchesConfirm: fnode =>
          closestLabelMatchesRegex(fnode.element, confirmStringRegex),
        closestLabelMatchesCurrent: fnode =>
          closestLabelMatchesRegex(fnode.element, currentAttrAndStringRegex),
        hasNewAriaLabel: fnode =>
          hasAriaLabelMatchingRegex(fnode.element, newStringRegex),
        hasConfirmAriaLabel: fnode =>
          hasAriaLabelMatchingRegex(fnode.element, confirmStringRegex),
        hasCurrentAriaLabel: fnode =>
          hasAriaLabelMatchingRegex(fnode.element, currentAttrAndStringRegex),
        hasNewPlaceholder: fnode =>
          hasPlaceholderMatchingRegex(fnode.element, newStringRegex),
        hasConfirmPlaceholder: fnode =>
          hasPlaceholderMatchingRegex(fnode.element, confirmStringRegex),
        hasCurrentPlaceholder: fnode =>
          hasPlaceholderMatchingRegex(fnode.element, currentAttrAndStringRegex),
        forgotPasswordInFormLinkTextContent: fnode =>
          testRegexesAgainstAnchorPropertyWithinElement(
            "textContent",
            fnode.element.form,
            passwordStringRegex,
            forgotStringRegex
          ),
        forgotPasswordInFormLinkHref: fnode =>
          testRegexesAgainstAnchorPropertyWithinElement(
            "href",
            fnode.element.form,
            passwordStringAndAttrRegex,
            forgotHrefRegex
          ),
        forgotPasswordInFormLinkTitle: fnode =>
          testRegexesAgainstAnchorPropertyWithinElement(
            "title",
            fnode.element.form,
            passwordStringRegex,
            forgotStringRegex
          ),
        forgotInFormLinkTextContent: fnode =>
          testRegexesAgainstAnchorPropertyWithinElement(
            "textContent",
            fnode.element.form,
            forgotStringRegex
          ),
        forgotInFormLinkHref: fnode =>
          testRegexesAgainstAnchorPropertyWithinElement(
            "href",
            fnode.element.form,
            forgotHrefRegex
          ),
        forgotPasswordInFormButtonTextContent: fnode =>
          hasSomeMatchingPredicateForSelectorWithinElement(
            fnode.element.form,
            "button",
            button =>
              textContentMatchesRegexes(
                button,
                passwordStringRegex,
                forgotStringRegex
              )
          ),
        forgotPasswordOnPageLinkTextContent: fnode =>
          testRegexesAgainstAnchorPropertyWithinElement(
            "textContent",
            fnode.element.ownerDocument,
            passwordStringRegex,
            forgotStringRegex
          ),
        forgotPasswordOnPageLinkHref: fnode =>
          testRegexesAgainstAnchorPropertyWithinElement(
            "href",
            fnode.element.ownerDocument,
            passwordStringAndAttrRegex,
            forgotHrefRegex
          ),
        forgotPasswordOnPageLinkTitle: fnode =>
          testRegexesAgainstAnchorPropertyWithinElement(
            "title",
            fnode.element.ownerDocument,
            passwordStringRegex,
            forgotStringRegex
          ),
        forgotPasswordOnPageButtonTextContent: fnode =>
          hasSomeMatchingPredicateForSelectorWithinElement(
            fnode.element.ownerDocument,
            "button",
            button =>
              textContentMatchesRegexes(
                button,
                passwordStringRegex,
                forgotStringRegex
              )
          ),
        elementAttrsMatchNew: fnode =>
          elementAttrsMatchRegex(fnode.element, newAttrRegex),
        elementAttrsMatchConfirm: fnode =>
          elementAttrsMatchRegex(fnode.element, confirmAttrRegex),
        elementAttrsMatchCurrent: fnode =>
          elementAttrsMatchRegex(fnode.element, currentAttrAndStringRegex),
        elementAttrsMatchPassword1: fnode =>
          elementAttrsMatchRegex(fnode.element, password1Regex),
        elementAttrsMatchPassword2: fnode =>
          elementAttrsMatchRegex(fnode.element, password2Regex),
        elementAttrsMatchLogin: fnode =>
          elementAttrsMatchRegex(fnode.element, loginRegex),
        formAttrsMatchRegister: fnode =>
          elementAttrsMatchRegex(fnode.element.form, registerFormAttrRegex),
        formHasRegisterAction: fnode =>
          containsRegex(
            registerActionRegex,
            fnode.element.form,
            form => form.action
          ),
        formButtonIsRegister: fnode =>
          testFormButtonsAgainst(fnode.element, registerStringRegex),
        formAttrsMatchLogin: fnode =>
          elementAttrsMatchRegex(fnode.element.form, loginFormAttrRegex),
        formHasLoginAction: fnode =>
          containsRegex(loginRegex, fnode.element.form, form => form.action),
        formButtonIsLogin: fnode =>
          testFormButtonsAgainst(fnode.element, loginRegex),
        hasAutocompleteCurrentPassword,
        formHasRememberMeCheckbox: fnode =>
          hasSomeMatchingPredicateForSelectorWithinElement(
            fnode.element.form,
            "input[type=checkbox]",
            checkbox =>
              rememberMeAttrRegex.test(checkbox.id) ||
              rememberMeAttrRegex.test(checkbox.name)
          ),
        formHasRememberMeLabel: fnode =>
          hasSomeMatchingPredicateForSelectorWithinElement(
            fnode.element.form,
            "label",
            label => rememberMeStringRegex.test(label.textContent)
          ),
        formHasNewsletterCheckbox: fnode =>
          hasSomeMatchingPredicateForSelectorWithinElement(
            fnode.element.form,
            "input[type=checkbox]",
            checkbox =>
              checkbox.id.includes("newsletter") ||
              checkbox.name.includes("newsletter")
          ),
        formHasNewsletterLabel: fnode =>
          hasSomeMatchingPredicateForSelectorWithinElement(
            fnode.element.form,
            "label",
            label => newsletterStringRegex.test(label.textContent)
          ),
        closestHeaderAboveIsLoginy: fnode =>
          closestHeaderAboveMatchesRegex(fnode.element, loginRegex),
        closestHeaderAboveIsRegistery: fnode =>
          closestHeaderAboveMatchesRegex(fnode.element, registerStringRegex),
        nextInputIsConfirmy,
      }),
      rule(type("new"), out("new")),
    ],
    coeffs,
    biases
  );
}

/*
 * ----- End of model -----
 */

this.NewPasswordModel = {
  type: "new",
  rules: makeRuleset([...coefficients.new], biases),
};
