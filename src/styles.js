const link = document.createElement("link");
link.type = "text/css";
link.rel = "stylesheet";
link.href = safari.extension.baseURI + "content.css";;
document.head.appendChild(link);
