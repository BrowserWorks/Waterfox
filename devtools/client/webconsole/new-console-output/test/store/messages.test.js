/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
"use strict";

const {
  getAllGroupsById,
  getAllMessagesById,
  getAllMessagesTableDataById,
  getAllMessagesUiById,
  getAllNetworkMessagesUpdateById,
  getAllRepeatById,
  getCurrentGroup,
  getVisibleMessages,
} = require("devtools/client/webconsole/new-console-output/selectors/messages");
const {
  clonePacket,
  getMessageAt,
  setupActions,
  setupStore,
} = require("devtools/client/webconsole/new-console-output/test/helpers");
const { stubPackets, stubPreparedMessages } = require("devtools/client/webconsole/new-console-output/test/fixtures/stubs/index");
const {
  MESSAGE_TYPE,
} = require("devtools/client/webconsole/new-console-output/constants");

const expect = require("expect");

describe("Message reducer:", () => {
  let actions;

  before(() => {
    actions = setupActions();
  });

  describe("messagesById", () => {
    it("adds a message to an empty store", () => {
      const { dispatch, getState } = setupStore([]);

      const packet = stubPackets.get("console.log('foobar', 'test')");
      const message = stubPreparedMessages.get("console.log('foobar', 'test')");
      dispatch(actions.messageAdd(packet));

      const messages = getAllMessagesById(getState());

      expect(messages.first()).toEqual(message);
    });

    it("increments repeat on a repeating message", () => {
      const key1 = "console.log('foobar', 'test')";
      const { dispatch, getState } = setupStore([key1, key1]);

      const packet = clonePacket(stubPackets.get(key1));

      // Repeat ID must be the same even if the timestamp is different.
      packet.message.timeStamp = 1;
      dispatch(actions.messageAdd(packet));
      packet.message.timeStamp = 2;
      dispatch(actions.messageAdd(packet));

      const messages = getAllMessagesById(getState());

      expect(messages.size).toBe(1);

      const repeat = getAllRepeatById(getState());
      expect(repeat[messages.first().id]).toBe(4);
    });

    it("does not increment repeat after closing a group", () => {
      const logKey = "console.log('foobar', 'test')";
      const { getState } = setupStore([
        logKey,
        logKey,
        "console.group('bar')",
        logKey,
        logKey,
        logKey,
        "console.groupEnd()",
        logKey,
      ]);

      const messages = getAllMessagesById(getState());

      expect(messages.size).toBe(4);
      const repeat = getAllRepeatById(getState());
      expect(repeat[messages.first().id]).toBe(2);
      expect(repeat[getMessageAt(getState(), 2).id]).toBe(3);
      expect(repeat[messages.last().id]).toBe(undefined);
    });

    it("does not clobber a unique message", () => {
      const key1 = "console.log('foobar', 'test')";
      const { dispatch, getState } = setupStore([key1, key1]);

      const packet = stubPackets.get(key1);
      dispatch(actions.messageAdd(packet));

      const packet2 = stubPackets.get("console.log(undefined)");
      dispatch(actions.messageAdd(packet2));

      const messages = getAllMessagesById(getState());
      expect(messages.size).toBe(2);

      const repeat = getAllRepeatById(getState());
      expect(repeat[messages.first().id]).toBe(3);
      expect(repeat[messages.last().id]).toBe(undefined);
    });

    it("adds a message in response to console.clear()", () => {
      const { dispatch, getState } = setupStore([]);

      dispatch(actions.messageAdd(stubPackets.get("console.clear()")));

      const messages = getAllMessagesById(getState());

      expect(messages.size).toBe(1);
      expect(messages.first().parameters[0]).toBe("Console was cleared.");
    });

    it("clears the messages list in response to MESSAGES_CLEAR action", () => {
      const { dispatch, getState } = setupStore([
        "console.log('foobar', 'test')",
        "console.log(undefined)",
        "console.table(['red', 'green', 'blue']);",
        "console.group('bar')",
      ]);

      dispatch(actions.messagesClear());

      const state = getState();
      expect(getAllMessagesById(state).size).toBe(0);
      expect(getVisibleMessages(state).length).toBe(0);
      expect(getAllMessagesUiById(state).size).toBe(0);
      expect(getAllGroupsById(state).size).toBe(0);
      expect(getAllMessagesTableDataById(state).size).toBe(0);
      expect(getCurrentGroup(state)).toBe(null);
      expect(getAllRepeatById(state)).toEqual({});
    });

    it("properly limits number of messages", () => {
      const { dispatch, getState } = setupStore([]);

      const logLimit = 1000;
      const packet = clonePacket(stubPackets.get("console.log(undefined)"));

      for (let i = 1; i <= logLimit + 2; i++) {
        packet.message.arguments = [`message num ${i}`];
        dispatch(actions.messageAdd(packet));
      }

      const messages = getAllMessagesById(getState());
      expect(messages.count()).toBe(logLimit);
      expect(messages.first().parameters[0]).toBe(`message num 3`);
      expect(messages.last().parameters[0]).toBe(`message num ${logLimit + 2}`);
    });

    it("properly limits number of messages when there are nested groups", () => {
      const { dispatch, getState } = setupStore([]);

      const logLimit = 1000;

      const packet = clonePacket(stubPackets.get("console.log(undefined)"));
      const packetGroup = clonePacket(stubPackets.get("console.group('bar')"));
      const packetGroupEnd = clonePacket(stubPackets.get("console.groupEnd()"));

      packetGroup.message.arguments = [`group-1`];
      dispatch(actions.messageAdd(packetGroup));
      packetGroup.message.arguments = [`group-1-1`];
      dispatch(actions.messageAdd(packetGroup));
      packetGroup.message.arguments = [`group-1-1-1`];
      dispatch(actions.messageAdd(packetGroup));
      packet.message.arguments = [`message-in-group-1`];
      dispatch(actions.messageAdd(packet));
      packet.message.arguments = [`message-in-group-2`];
      dispatch(actions.messageAdd(packet));
      // Closing group-1-1-1
      dispatch(actions.messageAdd(packetGroupEnd));
      // Closing group-1-1
      dispatch(actions.messageAdd(packetGroupEnd));
      // Closing group-1
      dispatch(actions.messageAdd(packetGroupEnd));

      for (let i = 0; i < logLimit; i++) {
        packet.message.arguments = [`message-${i}`];
        dispatch(actions.messageAdd(packet));
      }

      const visibleMessages = getVisibleMessages(getState());
      const messages = getAllMessagesById(getState());

      expect(messages.count()).toBe(logLimit);
      expect(visibleMessages.length).toBe(logLimit);
      expect(visibleMessages[0].parameters[0]).toBe(`message-0`);
      expect(visibleMessages[logLimit - 1].parameters[0]).toBe(`message-${logLimit - 1}`);

      // The groups were cleaned up.
      const groups = getAllGroupsById(getState());
      expect(groups.count()).toBe(0);
    });

    it("properly limits number of groups", () => {
      const logLimit = 100;
      const { dispatch, getState } = setupStore([], null, {logLimit});

      const packet = clonePacket(stubPackets.get("console.log(undefined)"));
      const packetGroup = clonePacket(stubPackets.get("console.group('bar')"));
      const packetGroupEnd = clonePacket(stubPackets.get("console.groupEnd()"));

      for (let i = 0; i < logLimit + 2; i++) {
        dispatch(actions.messageAdd(packetGroup));
        packet.message.arguments = [`message-${i}-a`];
        dispatch(actions.messageAdd(packet));
        packet.message.arguments = [`message-${i}-b`];
        dispatch(actions.messageAdd(packet));
        dispatch(actions.messageAdd(packetGroupEnd));
      }

      const visibleMessages = getVisibleMessages(getState());
      const messages = getAllMessagesById(getState());
      // We should have three times the logLimit since each group has one message inside.
      expect(messages.count()).toBe(logLimit * 3);

      // We should have logLimit number of groups
      const groups = getAllGroupsById(getState());
      expect(groups.count()).toBe(logLimit);

      expect(visibleMessages[1].parameters[0]).toBe(`message-2-a`);
      expect(messages.last().parameters[0]).toBe(`message-${logLimit + 1}-b`);
    });

    it("properly limits number of collapsed groups", () => {
      const logLimit = 100;
      const { dispatch, getState } = setupStore([], null, {logLimit});

      const packet = clonePacket(stubPackets.get("console.log(undefined)"));
      const packetGroupCollapsed = clonePacket(
        stubPackets.get("console.groupCollapsed('foo')"));
      const packetGroupEnd = clonePacket(stubPackets.get("console.groupEnd()"));

      for (let i = 0; i < logLimit + 2; i++) {
        packetGroupCollapsed.message.arguments = [`group-${i}`];
        dispatch(actions.messageAdd(packetGroupCollapsed));
        packet.message.arguments = [`message-${i}-a`];
        dispatch(actions.messageAdd(packet));
        packet.message.arguments = [`message-${i}-b`];
        dispatch(actions.messageAdd(packet));
        dispatch(actions.messageAdd(packetGroupEnd));
      }

      const messages = getAllMessagesById(getState());
      // We should have three times the logLimit since each group has two message inside.
      expect(messages.size).toBe(logLimit * 3);

      // We should have logLimit number of groups
      const groups = getAllGroupsById(getState());
      expect(groups.count()).toBe(logLimit);

      expect(messages.first().parameters[0]).toBe(`group-2`);
      expect(messages.last().parameters[0]).toBe(`message-${logLimit + 1}-b`);

      const visibleMessages = getVisibleMessages(getState());
      expect(visibleMessages.length).toBe(logLimit);
      const lastVisibleMessage = visibleMessages[visibleMessages.length - 1];
      expect(lastVisibleMessage.parameters[0]).toBe(`group-${logLimit + 1}`);
    });

    it("does not add null messages to the store", () => {
      const { dispatch, getState } = setupStore([]);

      const message = stubPackets.get("console.time('bar')");
      dispatch(actions.messageAdd(message));

      const messages = getAllMessagesById(getState());
      expect(messages.size).toBe(0);
    });

    it("adds console.table call with unsupported type as console.log", () => {
      const { dispatch, getState } = setupStore([]);

      const packet = stubPackets.get("console.table('bar')");
      dispatch(actions.messageAdd(packet));

      const messages = getAllMessagesById(getState());
      const tableMessage = messages.last();
      expect(tableMessage.level).toEqual(MESSAGE_TYPE.LOG);
    });

    it("adds console.group messages to the store", () => {
      const { dispatch, getState } = setupStore([]);

      const message = stubPackets.get("console.group('bar')");
      dispatch(actions.messageAdd(message));

      const messages = getAllMessagesById(getState());
      expect(messages.size).toBe(1);
    });

    it("sets groupId property as expected", () => {
      const { dispatch, getState } = setupStore([]);

      dispatch(actions.messageAdd(
        stubPackets.get("console.group('bar')")));

      const packet = stubPackets.get("console.log('foobar', 'test')");
      dispatch(actions.messageAdd(packet));

      const messages = getAllMessagesById(getState());
      expect(messages.size).toBe(2);
      expect(messages.last().groupId).toBe(messages.first().id);
    });

    it("does not display console.groupEnd messages to the store", () => {
      const { dispatch, getState } = setupStore([]);

      const message = stubPackets.get("console.groupEnd('bar')");
      dispatch(actions.messageAdd(message));

      const messages = getAllMessagesById(getState());
      expect(messages.size).toBe(0);
    });

    it("filters out message added after a console.groupCollapsed message", () => {
      const { dispatch, getState } = setupStore([]);

      const message = stubPackets.get("console.groupCollapsed('foo')");
      dispatch(actions.messageAdd(message));

      dispatch(actions.messageAdd(
        stubPackets.get("console.log('foobar', 'test')")));

      const messages = getVisibleMessages(getState());
      expect(messages.length).toBe(1);
    });

    it("adds console.dirxml call as console.log", () => {
      const { dispatch, getState } = setupStore([]);

      const packet = stubPackets.get("console.dirxml(window)");
      dispatch(actions.messageAdd(packet));

      const messages = getAllMessagesById(getState());
      const dirxmlMessage = messages.last();
      expect(dirxmlMessage.level).toEqual(MESSAGE_TYPE.LOG);
    });
  });

  describe("messagesUiById", () => {
    it("opens console.trace messages when they are added", () => {
      const { dispatch, getState } = setupStore([]);

      const message = stubPackets.get("console.trace()");
      dispatch(actions.messageAdd(message));

      const messages = getAllMessagesById(getState());
      const messagesUi = getAllMessagesUiById(getState());
      expect(messagesUi.size).toBe(1);
      expect(messagesUi.first()).toBe(messages.first().id);
    });

    it("clears the messages UI list in response to MESSAGES_CLEAR action", () => {
      const { dispatch, getState } = setupStore([
        "console.log('foobar', 'test')",
        "console.log(undefined)"
      ]);

      const traceMessage = stubPackets.get("console.trace()");
      dispatch(actions.messageAdd(traceMessage));

      dispatch(actions.messagesClear());

      const messagesUi = getAllMessagesUiById(getState());
      expect(messagesUi.size).toBe(0);
    });

    it("opens console.group messages when they are added", () => {
      const { dispatch, getState } = setupStore([]);

      const message = stubPackets.get("console.group('bar')");
      dispatch(actions.messageAdd(message));

      const messages = getAllMessagesById(getState());
      const messagesUi = getAllMessagesUiById(getState());
      expect(messagesUi.size).toBe(1);
      expect(messagesUi.first()).toBe(messages.first().id);
    });

    it("does not open console.groupCollapsed messages when they are added", () => {
      const { dispatch, getState } = setupStore([]);

      const message = stubPackets.get("console.groupCollapsed('foo')");
      dispatch(actions.messageAdd(message));

      const messagesUi = getAllMessagesUiById(getState());
      expect(messagesUi.size).toBe(0);
    });
  });

  describe("currentGroup", () => {
    it("sets the currentGroup when console.group message is added", () => {
      const { dispatch, getState } = setupStore([]);

      const packet = stubPackets.get("console.group('bar')");
      dispatch(actions.messageAdd(packet));

      const messages = getAllMessagesById(getState());
      const currentGroup = getCurrentGroup(getState());
      expect(currentGroup).toBe(messages.first().id);
    });

    it("sets currentGroup to expected value when console.groupEnd is added", () => {
      const { dispatch, getState } = setupStore([
        "console.group('bar')",
        "console.groupCollapsed('foo')"
      ]);

      let messages = getAllMessagesById(getState());
      let currentGroup = getCurrentGroup(getState());
      expect(currentGroup).toBe(messages.last().id);

      const endFooPacket = stubPackets.get("console.groupEnd('foo')");
      dispatch(actions.messageAdd(endFooPacket));
      messages = getAllMessagesById(getState());
      currentGroup = getCurrentGroup(getState());
      expect(currentGroup).toBe(messages.first().id);

      const endBarPacket = stubPackets.get("console.groupEnd('bar')");
      dispatch(actions.messageAdd(endBarPacket));
      messages = getAllMessagesById(getState());
      currentGroup = getCurrentGroup(getState());
      expect(currentGroup).toBe(null);
    });

    it("resets the currentGroup to null in response to MESSAGES_CLEAR action", () => {
      const { dispatch, getState } = setupStore([
        "console.group('bar')"
      ]);

      dispatch(actions.messagesClear());

      const currentGroup = getCurrentGroup(getState());
      expect(currentGroup).toBe(null);
    });
  });

  describe("groupsById", () => {
    it("adds the group with expected array when console.group message is added", () => {
      const { dispatch, getState } = setupStore([]);

      const barPacket = stubPackets.get("console.group('bar')");
      dispatch(actions.messageAdd(barPacket));

      let messages = getAllMessagesById(getState());
      let groupsById = getAllGroupsById(getState());
      expect(groupsById.size).toBe(1);
      expect(groupsById.has(messages.first().id)).toBe(true);
      expect(groupsById.get(messages.first().id)).toEqual([]);

      const fooPacket = stubPackets.get("console.groupCollapsed('foo')");
      dispatch(actions.messageAdd(fooPacket));
      messages = getAllMessagesById(getState());
      groupsById = getAllGroupsById(getState());
      expect(groupsById.size).toBe(2);
      expect(groupsById.has(messages.last().id)).toBe(true);
      expect(groupsById.get(messages.last().id)).toEqual([messages.first().id]);
    });

    it("resets groupsById in response to MESSAGES_CLEAR action", () => {
      const { dispatch, getState } = setupStore([
        "console.group('bar')",
        "console.groupCollapsed('foo')",
      ]);

      let groupsById = getAllGroupsById(getState());
      expect(groupsById.size).toBe(2);

      dispatch(actions.messagesClear());

      groupsById = getAllGroupsById(getState());
      expect(groupsById.size).toBe(0);
    });
  });

  describe("networkMessagesUpdateById", () => {
    it("adds the network update message when network update action is called", () => {
      const { dispatch, getState } = setupStore([
        "GET request",
        "XHR GET request"
      ]);

      let networkUpdates = getAllNetworkMessagesUpdateById(getState());
      expect(Object.keys(networkUpdates).length).toBe(0);

      let updatePacket = stubPackets.get("GET request update");
      dispatch(actions.networkMessageUpdate(updatePacket));

      networkUpdates = getAllNetworkMessagesUpdateById(getState());
      expect(Object.keys(networkUpdates).length).toBe(1);

      let xhrUpdatePacket = stubPackets.get("XHR GET request update");
      dispatch(actions.networkMessageUpdate(xhrUpdatePacket));

      networkUpdates = getAllNetworkMessagesUpdateById(getState());
      expect(Object.keys(networkUpdates).length).toBe(2);
    });

    it("resets networkMessagesUpdateById in response to MESSAGES_CLEAR action", () => {
      const { dispatch, getState } = setupStore([
        "XHR GET request"
      ]);

      const updatePacket = stubPackets.get("XHR GET request update");
      dispatch(actions.networkMessageUpdate(updatePacket));

      let networkUpdates = getAllNetworkMessagesUpdateById(getState());
      expect(Object.keys(networkUpdates).length).toBe(1);

      dispatch(actions.messagesClear());

      networkUpdates = getAllNetworkMessagesUpdateById(getState());
      expect(Object.keys(networkUpdates).length).toBe(0);
    });
  });
});
