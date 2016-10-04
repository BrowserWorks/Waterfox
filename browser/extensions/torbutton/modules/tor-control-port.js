// A module for TorBrowser that provides an asynchronous controller for
// Tor, through its ControlPort.
//
// This file is written in call stack order (later functions
// call earlier functions). The file can be processed
// with docco.js to produce pretty documentation.
//
// To import the module, use
//
//  let { controller } = Components.utils.import("path/to/tor-control-port.js");
//
// See the last function defined in this file:
//   controller(socketFile, host, port, password, onError)
// for usage of the controller function.

/* jshint esnext: true */
/* jshint -W097 */
/* global Components, console, Services */
"use strict";

// ### Mozilla Abbreviations
let {classes: Cc, interfaces: Ci, results: Cr, Constructor: CC, utils: Cu } = Components;

// ### Import Mozilla Services
Cu.import("resource://gre/modules/Services.jsm");

// __log__.
// Logging function
let log;
if ((typeof console) !== "undefined") {
  log = x => console.log(typeof(x) === "string" ? x.trimRight().replace(/\r\n/g, "\n") : JSON.stringify(x));
} else {
  let logger = Cc["@torproject.org/torbutton-logger;1"]
                 .getService(Components.interfaces.nsISupports).wrappedJSObject;
  log = x => logger.eclog(3, x.trimRight().replace(/\r\n/g, "\n"));
}

// ### announce this file
log("Loading tor-control-port.js\n");

// ## io
// I/O utilities namespace
let io = {};

// __io.asyncSocketStreams(socketFile, host, port)__.
// Creates a pair of asynchronous input and output streams for a socket at the
// given socketFile or host and port.
io.asyncSocketStreams = function (socketFile, host, port) {
  let sts = Cc["@mozilla.org/network/socket-transport-service;1"]
              .getService(Components.interfaces.nsISocketTransportService),
	  UNBUFFERED = Ci.nsITransport.OPEN_UNBUFFERED;

  // Create an instance of a socket transport.
  let socketTransport;
  if (socketFile) {
    socketTransport = sts.createUnixDomainTransport(socketFile);
  } else {
    socketTransport = sts.createTransport(null, 0, host, port, null);
  }

  // Open unbuffered asynchronous outputStream.
  let outputStream = socketTransport.openOutputStream(UNBUFFERED, 1, 1)
                      .QueryInterface(Ci.nsIAsyncOutputStream),
      // Open unbuffered asynchronous inputStream.
      inputStream = socketTransport.openInputStream(UNBUFFERED, 1, 1)
                      .QueryInterface(Ci.nsIAsyncInputStream);
  return [inputStream, outputStream];
};

// __io.pumpInputStream(scriptableInputStream, onInputData, onError)__.
// Run an "input stream pump" that takes an input stream and
// asynchronously pumps incoming data to the onInputData callback.
io.pumpInputStream = function (inputStream, onInputData, onError) {
  // Wrap raw inputStream with a "ScriptableInputStream" so we can read incoming data.
  let ScriptableInputStream = Components.Constructor(
    "@mozilla.org/scriptableinputstream;1", "nsIScriptableInputStream", "init"),
      scriptableInputStream = new ScriptableInputStream(inputStream),
      // A private method to read all data available on the input stream.
      readAll = function() {
        return scriptableInputStream.read(scriptableInputStream.available());
      },
      pump = Cc["@mozilla.org/network/input-stream-pump;1"]
               .createInstance(Components.interfaces.nsIInputStreamPump);
  // Start the pump.
  pump.init(inputStream, -1, -1, 0, 0, true);
  // Tell the pump to read all data whenever it is available, and pass the data
  // to the onInputData callback. The first argument to asyncRead implements
  // nsIStreamListener.
  pump.asyncRead({ onStartRequest: function (request, context) { },
                   onStopRequest: function (request, context, code) { },
                   onDataAvailable : function (request, context, stream, offset, count) {
                     try {
                       onInputData(readAll());
                     } catch (error) {
                       // readAll() or onInputData(...) has thrown an error.
                       // Notify calling code through onError.
                       onError(error);
                     }
                   } }, null);
};

