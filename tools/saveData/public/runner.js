(function () {
  const status = document.getElementById("status");
  const resource = document.getElementById("resource");
  const holder = document.getElementById("player");
  const gameSwf = "/swf/xfbbv451.swf";
  const query = new URLSearchParams(window.location.search);
  const renderer = query.get("renderer") || "webgl";
  const configuredMaxExecutionDuration = Number(query.get("timeout") || 60);
  const criticalAssets = [
    "/yinxiaov33.swf",
    "/j_otherscv35.swf",
    "/wupintubiaov43.swf",
    "/j_wanjiajiemianv443.swf",
    "/zawuv442.swf",
    "/ziti.swf",
    "/j_taskmoveclipv41.swf",
    "/skin_manv213.swf",
    "/dataxmlvav447.swf",
    "/map_0_0v446.swf",
    "/j_xinshouzhishiv29.swf",
    "/mp_cunzhuangv36.swf",
    "/WuqiB_xinshouqiangv33.swf",
    "/e_chushitaov12.swf",
  ];
  let prefetchPromise = null;

  window.RufflePlayer = window.RufflePlayer || {};
  window.RufflePlayer.config = {
    autoplay: "on",
    unmuteOverlay: "hidden",
    allowScriptAccess: true,
    allowNetworking: "all",
    logLevel: "warn",
    preferredRenderer: renderer === "auto" ? null : renderer,
    maxExecutionDuration: Number.isFinite(configuredMaxExecutionDuration) ? configuredMaxExecutionDuration : 20,
    upgradeToHttps: false,
    openUrlMode: "allow",
    urlRewriteRules: [
      [/^https?:\/\/stat\.api\.4399\.com\/flash_ctrl_version\.xml(?:\?.*)?$/, "/flash_ctrl_version.xml"],
      [/^https?:\/\/stat\.api\.4399\.com\/flash_ad_version\.xml(?:\?.*)?$/, "/flash_ad_version.xml"],
      [/^https?:\/\/stat\.api\.4399\.com\/flashflowstatis\/submitflowstatis\.php(\?.*)?$/, "/api/stat/flashflowstatis/submitflowstatis.php$1"],
      [/^https?:\/\/stat\.api\.4399\.com\/flash_flow\/([^/?]+)(\?.*)?$/, "/api/stat/flash_flow/$1$2"],
      [/^https?:\/\/stat\.api\.4399\.com\/archive_status\/log\.js(\?.*)?$/, "/api/stat/archive_status/log.js$1"],
      [/^https?:\/\/media\.5054399\.net\/cover\/entries(\?.*)?$/, "/api/media/cover/entries$1"],
      [/^https?:\/\/my\.4399\.com\/services\/game-play(?:\?.*)?$/, "/api/4399-task/game-play"],
      [/^https?:\/\/cdn\.comment\.4399pk\.com\/control\/ctrl_mo_v5\.swf(?:\?.*)?$/, "/ctrl_mo_v5.swf"],
      [/^https?:\/\/cdn\.comment\.4399pk\.com\/control\/A4399dv_base\.swf(?:\?.*)?$/, "/assets/A4399dv_base.swf"],
      [/^https?:\/\/cdn\.comment\.4399pk\.com\/control\/A4399dv_base_main\.swf(?:\?.*)?$/, "/assets/A4399dv_base_main.swf"],
      [/^https?:\/\/cdn\.comment\.4399pk\.com\/control\/open4399tools_AS3\.swf(?:\?.*)?$/, "/assets/open4399tools_AS3.swf"],
      [/^https:\/\/save\.api\.4399\.com(\/.*)?$/, "/api/4399$1"],
      [/^http:\/\/save\.api\.4399\.com(\/.*)?$/, "/api/4399$1"],
    ],
  };

  function setStatus(value) {
    status.textContent = value;
    window.__saveDataLog?.(value);
  }

  async function prefetchCriticalAssets() {
    if (prefetchPromise) {
      return prefetchPromise;
    }

    prefetchPromise = (async () => {
      window.__saveDataLog?.("预缓存读档资源");
      for (let index = 0; index < criticalAssets.length; index += 2) {
        await Promise.all(
          criticalAssets.slice(index, index + 2).map(async (asset) => {
            try {
              const response = await fetch(asset, { cache: "force-cache" });
              if (!response.ok) {
                throw new Error(`HTTP ${response.status}`);
              }
            } catch (error) {
              console.warn(`Failed to prefetch ${asset}`, error);
            }
          })
        );
      }
      window.__saveDataLog?.("读档资源预缓存完成");
    })();

    return prefetchPromise;
  }

  async function callExposedCallback(name, args) {
    const handle = window.__ruffleHandle;
    if (!handle || typeof handle.call_exposed_callback !== "function") {
      return false;
    }

    try {
      await handle.call_exposed_callback(name, args);
      return true;
    } catch (_error) {
      return false;
    }
  }

  window.__refreshGamePaymentState = async function () {
    return callExposedCallback("getBalance", []);
  };

  async function loadGame() {
    resource.textContent = gameSwf.split("/").pop();
    holder.textContent = "";

    const ruffle = window.RufflePlayer.newest();
    const player = ruffle.createPlayer();
    const handle = player.ruffle();
    player.style.width = "960px";
    player.style.height = "600px";
    window.__rufflePlayer = player;
    window.__ruffleHandle = handle;
    holder.appendChild(player);

    player.addEventListener("loadedmetadata", () => {
      setStatus("游戏已加载");
      void prefetchCriticalAssets();
    });
    player.addEventListener("error", (event) => {
      const message = event?.message ?? "unknown";
      setStatus(`加载错误: ${message}`);
    });
    setStatus(`加载 ${gameSwf}`);
    await handle.load({
      url: gameSwf,
      allowScriptAccess: true,
      allowNetworking: "all",
      base: "/",
    });
  }

  document.getElementById("reloadGame").addEventListener("click", () => loadGame());

  loadGame().catch((error) => setStatus(error instanceof Error ? error.message : String(error)));
})();
