// Mock chrome.storage API for Safari
const uniqueId = () =>
  Math.random()
    .toString(36)
    .replace(/[^a-z]+/g, "")
    .substr(2, 10);

const storageCalls = new Map();
const storageChangeListeners = [];

const changes = (oldValue, newValue) => {
  return Object.keys(newValue).reduce((diff, key) => {
    if (oldValue[key] === newValue[key]) {
      return diff;
    }

    return {
      ...diff,
      [key]: { oldValue: oldValue[key], newValue: newValue[key] }
    };
  }, {});
};


const respondToMessage = event => {
  if (event.name === "get-response") {
    const resolver = storageCalls.get(event.message.id);
    if (resolver) {
      resolver(event.message.value);
      storageCalls.delete(event.message.id);
    }
  } else if (event.name === "storage-change") {
    storageChangeListeners.forEach(listener =>
      listener(changes(event.message.old, event.message.new), event.message.namespace)
    );
  }
};

safari.self.addEventListener("message", respondToMessage);

const storage = namespace => {
  return {
    clear(callback) {
      safari.extension.dispatchMessage("clear", { namespace });
      if (callback) callback();
      return Promise.resolve();
    },
    get(keys, callback) {
      const transformResponse = (response) => {
        if (Array.isArray(keys)) {
          return keys
            .map(key => [key, data[key]])
            .reduce((obj, [key, value]) => ({ ...obj, [key]: value }), {});
        } else if (typeof keys === "object") {
          return Object.entries(keys)
            .map(([key, value]) => [key, response[key] || value])
            .reduce((obj, [key, value]) => ({ ...obj, [key]: value }), {});
        } else {
          return response;
        }
      }

      const normalizeKeys = () => {
        if (typeof keys === "string") {
          return [keys];
        } else if (Array.isArray(keys)) {
          return keys;
        } else if (typeof keys === "object") {
          return Object.keys(keys);
        } else {
          return undefined;
        }
      }

      const id = uniqueId();
      return new Promise(resolve => {
        storageCalls.set(id, response => {
          const value = transformResponse(response);
          resolve(value);
          if (callback) {
            callback(value);
          }
        });
        safari.extension.dispatchMessage("get", { id, keys: normalizeKeys(keys), namespace });
      });
    },
    remove(values, callback) {
      safari.extension.dispatchMessage("remove", { values, namespace });
      if (callback) callback();
      return Promise.resolve();
    },
    set(values, callback) {
      safari.extension.dispatchMessage("set", { values, namespace });
      if (callback) callback();
      return Promise.resolve();
    }
  };
};

browser = chrome = {
  runtime: {
    onMessage: {
      addListener: () => null
    },
    sendMessage(message) {
      safari.extension.dispatchMessage("message", message);
    },
    lastError: () => null
  },
  storage: {
    onChanged: {
      addListener(listener) {
        storageChangeListeners.push(listener);
      }
    },
    local: storage("local"),
    sync: storage("sync")
  }
};