// __io.asyncSocket(socketFile, host, port, onInputData, onError)__.
// Creates an asynchronous, text-oriented UNIX domain socket (if socketFile
// is defined) or TCP socket at host:port.
// The onInputData callback should accept a single argument, which will be called
// repeatedly, whenever incoming text arrives. Returns a socket object with two methods:
// socket.write(text) and socket.close(). onError will be passed the error object
// whenever a write fails.
io.asyncSocket = function (socketFile, host, port, onInputData, onError) {
  let [inputStream, outputStream] = io.asyncSocketStreams(socketFile, host,
                                                          port),
      pendingWrites = [];
  // Run an input stream pump to send incoming data to the onInputData callback.
  io.pumpInputStream(inputStream, onInputData, onError);
  // Return the "socket object" as described.
  return {
           // Write a message to the socket.
           write : function(aString) {
             pendingWrites.push(aString);
             outputStream.asyncWait(
               // Implement an nsIOutputStreamCallback:
               { onOutputStreamReady : function () {
                 let totalString = pendingWrites.join("");
                   try {
                     outputStream.write(totalString, totalString.length);
                     log("controlPort << " + totalString);
                   } catch (err) {
                     onError(err);
                   }
                   pendingWrites = [];
               } },
               0, 0, Services.tm.currentThread);
           },
           // Close the socket.
           close : function () {
             // Close stream objects.
             inputStream.close();
             outputStream.close();
           }
         };
};

// __io.onDataFromOnLine(onLine)__.
// Converts a callback that expects incoming individual lines of text to a callback that
// expects incoming raw socket string data.
io.onDataFromOnLine = function (onLine) {
  // A private variable that stores the last unfinished line.
  let pendingData = "";
  // Return a callback to be passed to io.asyncSocket. First, splits data into lines of
  // text. If the incoming data is not terminated by CRLF, then the last
  // unfinished line will be stored in pendingData, to be prepended to the data in the
  // next call to onData. The already complete lines of text are then passed in sequence
  // to onLine.
  return function (data) {
    let totalData = pendingData + data,
        lines = totalData.split("\r\n"),
        n = lines.length;
    pendingData = lines[n - 1];
    // Call onLine for all completed lines.
    lines.slice(0,-1).map(onLine);
  };
};

// __io.onLineFromOnMessage(onMessage)__.
// Converts a callback that expects incoming control port multiline message strings to a
// callback that expects individual lines.
io.onLineFromOnMessage = function (onMessage) {
  // A private variable that stores the last unfinished line.
  let pendingLines = [],
      // A private variable to monitor whether we are receiving a multiline
      // value, beginning with ###+ and ending with a single ".".
      multilineValueInProgress = false;
  // Return a callback that expects individual lines.
  return function (line) {
    // Add to the list of pending lines.
    pendingLines.push(line);
    // 'Multiline values' are possible. We avoid interrupting one by detecting it
    // and waiting for a terminating "." on its own line.
    // (See control-spec section 3.9 and https://trac.torproject.org/16990#comment:28
    if (line.match(/^\d\d\d\+.+?=$/) && pendingLines.length === 1) {
      multilineValueInProgress = true;
    }
    if (multilineValueInProgress && line.match(/^\.$/)) {
      multilineValueInProgress = false;
    }
    // If line is the last in a message, then pass on the full multiline message.
    if (!multilineValueInProgress &&
        line.match(/^\d\d\d /) &&
        (pendingLines.length === 1 ||
         pendingLines[0].substring(0,3) === line.substring(0,3))) {
      // Combine pending lines to form message.
      let message = pendingLines.join("\r\n");
      log("controlPort >> " + message);
      // Wipe pendingLines before we call onMessage, in case onMessage throws an error.
      pendingLines = [];
      // Pass multiline message to onMessage.
      onMessage(message);
    }
  };
};

// __io.callbackDispatcher()__.
// Returns dispatcher object with three member functions:
// dispatcher.addCallback(regex, callback), dispatcher.removeCallback(callback),
// and dispatcher.pushMessage(message).
// Pass pushMessage to another function that needs a callback with a single string
// argument. Whenever dispatcher.pushMessage receives a string, the dispatcher will
// check for any regex matches and pass the string on to the corresponding callback(s).
io.callbackDispatcher = function () {
  let callbackPairs = [],
      removeCallback = function (aCallback) {
        callbackPairs = callbackPairs.filter(function ([regex, callback]) {
          return callback !== aCallback;
        });
      },
      addCallback = function (regex, callback) {
        if (callback) {
          callbackPairs.push([regex, callback]);
        }
        return function () { removeCallback(callback); };
      },
      pushMessage = function (message) {
        for (let [regex, callback] of callbackPairs) {
          if (message.match(regex)) {
            callback(message);
          }
        }
      };
  return { pushMessage : pushMessage, removeCallback : removeCallback,
           addCallback : addCallback };
};

