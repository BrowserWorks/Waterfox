/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const ChromeUtils = require("ChromeUtils");
const { OS } = ChromeUtils.import("resource://gre/modules/osfile.jsm");

const {
  getAdHocFrontOrPrimitiveGrip,
} = require("devtools/client/fronts/object");

const CHROME_PREFIX = "chrome://mochitests/content/browser/";
const STUBS_FOLDER = "devtools/client/webconsole/test/node/fixtures/stubs/";
const STUBS_UPDATE_ENV = "WEBCONSOLE_STUBS_UPDATE";

async function createResourceWatcherForTab(tab) {
  // Avoid mocha to try to load these module and fail while doing it when running node tests
  const {
    ResourceWatcher,
  } = require("devtools/shared/resources/resource-watcher");
  const { TargetList } = require("devtools/shared/resources/target-list");
  const { TargetFactory } = require("devtools/client/framework/target");

  const target = await TargetFactory.forTab(tab);
  const targetList = new TargetList(target.client.mainRoot, target);

  await target.attach();
  // Attach the thread actor in order to ensure having sources
  // and have the `sourceId` attribute correctly set.
  const threadFront = await target.attachThread({});
  // Resume the thread, otherwise it stays pause and we prevent JS from running
  await threadFront.resume();

  await targetList.startListening();
  return new ResourceWatcher(targetList);
}

