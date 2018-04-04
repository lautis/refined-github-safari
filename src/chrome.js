// Mock chrome.storage API for Safari

const data = {};

const getValue = (keys) => {
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
    return {...data };
  }
}

const storage = {
  get(keys, callback) {
    const value = getValue(keys);
    if (callback) callback(value);
    return Promise.resolve(value);
  },

  set(values, callback) {
    Object.entries(values).forEach(([key, value]) => data[key] = value);
    if (callback) callback();
    return Promise.resolve();
  }
};

browser = chrome = {
  storage: {
    onChanged: {
      addListener(listener) {}
    },
    local: storage,
    sync: storage
  }
};