// __io.matchRepliesToCommands(asyncSend, dispatcher)__.
// Takes asyncSend(message), an asynchronous send function, and the callback
// dispatcher, and returns a function Promise<response> sendCommand(command).
io.matchRepliesToCommands = function (asyncSend, dispatcher) {
  let commandQueue = [],
      sendCommand = function (command, replyCallback, errorCallback) {
        commandQueue.push([command, replyCallback, errorCallback]);
        asyncSend(command);
      };
  // Watch for responses (replies or error messages)
  dispatcher.addCallback(/^[245]\d\d/, function (message) {
    let [command, replyCallback, errorCallback] = commandQueue.shift();
    if (message.match(/^2/) && replyCallback) replyCallback(message);
    if (message.match(/^[45]/) && errorCallback) {
      errorCallback(new Error(command + " -> " + message));
    }
  });
  // Create and return a version of sendCommand that returns a Promise.
  return command => new Promise(function (replyCallback, errorCallback) {
    sendCommand(command, replyCallback, errorCallback);
  });
};

// __io.controlSocket(socketFile, host, port, password, onError)__.
// Instantiates and returns a socket to a tor ControlPort at socketFile or
// host:port, authenticating with the given password. onError is called with an
// error object as its single argument whenever an error occurs. Example:
//
//     // Open the socket
//     let socket = controlSocket(undefined, "127.0.0.1", 9151, "MyPassw0rd",
//                    function (error) { console.log(error.message || error); });
//     // Send command and receive "250" reply or error message
//     socket.sendCommand(commandText, replyCallback, errorCallback);
//     // Register or deregister for "650" notifications
//     // that match regex
//     socket.addNotificationCallback(regex, callback);
//     socket.removeNotificationCallback(callback);
//     // Close the socket permanently
//     socket.close();
io.controlSocket = function (socketFile, host, port, password, onError) {
  // Produce a callback dispatcher for Tor messages.
  let mainDispatcher = io.callbackDispatcher(),
      // Open the socket and convert format to Tor messages.
      socket = io.asyncSocket(socketFile, host, port,
                              io.onDataFromOnLine(
                                   io.onLineFromOnMessage(mainDispatcher.pushMessage)),
                              onError),
      // Controllers should send commands terminated by CRLF.
      writeLine = function (text) { socket.write(text + "\r\n"); },
      // Create a sendCommand method from writeLine.
      sendCommand = io.matchRepliesToCommands(writeLine, mainDispatcher),
      // Create a secondary callback dispatcher for Tor notification messages.
      notificationDispatcher = io.callbackDispatcher();
  // Pass asynchronous notifications to notification dispatcher.
  mainDispatcher.addCallback(/^650/, notificationDispatcher.pushMessage);
  // Log in to control port.
  sendCommand("authenticate " + (password || ""));
  // Activate needed events.
  sendCommand("setevents stream");
  return { close : socket.close, sendCommand : sendCommand,
           addNotificationCallback : notificationDispatcher.addCallback,
           removeNotificationCallback : notificationDispatcher.removeCallback };
};

// ## utils
// A namespace for utility functions
let utils = {};

// __utils.identity(x)__.
// Returns its argument unchanged.
utils.identity = function (x) { return x; };

// __utils.isString(x)__.
// Returns true iff x is a string.
utils.isString = function (x) {
  return typeof(x) === 'string' || x instanceof String;
};

// __utils.capture(string, regex)__.
// Takes a string and returns an array of capture items, where regex must have a single
// capturing group and use the suffix /.../g to specify a global search.
utils.capture = function (string, regex) {
  let matches = [];
  // Special trick to use string.replace for capturing multiple matches.
  string.replace(regex, function (a, captured) {
    matches.push(captured);
  });
  return matches;
};

// __utils.extractor(regex)__.
// Returns a function that takes a string and returns an array of regex matches. The
// regex must use the suffix /.../g to specify a global search.
utils.extractor = function (regex) {
  return function (text) {
    return utils.capture(text, regex);
  };
};

