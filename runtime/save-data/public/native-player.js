(function () {
  const status = document.getElementById("status");
  const resource = document.getElementById("resource");
  const holder = document.getElementById("player");
  const query = new URLSearchParams(window.location.search);
  const gameSwf = query.get("swf") || "/swf/xfbbv451-native.swf";

  window.__saveDataRunnerConfig = { renderer: "native-flash" };

  function flashObject() {
    return document.getElementById("flashgame");
  }

  function focusFlashGame() {
    const object = flashObject();
    if (object && typeof object.focus === "function") {
      try {
        object.focus({ preventScroll: true });
      } catch {
        object.focus();
      }
    }
  }

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
    object.tabIndex = 0;
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
    fallback.textContent = "未找到原生 Flash 插件。";
    object.appendChild(fallback);
    holder.appendChild(object);
    setStatus("原生 Flash");
    window.setTimeout(focusFlashGame, 0);
    window.setTimeout(focusFlashGame, 250);
    if (window.__saveDataLog) {
      window.__saveDataLog("原生 Flash 播放器已挂载");
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
    setStatus("等待启动器");
    if (window.__saveDataLog) {
      window.__saveDataLog("等待原生启动器");
    }
  } else {
    mountFlash();
  }
})();
