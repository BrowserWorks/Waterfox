/*
 * Copyright 2012, Mozilla Foundation and contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

"use strict";

// THIS FILE IS GENERATED FROM SOURCE IN THE GCLI PROJECT
// PLEASE TALK TO SOMEONE IN DEVELOPER TOOLS BEFORE EDITING IT

var mockCommands;
if (typeof exports !== "undefined") {
  // If we're being loaded via require();
  mockCommands = exports;
}
else {
  // If we're being loaded via loadScript in mochitest
  mockCommands = {};
}

// We use an alias for exports here because this module is used in Firefox
// mochitests where we don't have define/require

/**
 * Registration and de-registration.
 */
mockCommands.setup = function (requisition) {
  requisition.system.addItems(mockCommands.items);
};

mockCommands.shutdown = function (requisition) {
  requisition.system.removeItems(mockCommands.items);
};

function createExec(name) {
  return function (args, context) {
    var promises = [];

    Object.keys(args).map(argName => {
      var value = args[argName];
      var type = this.getParameterByName(argName).type;
      var promise = Promise.resolve(type.stringify(value, context));
      promises.push(promise.then(str => {
        return { name: argName, value: str };
      }));
    });

    return Promise.all(promises).then(data => {
      var argValues = {};
      data.forEach(function (entry) { argValues[entry.name] = entry.value; });

      return context.typedData("testCommandOutput", {
        name: name,
        args: argValues
      });
    });
  };
}