// __utils.splitLines(string)__.
// Splits a string into an array of strings, each corresponding to a line.
utils.splitLines = function (string) { return string.split(/\r?\n/); };

// __utils.splitAtSpaces(string)__.
// Splits a string into chunks between spaces. Does not split at spaces
// inside pairs of quotation marks.
utils.splitAtSpaces = utils.extractor(/((\S*?"(.*?)")+\S*|\S+)/g);

// __utils.splitAtFirst(string, regex)__.
// Splits a string at the first instance of regex match. If no match is
// found, returns the whole string.
utils.splitAtFirst = function (string, regex) {
  let match = string.match(regex);
  return match ? [ string.substring(0, match.index),
                   string.substring(match.index + match[0].length) ]
               : string;
};

// __utils.splitAtEquals(string)__.
// Splits a string into chunks between equals. Does not split at equals
// inside pairs of quotation marks.
utils.splitAtEquals = utils.extractor(/(([^=]*?"(.*?)")+[^=]*|[^=]+)/g);

// __utils.mergeObjects(arrayOfObjects)__.
// Takes an array of objects like [{"a":"b"},{"c":"d"}] and merges to a single object.
// Pure function.
utils.mergeObjects = function (arrayOfObjects) {
  let result = {};
  for (let obj of arrayOfObjects) {
    for (let key in obj) {
      result[key] = obj[key];
    }
  }
  return result;
};

// __utils.listMapData(parameterString, listNames)__.
// Takes a list of parameters separated by spaces, of which the first several are
// unnamed, and the remainder are named, in the form `NAME=VALUE`. Apply listNames
// to the unnamed parameters, and combine them in a map with the named parameters.
// Example: `40 FAILED 0 95.78.59.36:80 REASON=CANT_ATTACH`
//
//     utils.listMapData("40 FAILED 0 95.78.59.36:80 REASON=CANT_ATTACH",
//                       ["streamID", "event", "circuitID", "IP"])
//     // --> {"streamID" : "40", "event" : "FAILED", "circuitID" : "0",
//     //      "address" : "95.78.59.36:80", "REASON" : "CANT_ATTACH"}"
utils.listMapData = function (parameterString, listNames) {
  // Split out the space-delimited parameters.
  let parameters = utils.splitAtSpaces(parameterString),
      dataMap = {};
  // Assign listNames to the first n = listNames.length parameters.
  for (let i = 0; i < listNames.length; ++i) {
    dataMap[listNames[i]] = parameters[i];
  }
  // Read key-value pairs and copy these to the dataMap.
  for (let i = listNames.length; i < parameters.length; ++i) {
    let [key, value] = utils.splitAtEquals(parameters[i]);
    if (key && value) {
      dataMap[key] = value;
    }
  }
  return dataMap;
};

// __utils.rejectPromise(errorMessage)__.
// Returns a rejected promise with the given error message.
utils.rejectPromise = errorMessage => Promise.reject(new Error(errorMessage));

// ## info
// A namespace for functions related to tor's GETINFO and GETCONF command.
let info = {};

// __info.keyValueStringsFromMessage(messageText)__.
// Takes a message (text) response to GETINFO or GETCONF and provides
// a series of key-value strings, which are either multiline (with a `250+` prefix):
//
//     250+config/defaults=
//     AccountingMax "0 bytes"
//     AllowDotExit "0"
//     .
//
// or single-line (with a `250-` or `250 ` prefix):
//
//     250-version=0.2.6.0-alpha-dev (git-b408125288ad6943)
info.keyValueStringsFromMessage = utils.extractor(/^(250\+[\s\S]+?^\.|250[- ].+?)$/gmi);

// __info.applyPerLine(transformFunction)__.
// Returns a function that splits text into lines,
// and applies transformFunction to each line.
info.applyPerLine = function (transformFunction) {
  return function (text) {
    return utils.splitLines(text.trim()).map(transformFunction);
  };
};

