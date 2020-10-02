 function addStylesheet(name) {
   const link = document.createElement("link");
   link.type = "text/css";
   link.rel = "stylesheet";
   link.href = safari.extension.baseURI + name;
   document.head.appendChild(link);
 }

const observer = new MutationObserver(() => {
  if (document.body) {
    addStylesheet("refined-github.css");
    addStylesheet("safari.css");
    observer.disconnect();
  }
});
observer.observe(document, {childList: true, subtree: true})
