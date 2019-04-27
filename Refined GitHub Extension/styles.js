document.addEventListener('DOMContentLoaded', function() {
  function addStylesheet(name) {
    const link = document.createElement("link");
    link.type = "text/css";
    link.rel = "stylesheet";
    link.href = safari.extension.baseURI + name;
    document.head.appendChild(link);
  }

  addStylesheet("content.css");
  addStylesheet("features.css");

}, false);
