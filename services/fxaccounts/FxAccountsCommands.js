/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const EXPORTED_SYMBOLS = ["SendTab", "FxAccountsCommands"];

const { COMMAND_SENDTAB, COMMAND_SENDTAB_TAIL, log } = ChromeUtils.import(
  "resource://gre/modules/FxAccountsCommon.js"
);
ChromeUtils.defineModuleGetter(
  this,
  "PushCrypto",
  "resource://gre/modules/PushCrypto.jsm"
);
const { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
const { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
const { Observers } = ChromeUtils.import(
  "resource://services-common/observers.js"
);

XPCOMUtils.defineLazyModuleGetters(this, {
  BulkKeyBundle: "resource://services-sync/keys.js",
  CommonUtils: "resource://services-common/utils.js",
  CryptoUtils: "resource://services-crypto/utils.js",
  CryptoWrapper: "resource://services-sync/record.js",
});

class FxAccountsCommands {
  constructor(fxAccountsInternal) {
    this._fxai = fxAccountsInternal;
    this.sendTab = new SendTab(this, fxAccountsInternal);
  }

  async availableCommands() {
    if (
      !Services.prefs.getBoolPref("identity.fxaccounts.commands.enabled", true)
    ) {
      return {};
    }
    const sendTabKey = await this.sendTab.getEncryptedKey();
    if (!sendTabKey) {
      // This will happen if the account is not verified yet.
      return {};
    }
    return {
      [COMMAND_SENDTAB]: sendTabKey,
    };
  }

  async invoke(command, device, payload) {
    const { sessionToken } = await this._fxai.getUserAccountData([
      "sessionToken",
    ]);
    const client = this._fxai.fxAccountsClient;
    await client.invokeCommand(sessionToken, command, device.id, payload);
    log.info(`Payload sent to device ${device.id}.`);
  }

  /**
   * Poll and handle device commands for the current device.
   * This method can be called either in response to a Push message,
   * or by itself as a "commands recovery" mechanism.
   *
   * @param {Number} receivedIndex "Command received" push messages include
   * the index of the command that triggered the message. We use it as a
   * hint when we have no "last command index" stored.
   */
  async pollDeviceCommands(receivedIndex = 0) {
    // Whether the call to `pollDeviceCommands` was initiated by a Push message from the FxA
    // servers in response to a message being received or simply scheduled in order
    // to fetch missed messages.
    const scheduledFetch = receivedIndex == 0;
    if (
      !Services.prefs.getBoolPref("identity.fxaccounts.commands.enabled", true)
    ) {
      return false;
    }
    log.info(`Polling device commands.`);
    await this._fxai.withCurrentAccountState(async state => {
      const { device } = await state.getUserAccountData(["device"]);
      if (!device) {
        throw new Error("No device registration.");
      }
      // We increment lastCommandIndex by 1 because the server response includes the current index.
      // If we don't have a `lastCommandIndex` stored, we fall back on the index from the push message we just got.
      const lastCommandIndex = device.lastCommandIndex + 1 || receivedIndex;
      // We have already received this message before.
      if (receivedIndex > 0 && receivedIndex < lastCommandIndex) {
        return;
      }
      const { index, messages } = await this._fetchDeviceCommands(
        lastCommandIndex
      );
      if (messages.length) {
        await state.updateUserAccountData({
          device: { ...device, lastCommandIndex: index },
        });
        log.info(`Handling ${messages.length} messages`);
        if (scheduledFetch) {
          Services.telemetry.scalarAdd(
            "identity.fxaccounts.missed_commands_fetched",
            messages.length
          );
        }
        await this._handleCommands(messages);
      }
    });
    return true;
  }

  async _fetchDeviceCommands(index, limit = null) {
    const userData = await this._fxai.getUserAccountData();
    if (!userData) {
      throw new Error("No user.");
    }
    const { sessionToken } = userData;
    if (!sessionToken) {
      throw new Error("No session token.");
    }
    const client = this._fxai.fxAccountsClient;
    const opts = { index };
    if (limit != null) {
      opts.limit = limit;
    }
    return client.getCommands(sessionToken, opts);
  }

  async _handleCommands(messages) {
    try {
      await this._fxai.device.refreshDeviceList();
    } catch (e) {
      log.warn("Error refreshing device list", e);
    }
    // We debounce multiple incoming tabs so we show a single notification.
    const tabsReceived = [];
    for (const { data } of messages) {
      const { command, payload, sender: senderId } = data;
      const sender =
        senderId && this._fxai.device.recentDeviceList
          ? this._fxai.device.recentDeviceList.find(d => d.id == senderId)
          : null;
      if (!sender) {
        log.warn(
          "Incoming command is from an unknown device (maybe disconnected?)"
        );
      }
      switch (command) {
        case COMMAND_SENDTAB:
          try {
            const { title, uri } = await this.sendTab.handle(senderId, payload);
            log.info(
              `Tab received with FxA commands: ${title} from ${
                sender ? sender.name : "Unknown device"
              }.`
            );
            tabsReceived.push({ title, uri, sender });
          } catch (e) {
            log.error(`Error while handling incoming Send Tab payload.`, e);
          }
          break;
        default:
          log.info(`Unknown command: ${command}.`);
      }
    }
    if (tabsReceived.length) {
      Observers.notify("fxaccounts:commands:open-uri", tabsReceived);
    }
  }
}

/**
 * Send Tab is built on top of FxA commands.
 *
 * Devices exchange keys wrapped in kSync between themselves (getEncryptedKey)
 * during the device registration flow. The FxA server can theorically never
 * retrieve the send tab keys since it doesn't know kSync.
 */
class SendTab {
  constructor(commands, fxAccountsInternal) {
    this._commands = commands;
    this._fxai = fxAccountsInternal;
  }
  /**
   * @param {Device[]} to - Device objects (typically returned by fxAccounts.getDevicesList()).
   * @param {Object} tab
   * @param {string} tab.url
   * @param {string} tab.title
   * @returns A report object, in the shape of
   *          {succeded: [Device], error: [{device: Device, error: Exception}]}
   */
  async send(to, tab) {
    log.info(`Sending a tab to ${to.length} devices.`);
    const flowID = this._fxai.telemetry.generateFlowID();
    const encoder = new TextEncoder("utf8");
    const data = { entries: [{ title: tab.title, url: tab.url }] };
    const bytes = encoder.encode(JSON.stringify(data));
    const report = {
      succeeded: [],
      failed: [],
    };
    for (let device of to) {
      try {
        const encrypted = await this._encrypt(bytes, device);
        const payload = { encrypted, flowID };
        await this._commands.invoke(COMMAND_SENDTAB, device, payload); // FxA needs an object.
        this._fxai.telemetry.recordEvent(
          "command-sent",
          COMMAND_SENDTAB_TAIL,
          this._fxai.telemetry.sanitizeDeviceId(device.id),
          { flowID }
        );
        report.succeeded.push(device);
      } catch (error) {
        log.error("Error while invoking a send tab command.", error);
        report.failed.push({ device, error });
      }
    }
    return report;
  }

  // Returns true if the target device is compatible with FxA Commands Send tab.
  isDeviceCompatible(device) {
    return (
      Services.prefs.getBoolPref(
        "identity.fxaccounts.commands.enabled",
        true
      ) &&
      device.availableCommands &&
      device.availableCommands[COMMAND_SENDTAB]
    );
  }

  // Handle incoming send tab payload, called by FxAccountsCommands.
  async handle(senderID, { encrypted, flowID }) {
    const bytes = await this._decrypt(encrypted);
    const decoder = new TextDecoder("utf8");
    const data = JSON.parse(decoder.decode(bytes));
    const current = data.hasOwnProperty("current")
      ? data.current
      : data.entries.length - 1;
    const { title, url: uri } = data.entries[current];
    this._fxai.telemetry.recordEvent(
      "command-received",
      COMMAND_SENDTAB_TAIL,
      this._fxai.telemetry.sanitizeDeviceId(senderID),
      { flowID }
    );

    return {
      title,
      uri,
    };
  }

  async _encrypt(bytes, device) {
    let bundle = device.availableCommands[COMMAND_SENDTAB];
    if (!bundle) {
      throw new Error(`Device ${device.id} does not have send tab keys.`);
    }
    const { kSync, kXCS: ourKid } = await this._fxai.keys.getKeys();
    const { kid: theirKid } = JSON.parse(
      device.availableCommands[COMMAND_SENDTAB]
    );
    if (theirKid != ourKid) {
      throw new Error("Target Send Tab key ID is different from ours");
    }
    const json = JSON.parse(bundle);
    const wrapper = new CryptoWrapper();
    wrapper.deserialize({ payload: json });
    const syncKeyBundle = BulkKeyBundle.fromHexKey(kSync);
    let { publicKey, authSecret } = await wrapper.decrypt(syncKeyBundle);
    authSecret = urlsafeBase64Decode(authSecret);
    publicKey = urlsafeBase64Decode(publicKey);

    const { ciphertext: encrypted } = await PushCrypto.encrypt(
      bytes,
      publicKey,
      authSecret
    );
    return urlsafeBase64Encode(encrypted);
  }

  async _getPersistedKeys() {
    const { device } = await this._fxai.getUserAccountData(["device"]);
    return device && device.sendTabKeys;
  }

  async _decrypt(ciphertext) {
    let { privateKey, publicKey, authSecret } = await this._getPersistedKeys();
    publicKey = urlsafeBase64Decode(publicKey);
    authSecret = urlsafeBase64Decode(authSecret);
    ciphertext = new Uint8Array(urlsafeBase64Decode(ciphertext));
    return PushCrypto.decrypt(
      privateKey,
      publicKey,
      authSecret,
      // The only Push encoding we support.
      { encoding: "aes128gcm" },
      ciphertext
    );
  }

  async _generateAndPersistKeys() {
    let [publicKey, privateKey] = await PushCrypto.generateKeys();
    publicKey = urlsafeBase64Encode(publicKey);
    let authSecret = PushCrypto.generateAuthenticationSecret();
    authSecret = urlsafeBase64Encode(authSecret);
    const sendTabKeys = {
      publicKey,
      privateKey,
      authSecret,
    };
    await this._fxai.withCurrentAccountState(async state => {
      const { device } = await state.getUserAccountData(["device"]);
      await state.updateUserAccountData({
        device: {
          ...device,
          sendTabKeys,
        },
      });
    });
    return sendTabKeys;
  }

  async getEncryptedKey() {
    let sendTabKeys = await this._getPersistedKeys();
    if (!sendTabKeys) {
      sendTabKeys = await this._generateAndPersistKeys();
    }
    // Strip the private key from the bundle to encrypt.
    const keyToEncrypt = {
      publicKey: sendTabKeys.publicKey,
      authSecret: sendTabKeys.authSecret,
    };
    // getEncryptedKey() will be called as part of device registration, which
    // happens immediately after signup/signin, so there's a good chance we
    // don't yet have kSync et. al. Unverified users will be unable to fetch
    // keys, meaning they will end up registering the device twice (once without
    // sendtab support, then once with sendtab support when they verify), but
    // that's OK.
    if (!(await this._fxai.keys.canGetKeys())) {
      log.info("Can't fetch keys, so unable to determine sendtab keys");
      return null;
    }
    let kSync, kXCS;
    try {
      ({ kSync, kXCS } = await this._fxai.keys.getKeys());
      if (!kSync || !kXCS) {
        log.warn(
          "Fetched the keys but didn't get any, so unable to determine sendtab keys"
        );
        return null;
      }
    } catch (ex) {
      log.warn("Failed to fetch keys, so unable to determine sendtab keys", ex);
      return null;
    }
    const wrapper = new CryptoWrapper();
    wrapper.cleartext = keyToEncrypt;
    const keyBundle = BulkKeyBundle.fromHexKey(kSync);
    await wrapper.encrypt(keyBundle);
    return JSON.stringify({
      kid: kXCS,
      IV: wrapper.IV,
      hmac: wrapper.hmac,
      ciphertext: wrapper.ciphertext,
    });
  }
}

function urlsafeBase64Encode(buffer) {
  return ChromeUtils.base64URLEncode(new Uint8Array(buffer), { pad: false });
}

function urlsafeBase64Decode(str) {
  return ChromeUtils.base64URLDecode(str, { padding: "reject" });
}