mockCommands.items = [
  {
    item: "converter",
    from: "testCommandOutput",
    to: "dom",
    exec: function (testCommandOutput, context) {
      var view = context.createView({
        data: testCommandOutput,
        html: "" +
          "<table>" +
            "<thead>" +
              "<tr>" +
                '<th colspan="3">Exec: ${name}</th>' +
              "</tr>" +
            "</thead>" +
            "<tbody>" +
              '<tr foreach="key in ${args}">' +
                "<td> ${key}</td>" +
                "<td>=</td>" +
                "<td>${args[key]}</td>" +
              "</tr>" +
            "</tbody>" +
          "</table>",
        options: {
          allowEval: true
        }
      });

      return view.toDom(context.document);
    }
  },
  {
    item: "converter",
    from: "testCommandOutput",
    to: "string",
    exec: function (testCommandOutput, context) {
      var argsOut = Object.keys(testCommandOutput.args).map(function (key) {
        return key + "=" + testCommandOutput.args[key];
      }).join(" ");
      return "Exec: " + testCommandOutput.name + " " + argsOut;
    }
  },
  {
    item: "type",
    name: "optionType",
    parent: "selection",
    lookup: [
      {
        name: "option1",
        value: "string"
      },
      {
        name: "option2",
        value: "number"
      },
      {
        name: "option3",
        value: {
          name: "selection",
          lookup: [
            { name: "one", value: 1 },
            { name: "two", value: 2 },
            { name: "three", value: 3 }
          ]
        }
      }
    ]
  },
  {
    item: "type",
    name: "optionValue",
    parent: "delegate",
    delegateType: function (executionContext) {
      if (executionContext != null) {
        var option = executionContext.getArgsObject().optionType;
        if (option != null) {
          return option;
        }
      }
      return "blank";
    }
  },
  {
    item: "command",
    name: "tsv",
    params: [
      { name: "optionType", type: "optionType" },
      { name: "optionValue", type: "optionValue" }
    ],
    exec: createExec("tsv")
  },
  {
    item: "command",
    name: "tsr",
    params: [ { name: "text", type: "string" } ],
    exec: createExec("tsr")
  },
  {
    item: "command",
    name: "tsrsrsr",
    params: [
      { name: "p1", type: "string" },
      { name: "p2", type: "string" },
      { name: "p3", type: { name: "string", allowBlank: true} },
    ],
    exec: createExec("tsrsrsr")
  },
  {
    item: "command",
    name: "tso",
    params: [ { name: "text", type: "string", defaultValue: null } ],
    exec: createExec("tso")
  },
  {
    item: "command",
    name: "tse",
    params: [
      { name: "node", type: "node" },
      {
        group: "options",
        params: [
          { name: "nodes", type: { name: "nodelist" } },
          { name: "nodes2", type: { name: "nodelist", allowEmpty: true } }
        ]
      }
    ],
    exec: createExec("tse")
  },
  {
    item: "command",
    name: "tsj",
    params: [ { name: "javascript", type: "javascript" } ],
    exec: createExec("tsj")
  },
  {
    item: "command",
    name: "tsb",
    params: [ { name: "toggle", type: "boolean" } ],
    exec: createExec("tsb")
  },
  {
    item: "command",
    name: "tss",
    exec: createExec("tss")
  },
  {
    item: "command",
    name: "tsu",
    params: [
      {
        name: "num",
        type: {
          name: "number",
          max: 10,
          min: -5,
          step: 3
        }
      }
    ],
    exec: createExec("tsu")
  },
  {
    item: "command",
    name: "tsf",
    params: [
      {
        name: "num",
        type: {
          name: "number",
          allowFloat: true,
          max: 11.5,
          min: -6.5,
          step: 1.5
        }
      }
    ],
    exec: createExec("tsf")
  },
  {
    item: "command",
    name: "tsn"
  },
  {
    item: "command",
    name: "tsn dif",
    params: [ { name: "text", type: "string", description: "tsn dif text" } ],
    exec: createExec("tsnDif")
  },
  {
    item: "command",
    name: "tsn hidden",
    hidden: true,
    exec: createExec("tsnHidden")
  },
  {
    item: "command",
    name: "tsn ext",
    params: [ { name: "text", type: "string" } ],
    exec: createExec("tsnExt")
  },
  {
    item: "command",
    name: "tsn exte",
    params: [ { name: "text", type: "string" } ],
    exec: createExec("tsnExte")
  },
  {
    item: "command",
    name: "tsn exten",
    params: [ { name: "text", type: "string" } ],
    exec: createExec("tsnExten")
  },
  {
    item: "command",
    name: "tsn extend",
    params: [ { name: "text", type: "string" } ],
    exec: createExec("tsnExtend")
  },
  {
    item: "command",
    name: "tsn deep"
  },
  {
    item: "command",
    name: "tsn deep down"
  },
  {
    item: "command",
    name: "tsn deep down nested"
  },
  {
    item: "command",
    name: "tsn deep down nested cmd",
    exec: createExec("tsnDeepDownNestedCmd")
  },
  {
    item: "command",
    name: "tshidden",
    hidden: true,
    params: [
      {
        group: "Options",
        params: [
          {
            name: "visible",
            type: "string",
            short: "v",
            defaultValue: null,
            description: "visible"
          },
          {
            name: "invisiblestring",
            type: "string",
            short: "i",
            description: "invisiblestring",
            defaultValue: null,
            hidden: true
          },
          {
            name: "invisibleboolean",
            short: "b",
            type: "boolean",
            description: "invisibleboolean",
            hidden: true
          }
        ]
      }
    ],
    exec: createExec("tshidden")
  },
  {
    item: "command",
    name: "tselarr",
    params: [
      { name: "num", type: { name: "selection", data: [ "1", "2", "3" ] } },
      { name: "arr", type: { name: "array", subtype: "string" } }
    ],
    exec: createExec("tselarr")
  },
  {
    item: "command",
    name: "tsm",
    description: "a 3-param test selection|string|number",
    params: [
      { name: "abc", type: { name: "selection", data: [ "a", "b", "c" ] } },
      { name: "txt", type: "string" },
      { name: "num", type: { name: "number", max: 42, min: 0 } }
    ],
    exec: createExec("tsm")
  },
  {
    item: "command",
    name: "tsg",
    description: "a param group test",
    params: [
      {
        name: "solo",
        type: { name: "selection", data: [ "aaa", "bbb", "ccc" ] },
        description: "solo param"
      },
      {
        group: "First",
        params: [
          {
            name: "txt1",
            type: "string",
            defaultValue: null,
            description: "txt1 param"
          },
          {
            name: "bool",
            type: "boolean",
            description: "bool param"
          }
        ]
      },
      {
        name: "txt2",
        type: "string",
        defaultValue: "d",
        description: "txt2 param",
        option: "Second"
      },
      {
        name: "num",
        type: { name: "number", min: 40 },
        defaultValue: 42,
        description: "num param",
        option: "Second"
      }
    ],
    exec: createExec("tsg")
  },
  {
    item: "command",
    name: "tscook",
    description: "param group test to catch problems with cookie command",
    params: [
      {
        name: "key",
        type: "string",
        description: "tscookKeyDesc"
      },
      {
        name: "value",
        type: "string",
        description: "tscookValueDesc"
      },
      {
        group: "tscookOptionsDesc",
        params: [
          {
            name: "path",
            type: "string",
            defaultValue: "/",
            description: "tscookPathDesc"
          },
          {
            name: "domain",
            type: "string",
            defaultValue: null,
            description: "tscookDomainDesc"
          },
          {
            name: "secure",
            type: "boolean",
            description: "tscookSecureDesc"
          }
        ]
      }
    ],
    exec: createExec("tscook")
  },
  {
    item: "command",
    name: "tslong",
    description: "long param tests to catch problems with the jsb command",
    params: [
      {
        name: "msg",
        type: "string",
        description: "msg Desc"
      },
      {
        group: "Options Desc",
        params: [
          {
            name: "num",
            short: "n",
            type: "number",
            description: "num Desc",
            defaultValue: 2
          },
          {
            name: "sel",
            short: "s",
            type: {
              name: "selection",
              lookup: [
                { name: "space", value: " " },
                { name: "tab", value: "\t" }
              ]
            },
            description: "sel Desc",
            defaultValue: " "
          },
          {
            name: "bool",
            short: "b",
            type: "boolean",
            description: "bool Desc"
          },
          {
            name: "num2",
            short: "m",
            type: "number",
            description: "num2 Desc",
            defaultValue: -1
          },
          {
            name: "bool2",
            short: "c",
            type: "boolean",
            description: "bool2 Desc"
          },
          {
            name: "sel2",
            short: "t",
            type: {
              name: "selection",
              data: [ "collapse", "basic", "with space", "with two spaces" ]
            },
            description: "sel2 Desc",
            defaultValue: "collapse"
          }
        ]
      }
    ],
    exec: createExec("tslong")
  },
  {
    item: "command",
    name: "tsdate",
    description: "long param tests to catch problems with the jsb command",
    params: [
      {
        name: "d1",
        type: "date",
      },
      {
        name: "d2",
        type: {
          name: "date",
          min: "1 jan 2000",
          max: "28 feb 2000",
          step: 2
        }
      },
    ],
    exec: createExec("tsdate")
  },
  {
    item: "command",
    name: "tsfail",
    description: "test errors",
    params: [
      {
        name: "method",
        type: {
          name: "selection",
          data: [
            "reject", "rejecttyped",
            "throwerror", "throwstring", "throwinpromise",
            "noerror"
          ]
        }
      }
    ],
    exec: function (args, context) {
      if (args.method === "reject") {
        return new Promise(function (resolve, reject) {
          context.environment.window.setTimeout(function () {
            reject("rejected promise");
          }, 10);
        });
      }

      if (args.method === "rejecttyped") {
        return new Promise(function (resolve, reject) {
          context.environment.window.setTimeout(function () {
            reject(context.typedData("number", 54));
          }, 10);
        });
      }

      if (args.method === "throwinpromise") {
        return new Promise(function (resolve, reject) {
          context.environment.window.setTimeout(function () {
            resolve("should be lost");
          }, 10);
        }).then(function () {
          var t = null;
          return t.foo;
        });
      }

      if (args.method === "throwerror") {
        throw new Error("thrown error");
      }

      if (args.method === "throwstring") {
        throw "thrown string";
      }

      return "no error";
    }
  },
  {
    item: "command",
    name: "tsfile",
    description: "test file params",
  },
  {
    item: "command",
    name: "tsfile open",
    description: "a file param in open mode",
    params: [
      {
        name: "p1",
        type: {
          name: "file",
          filetype: "file",
          existing: "yes"
        }
      }
    ],
    exec: createExec("tsfile open")
  },
  {
    item: "command",
    name: "tsfile saveas",
    description: "a file param in saveas mode",
    params: [
      {
        name: "p1",
        type: {
          name: "file",
          filetype: "file",
          existing: "no"
        }
      }
    ],
    exec: createExec("tsfile saveas")
  },
  {
    item: "command",
    name: "tsfile save",
    description: "a file param in save mode",
    params: [
      {
        name: "p1",
        type: {
          name: "file",
          filetype: "file",
          existing: "maybe"
        }
      }
    ],
    exec: createExec("tsfile save")
  },
  {
    item: "command",
    name: "tsfile cd",
    description: "a file param in cd mode",
    params: [
      {
        name: "p1",
        type: {
          name: "file",
          filetype: "directory",
          existing: "yes"
        }
      }
    ],
    exec: createExec("tsfile cd")
  },
  {
    item: "command",
    name: "tsfile mkdir",
    description: "a file param in mkdir mode",
    params: [
      {
        name: "p1",
        type: {
          name: "file",
          filetype: "directory",
          existing: "no"
        }
      }
    ],
    exec: createExec("tsfile mkdir")
  },
  {
    item: "command",
    name: "tsfile rm",
    description: "a file param in rm mode",
    params: [
      {
        name: "p1",
        type: {
          name: "file",
          filetype: "any",
          existing: "yes"
        }
      }
    ],
    exec: createExec("tsfile rm")
  },
  {
    item: "command",
    name: "tsslow",
    params: [
      {
        name: "hello",
        type: {
          name: "selection",
          data: function (context) {
            return new Promise(function (resolve, reject) {
              context.environment.window.setTimeout(function () {
                resolve([
                  "Shalom", "Namasté", "Hallo", "Dydd-da",
                  "Chào", "Hej", "Saluton", "Sawubona"
                ]);
              }, 10);
            });
          }
        }
      }
    ],
    exec: function (args, context) {
      return "Test completed";
    }
  },
  {
    item: "command",
    name: "urlc",
    params: [
      {
        name: "url",
        type: "url"
      }
    ],
    returnType: "json",
    exec: function (args, context) {
      return args;
    }
  },
  {
    item: "command",
    name: "unionc1",
    params: [
      {
        name: "first",
        type: {
          name: "union",
          alternatives: [
            {
              name: "selection",
              lookup: [
                { name: "one", value: 1 },
                { name: "two", value: 2 },
              ]
            },
            "number",
            { name: "string" }
          ]
        }
      }
    ],
    returnType: "json",
    exec: function (args, context) {
      return args;
    }
  },
  {
    item: "command",
    name: "unionc2",
    params: [
      {
        name: "first",
        type: {
          name: "union",
          alternatives: [
            {
              name: "selection",
              lookup: [
                { name: "one", value: 1 },
                { name: "two", value: 2 },
              ]
            },
            {
              name: "url"
            }
          ]
        }
      }
    ],
    returnType: "json",
    exec: function (args, context) {
      return args;
    }
  },
  {
    item: "command",
    name: "tsres",
    params: [
      {
        name: "resource",
        type: "resource"
      }
    ],
    exec: createExec("tsres"),
  }
];