// __info.routerStatusParser(valueString)__.
// Parses a router status entry as, described in
// https://gitweb.torproject.org/torspec.git/tree/dir-spec.txt
// (search for "router status entry")
info.routerStatusParser = function (valueString) {
  let lines = utils.splitLines(valueString),
      objects = [];
  for (let line of lines) {
    // Drop first character and grab data following it.
    let myData = line.substring(2),
    // Accumulate more maps with data, depending on the first character in the line.
        dataFun = {
          "r" : data => utils.listMapData(data, ["nickname", "identity", "digest",
                                                 "publicationDate", "publicationTime",
                                                 "IP", "ORPort", "DirPort"]),
          "a" : data => ({ "IPv6" :  data }),
          "s" : data => ({ "statusFlags" : utils.splitAtSpaces(data) }),
          "v" : data => ({ "version" : data }),
          "w" : data => utils.listMapData(data, []),
          "p" : data => ({ "portList" : data.split(",") }),
        }[line.charAt(0)];
    if (dataFun !== undefined) {
      objects.push(dataFun(myData));
    }
  }
  return utils.mergeObjects(objects);
};

// __info.circuitStatusParser(line)__.
// Parse the output of a circuit status line.
info.circuitStatusParser = function (line) {
  let data = utils.listMapData(line, ["id","status","circuit"]),
      circuit = data.circuit;
  // Parse out the individual circuit IDs and names.
  if (circuit) {
    data.circuit = circuit.split(",").map(function (x) {
      return x.split(/~|=/);
    });
  }
  return data;
};

// __info.streamStatusParser(line)__.
// Parse the output of a stream status line.
info.streamStatusParser = function (text) {
  return utils.listMapData(text, ["StreamID", "StreamStatus",
                                  "CircuitID", "Target"]);
};

// __info.bridgeParser(bridgeLine)__.
// Takes a single line from a `getconf bridge` result and returns
// a map containing the bridge's type, address, and ID.
info.bridgeParser = function(bridgeLine) {
  let result = {},
      tokens = bridgeLine.split(/\s+/);
  // First check if we have a "vanilla" bridge:
  if (tokens[0].match(/^\d+\.\d+\.\d+\.\d+/)) {
    result.type = "vanilla";
    [result.address, result.ID] = tokens;
  // Several bridge types have a similar format:
  } else {
    result.type = tokens[0];
    if (["flashproxy", "fte", "meek", "obfs3", "obfs4", "scramblesuit"]
               .indexOf(result.type) >= 0) {
      [result.address, result.ID] = tokens.slice(1);
    }
  }
  return result.type ? result : null;
};

// __info.parsers__.
// A map of GETINFO and GETCONF keys to parsing function, which convert
// result strings to JavaScript data.
info.parsers = {
  "ns/id/" : info.routerStatusParser,
  "ip-to-country/" : utils.identity,
  "circuit-status" : info.applyPerLine(info.circuitStatusParser),
  "bridge" : info.bridgeParser,
  // Currently unused parsers:
  //  "ns/name/" : info.routerStatusParser,
  //  "stream-status" : info.applyPerLine(info.streamStatusParser),
  //  "version" : utils.identity,
  //  "config-file" : utils.identity,
};

// __info.getParser(key)__.
// Takes a key and determines the parser function that should be used to
// convert its corresponding valueString to JavaScript data.
info.getParser = function(key) {
  return info.parsers[key] ||
         info.parsers[key.substring(0, key.lastIndexOf("/") + 1)];
};

// __info.stringToValue(string)__.
// Converts a key-value string as from GETINFO or GETCONF to a value.
info.stringToValue = function (string) {
  // key should look something like `250+circuit-status=` or `250-circuit-status=...`
  // or `250 circuit-status=...`
  let matchForKey = string.match(/^250[ +-](.+?)=/),
      key = matchForKey ? matchForKey[1] : null;
  if (key === null) return null;
  // matchResult finds a single-line result for `250-` or `250 `,
  // or a multi-line one for `250+`.
  let matchResult = string.match(/^250[ -].+?=(.*)$/) ||
                    string.match(/^250\+.+?=([\s\S]*?)^\.$/m),
      // Retrieve the captured group (the text of the value in the key-value pair)
      valueString = matchResult ? matchResult[1] : null,
      // Get the parser function for the key found.
      parse = info.getParser(key.toLowerCase());
  if (parse === undefined) {
    throw new Error("No parser found for '" + key + "'");
  }
  // Return value produced by the parser.
  return parse(valueString);
};

// __info.getMultipleResponseValues(message)__.
// Process multiple responses to a GETINFO or GETCONF request.
info.getMultipleResponseValues = function (message) {
  return info.keyValueStringsFromMessage(message)
             .map(info.stringToValue)
             .filter(utils.identity);
};

