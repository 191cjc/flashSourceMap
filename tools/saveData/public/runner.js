(function () {
  const status = document.getElementById("status");
  const resource = document.getElementById("resource");
  const holder = document.getElementById("player");
  const gameSwf = "/swf/xfbbv451.swf";

  window.RufflePlayer = window.RufflePlayer || {};
  window.RufflePlayer.config = {
    autoplay: "on",
    unmuteOverlay: "hidden",
    allowScriptAccess: true,
    allowNetworking: "all",
    logLevel: "warn",
    preferredRenderer: "canvas",
    upgradeToHttps: false,
    openUrlMode: "allow",
    urlRewriteRules: [
      [/^https?:\/\/stat\.api\.4399\.com\/flash_ctrl_version\.xml(?:\?.*)?$/, "/flash_ctrl_version.xml"],
      [/^https?:\/\/stat\.api\.4399\.com\/flash_ad_version\.xml(?:\?.*)?$/, "/flash_ad_version.xml"],
      [/^https?:\/\/stat\.api\.4399\.com\/flashflowstatis\/submitflowstatis\.php(\?.*)?$/, "/api/stat/flashflowstatis/submitflowstatis.php$1"],
      [/^https?:\/\/stat\.api\.4399\.com\/flash_flow\/([^/?]+)(\?.*)?$/, "/api/stat/flash_flow/$1$2"],
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

  async function loadGame() {
    resource.textContent = gameSwf.split("/").pop();
    holder.textContent = "";

    const ruffle = window.RufflePlayer.newest();
    const player = ruffle.createPlayer();
    player.style.width = "960px";
    player.style.height = "600px";
    holder.appendChild(player);

    player.addEventListener("loadedmetadata", () => setStatus("游戏已加载"));
    player.addEventListener("error", (event) => setStatus(`加载错误: ${event?.message ?? "unknown"}`));
    setStatus(`加载 ${gameSwf}`);
    await player.ruffle().load({
      url: gameSwf,
      allowScriptAccess: true,
      allowNetworking: "all",
      base: "/",
    });
  }

  document.getElementById("reloadGame").addEventListener("click", () => loadGame());

  loadGame().catch((error) => setStatus(error instanceof Error ? error.message : String(error)));
})();
