/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
"use strict";

// Test utils.
const expect = require("expect");
const {
  renderComponent,
  shallowRenderComponent
} = require("devtools/client/webconsole/new-console-output/test/helpers");

// Components under test.
const { MessageContainer } = require("devtools/client/webconsole/new-console-output/components/message-container");
const ConsoleApiCall = require("devtools/client/webconsole/new-console-output/components/message-types/console-api-call");
const EvaluationResult = require("devtools/client/webconsole/new-console-output/components/message-types/evaluation-result");
const PageError = require("devtools/client/webconsole/new-console-output/components/message-types/page-error");

// Test fakes.
const { stubPreparedMessages } = require("devtools/client/webconsole/new-console-output/test/fixtures/stubs/index");
const serviceContainer = require("devtools/client/webconsole/new-console-output/test/fixtures/serviceContainer");

describe("MessageContainer component:", () => {
  it("pipes data to children as expected", () => {
    const message = stubPreparedMessages.get("console.log('foobar', 'test')");
    const rendered = renderComponent(MessageContainer, {message, serviceContainer});

    expect(rendered.textContent.includes("foobar")).toBe(true);
  });
  it("picks correct child component", () => {
    const messageTypes = [
      {
        component: ConsoleApiCall,
        message: stubPreparedMessages.get("console.log('foobar', 'test')")
      },
      {
        component: EvaluationResult,
        message: stubPreparedMessages.get("new Date(0)")
      },
      {
        component: PageError,
        message: stubPreparedMessages.get("ReferenceError: asdf is not defined")
      }
    ];

    messageTypes.forEach(info => {
      const { component, message } = info;
      const rendered = shallowRenderComponent(MessageContainer, {
        message,
        serviceContainer,
      });
      expect(rendered.type).toBe(component);
    });
  });
});
