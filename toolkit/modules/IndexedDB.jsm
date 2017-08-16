/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

/**
 * @file
 *
 * This module provides Promise-based wrappers around ordinarily
 * IDBRequest-based IndexedDB methods and classes.
 */

/* exported IndexedDB */
var EXPORTED_SYMBOLS = ["IndexedDB"];

const {classes: Cc, interfaces: Ci, utils: Cu, results: Cr} = Components;

Cu.importGlobalProperties(["indexedDB"]);

/**
 * Wraps the given request object, and returns a Promise which resolves when
 * the requests succeeds or rejects when it fails.
 *
 * @param {IDBRequest} request
 *        An IndexedDB request object to wrap.
 * @returns {Promise}
 */
function wrapRequest(request) {
  return new Promise((resolve, reject) => {
    request.onsuccess = () => {
      resolve(request.result);
    };
    request.onerror = () => {
      reject(request.error);
    };
  });
}

/**
 * Forwards a set of getter properties from a wrapper class to the wrapped
 * object.
 *
 * @param {function} cls
 *        The class constructor for which to forward the getters.
 * @param {string} target
 *        The name of the property which contains the wrapped object to which
 *        to forward the getters.
 * @param {Array<string>} props
 *        A list of property names to forward.
 */
function forwardGetters(cls, target, props) {
  for (let prop of props) {
    Object.defineProperty(cls.prototype, prop, {
      get() {
        return this[target][prop];
      },
    });
  }
}

/**
 * Forwards a set of getter and setter properties from a wrapper class to the
 * wrapped object.
 *
 * @param {function} cls
 *        The class constructor for which to forward the properties.
 * @param {string} target
 *        The name of the property which contains the wrapped object to which
 *        to forward the properties.
 * @param {Array<string>} props
 *        A list of property names to forward.
 */
function forwardProps(cls, target, props) {
  for (let prop of props) {
    Object.defineProperty(cls.prototype, prop, {
      get() {
        return this[target][prop];
      },
      set(value) {
        this[target][prop] = value;
      },
    });
  }
}

/**
 * Wraps a set of IDBRequest-based methods via {@link wrapRequest} and
 * forwards them to the equivalent methods on the wrapped object.
 *
 * @param {function} cls
 *        The class constructor for which to forward the methods.
 * @param {string} target
 *        The name of the property which contains the wrapped object to which
 *        to forward the methods.
 * @param {Array<string>} methods
 *        A list of method names to forward.
 */
function wrapMethods(cls, target, methods) {
  for (let method of methods) {
    cls.prototype[method] = function(...args) {
      return wrapRequest(this[target][method](...args));
    };
  }
}

/**
 * Forwards a set of methods from a wrapper class to the wrapped object.
 *
 * @param {function} cls
 *        The class constructor for which to forward the getters.
 * @param {string} target
 *        The name of the property which contains the wrapped object to which
 *        to forward the methods.
 * @param {Array<string>} methods
 *        A list of method names to forward.
 */
function forwardMethods(cls, target, methods) {
  for (let method of methods) {
    cls.prototype[method] = function(...args) {
      return this[target][method](...args);
    };
  }
}

class Cursor {
  constructor(cursor, source) {
    this.cursor = cursor;
    this.source = source;
  }
}

forwardGetters(Cursor, "cursor",
               ["direction", "key", "primaryKey"]);

wrapMethods(Cursor, "cursor", ["delete", "update"]);

forwardMethods(Cursor, "cursor",
               ["advance", "continue", "continuePrimaryKey"]);

class CursorWithValue extends Cursor {}

forwardGetters(CursorWithValue, "cursor", ["value"]);

class Cursed {
  constructor(cursed) {
    this.cursed = cursed;
  }

  openCursor(...args) {
    return wrapRequest(this.cursed.openCursor(...args)).then(cursor => {
      return new CursorWithValue(cursor, this);
    });
  }

  openKeyCursor(...args) {
    return wrapRequest(this.cursed.openKeyCursor(...args)).then(cursor => {
      return new Cursor(cursor, this);
    });
  }
}

wrapMethods(Cursed, "cursed",
            ["count", "get", "getAll", "getAllKeys", "getKey"]);

class Index extends Cursed {
  constructor(index, objectStore) {
    super(index);

    this.objectStore = objectStore;
    this.index = index;
  }
}

forwardGetters(Index, "index",
               ["isAutoLocale", "keyPath", "locale", "multiEntry", "name", "unique"]);

class ObjectStore extends Cursed {
  constructor(store) {
    super(store);

    this.store = store;
  }

  createIndex(...args) {
    return new Index(this.store.createIndex(...args),
                     this);
  }

