(function () {
  const status = document.getElementById("status");
  const resource = document.getElementById("resource");
  const holder = document.getElementById("player");
  const query = new URLSearchParams(window.location.search);
  const gameSwf = query.get("swf") || "/swf/xfbbv451-native.swf";

  window.__saveDataRunnerConfig = { renderer: "native-flash" };

  function setStatus(value) {
    if (status) {
      status.textContent = value;
    }
  }

  function mountFlash() {
    if (!holder) {
      return;
    }
    holder.innerHTML = "";

    const object = document.createElement("object");
    object.id = "flashgame";
    object.type = "application/x-shockwave-flash";
    object.data = gameSwf;
    object.width = "960";
    object.height = "600";
    object.style.width = "100%";
    object.style.height = "100%";

    const params = {
      movie: gameSwf,
      quality: "high",
      bgcolor: "#000000",
      allowScriptAccess: "always",
      allowNetworking: "all",
      wmode: "direct",
      base: "/",
    };

    for (const [name, value] of Object.entries(params)) {
      const param = document.createElement("param");
      param.name = name;
      param.value = value;
      object.appendChild(param);
    }

    const fallback = document.createElement("p");
    fallback.textContent = "Native Flash plugin is unavailable.";
    object.appendChild(fallback);
    holder.appendChild(object);
    setStatus("native flash");
    if (window.__saveDataLog) {
      window.__saveDataLog("Native Flash player mounted");
    }
  }

  if (resource) {
    resource.textContent = gameSwf;
  }

  window.__nativeFlashMount = mountFlash;

  const reloadButton = document.getElementById("reloadGame");
  if (reloadButton) {
    reloadButton.addEventListener("click", () => {
      if (window.__saveDataSetGameState) {
        window.__saveDataSetGameState("selecting");
      }
      mountFlash();
    });
  }

  if (query.get("autostart") === "0") {
    setStatus("waiting");
    if (window.__saveDataLog) {
      window.__saveDataLog("Waiting for native launcher");
    }
  } else {
    mountFlash();
  }
})();
