(function () {
  const status = document.getElementById("status");
  const resource = document.getElementById("resource");
  const holder = document.getElementById("player");
  const query = new URLSearchParams(window.location.search);
  const gameSwf = query.get("swf") || "/swf/xfbbv451-native.swf";
  const gameWidth = positiveDimension(query.get("gameWidth"), 960);
  const gameHeight = positiveDimension(query.get("gameHeight"), 600);

  window.__saveDataRunnerConfig = { renderer: "native-flash" };

  function positiveDimension(value, fallback) {
    const parsed = Number(value);
    return Number.isFinite(parsed) && parsed > 0 ? Math.round(parsed) : fallback;
  }

  function stageHorizontalPadding() {
    const stage = document.querySelector(".stage");
    if (!stage) {
      return 40;
    }
    const style = window.getComputedStyle(stage);
    return (Number.parseFloat(style.paddingLeft) || 0) + (Number.parseFloat(style.paddingRight) || 0);
  }

  function setGameViewport(width, height) {
    const safeWidth = positiveDimension(width, gameWidth);
    const safeHeight = positiveDimension(height, gameHeight);
    document.documentElement.style.setProperty("--game-width", `${safeWidth}px`);
    document.documentElement.style.setProperty("--game-height", `${safeHeight}px`);
    document.documentElement.style.setProperty("--stage-width", `${safeWidth + stageHorizontalPadding()}px`);
  }

  function syncGameViewportFromElement(element) {
    const rect = element.getBoundingClientRect();
    if (rect.width > 0 && rect.height > 0) {
      setGameViewport(rect.width, rect.height);
    }
  }

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
    object.width = String(gameWidth);
    object.height = String(gameHeight);
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
    setGameViewport(gameWidth, gameHeight);
    holder.appendChild(object);
    setStatus("原生 Flash");
    window.requestAnimationFrame(() => syncGameViewportFromElement(object));
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
