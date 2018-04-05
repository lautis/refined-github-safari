// Mock chrome.storage API for Safari
const uniqueId = () =>
  Math.random()
    .toString(36)
    .replace(/[^a-z]+/g, "")
    .substr(2, 10);

const storageCalls = new Map();
const storageChangeListeners = [];

const respondToMessage = event => {
  if (event.name === "get-response") {
    const resolver = storageCalls.get(event.message.id);
    if (resolver) {
      resolver(event.message.value);
      storageCalls.delete(event.message.id);
    }
  } else if (event.name === "storage-change") {
    storageChangeListeners.forEach(listener =>
      listener(event.message.changes, event.message.namespace)
    );
  }
};

safari.self.addEventListener("message", respondToMessage, false);

const storage = namespace => {
  return {
    get(keys, callback) {
      const id = uniqueId();
      return new Promise(resolve => {
        storageCalls.set(id, value => {
          resolve(value);
          if (callback) {
            callback(value);
          }
        });
        safari.self.tab.dispatchMessage("get", { id, keys, namespace });
      });
    },

    set(values, callback) {
      safari.self.tab.dispatchMessage("set", { values, namespace });
      if (callback) callback();
      return Promise.resolve();
    }
  };
};

browser = chrome = {
  runtime: {
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