// eslint-disable-next-line complexity
function getCleanedPacket(key, packet) {
  const { stubPackets } = require(CHROME_PREFIX + STUBS_FOLDER + "index");

  // Strip escaped characters.
  const safeKey = key
    .replace(/\\n/g, "\n")
    .replace(/\\r/g, "\r")
    .replace(/\\\"/g, `\"`)
    .replace(/\\\'/g, `\'`);

  cleanTimeStamp(packet);
  // Remove the targetFront property that has a cyclical reference and that we don't need
  // in our node tests.
  delete packet.targetFront;

  if (!stubPackets.has(safeKey)) {
    return packet;
  }

  // If the stub already exist, we want to ignore irrelevant properties (actor, timer, …)
  // that might changed and "pollute" the diff resulting from this stub generation.
  const existingPacket = stubPackets.get(safeKey);
  const res = Object.assign({}, packet, {
    from: existingPacket.from,
  });

  if (res.innerWindowID) {
    res.innerWindowID = existingPacket.innerWindowID;
  }

  if (res.startedDateTime) {
    res.startedDateTime = existingPacket.startedDateTime;
  }

  if (res.actor) {
    res.actor = existingPacket.actor;
  }

  if (res.channelId) {
    res.channelId = existingPacket.channelId;
  }

  if (res.resultID) {
    res.resultID = existingPacket.resultID;
  }

  if (res.message) {
    if (res.message.timer) {
      // Clean timer properties on the message.
      // Those properties are found on console.time, timeLog and timeEnd calls,
      // and those time can vary, which is why we need to clean them.
      if ("duration" in res.message.timer) {
        res.message.timer.duration = existingPacket.message.timer.duration;
      }
    }
    // Clean innerWindowId on the message prop.
    res.message.innerWindowID = existingPacket.message.innerWindowID;

    if (Array.isArray(res.message.arguments)) {
      res.message.arguments = res.message.arguments.map((argument, i) => {
        if (!argument || typeof argument !== "object") {
          return argument;
        }

        const newArgument = Object.assign({}, argument);
        const existingArgument = existingPacket.message.arguments[i];

        if (existingArgument && newArgument._grip) {
          // Clean actor ids on each message.arguments item.
          copyExistingActor(newArgument, existingArgument);

          // `window`'s properties count can vary from OS to OS, so we
          // clean the `ownPropertyLength` property from the grip.
          if (newArgument._grip.class === "Window") {
            newArgument._grip.ownPropertyLength =
              existingArgument._grip.ownPropertyLength;
          }
        }
        return newArgument;
      });
    }

    if (res.message.sourceId) {
      res.message.sourceId = existingPacket.message.sourceId;
    }

    if (Array.isArray(res.message.stacktrace)) {
      res.message.stacktrace = res.message.stacktrace.map((frame, i) => {
        const existingFrame = existingPacket.message.stacktrace[i];
        if (frame && existingFrame && frame.sourceId) {
          frame.sourceId = existingFrame.sourceId;
        }
        return frame;
      });
    }
  }

  if (res?.exception?.actor && existingPacket.exception.actor) {
    // Clean actor ids on evaluation exception
    copyExistingActor(res.exception, existingPacket.exception);
  }

  if (res.result && res.result._grip && existingPacket.result) {
    // Clean actor ids on evaluation result messages.
    copyExistingActor(res.result, existingPacket.result);
  }

  if (
    res?.result?._grip?.promiseState?.reason &&
    existingPacket?.result?._grip?.promiseState?.reason
  ) {
    // Clean actor ids on evaluation promise result messages.
    copyExistingActor(
      res.result._grip.promiseState.reason,
      existingPacket.result._grip.promiseState.reason
    );
  }

  if (
    res?.result?._grip?.promiseState?.timeToSettle &&
    existingPacket?.result?._grip?.promiseState?.timeToSettle
  ) {
    res.result._grip.promiseState.timeToSettle =
      existingPacket.result._grip.promiseState.timeToSettle;
  }

  if (res.exception && existingPacket.exception) {
    // Clean actor ids on exception messages.
    copyExistingActor(res.exception, existingPacket.exception);

    if (
      res.exception._grip &&
      res.exception._grip.preview &&
      existingPacket.exception._grip &&
      existingPacket.exception._grip.preview
    ) {
      if (
        typeof res.exception._grip.preview.message === "object" &&
        res.exception._grip.preview.message._grip.type === "longString" &&
        typeof existingPacket.exception._grip.preview.message === "object" &&
        existingPacket.exception._grip.preview.message._grip.type ===
          "longString"
      ) {
        copyExistingActor(
          res.exception._grip.preview.message,
          existingPacket.exception._grip.preview.message
        );
      }
    }

    if (
      typeof res.exceptionMessage === "object" &&
      res.exceptionMessage._grip &&
      res.exceptionMessage._grip.type === "longString"
    ) {
      copyExistingActor(res.exceptionMessage, existingPacket.exceptionMessage);
    }
  }

  if (res.eventActor) {
    // Clean actor ids and startedDateTime on network messages.
    res.eventActor.actor = existingPacket.eventActor.actor;
    res.eventActor.startedDateTime = existingPacket.eventActor.startedDateTime;
  }

  if (res.pageError) {
    // Clean innerWindowID on pageError messages.
    res.pageError.innerWindowID = existingPacket.pageError.innerWindowID;

    if (
      typeof res.pageError.errorMessage === "object" &&
      res.pageError.errorMessage._grip &&
      res.pageError.errorMessage._grip.type === "longString"
    ) {
      copyExistingActor(
        res.pageError.errorMessage,
        existingPacket.pageError.errorMessage
      );
    }

    if (
      res.pageError.exception?._grip?.preview?.message?._grip &&
      existingPacket.pageError.exception?._grip?.preview?.message?._grip
    ) {
      copyExistingActor(
        res.pageError.exception._grip.preview.message,
        existingPacket.pageError.exception._grip.preview.message
      );
    }

    if (res.pageError.exception && existingPacket.pageError.exception) {
      copyExistingActor(
        res.pageError.exception,
        existingPacket.pageError.exception
      );
    }

    if (res.pageError.sourceId) {
      res.pageError.sourceId = existingPacket.pageError.sourceId;
    }

    if (
      Array.isArray(res.pageError.stacktrace) &&
      Array.isArray(existingPacket.pageError.stacktrace)
    ) {
      res.pageError.stacktrace = res.pageError.stacktrace.map((frame, i) => {
        const existingFrame = existingPacket.pageError.stacktrace[i];
        if (frame && existingFrame && frame.sourceId) {
          frame.sourceId = existingFrame.sourceId;
        }
        return frame;
      });
    }
  }

  if (Array.isArray(res.exceptionStack)) {
    res.exceptionStack = res.exceptionStack.map((frame, i) => {
      const existingFrame = existingPacket.exceptionStack[i];
      if (frame && existingFrame && frame.sourceId) {
        frame.sourceId = existingFrame.sourceId;
      }
      return frame;
    });
  }

  if (res.frame && existingPacket.frame) {
    res.frame.sourceId = existingPacket.frame.sourceId;
  }

  if (res.packet) {
    const override = {};
    const keys = ["totalTime", "from", "contentSize", "transferredSize"];
    keys.forEach(x => {
      if (res.packet[x] !== undefined) {
        override[x] = existingPacket.packet[key];
      }
    });
    res.packet = Object.assign({}, res.packet, override);
  }

  if (res.networkInfo) {
    if (res.networkInfo.startedDateTime) {
      res.networkInfo.startedDateTime =
        existingPacket.networkInfo.startedDateTime;
    }

    if (res.networkInfo.totalTime) {
      res.networkInfo.totalTime = existingPacket.networkInfo.totalTime;
    }

    if (res.networkInfo.actor) {
      res.networkInfo.actor = existingPacket.networkInfo.actor;
    }

    if (res.networkInfo.request && res.networkInfo.request.headersSize) {
      res.networkInfo.request.headersSize =
        existingPacket.networkInfo.request.headersSize;
    }

    if (
      res.networkInfo.response &&
      res.networkInfo.response.headersSize !== undefined
    ) {
      res.networkInfo.response.headersSize =
        existingPacket.networkInfo.response.headersSize;
    }
    if (
      res.networkInfo.response &&
      res.networkInfo.response.bodySize !== undefined
    ) {
      res.networkInfo.response.bodySize =
        existingPacket.networkInfo.response.bodySize;
    }
    if (
      res.networkInfo.response &&
      res.networkInfo.response.transferredSize !== undefined
    ) {
      res.networkInfo.response.transferredSize =
        existingPacket.networkInfo.response.transferredSize;
    }
  }

  if (res.updates && Array.isArray(res.updates)) {
    res.updates.sort();
  }

  if (res.helperResult) {
    copyExistingActor(
      res.helperResult.object,
      existingPacket.helperResult.object
    );
  }

  return res;
}

function cleanTimeStamp(packet) {
  // We want to have the same timestamp for every stub, so they won't be re-sorted when
  // adding them to the store.
  const uniqueTimeStamp = 1572867483805;

  if (packet.timestamp) {
    packet.timestamp = uniqueTimeStamp;
  }

  if (packet.timeStamp) {
    packet.timeStamp = uniqueTimeStamp;
  }

  if (packet.startTime) {
    packet.startTime = uniqueTimeStamp;
  }

  if (packet?.message?.timeStamp) {
    packet.message.timeStamp = uniqueTimeStamp;
  }

  if (packet?.result?._grip?.preview?.timestamp) {
    packet.result._grip.preview.timestamp = uniqueTimeStamp;
  }

  if (packet?.result?._grip?.promiseState?.creationTimestamp) {
    packet.result._grip.promiseState.creationTimestamp = uniqueTimeStamp;
  }

  if (packet?.exception?._grip?.preview?.timestamp) {
    packet.exception._grip.preview.timestamp = uniqueTimeStamp;
  }

  if (packet?.eventActor?.timeStamp) {
    packet.eventActor.timeStamp = uniqueTimeStamp;
  }

  if (packet?.pageError?.timeStamp) {
    packet.pageError.timeStamp = uniqueTimeStamp;
  }

  if (packet?.networkInfo?.timeStamp) {
    packet.networkInfo.timeStamp = uniqueTimeStamp;
  }
}

function copyExistingActor(a, b) {
  if (!a || !b) {
    return;
  }

  if (a.actorID && b.actorID) {
    a.actorID = b.actorID;
  }

  if (a.actor && b.actor) {
    a.actor = b.actor;
  }

  if (a._grip && b._grip && a._grip.actor && b._grip.actor) {
    a._grip.actor = b._grip.actor;
  }
}

/**
 * Write stubs to a given file
 *
 * @param {Object} env
 * @param {String} fileName: The file to write the stubs in.
 * @param {Map} packets: A Map of the packets.
 * @param {Boolean} isNetworkMessage: Is the packets are networkMessage packets
 */
async function writeStubsToFile(env, fileName, packets, isNetworkMessage) {
  const mozRepo = env.get("MOZ_DEVELOPER_REPO_DIR");
  const filePath = `${mozRepo}/${STUBS_FOLDER + fileName}`;

  const serializedPackets = Array.from(packets.entries()).map(
    ([key, packet]) => {
      const stringifiedPacket = getSerializedPacket(packet);
      return `rawPackets.set(\`${key}\`, ${stringifiedPacket});`;
    }
  );

  const fileContent = `/* Any copyright is dedicated to the Public Domain.
  http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable max-len */

"use strict";

/*
 * THIS FILE IS AUTOGENERATED. DO NOT MODIFY BY HAND. RUN TESTS IN FIXTURES/ TO UPDATE.
 */

const {
  parsePacketsWithFronts,
} = require("chrome://mochitests/content/browser/devtools/client/webconsole/test/browser/stub-generator-helpers");
const { prepareMessage } = require("devtools/client/webconsole/utils/messages");
const {
  ConsoleMessage,
  NetworkEventMessage,
} = require("devtools/client/webconsole/types");

const rawPackets = new Map();
${serializedPackets.join("\n\n")}


const stubPackets = parsePacketsWithFronts(rawPackets);

const stubPreparedMessages = new Map();
for (const [key, packet] of Array.from(stubPackets.entries())) {
  const transformedPacket = prepareMessage(${
    isNetworkMessage ? "packet.networkInfo || packet" : "packet"
  }, {
    getNextId: () => "1",
  });
  const message = ${
    isNetworkMessage
      ? "NetworkEventMessage(transformedPacket);"
      : "ConsoleMessage(transformedPacket);"
  }
  stubPreparedMessages.set(key, message);
}

module.exports = {
  rawPackets,
  stubPreparedMessages,
  stubPackets,
};
`;

  await OS.File.writeAtomic(filePath, fileContent);
}

function getStubFile(fileName) {
  return require(CHROME_PREFIX + STUBS_FOLDER + fileName);
}

function getSerializedPacket(packet) {
  return JSON.stringify(
    packet,
    function(_, value) {
      // The message can have fronts that we need to serialize
      if (value && value._grip) {
        return { _grip: value._grip, actorID: value.actorID };
      }

      return value;
    },
    2
  );
}

/**
 *
 * @param {Map} rawPackets
 */
function parsePacketsWithFronts(rawPackets) {
  const packets = new Map();
  for (const [key, packet] of rawPackets.entries()) {
    const newPacket = parsePacketAndCreateFronts(packet);
    packets.set(key, newPacket);
  }
  return packets;
}

function parsePacketAndCreateFronts(packet) {
  if (!packet) {
    return packet;
  }
  if (Array.isArray(packet)) {
    packet.forEach(parsePacketAndCreateFronts);
  }
  if (typeof packet === "object") {
    for (const [key, value] of Object.entries(packet)) {
      if (value?._grip) {
        // The message of an error grip might be a longString.
        if (value._grip?.preview?.message?._grip) {
          value._grip.preview.message = value._grip.preview.message._grip;
        }

        packet[key] = getAdHocFrontOrPrimitiveGrip(value._grip, {
          conn: {
            poolFor: () => {},
            addActorPool: () => {},
            getFrontByID: () => {},
          },
          manage: () => {},
        });
      } else {
        packet[key] = parsePacketAndCreateFronts(value);
      }
    }
  }

  return packet;
}

module.exports = {
  STUBS_UPDATE_ENV,
  createResourceWatcherForTab,
  getStubFile,
  getCleanedPacket,
  getSerializedPacket,
  parsePacketsWithFronts,
  writeStubsToFile,
};