  index(...args) {
    return new Index(this.store.index(...args),
                     this);
  }
}

wrapMethods(ObjectStore, "store",
            ["add", "clear", "delete", "put"]);

forwardMethods(ObjectStore, "store", ["deleteIndex"]);

class Transaction {
  constructor(transaction) {
    this.transaction = transaction;

    this._completionPromise = new Promise((resolve, reject) => {
      transaction.oncomplete = resolve;
      transaction.onerror = () => {
        reject(transaction.error);
      };
    });
  }

  objectStore(name) {
    return new ObjectStore(this.transaction.objectStore(name));
  }

  /**
   * Returns a Promise which resolves when the transaction completes, or
   * rejects when a transaction error occurs.
   *
   * @returns {Promise}
   */
  promiseComplete() {
    return this._completionPromise;
  }
}

forwardGetters(Transaction, "transaction",
               ["db", "mode", "error", "objectStoreNames"]);

forwardMethods(Transaction, "transaction", ["abort"]);

class IndexedDB {
  /**
   * Opens the database with the given name, and returns a Promise which
   * resolves to an IndexedDB instance when the operation completes.
   *
   * @param {string} dbName
   *        The name of the database to open.
   * @param {object} options
   *        The options with which to open the database.
   * @param {integer} options.version
   *        The schema version with which the database needs to be opened. If
   *        the database does not exist, or its current schema version does
   *        not match, the `onupgradeneeded` function will be called.
   * @param {string} [options.storage]
   *        The storage type of the database. If present, may be one of
   *        "temporary" or "persistent".
   * @param {function} [onupgradeneeded]
   *        A function which will be called with an IndexedDB object as its
   *        first parameter when the database needs to be created, or its
   *        schema needs to be upgraded. If this function is not provided, the
   *        {@link #onupgradeneeded} method will be called instead.
   *
   * @returns {Promise<IndexedDB>}
   */
  static open(dbName, options, onupgradeneeded = null) {
    let request = indexedDB.open(dbName, options);

    request.onupgradeneeded = event => {
      let db = new this(request.result);
      if (onupgradeneeded) {
        onupgradeneeded(db, event);
      } else {
        db.onupgradeneeded(event);
      }
    };

    return wrapRequest(request).then(db => new IndexedDB(db));
  }

  constructor(db) {
    this.db = db;
  }

  onupgradeneeded() {}

  /**
   * Opens a transaction for the given object stores.
   *
   * @param {Array<string>} storeNames
   *        The names of the object stores for which to open a transaction.
   * @param {string} [mode = "readonly"]
   *        The mode in which to open the transaction.
   * @param {function} [callback]
   *        An optional callback function. If provided, the function will be
   *        called with the Transaction, and a Promise will be returned, which
   *        will resolve to the callback's return value when the transaction
   *        completes.
   * @returns {Transaction|Promise}
   */
  transaction(storeNames, mode, callback = null) {
    let transaction = new Transaction(this.db.transaction(storeNames, mode));

    if (callback) {
      let result = new Promise(resolve => {
        resolve(callback(transaction));
      });
      return transaction.promiseComplete().then(() => result);
    }

    return transaction;
  }

  /**
   * Opens a transaction for a single object store, and returns that object
   * store.
   *
   * @param {string} storeName
   *        The name of the object store to open.
   * @param {string} [mode = "readonly"]
   *        The mode in which to open the transaction.
   * @param {function} [callback]
   *        An optional callback function. If provided, the function will be
   *        called with the ObjectStore, and a Promise will be returned, which
   *        will resolve to the callback's return value when the transaction
   *        completes.
   * @returns {ObjectStore|Promise}
   */
  objectStore(storeName, mode, callback = null) {
    let transaction = this.transaction([storeName], mode);
    let objectStore = transaction.objectStore(storeName);

    if (callback) {
      let result = new Promise(resolve => {
        resolve(callback(objectStore));
      });
      return transaction.promiseComplete().then(() => result);
    }

    return objectStore;
  }

  createObjectStore(...args) {
    return new ObjectStore(this.db.createObjectStore(...args));
  }
}

for (let method of ["cmp", "deleteDatabase"]) {
  IndexedDB[method] = function(...args) {
    return indexedDB[method](...args);
  };
}

forwardMethods(IndexedDB, "db",
               ["addEventListener", "close", "deleteObjectStore", "hasEventListener", "removeEventListener"]);

forwardGetters(IndexedDB, "db",
               ["name", "objectStoreNames", "version"]);

forwardProps(IndexedDB, "db",
             ["onabort", "onclose", "onerror", "onversionchange"]);
