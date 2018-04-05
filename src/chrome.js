// Mock chrome.storage API for Safari
const getValue = (data, keys) => {
  if (typeof keys === "string") {
    return { [keys]: data[keys] };
  } else if (typeof keys === "array") {
    return keys
      .map(key => [key, data[key]])
      .reduce((obj, [key, value]) => ({ ...obj, [key]: value }), {});
  } else if (typeof keys === "object") {
    return Object.entries(keys)
      .map(([key, value]) => [key, data[key] || value])
      .reduce((obj, [key, value]) => ({ ...obj, [key]: value }), {});
  } else {
    return { ...data };
  }
};

const safeParse = data => {
  try {
    const parsed = JSON.parse(data) || {};
    parsed.options ||= {};
    parsed.options.disabledFeatures ||= "show-recently-pushed-branches";
    return parsed;
  } catch {
    return {};
  }
};

const storage = prefix => {
  const localStorageKey = `refined-github:${prefix}`;
  const readLocalStorage = () =>
    safeParse(localStorage.getItem(localStorageKey));
  const writeLocalStorage = data =>
    localStorage.setItem(localStorageKey, JSON.stringify(data));
  /*const data = {
    options: { disabledFeatures: "show-recently-pushed-branches" }
  };*/

  return {
    get(keys, callback) {
      const data = readLocalStorage();
      const value = getValue(data, keys);
      if (callback) callback(value);
      return Promise.resolve(value);
    },

    set(values, callback) {
      const data = readLocalStorage();
      Object.entries(values).forEach(([key, value]) => (data[key] = value));
      writeLocalStorage(data);
      if (callback) callback();
      return Promise.resolve();
    }
  };
};

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

browser = chrome = {
  runtime: {
    lastError: () => null
  },
  storage: {
    onChanged: {
      addListener(listener) {
        window.addEventListener("storage", event => {
          if (event.key.startsWith("refined-github:")) {
            const namespace = event.key.split(":", 2)[1];
            listener(
              changes(JSON.parse(event.oldValue), JSON.parse(event.newValue)),
              namespace
            );
          }
        });
      }
    },
    local: storage("local"),
    sync: storage("sync")
  }
};
