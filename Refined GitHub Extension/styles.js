function addStylesheet(name) {
  const link = document.createElement("link");
  link.type = "text/css";
  link.rel = "stylesheet";
  link.href = safari.extension.baseURI + name;
  document.head.appendChild(link);
}

addStylesheet("refined-github.css");
addStylesheet("safari.css");
