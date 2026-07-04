(function () {
  const status = document.getElementById("status");
  const resource = document.getElementById("resource");
  const holder = document.getElementById("player");
  const gameSwf = "/swf/xfbbv451.swf";
  const query = new URLSearchParams(window.location.search);
  const renderer = query.get("renderer") || "webgl";
  const deviceFontRenderer = query.get("deviceFonts") || "canvas";
  const embeddedFontSources = [
    "/font-aliases/ziti-simsun.swf",
    "/font-aliases/ziti-simsun-bold.swf",
    "/font-aliases/ziti-songti.swf",
    "/font-aliases/ziti-songti-bold.swf",
    "/font-aliases/ziti-arial.swf",
    "/font-aliases/ziti-arial-bold.swf",
    "/font-aliases/ziti-yahei.swf",
    "/font-aliases/ziti-yahei-bold.swf",
    "/font-aliases/ziti-microsoft-yahei.swf",
    "/font-aliases/ziti-microsoft-yahei-bold.swf",
    "/font-aliases/ziti-heiti.swf",
    "/font-aliases/ziti-newsimsun.swf",
    "/font-aliases/ziti-newsimsun-bold.swf",
    "/font-aliases/ziti-nsimsun.swf",
    "/font-aliases/ziti-nsimsun-bold.swf",
    "/font-aliases/ziti-times-new-roman.swf",
  ];
  const fontSources = deviceFontRenderer === "embedded" ? embeddedFontSources : [];
  const configuredMaxExecutionDuration = Number(query.get("timeout") || 60);
  const telemetryEnabled = query.get("telemetry") === "1";
  const warmupEnabled = query.get("warmup") !== "0";
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
  const warmupAssets = [
    "/pmodes2v43.swf",
    "/pmodes1v43.swf",
    "/t_boxv44.swf",
    "/j_shangchengv29.swf",
    "/j_sxpanelv44.swf",
    "/WuqiB_hyemqiangv42.swf",
    "/e_cyzmkaijiav39.swf",
    "/e_cyzmyaodaiv39.swf",
    "/e_cyzmhuwanv39.swf",
    "/sz_cqzhkaijiav27.swf",
    "/sz_cqzhchibangv27.swf",
    "/WuqiB_cqzhv33.swf",
    "/sz_cqzhxgv232.swf",
    "/chjjyznv40.swf",
    "/skin_wmanv295.swf",
    "/WuqiB_leitingxueyuv33.swf",
    "/e_wkaijiajinav28.swf",
    "/e_wyaodaijinav28.swf",
    "/e_wchushitaov28.swf",
    "/map_0_1.swf",
    "/m_gebulina.swf",
    "/mp_shiliankongjian.swf",
    "/WuqiM_zhuijizhelueyingv33.swf",
    "/WuqiM_zhuijizhelieyanv33.swf",
    "/WuqiL_liuxingfeipanv33.swf",
    "/WuqiL_binglingdanatv33.swf",
    "/WuqiH_leimangjiyingv33.swf",
    "/WuqiB_wleimangjiyingv38.swf",
    "/WuqiB_wliuxingfeipanv38.swf",
    "/WuqiB_wzhaohuanzhev38.swf",
    "/WuqiB_wzhuijizhelieyanv38.swf",
    "/WuqiB_wzhuijizhelueyingv38.swf",
    "/yinxiaogwv33.swf",
    "/yinxiaocwv33.swf",
    "/j_bossxuetiaov43.swf",
    "/j_pengfenv43.swf",
    "/j_playerpanelv34.swf",
    "/j_bagpanelv20.swf",
    "/ts_44v42.swf",
    "/j_playertaskpanelv32.swf",
  ];
  let prefetchPromise = null;
  const startedAt = performance.now();
  const originalFetch = window.fetch.bind(window);

  window.RufflePlayer = window.RufflePlayer || {};
  window.RufflePlayer.config = {
    autoplay: "on",
    unmuteOverlay: "hidden",
    allowScriptAccess: true,
    allowNetworking: "all",
    logLevel: "warn",
    preferredRenderer: renderer,
    deviceFontRenderer,
    fontSources,
    defaultFonts: {
      sans: ["SimSun", "宋体", "NSimSun", "新宋体", "Microsoft YaHei", "微软雅黑", "Arial", "FZZongYi-M05S", "Droid Sans Fallback", "Noto Sans"],
      _sans: ["SimSun", "宋体", "NSimSun", "新宋体", "Microsoft YaHei", "微软雅黑", "Arial", "FZZongYi-M05S", "Droid Sans Fallback", "Noto Sans"],
      serif: ["SimSun", "宋体", "NSimSun", "新宋体", "Times New Roman", "FZZongYi-M05S", "Droid Sans Fallback", "Noto Serif"],
      _serif: ["SimSun", "宋体", "NSimSun", "新宋体", "Times New Roman", "FZZongYi-M05S", "Droid Sans Fallback", "Noto Serif"],
      typewriter: ["SimSun", "宋体", "NSimSun", "新宋体", "Consolas", "Courier New", "FZZongYi-M05S", "Droid Sans Mono", "Noto Sans Mono"],
      _typewriter: ["SimSun", "宋体", "NSimSun", "新宋体", "Consolas", "Courier New", "FZZongYi-M05S", "Droid Sans Mono", "Noto Sans Mono"],
      japaneseGothic: ["MS PGothic", "SimSun", "宋体", "NSimSun", "新宋体", "Microsoft YaHei", "微软雅黑", "FZZongYi-M05S", "Droid Sans Fallback"],
      japaneseGothicMono: ["MS Gothic", "SimSun", "宋体", "NSimSun", "新宋体", "FZZongYi-M05S", "Droid Sans Mono"],
      japaneseMincho: ["MS Mincho", "SimSun", "宋体", "NSimSun", "新宋体", "FZZongYi-M05S", "Droid Serif"],
    },
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
  window.__saveDataRunnerConfig = { renderer, deviceFontRenderer, fontSources };

  function logClientEvent(event, result, details) {
    if (!telemetryEnabled) {
      return;
    }

    const payload = JSON.stringify({
      event,
      result,
      href: window.location.href,
      elapsedMs: Math.round(performance.now() - startedAt),
      renderer,
      details,
    });

    if (navigator.sendBeacon) {
      const sent = navigator.sendBeacon("/api/saveData/client-log", new Blob([payload], { type: "application/json" }));
      if (sent) {
        return;
      }
    }

    originalFetch("/api/saveData/client-log", {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: payload,
      keepalive: true,
    }).catch(() => {});
  }

  function installRuffleConsoleObserver() {
    const observed = new Set();
    const originalConsole = {
      log: console.log.bind(console),
      info: console.info.bind(console),
      warn: console.warn.bind(console),
      error: console.error.bind(console),
    };

    function messageFromArgs(args) {
      return args
        .map((arg) => {
          if (typeof arg === "string") {
            return arg;
          }
          if (arg instanceof Error) {
            return `${arg.name}: ${arg.message}`;
          }
          return "";
        })
        .filter(Boolean)
        .join(" ")
        .replaceAll("%c", "")
        .replace(/\s+/g, " ")
        .trim();
    }

    function emitOnce(key, event, result, details) {
      if (observed.has(key)) {
        return;
      }
      observed.add(key);
      logClientEvent(event, result, details);
    }

    function observe(method, args) {
      const message = messageFromArgs(args);
      if (!message) {
        return;
      }

      const rendererMatch = message.match(/Used renderer:\s*([^)]+)/i);
      if (rendererMatch) {
        emitOnce("renderer", "ruffle.renderer", "ok", {
          configuredRenderer: renderer,
          actualRenderer: rendererMatch[1],
          deviceFontRenderer,
          fontSources,
          message,
        });
        return;
      }

      const rendererErrorMatch = message.match(/Error creating ([^:]+ renderer):\s*(.+)$/i);
      if (rendererErrorMatch) {
        emitOnce(`renderer_error:${rendererErrorMatch[1]}`, "ruffle.renderer_error", "error", {
          configuredRenderer: renderer,
          renderer: rendererErrorMatch[1],
          message: rendererErrorMatch[2],
        });
        return;
      }

      const unknownFontMatch = message.match(/Unknown device font "([^"]+)"/i);
      if (unknownFontMatch) {
        emitOnce(`font:${unknownFontMatch[1]}`, "ruffle.font_warning", "warning", {
          fontName: unknownFontMatch[1],
          deviceFontRenderer,
          message,
        });
        return;
      }

      if (/Couldn't download font source|Couldn't register font|Failed to parse font|Failed to load device font/i.test(message)) {
        emitOnce(`font_error:${message}`, "ruffle.font_error", "error", {
          deviceFontRenderer,
          message,
        });
      }
    }

    for (const method of Object.keys(originalConsole)) {
      console[method] = (...args) => {
        try {
          observe(method, args);
        } catch (_error) {
          // Keep console observation best-effort; never break the player.
        }
        originalConsole[method](...args);
      };
    }
  }

  if (telemetryEnabled) {
    installRuffleConsoleObserver();
  }

  function fetchUrl(input) {
    if (typeof input === "string") {
      return input;
    }
    if (input instanceof URL) {
      return input.toString();
    }
    return input?.url || "";
  }

  function shouldLogFetch(url, ms, status, failed) {
    if (!url || url.includes("/api/saveData/client-log")) {
      return false;
    }
    if (failed || status >= 400) {
      return true;
    }
    if (/\.swf(?:\?|$)/i.test(url)) {
      return ms >= 350;
    }
    if (/\/api\/4399|\/api\/saveData|save\.api\.4399\.com/i.test(url)) {
      return ms >= 250;
    }
    return ms >= 750;
  }

  function requestBodyParams(init) {
    const body = init?.body;
    if (!body) {
      return new URLSearchParams();
    }
    if (typeof body === "string" || body instanceof URLSearchParams) {
      return new URLSearchParams(body.toString());
    }
    if (body instanceof FormData) {
      const params = new URLSearchParams();
      for (const [key, value] of body.entries()) {
        if (typeof value === "string") {
          params.append(key, value);
        }
      }
      return params;
    }
    return new URLSearchParams();
  }

  function platformAction(url, init) {
    if (!url) {
      return "";
    }
    let parsed;
    try {
      parsed = new URL(url, window.location.href);
    } catch (_error) {
      return "";
    }

    const isSaveHost = parsed.hostname === "save.api.4399.com";
    const isSaveApi = parsed.pathname.startsWith("/api/4399") || isSaveHost;
    const isMallApi =
      parsed.pathname === "/api/4399/mall/FlashStoreApi" ||
      (isSaveHost && parsed.pathname === "/mall/FlashStoreApi");
    if (isMallApi) {
      return "mall";
    }
    if (!isSaveApi) {
      return "";
    }

    const bodyParams = requestBodyParams(init);
    return parsed.searchParams.get("ac") || bodyParams.get("ac") || "";
  }

  function updateGameStateFromPlatformRequest(url, init, status) {
    if (status >= 400) {
      return;
    }

    const action = platformAction(url, init);
    if (action === "get" || action === "save" || action === "mall") {
      window.__saveDataSetGameState?.("in_game");
    }
  }

  window.fetch = async function instrumentedFetch(input, init) {
    const url = fetchUrl(input);
    const started = performance.now();
    try {
      const response = await originalFetch(input, init);
      updateGameStateFromPlatformRequest(url, init, response.status);
      const ms = Math.round(performance.now() - started);
      if (telemetryEnabled && shouldLogFetch(url, ms, response.status, false)) {
        logClientEvent("client.fetch_slow", "ok", {
          url,
          status: response.status,
          ms,
          contentLength: response.headers.get("content-length") || "",
        });
      }
      return response;
    } catch (error) {
      const ms = Math.round(performance.now() - started);
      if (telemetryEnabled) {
        logClientEvent("client.fetch_slow", "error", {
          url,
          ms,
          message: error instanceof Error ? error.message : String(error),
        });
      }
      throw error;
    }
  };

  function startFrameMonitor() {
    let intervalStart = performance.now();
    let lastFrame = intervalStart;
    let frameCount = 0;
    let longFrames = 0;
    let maxFrameMs = 0;

    function tick(now) {
      const delta = now - lastFrame;
      lastFrame = now;
      frameCount += 1;
      if (delta >= 80) {
        longFrames += 1;
        maxFrameMs = Math.max(maxFrameMs, delta);
      }

      if (now - intervalStart >= 15000) {
        if (longFrames > 0) {
          logClientEvent("client.frame_jank", "ok", {
            intervalMs: Math.round(now - intervalStart),
            frames: frameCount,
            longFrames,
            maxFrameMs: Math.round(maxFrameMs),
          });
        }
        intervalStart = now;
        frameCount = 0;
        longFrames = 0;
        maxFrameMs = 0;
      }

      requestAnimationFrame(tick);
    }

    requestAnimationFrame(tick);
  }

  function setStatus(value) {
    status.textContent = value;
    window.__saveDataLog?.(value);
  }

  async function prefetchAssets(label, assets, batchSize) {
    const uniqueAssets = [...new Set(assets)];
    let ok = 0;
    let failed = 0;
    const started = performance.now();

    for (let index = 0; index < uniqueAssets.length; index += batchSize) {
      await Promise.all(
        uniqueAssets.slice(index, index + batchSize).map(async (asset) => {
          try {
            const response = await fetch(asset, { cache: "force-cache" });
            if (!response.ok) {
              throw new Error(`HTTP ${response.status}`);
            }
            ok += 1;
          } catch (error) {
            failed += 1;
            console.warn(`Failed to prefetch ${asset}`, error);
          }
        })
      );
    }

    logClientEvent("client.prefetch", failed > 0 ? "partial" : "ok", {
      label,
      ok,
      failed,
      ms: Math.round(performance.now() - started),
    });
  }

  async function prefetchCriticalAssets() {
    if (prefetchPromise) {
      return prefetchPromise;
    }

    prefetchPromise = (async () => {
      window.__saveDataLog?.("预缓存读档资源");
      await prefetchAssets("critical", criticalAssets, 2);
      if (warmupEnabled) {
        window.__saveDataLog?.("预热常用战斗资源");
        await prefetchAssets("warmup", warmupAssets, 2);
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

  async function logRendererInfo() {
    const handle = window.__ruffleHandle;
    if (!handle || typeof handle.renderer_debug_info !== "function") {
      return;
    }
    try {
      logClientEvent("ruffle.renderer", "ok", {
        configuredRenderer: renderer,
        deviceFontRenderer,
        info: await handle.renderer_debug_info(),
      });
    } catch (error) {
      logClientEvent("ruffle.renderer", "error", {
        configuredRenderer: renderer,
        deviceFontRenderer,
        message: error instanceof Error ? error.message : String(error),
      });
    }
  }

  async function loadGame() {
    window.__saveDataSetGameState?.("selecting");
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
      if (telemetryEnabled) {
        void logRendererInfo();
      }
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

  if (telemetryEnabled) {
    startFrameMonitor();
  }
  loadGame().catch((error) => setStatus(error instanceof Error ? error.message : String(error)));
})();