// __info.getInfo(controlSocket, key)__.
// Sends GETINFO for a single key. Returns a promise with the result.
info.getInfo = function (aControlSocket, key) {
  if (!utils.isString(key)) {
    return utils.rejectPromise("key argument should be a string");
  }
  return aControlSocket
    .sendCommand("getinfo " + key)
    .then(response => info.getMultipleResponseValues(response)[0]);
};

// __info.getConf(aControlSocket, key)__.
// Sends GETCONF for a single key. Returns a promise with the result.
info.getConf = function (aControlSocket, key) {
  // GETCONF with a single argument returns results with
  // one or more lines that look like `250[- ]key=value`.
  // Any GETCONF lines that contain a single keyword only are currently dropped.
  // So we can use similar parsing to that for getInfo.
  if (!utils.isString(key)) {
    return utils.rejectPromise("key argument should be a string");
  }
  return aControlSocket.sendCommand("getconf " + key)
                       .then(info.getMultipleResponseValues);
};

// ## event
// Handlers for events

let event = {};

// __event.parsers__.
// A map of EVENT keys to parsing functions, which convert result strings to JavaScript
// data.
event.parsers = {
  "stream" : info.streamStatusParser,
  // Currently unused:
  // "circ" : info.circuitStatusParser,
};

// __event.messageToData(type, message)__.
// Extract the data from an event. Note, at present
// we only extract streams that look like `"650" SP...`
event.messageToData = function (type, message) {
  let dataText = message.match(/^650 \S+?\s(.*)/m)[1];
  return dataText ? event.parsers[type.toLowerCase()](dataText) : null;
};

// __event.watchEvent(controlSocket, type, filter, onData)__.
// Watches for a particular type of event. If filter(data) returns true, the event's
// data is passed to the onData callback. Returns a zero arg function that
// stops watching the event. Note: we only observe `"650" SP...` events
// currently (no `650+...` or `650-...` events).
event.watchEvent = function (controlSocket, type, filter, onData) {
  return controlSocket.addNotificationCallback(new RegExp("^650 " + type),
    function (message) {
      let data = event.messageToData(type, message);
      if (filter === null || filter(data)) {
        onData(data);
      }
    });
};

// ## tor
// Things related to the main controller.
let tor = {};

// __tor.controllerCache__.
// A map from "unix:socketpath" or "host:port" to controller objects. Prevents
// redundant instantiation of control sockets.
tor.controllerCache = {};

// __tor.controller(socketFile, host, port, password, onError)__.
// Creates a tor controller at the given socketFile or host and port, with the
// given password.
// onError returns asynchronously whenever a connection error occurs.
tor.controller = function (socketFile, host, port, password, onError) {
  let socket = io.controlSocket(socketFile, host, port, password, onError),
      isOpen = true;
  return { getInfo : key => info.getInfo(socket, key),
           getConf : key => info.getConf(socket, key),
           watchEvent : (type, filter, onData) =>
                          event.watchEvent(socket, type, filter, onData),
           isOpen : () => isOpen,
           close : () => { isOpen = false; socket.close(); }
         };
};

// ## Export

// __controller(socketFile, host, port, password, onError)__.
// Instantiates and returns a controller object connected to a tor ControlPort
// on socketFile or at host:port, authenticating with the given password, if
// the controller doesn't yet exist. Otherwise returns the existing controller
// to the given socketFile or host:port.
// onError is called with an error object as its single argument whenever
// an error occurs. Example:
//
//     // Get the controller
//     let c = controller(undefined, "127.0.0.1", 9151, "MyPassw0rd",
//                    function (error) { console.log(error.message || error); });
//     // Send command and receive `250` reply or error message in a promise:
//     let replyPromise = c.getInfo("ip-to-country/16.16.16.16");
//     // Close the controller permanently
//     c.close();
var controller = function (socketFile, host, port, password, onError) {
  let dest = (socketFile) ? "unix:" + socketFile.path : host + ":" + port,
      maybeController = tor.controllerCache[dest];
  return (tor.controllerCache[dest] =
           (maybeController && maybeController.isOpen()) ?
             maybeController :
             tor.controller(socketFile, host, port, password, onError));
};

// Export the controller function for external use.
var EXPORTED_SYMBOLS = ["controller"];
