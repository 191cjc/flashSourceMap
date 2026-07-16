(function () {
  const account = {
    uid: "10001",
    username: "local_user",
    nickname: "本地玩家",
    loginType: "local",
  };

  const nativeAlert = typeof window.alert === "function" ? window.alert.bind(window) : null;

  window.alert = function (message) {
    if (/space bar/i.test(String(message || ""))) {
      return;
    }
    if (nativeAlert) {
      nativeAlert(message);
    }
  };

  window.loginCallback = function () {};
  window.logoutCallback = function () {};
  window.closeLogRegWindow = function () {};
  window.ctrlInitCompleted = function () {};
  window.loginSuccess = function () {};
  window.logoutSuccess = function () {};
  window.getGameInfo = function () {
    return "100025235|机甲小子|local";
  };
  window.get4399id = function () {
    return "100025235";
  };

  window.UniLogin = {
    getUid() {
      return account.uid;
    },
    getUname() {
      return account.username;
    },
    getDisplayNameText() {
      return account.nickname;
    },
    getUserLoginType() {
      return account.loginType;
    },
    showPopupLogin() {
      window.loginCallback();
      return "1";
    },
    showPopupReg() {
      window.loginCallback();
      return "1";
    },
    logout() {
      window.logoutCallback();
      return "1";
    },
  };

  window.__saveDataAccount = account;
  const MAX_ITEM_QUEUE = 12;
  const QUICK_ITEM_COUNTS = [1, 9, 99, 999];
  let gameState = "selecting";
  let rechargeBusy = false;
  let walletRefreshInFlight = false;
  let levelRewardState = null;
  let activityVisibilityState = null;
  let equipmentStrengtheningState = null;
  let petSkillState = null;
  let zodiacSoulExpState = null;
  let advancedPetEggState = null;
  let petFusionExpState = null;
  let itemCatalog = [];
  let itemQueue = [];
  let itemSearchTerm = "";
  let itemPopover = null;
  let optimizationPopover = null;
  let onlineModeBusy = false;
  let onlineModeStatus = null;

  window.__saveDataLog = function (message) {
    const log = document.getElementById("log");
    if (!log) {
      return;
    }
    const li = document.createElement("li");
    li.textContent = message;
    log.prepend(li);
    while (log.children.length > 80) {
      if (log.lastElementChild) {
        log.lastElementChild.remove();
      }
    }
  };

  function formatAmount(value) {
    return Number(value == null ? 0 : value).toLocaleString("zh-CN");
  }

  function formatProbability(value, total) {
    const probability = Number(value) / Number(total || 1);
    return Number.isFinite(probability)
      ? probability.toLocaleString("zh-CN", { style: "percent", maximumFractionDigits: 2 })
      : "未知";
  }

  function escapeHtml(value) {
    return String(value == null ? "" : value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function clampInteger(value, fallback, min, max) {
    const parsed = Math.floor(Number(value));
    if (!Number.isSafeInteger(parsed)) {
      return fallback;
    }
    return Math.min(max, Math.max(min, parsed));
  }

  function readText(response) {
    return response.text();
  }

  async function readJsonResponse(response) {
    const text = await readText(response);
    try {
      return JSON.parse(text);
    } catch {
      throw new Error(text || `HTTP ${response.status}`);
    }
  }

  // ── 线上导入 ──────────────────────────────────────────────
  let onlineSession = null; // { uid, username, nickname, cookie }

  function setOnlineImportHint(msg, isError) {
    const el = document.getElementById("onlineImportHint");
    if (!el) return;
    el.textContent = msg;
    el.className = "hint" + (isError ? " is-warning" : "");
  }

  function renderOnlineSlots(slots) {
    const container = document.getElementById("onlineImportSlots");
    if (!container) return;
    if (!slots || slots.length === 0) {
      container.innerHTML = "<p class=\"hint\">没有找到线上存档。</p>";
      return;
    }
    container.innerHTML = slots.map((slot) => {
      const hasData = slot.data && slot.data.length > 0;
      const label = escapeHtml(slot.title || `存档 ${slot.index}`);
      const time = escapeHtml(slot.datetime || "");
      return `<div class="online-import-slot${hasData ? "" : " is-empty"}">
        <div class="online-import-slot-info">
          <strong>${label}</strong>${time ? ` <span class="hint">${time}</span>` : ""}
          ${hasData ? "" : " <span class=\"hint\">(空)</span>"}
        </div>
        <div class="online-import-slot-actions">
          ${[0,1,2,3,4,5].map((i) =>
            `<button type="button" class="online-import-to-slot" data-source-index="${slot.index}" data-target-index="${i}" data-title="${escapeHtml(slot.title || `存档 ${slot.index}`)}" data-data="${escapeHtml(slot.data || "")}"${hasData ? "" : " disabled"}>→本地${i}</button>`
          ).join("")}
        </div>
      </div>`;
    }).join("");
  }

  async function fetchOnlineSaves() {
    if (!onlineSession) return;
    setOnlineImportHint("正在拉取存档列表…", false);
    try {
      const res = await fetch("/api/online-import/saves", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ uid: onlineSession.uid, username: onlineSession.username, cookie: onlineSession.cookie }),
      });
      const json = await readJsonResponse(res);
      if (!json.ok) throw new Error(json.error || "未知错误");
      renderOnlineSlots(json.slots);
      setOnlineImportHint(`已加载 ${json.slots.length} 个存档槽。`, false);
    } catch (err) {
      setOnlineImportHint(`拉取失败：${err.message}`, true);
    }
  }

  function showOnlineSession() {
    const form = document.getElementById("onlineImportLoginForm");
    const session = document.getElementById("onlineImportSession");
    const nick = document.getElementById("onlineImportNick");
    if (form) form.hidden = true;
    if (session) session.hidden = false;
    if (nick) nick.textContent = onlineSession ? onlineSession.nickname : "";
  }

  function showOnlineLoginForm() {
    const form = document.getElementById("onlineImportLoginForm");
    const session = document.getElementById("onlineImportSession");
    const container = document.getElementById("onlineImportSlots");
    if (form) form.hidden = false;
    if (session) session.hidden = true;
    if (container) container.innerHTML = "";
    setOnlineImportHint("", false);
  }

  document.addEventListener("click", async function (e) {
    const target = e.target;

    if (target && target.id === "onlineImportLogin") {
      const username = (document.getElementById("onlineImportUsername") || {}).value || "";
      const password = (document.getElementById("onlineImportPassword") || {}).value || "";
      const cookie = (document.getElementById("onlineImportCookie") || {}).value || "";
      const uid = (document.getElementById("onlineImportUid") || {}).value || "";
      target.disabled = true;
      setOnlineImportHint("正在登录…", false);
      try {
        const res = await fetch("/api/online-import/login", {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: JSON.stringify({ username, password, cookie, uid }),
        });
        const json = await readJsonResponse(res);
        if (!json.ok) throw new Error(json.error || "登录失败");
        onlineSession = { uid: json.uid, username: json.username, nickname: json.nickname, cookie: json.cookie };
        showOnlineSession();
        await fetchOnlineSaves();
      } catch (err) {
        setOnlineImportHint(`登录失败：${err.message}`, true);
      } finally {
        target.disabled = false;
      }
    }

    if (target && target.id === "onlineImportRefresh") {
      await fetchOnlineSaves();
    }

    if (target && target.id === "onlineImportLogout") {
      onlineSession = null;
      showOnlineLoginForm();
    }

    if (target && target.classList && target.classList.contains("online-import-to-slot")) {
      const data = target.dataset.data || "";
      const title = target.dataset.title || "线上导入";
      const targetIndex = Number(target.dataset.targetIndex ?? 0);
      if (!data) return;
      if (!confirm(`确认将"${title}"覆盖到本地存档槽 ${targetIndex}？此操作不可撤销。`)) return;
      target.disabled = true;
      try {
        const res = await fetch("/api/online-import/import", {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: JSON.stringify({ data, title, targetIndex }),
        });
        const json = await readJsonResponse(res);
        if (!json.ok) throw new Error(json.error || "导入失败");
        setOnlineImportHint(`已成功导入到本地存档槽 ${targetIndex}。`, false);
        window.__saveDataLog && window.__saveDataLog(`线上存档"${title}"已导入到本地槽 ${targetIndex}`);
      } catch (err) {
        setOnlineImportHint(`导入失败：${err.message}`, true);
      } finally {
        target.disabled = false;
      }
    }
  });

  function rechargeBlockedMessage() {
    return "已进入游戏，充值暂不可用；请重载游戏后先充值，再进入存档。";
  }

  function isRechargeBlocked() {
    return gameState === "in_game";
  }

  function updateRechargeControls() {
    const input = document.getElementById("rechargeAmount");
    const button = document.getElementById("localRecharge");
    const hint = document.getElementById("rechargeHint");
    const blocked = isRechargeBlocked();

    if (input) {
      input.disabled = blocked || rechargeBusy;
    }
    if (button) {
      button.disabled = blocked || rechargeBusy;
      button.textContent = blocked ? "游戏中不可充值" : rechargeBusy ? "充值中" : "点击充值";
    }
    if (hint) {
      hint.textContent = blocked ? rechargeBlockedMessage() : "请先充值，再进入存档；进入游戏后充值暂不可用。";
      hint.classList.toggle("is-warning", blocked);
    }
  }

  window.__saveDataSetGameState = function (state) {
    if (state !== "selecting" && state !== "in_game") {
      return;
    }
    if (gameState === state) {
      return;
    }
    gameState = state;
    updateRechargeControls();
    updateOptimizationControls();
    if (state === "in_game") {
      window.__saveDataLog && window.__saveDataLog("已进入游戏，本地充值入口已暂时禁用");
    }
  };

  async function refreshAccount() {
    const response = await fetch("/api/unilogin/account", { cache: "no-store" });
    if (!response.ok) {
      throw new Error(`账号读取失败 HTTP ${response.status}`);
    }
    Object.assign(account, await response.json());
    const el = document.getElementById("account");
    if (el) {
      el.textContent = `${account.nickname} (${account.uid})`;
    }
    return account;
  }

  refreshAccount().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));

  function setOnlineModeHint(message, warning) {
    const hint = document.getElementById("onlineModeHint");
    if (!hint) {
      return;
    }
    hint.textContent = message;
    hint.classList.toggle("is-warning", Boolean(warning));
  }

  function onlineModeLabel(mode) {
    return {
      eligible: "单机模式，可接入",
      online: "联机模式，已同步",
      sync_pending: "联机模式，等待同步",
      server_offline: "服务器不可用",
      identity_conflict: "本地 UID 不一致",
      migration_failed: "UID 迁移失败",
      unsupported: "当前存档后端不支持",
    }[mode] || mode || "未知";
  }

  function renderOnlineMode(result) {
    onlineModeStatus = result;
    const server = result && result.server ? result.server : {};
    const currentAccount = result && result.account ? result.account : account;
    const mode = result && result.mode ? result.mode : "server_offline";
    const enabled = Boolean(result && result.online && result.online.enabled);
    const joined = enabled || String(currentAccount && currentAccount.uid) !== "10001";
    const serverText = server.healthy
      ? `正常 · ${Number(server.latencyMs || 0)}ms`
      : server.reachable
        ? `异常 · HTTP ${server.status || "?"}`
        : "无法连接";
    const serverElement = document.getElementById("onlineModeServer");
    const stateElement = document.getElementById("onlineModeState");
    const pendingElement = document.getElementById("onlineModePending");
    const uidInput = document.getElementById("onlineModeUid");
    const usernameInput = document.getElementById("onlineModeUsername");
    const joinButton = document.getElementById("onlineModeJoin");
    const profileButton = document.getElementById("onlineModeSaveProfile");
    const syncButton = document.getElementById("onlineModeSync");
    const refreshButton = document.getElementById("onlineModeRefresh");
    if (serverElement) serverElement.textContent = serverText;
    if (stateElement) stateElement.textContent = onlineModeLabel(mode);
    if (pendingElement) pendingElement.textContent = String((result && result.sync && result.sync.pendingCount) || 0);
    if (uidInput) uidInput.value = String((currentAccount && currentAccount.uid) || "10001");
    if (usernameInput) {
      usernameInput.value = String((currentAccount && currentAccount.username) || "local_user");
      usernameInput.disabled = !joined || onlineModeBusy;
    }
    if (joinButton) {
      joinButton.hidden = mode !== "eligible";
      joinButton.disabled = onlineModeBusy || !server.healthy;
    }
    if (profileButton) {
      profileButton.hidden = !joined;
      profileButton.disabled = onlineModeBusy || !server.healthy;
    }
    if (syncButton) {
      syncButton.hidden = !joined;
      syncButton.disabled = onlineModeBusy || !server.healthy;
    }
    if (refreshButton) refreshButton.disabled = onlineModeBusy;

    if (mode === "eligible") {
      setOnlineModeHint("点击接入后，服务器会分配永久 UID，并重写本地存档身份。", false);
    } else if (mode === "identity_conflict") {
      setOnlineModeHint("检测到账号 UID 与存档 UID 不一致，远程同步已暂停。", true);
    } else if (!server.healthy) {
      setOnlineModeHint("Linux 服务不可用，本地读取、保存、钱包和充值仍可正常使用。", true);
    } else if (mode === "sync_pending") {
      setOnlineModeHint("本地存档已经保存，远程副本正在等待同步。", true);
    } else if (joined) {
      setOnlineModeHint("UID 不可修改；用户名修改后会重写本地存档并重载游戏。", false);
    }
  }

  async function refreshOnlineMode() {
    const response = await fetch("/api/saveData/online-mode/status", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok === false) {
      throw new Error(result.message || result.error || `HTTP ${response.status}`);
    }
    renderOnlineMode(result);
    return result;
  }

  async function postOnlineMode(pathname, payload) {
    const response = await fetch(pathname, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify(payload || {}),
    });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok === false) {
      throw new Error(result.message || result.error || `HTTP ${response.status}`);
    }
    return result;
  }

  function reloadGameAfterIdentityChange(message) {
    window.__saveDataLog && window.__saveDataLog(message);
    window.setTimeout(() => {
      if (window.__saveDataSetGameState) {
        window.__saveDataSetGameState("selecting");
      }
      if (window.__nativeFlashMount) {
        window.__nativeFlashMount();
      }
    }, 800);
  }

  async function joinOnlineMode() {
    if (onlineModeBusy) return;
    if (window.confirm && !window.confirm("接入后会获得永久 UID，并重写当前本地存档身份。是否继续？")) return;
    onlineModeBusy = true;
    renderOnlineMode(onlineModeStatus || {});
    setOnlineModeHint("正在注册 UID、迁移本地存档并上传服务器……", false);
    try {
      await postOnlineMode("/api/saveData/online-mode/join");
      await refreshAccount();
      await refreshOnlineMode();
      reloadGameAfterIdentityChange(`已接入联机模式，当前 UID ${account.uid}`);
    } catch (error) {
      setOnlineModeHint(error instanceof Error ? error.message : String(error), true);
    } finally {
      onlineModeBusy = false;
      refreshOnlineMode().catch(() => undefined);
    }
  }

  async function saveOnlineUsername() {
    if (onlineModeBusy) return;
    const input = document.getElementById("onlineModeUsername");
    const username = input ? input.value.trim() : "";
    onlineModeBusy = true;
    renderOnlineMode(onlineModeStatus || {});
    try {
      await postOnlineMode("/api/saveData/online-mode/profile", { username });
      await refreshAccount();
      await refreshOnlineMode();
      reloadGameAfterIdentityChange(`联机用户名已修改为 ${account.username}`);
    } catch (error) {
      setOnlineModeHint(error instanceof Error ? error.message : String(error), true);
    } finally {
      onlineModeBusy = false;
      refreshOnlineMode().catch(() => undefined);
    }
  }

  async function syncOnlineMode() {
    if (onlineModeBusy) return;
    onlineModeBusy = true;
    renderOnlineMode(onlineModeStatus || {});
    try {
      const result = await postOnlineMode("/api/saveData/online-mode/sync");
      window.__saveDataLog && window.__saveDataLog(`远程存档同步完成：${result.synced || 0} 个`);
      await refreshOnlineMode();
    } catch (error) {
      setOnlineModeHint(error instanceof Error ? error.message : String(error), true);
    } finally {
      onlineModeBusy = false;
      refreshOnlineMode().catch(() => undefined);
    }
  }

  function setOptimizationStatus(status, text, className, label) {
    if (!status) {
      return;
    }
    status.textContent = text;
    status.classList.remove("is-pending", "is-ok", "is-error");
    status.classList.add(className);
    status.setAttribute("aria-label", label);
  }

  function optimizationItem(key) {
    return document.querySelector(`[data-optimization-key="${key}"]`);
  }

  function setOptimizationDescription(key, message, warning) {
    const item = optimizationItem(key);
    if (!item) {
      return;
    }
    const title = item.querySelector("span")?.textContent || "体验优化";
    item.setAttribute("data-popover-title", title);
    item.setAttribute("data-popover-body", message);
    item.setAttribute("data-popover-tone", warning ? "warning" : "normal");
    item.classList.toggle("is-warning", Boolean(warning));
  }

  function updateLevelRewardHint() {
    const status = document.getElementById("levelRewardStatus");
    if (!optimizationItem("levelReward") && !status) {
      return;
    }

    if (!levelRewardState) {
      setOptimizationStatus(status, "…", "is-pending", "检测中");
      setOptimizationDescription("levelReward", "正在检测体验优化状态。", false);
      return;
    }
    if (!levelRewardState.loaded) {
      setOptimizationStatus(status, "×", "is-error", "未生效");
      setOptimizationDescription(
        "levelReward",
        "关卡数据还未加载完成。请先成功进入一次游戏，关闭后重新打开；重启后该优化会自动生效。",
        true
      );
      return;
    }

    const value = formatAmount(levelRewardState.achievementBoostValue);
    setOptimizationStatus(status, "✓", "is-ok", "已生效");
    setOptimizationDescription("levelReward", `关卡成就点奖励优化已生效：通关成就点奖励固定为 ${value}。`, false);
  }

  function updateActivityVisibilityHint() {
    const status = document.getElementById("activityVisibilityStatus");
    if (!optimizationItem("activityVisibility") && !status) {
      return;
    }

    if (!activityVisibilityState) {
      setOptimizationStatus(status, "…", "is-pending", "检测中");
      setOptimizationDescription("activityVisibility", "正在检测活动配置状态。", false);
      return;
    }
    if (!activityVisibilityState.loaded) {
      setOptimizationStatus(status, "×", "is-error", "未生效");
      setOptimizationDescription(
        "activityVisibility",
        activityVisibilityState.error
          ? `限时活动全展示加载失败：${activityVisibilityState.error}`
          : "活动配置还未加载完成。请先成功进入一次游戏，关闭后重新打开；重启后该优化会自动生效。",
        true
      );
      return;
    }

    setOptimizationStatus(status, "✓", "is-ok", "已生效");
    const count = formatAmount(activityVisibilityState.giftCount);
    const timed = formatAmount(activityVisibilityState.timedGiftCount);
    const delisted = formatAmount(activityVisibilityState.delistedGiftCount);
    setOptimizationDescription(
      "activityVisibility",
      `限时活动全展示已生效：已加载 ${count} 条礼包活动，解除 ${timed} 条时间限制、${delisted} 条下架标记。`,
      false
    );
  }

  function updateEquipmentStrengtheningHint() {
    const status = document.getElementById("equipmentStrengtheningStatus");
    if (!optimizationItem("equipmentStrengthening") && !status) {
      return;
    }

    if (!equipmentStrengtheningState) {
      setOptimizationStatus(status, "…", "is-pending", "检测中");
      setOptimizationDescription("equipmentStrengthening", "正在检测装备强化配置状态。", false);
      return;
    }
    if (!equipmentStrengtheningState.loaded) {
      setOptimizationStatus(status, "×", "is-error", "未生效");
      setOptimizationDescription(
        "equipmentStrengthening",
        equipmentStrengtheningState.error
          ? `装备强化优化加载失败：${equipmentStrengtheningState.error}`
          : "强化配置还未加载完成。请先成功进入一次游戏，关闭后重新打开；重启后该优化会自动生效。",
        true
      );
      return;
    }

    const recordCount = formatAmount(equipmentStrengtheningState.probabilityRecordCount || equipmentStrengtheningState.recordCount || 0);
    const entryCount = formatAmount(equipmentStrengtheningState.patchedProbabilityEntryCount || equipmentStrengtheningState.probabilityEntryCount || 0);
    const probability = Number(equipmentStrengtheningState.successProbability) || 100;
    setOptimizationStatus(status, "✓", "is-ok", "已生效");
    setOptimizationDescription(
      "equipmentStrengthening",
      `装备强化优化已生效：${recordCount} 条强化配置、${entryCount} 个强化等级成功率均为 ${probability}%，强化成功后会直接升至该装备满级，并把装备完美度提升到上限。`,
      false
    );
  }

  function updatePetSkillHint() {
    const status = document.getElementById("petSkillStatus");
    if (!optimizationItem("petSkill") && !status) {
      return;
    }

    if (!petSkillState) {
      setOptimizationStatus(status, "…", "is-pending", "检测中");
      setOptimizationDescription("petSkill", "正在检测宠物技能领悟配置状态。", false);
      return;
    }
    if (!petSkillState.loaded) {
      setOptimizationStatus(status, "×", "is-error", "未生效");
      setOptimizationDescription(
        "petSkill",
        petSkillState.error
          ? `宠物技能优化加载失败：${petSkillState.error}`
          : "宠物技能配置还未加载完成。请先成功进入一次游戏，关闭后重新打开；重启后该优化会自动生效。",
        true
      );
      return;
    }

    const pools = formatAmount(petSkillState.optimizedPoolCount || petSkillState.learningPoolCount || 0);
    const skills = formatAmount(petSkillState.affectedSkillCount || 0);
    const fragments = formatAmount(petSkillState.fragmentEntryRemovalCount || 0);
    const multiplier = Number(petSkillState.initialExpMultiplier) || 20;
    const nextLevelProbability = Math.round(((Number(petSkillState.nextLevelUnlockProbability) || 10000) / 10000) * 100);
    setOptimizationStatus(status, "✓", "is-ok", "已生效");
    setOptimizationDescription(
      "petSkill",
      `宠物技能优化已生效：${pools} 个领悟池只保留最高品质技能，移除 ${fragments} 个技能碎片结果，下一等级解锁概率 ${nextLevelProbability}%，${skills} 个可领悟技能初始经验提升为 ${multiplier} 倍。`,
      false
    );
  }

  function updateZodiacSoulExpHint() {
    const status = document.getElementById("zodiacSoulExpStatus");
    if (!optimizationItem("zodiacSoulExp") && !status) {
      return;
    }

    if (!zodiacSoulExpState) {
      setOptimizationStatus(status, "…", "is-pending", "检测中");
      setOptimizationDescription("zodiacSoulExp", "正在检测斗魂升级补丁状态。", false);
      return;
    }
    if (!zodiacSoulExpState.loaded) {
      setOptimizationStatus(status, "×", "is-error", "未生效");
      setOptimizationDescription(
        "zodiacSoulExp",
        zodiacSoulExpState.error
          ? `斗魂升级优化加载失败：${zodiacSoulExpState.error}`
          : "斗魂升级补丁还未生成完成。请先成功进入一次游戏，关闭后重新打开；重启后该优化会自动生效。",
        true
      );
      return;
    }

    const targetLevel = formatAmount(zodiacSoulExpState.targetLevel || 100);
    const targetUpLimit = formatAmount(zodiacSoulExpState.targetUpLimit || 3);
    setOptimizationStatus(status, "✓", "is-ok", "已生效");
    setOptimizationDescription(
      "zodiacSoulExp",
      `斗魂升级优化已生效：融化斗魂时直接升到 ${targetLevel} 级，并同步写入最高等级上限 ${targetUpLimit}。`,
      false
    );
  }

  function updateAdvancedPetEggHint() {
    const status = document.getElementById("advancedPetEggStatus");
    if (!optimizationItem("advancedPetEgg") && !status) {
      return;
    }

    if (!advancedPetEggState) {
      setOptimizationStatus(status, "…", "is-pending", "检测中");
      setOptimizationDescription("advancedPetEgg", "正在检测高级宠物蛋池状态。", false);
      return;
    }
    if (!advancedPetEggState.loaded) {
      setOptimizationStatus(status, "×", "is-error", "未生效");
      setOptimizationDescription(
        "advancedPetEgg",
        advancedPetEggState.error
          ? `高级宠物蛋池优化加载失败：${advancedPetEggState.error}`
          : "高级宠物蛋池配置还未加载完成。请先成功进入一次游戏，关闭后重新打开；重启后该优化会自动生效。",
        true
      );
      return;
    }

    const firstTarget = Array.isArray(advancedPetEggState.targets) ? advancedPetEggState.targets[0] : null;
    const targetCount = firstTarget && Array.isArray(firstTarget.patchedPetIds) ? firstTarget.patchedPetIds.length : 0;
    const firstProbability = firstTarget && Array.isArray(firstTarget.patchedProbabilities) ? firstTarget.patchedProbabilities[0] : 0;
    const probabilityText = formatProbability(firstProbability, advancedPetEggState.probabilityTotal);
    setOptimizationStatus(status, "✓", "is-ok", "已生效");
    setOptimizationDescription(
      "advancedPetEgg",
      `高级宠物蛋池优化已生效：仅保留 ${targetCount} 只 4 星以上宠物并加入暗黑之子，单只概率 ${probabilityText}。`,
      false
    );
  }

  function updatePetFusionExpHint() {
    const status = document.getElementById("petFusionExpStatus");
    if (!optimizationItem("petFusionExp") && !status) {
      return;
    }

    if (!petFusionExpState) {
      setOptimizationStatus(status, "…", "is-pending", "检测中");
      setOptimizationDescription("petFusionExp", "正在检测宠物初始融合经验状态。", false);
      return;
    }
    if (!petFusionExpState.loaded) {
      setOptimizationStatus(status, "×", "is-error", "未生效");
      setOptimizationDescription(
        "petFusionExp",
        petFusionExpState.error
          ? `宠物初始融合经验优化加载失败：${petFusionExpState.error}`
          : "宠物表配置还未加载完成。请先成功进入一次游戏，关闭后重新打开；重启后该优化会自动生效。",
        true
      );
      return;
    }

    const multiplier = Number(petFusionExpState.multiplier) || 10;
    const targets = Array.isArray(petFusionExpState.targets) ? petFusionExpState.targets : [];
    const details = targets
      .map((target) => {
        const base = Math.round(Number(target.targetFusionExp || 0) / multiplier);
        return `${target.name || `宠物 ${target.petId}`} ${formatAmount(base)}→${formatAmount(target.targetFusionExp)}`;
      })
      .join("；");
    setOptimizationStatus(status, "✓", "is-ok", "已生效");
    setOptimizationDescription(
      "petFusionExp",
      `宠物初始融合经验优化已生效：${targets.length} 只高级宠物蛋目标宠物的初始融合经验提升为原来的 ${multiplier} 倍。${details ? `\n${details}` : ""}`,
      false
    );
  }

  function updateOptimizationControls() {
    updateLevelRewardHint();
    updateActivityVisibilityHint();
    updateEquipmentStrengtheningHint();
    updatePetSkillHint();
    updateZodiacSoulExpHint();
    updateAdvancedPetEggHint();
    updatePetFusionExpHint();
  }

  function bagLabel(value) {
    const labels = {
      0: "装备",
      1: "宝石",
      2: "其他",
      3: "时装",
      4: "装备槽",
      5: "强化",
      6: "镶嵌",
      7: "合成",
      8: "仓库",
      11: "武魂",
    };
    return labels[value] || `背包 ${value}`;
  }

  function jobLabel(value) {
    const labels = {
      "-1": "不限",
      0: "不限",
      1: "机枪",
      2: "炮击",
      3: "冷兵器",
      4: "绝影",
    };
    return labels[value] || `职业 ${value}`;
  }

  function itemById(id) {
    return itemCatalog.find((item) => item.id === Number(id)) || null;
  }

  function hasItemMallValue(item) {
    const mallPrice = Number(item && item.mallPrice);
    return Boolean(item && item.hasMallPrice) && Number.isFinite(mallPrice) && mallPrice > 0;
  }

  function maxStackForItem(item) {
    const stack = Math.floor(Number(item && item.stack));
    return Number.isFinite(stack) && stack > 0 ? Math.min(999, stack) : 1;
  }

  function itemLabel(entry) {
    const item = itemById(entry && entry.id);
    const name = item && item.name ? item.name : `ID ${entry && entry.id ? entry.id : 0}`;
    return `${name} / ID ${entry && entry.id ? entry.id : 0} x${entry && entry.count ? entry.count : 1}`;
  }

  function itemSummary(item) {
    const parts = [
      `ID ${item.id}`,
      bagLabel(item.bag),
      `类型 ${item.type}`,
      `小类 ${item.smallType}`,
      `堆叠 ${maxStackForItem(item)}`,
    ];
    if (hasItemMallValue(item)) {
      parts.push(`商城价值 ${formatAmount(item.mallPrice)}`);
    }
    if (item.job !== -1 && item.job !== 0) {
      parts.push(jobLabel(item.job));
    }
    return parts.join(" / ");
  }

  function itemDetails(item) {
    return [
      `名称：${item.name || "未命名"}`,
      `ID：${item.id}`,
      `背包：${bagLabel(item.bag)} (${item.bag})`,
      `类型：${item.type}，小类：${item.smallType}`,
      `职业限制：${jobLabel(item.job)} (${item.job})`,
      `使用等级：${item.useLevel}`,
      `创建等级：${item.createLevel}`,
      `颜色：${item.color}，阶段：${item.quality}`,
      `普通价格：${item.price}`,
      `商城价值：${hasItemMallValue(item) ? formatAmount(item.mallPrice) : "无"}`,
      `堆叠上限：${maxStackForItem(item)}`,
      `可使用：${item.canUse ? "是" : "否"}`,
      item.needId > 0 ? `需求：${item.needId} x${item.needCount}` : "",
      item.description ? `说明：${item.description}` : "",
    ].filter(Boolean).join("\n");
  }

  function ensureItemPopover() {
    if (itemPopover && document.body.contains(itemPopover)) {
      return itemPopover;
    }
    itemPopover = document.createElement("div");
    itemPopover.className = "item-detail-popover";
    itemPopover.setAttribute("role", "tooltip");
    document.body.appendChild(itemPopover);
    return itemPopover;
  }

  function positionItemPopover(target) {
    if (!itemPopover) {
      return;
    }
    const rect = target.getBoundingClientRect();
    const margin = 10;
    const gap = 8;
    const width = itemPopover.offsetWidth;
    const height = itemPopover.offsetHeight;
    let left = rect.right + gap;
    if (left + width > window.innerWidth - margin) {
      left = rect.left - width - gap;
    }
    if (left < margin) {
      left = Math.max(margin, window.innerWidth - width - margin);
    }

    let top = rect.top;
    if (top + height > window.innerHeight - margin) {
      top = window.innerHeight - height - margin;
    }
    itemPopover.style.left = `${Math.max(margin, left)}px`;
    itemPopover.style.top = `${Math.max(margin, top)}px`;
  }

  function showItemPopover(target) {
    const item = itemById(target.getAttribute("data-item-id"));
    if (!item) {
      return;
    }
    const popover = ensureItemPopover();
    popover.textContent = "";

    const title = document.createElement("div");
    title.className = "item-detail-popover-title";
    title.textContent = item.name || "未命名";

    const body = document.createElement("div");
    body.className = "item-detail-popover-body";
    body.textContent = itemDetails(item);

    popover.append(title, body);
    popover.classList.add("is-visible");
    positionItemPopover(target);
  }

  function hideItemPopover() {
    if (itemPopover) {
      itemPopover.classList.remove("is-visible");
    }
  }

  function ensureOptimizationPopover() {
    if (optimizationPopover && document.body.contains(optimizationPopover)) {
      return optimizationPopover;
    }
    optimizationPopover = document.createElement("div");
    optimizationPopover.className = "item-detail-popover optimization-detail-popover";
    optimizationPopover.setAttribute("role", "tooltip");
    document.body.appendChild(optimizationPopover);
    return optimizationPopover;
  }

  function positionOptimizationPopover(target) {
    if (!optimizationPopover) {
      return;
    }
    const rect = target.getBoundingClientRect();
    const margin = 10;
    const gap = 8;
    const width = optimizationPopover.offsetWidth;
    const height = optimizationPopover.offsetHeight;
    let left = rect.right + gap;
    if (left + width > window.innerWidth - margin) {
      left = rect.left - width - gap;
    }
    if (left < margin) {
      left = Math.max(margin, window.innerWidth - width - margin);
    }

    let top = rect.top;
    if (top + height > window.innerHeight - margin) {
      top = window.innerHeight - height - margin;
    }
    optimizationPopover.style.left = `${Math.max(margin, left)}px`;
    optimizationPopover.style.top = `${Math.max(margin, top)}px`;
  }

  function showOptimizationPopover(target) {
    const bodyText = target.getAttribute("data-popover-body") || "";
    if (!bodyText) {
      return;
    }
    const popover = ensureOptimizationPopover();
    popover.textContent = "";

    const title = document.createElement("div");
    title.className = "item-detail-popover-title";
    title.textContent = target.getAttribute("data-popover-title") || "体验优化";

    const body = document.createElement("div");
    body.className = "item-detail-popover-body";
    body.textContent = bodyText;

    popover.append(title, body);
    popover.classList.toggle("is-warning", target.getAttribute("data-popover-tone") === "warning");
    popover.classList.add("is-visible");
    positionOptimizationPopover(target);
  }

  function hideOptimizationPopover() {
    if (optimizationPopover) {
      optimizationPopover.classList.remove("is-visible");
      optimizationPopover.classList.remove("is-warning");
    }
  }

  function setItemHint(message, warning) {
    const hint = document.getElementById("itemSendHint");
    if (!hint) {
      return;
    }
    hint.textContent = message;
    hint.classList.toggle("is-warning", Boolean(warning));
  }

  function renderItemSearchResults() {
    const list = document.getElementById("itemSearchResults");
    if (!list) {
      return;
    }
    hideItemPopover();
    if (itemCatalog.length === 0) {
      list.innerHTML = `<div class="empty-state">物品数据尚未加载。请先成功加载一次游戏资源。</div>`;
      return;
    }

    const query = itemSearchTerm.trim().toLowerCase();
    const filtered = itemCatalog
      .filter((item) => {
        if (!query) {
          return true;
        }
        return String(item.id).includes(query)
          || String(item.name || "").toLowerCase().includes(query)
          || String(item.type).includes(query)
          || String(item.smallType).includes(query)
          || String(item.bag).includes(query)
          || bagLabel(item.bag).toLowerCase().includes(query)
          || jobLabel(item.job).toLowerCase().includes(query);
      })
      .slice(0, 80);

    if (filtered.length === 0) {
      list.innerHTML = `<div class="empty-state">没有匹配的物品。</div>`;
      return;
    }

    list.innerHTML = filtered.map((item) => {
      const maxStack = maxStackForItem(item);
      const actions = QUICK_ITEM_COUNTS.map((count) => {
        const disabled = count > maxStack;
        const reason = `堆叠上限 ${maxStack}`;
        return `<button type="button" data-add-item="${item.id}" data-add-count="${count}" ${disabled ? "disabled" : ""} title="${escapeHtml(disabled ? reason : `发送 ${count} 个`)}">+${count}</button>`;
      }).join("");
      return `
        <div class="item-result" data-item-id="${item.id}" tabindex="0">
          <div class="item-result-name">${escapeHtml(item.name || "未命名")}</div>
          <div class="item-add-actions">${actions}</div>
        </div>
      `;
    }).join("");
  }

  async function refreshItems() {
    const response = await fetch("/api/saveData/items", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error == null ? `读取物品列表失败: ${response.status}` : result.error);
    }
    itemCatalog = Array.isArray(result.items) ? result.items : [];
    renderItemSearchResults();
    if (!result.loaded) {
      setItemHint("物品数据尚未加载。请先成功进入一次游戏，或等待资源缓存完成后重载。", true);
    }
    return result;
  }

  async function sendItemImmediately(itemId, count) {
    const item = itemById(itemId);
    if (!item) {
      setItemHint(`未找到物品 ID ${itemId}`, true);
      return;
    }
    const amount = clampInteger(count, 1, 1, 999);
    const maxStack = maxStackForItem(item);
    if (amount > maxStack) {
      setItemHint(`${item.name || item.id} 的堆叠上限是 ${maxStack}，不能发送 +${amount}。`, true);
      return;
    }

    itemQueue = [{ id: item.id, count: amount }];
    try {
      const called = await callFlashCallback("codexSendBagItems");
      if (!called) {
        itemQueue = [];
        setItemHint("未找到 Flash 回调 codexSendBagItems。请重载游戏并进入存档后再试。", true);
        window.__saveDataLog && window.__saveDataLog("发送物品失败：未找到 Flash 回调");
        return;
      }
      if (itemQueue.length > 0) {
        setItemHint(`已请求发送 ${item.name || item.id} x${amount}。${hasItemMallValue(item) ? ` 商城价值 ${formatAmount(item.mallPrice)}。` : ""}`, hasItemMallValue(item));
        window.__saveDataLog && window.__saveDataLog(`发送物品已触发：${itemLabel(itemQueue[0])}`);
      }
    } catch (error) {
      itemQueue = [];
      const message = error instanceof Error ? error.message : String(error);
      setItemHint(message, true);
      window.__saveDataLog && window.__saveDataLog(`发送物品异常：${message}`);
    }
  }

  function findFlashCallback(callbackName) {
    const candidates = [];
    if (typeof window[callbackName] === "function") {
      candidates.push(window);
    }
    for (const item of document.querySelectorAll("object, embed")) {
      candidates.push(item);
    }
    return candidates.find((item) => item && typeof item[callbackName] === "function") || null;
  }

  async function callFlashCallback(callbackName) {
    const target = findFlashCallback(callbackName);
    if (!target) {
      return false;
    }
    target[callbackName]();
    return true;
  }

  window.dataIndexYouData = function (kind, payload) {
    if (kind === "goodsId" || kind === "goodsNum") {
      const index = clampInteger(payload, 0, 0, MAX_ITEM_QUEUE);
      if (kind === "goodsId" && index >= MAX_ITEM_QUEUE) {
        return window.codexBagMockDone();
      }
      return window.codexBagMockValue(kind, index);
    }
    return "0";
  };

  window.codexBagMockValue = function (kind, index) {
    const safeIndex = clampInteger(index, 0, 0, MAX_ITEM_QUEUE - 1);
    const item = itemQueue[safeIndex];
    if (!item) {
      return "0";
    }
    return kind === "goodsNum" ? String(item.count) : String(item.id);
  };

  window.codexBagMockDone = function () {
    if (itemQueue.length === 0) {
      return "0";
    }
    const sentItems = itemQueue.slice();
    itemQueue = [];
    setItemHint(`Flash 已读取 ${sentItems.map(itemLabel).join("；")}。`, false);
    window.__saveDataLog && window.__saveDataLog(`Flash 已读取发送物品：${sentItems.map(itemLabel).join("；")}`);
    return "1";
  };

  async function refreshLevelRewards() {
    const response = await fetch("/api/saveData/level-rewards", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error == null ? `读取关卡奖励失败: ${response.status}` : result.error);
    }
    levelRewardState = result;
    updateOptimizationControls();
    return result;
  }

  async function refreshActivityVisibility() {
    const response = await fetch("/api/saveData/activity-visibility", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error == null ? `读取活动配置失败: ${response.status}` : result.error);
    }
    activityVisibilityState = result;
    updateOptimizationControls();
    return result;
  }

  async function refreshEquipmentStrengthening() {
    const response = await fetch("/api/saveData/equipment-strengthening", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error == null ? `读取装备强化配置失败: ${response.status}` : result.error);
    }
    equipmentStrengtheningState = result;
    updateOptimizationControls();
    return result;
  }

  async function refreshPetSkills() {
    const response = await fetch("/api/saveData/pet-skills", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error == null ? `读取宠物技能配置失败: ${response.status}` : result.error);
    }
    petSkillState = result;
    updateOptimizationControls();
    return result;
  }

  async function refreshZodiacSoulExp() {
    const response = await fetch("/api/saveData/zodiac-soul-exp", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error == null ? `读取斗魂升级补丁状态失败: ${response.status}` : result.error);
    }
    zodiacSoulExpState = result;
    updateOptimizationControls();
    return result;
  }

  async function refreshAdvancedPetEggs() {
    const response = await fetch("/api/saveData/advanced-pet-eggs", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error == null ? `读取高级宠物蛋池失败: ${response.status}` : result.error);
    }
    advancedPetEggState = result;
    updateOptimizationControls();
    return result;
  }

  async function refreshPetFusionExp() {
    const response = await fetch("/api/saveData/pet-fusion-exp", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error == null ? `读取宠物初始融合经验失败: ${response.status}` : result.error);
    }
    petFusionExpState = result;
    updateOptimizationControls();
    return result;
  }

  function renderWallet(wallet) {
    const balance = document.getElementById("walletBalance");
    const totalRecharged = document.getElementById("walletTotalRecharged");
    const totalPaid = document.getElementById("walletTotalPaid");

    if (balance) {
      balance.textContent = formatAmount(wallet.balance);
    }
    if (totalRecharged) {
      totalRecharged.textContent = formatAmount(wallet.totalRecharged);
    }
    if (totalPaid) {
      totalPaid.textContent = formatAmount(wallet.totalPaid);
    }
  }

  async function refreshWallet() {
    if (walletRefreshInFlight) {
      return null;
    }
    walletRefreshInFlight = true;
    try {
      const response = await fetch(`/api/saveData/wallet?uid=${encodeURIComponent(account.uid)}`, { cache: "no-store" });
      if (!response.ok) {
        throw new Error(`读取钱包失败: ${response.status}`);
      }
      const wallet = await response.json();
      renderWallet(wallet);
      return wallet;
    } finally {
      walletRefreshInFlight = false;
    }
  }

  async function rechargeLocally() {
    const input = document.getElementById("rechargeAmount");
    const amount = Math.floor(Number(input ? input.value : 0));

    if (isRechargeBlocked()) {
      window.__saveDataLog && window.__saveDataLog(rechargeBlockedMessage());
      updateRechargeControls();
      return;
    }

    if (!Number.isSafeInteger(amount) || amount <= 0) {
      window.__saveDataLog && window.__saveDataLog("充值金额无效");
      return;
    }

    rechargeBusy = true;
    updateRechargeControls();

    try {
      const response = await fetch("/api/saveData/recharge", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ uid: account.uid, amount }),
      });
      const result = await response.json();
      if (!response.ok || !result.ok) {
        throw new Error(result.error == null ? `HTTP ${response.status}` : result.error);
      }

      renderWallet(result.wallet);
      window.__saveDataLog && window.__saveDataLog(`本地充值 +${formatAmount(result.wallet.amount)}，余额 ${formatAmount(result.wallet.balance)}`);

      const notified = window.__refreshGamePaymentState ? await window.__refreshGamePaymentState() : undefined;
      if (notified) {
        window.__saveDataLog && window.__saveDataLog("已请求游戏刷新余额");
      } else {
        window.__saveDataLog && window.__saveDataLog("游戏将在下一次余额查询时读取新值");
      }
    } catch (error) {
      window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error));
    } finally {
      rechargeBusy = false;
      updateRechargeControls();
    }
  }

  function activateTab(tabName) {
    for (const button of document.querySelectorAll("[data-tab-button]")) {
      button.classList.toggle("is-active", button.getAttribute("data-tab-button") === tabName);
    }
    for (const panel of document.querySelectorAll("[data-tab-panel]")) {
      panel.classList.toggle("is-active", panel.getAttribute("data-tab-panel") === tabName);
    }
    if (tabName === "onlineMode") {
      refreshOnlineMode().catch((error) => setOnlineModeHint(error instanceof Error ? error.message : String(error), true));
    }
  }

  function setupTabs() {
    for (const button of document.querySelectorAll("[data-tab-button]")) {
      button.addEventListener("click", () => activateTab(button.getAttribute("data-tab-button") || "wallet"));
    }
  }

  window.__saveDataRefreshWallet = refreshWallet;
  window.__saveDataNotifyWalletChanged = function () {
    return refreshWallet()
      .then(() => {
        window.__saveDataLog && window.__saveDataLog("已刷新本地钱包金额");
        return true;
      })
      .catch((error) => {
        window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error));
        return false;
      });
  };

  setupTabs();
  renderItemSearchResults();

  const localRechargeButton = document.getElementById("localRecharge");
  if (localRechargeButton) {
    localRechargeButton.addEventListener("click", () => {
      rechargeLocally();
    });
  }
  const onlineModeJoin = document.getElementById("onlineModeJoin");
  if (onlineModeJoin) onlineModeJoin.addEventListener("click", joinOnlineMode);
  const onlineModeSaveProfile = document.getElementById("onlineModeSaveProfile");
  if (onlineModeSaveProfile) onlineModeSaveProfile.addEventListener("click", saveOnlineUsername);
  const onlineModeSync = document.getElementById("onlineModeSync");
  if (onlineModeSync) onlineModeSync.addEventListener("click", syncOnlineMode);
  const onlineModeRefresh = document.getElementById("onlineModeRefresh");
  if (onlineModeRefresh) {
    onlineModeRefresh.addEventListener("click", () => {
      refreshOnlineMode().catch((error) => setOnlineModeHint(error instanceof Error ? error.message : String(error), true));
    });
  }
  const optimizationList = document.querySelector(".optimization-list");
  if (optimizationList) {
    optimizationList.addEventListener("pointerover", (event) => {
      const item = event.target && event.target.closest ? event.target.closest(".optimization-item") : null;
      if (item && optimizationList.contains(item)) {
        showOptimizationPopover(item);
      }
    });
    optimizationList.addEventListener("pointerout", (event) => {
      const item = event.target && event.target.closest ? event.target.closest(".optimization-item") : null;
      if (!item) {
        return;
      }
      const related = event.relatedTarget;
      if (related && item.contains(related)) {
        return;
      }
      hideOptimizationPopover();
    });
    optimizationList.addEventListener("focusin", (event) => {
      const item = event.target && event.target.closest ? event.target.closest(".optimization-item") : null;
      if (item && optimizationList.contains(item)) {
        showOptimizationPopover(item);
      }
    });
    optimizationList.addEventListener("focusout", (event) => {
      const item = event.target && event.target.closest ? event.target.closest(".optimization-item") : null;
      const related = event.relatedTarget;
      if (!item || (related && item.contains(related))) {
        return;
      }
      hideOptimizationPopover();
    });
  }
  const itemSearch = document.getElementById("itemSearch");
  if (itemSearch) {
    itemSearch.addEventListener("input", () => {
      itemSearchTerm = itemSearch.value;
      renderItemSearchResults();
    });
  }
  const itemSearchResults = document.getElementById("itemSearchResults");
  if (itemSearchResults) {
    itemSearchResults.addEventListener("click", (event) => {
      const button = event.target && event.target.closest ? event.target.closest("[data-add-item]") : null;
      if (!button || button.disabled) {
        return;
      }
      sendItemImmediately(button.getAttribute("data-add-item"), button.getAttribute("data-add-count"));
    });
    itemSearchResults.addEventListener("pointerover", (event) => {
      const result = event.target && event.target.closest ? event.target.closest(".item-result") : null;
      if (result && itemSearchResults.contains(result)) {
        showItemPopover(result);
      }
    });
    itemSearchResults.addEventListener("pointerout", (event) => {
      const result = event.target && event.target.closest ? event.target.closest(".item-result") : null;
      if (!result) {
        return;
      }
      const related = event.relatedTarget;
      if (related && result.contains(related)) {
        return;
      }
      hideItemPopover();
    });
    itemSearchResults.addEventListener("focusin", (event) => {
      const result = event.target && event.target.closest ? event.target.closest(".item-result") : null;
      if (result && itemSearchResults.contains(result)) {
        showItemPopover(result);
      }
    });
    itemSearchResults.addEventListener("focusout", (event) => {
      const result = event.target && event.target.closest ? event.target.closest(".item-result") : null;
      const related = event.relatedTarget;
      if (!result || (related && result.contains(related))) {
        return;
      }
      hideItemPopover();
    });
  }
  updateRechargeControls();
  updateOptimizationControls();
  refreshWallet().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));
  refreshLevelRewards().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));
  refreshActivityVisibility().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));
  refreshEquipmentStrengthening().catch((error) =>
    window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error))
  );
  refreshPetSkills().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));
  refreshZodiacSoulExp().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));
  refreshAdvancedPetEggs().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));
  refreshPetFusionExp().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));
  refreshItems().catch((error) => {
    setItemHint(error instanceof Error ? error.message : String(error), true);
    window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error));
  });
  refreshOnlineMode().catch((error) => setOnlineModeHint(error instanceof Error ? error.message : String(error), true));
  window.addEventListener("resize", () => {
    hideItemPopover();
    hideOptimizationPopover();
  });
  window.addEventListener("scroll", () => {
    hideItemPopover();
    hideOptimizationPopover();
  }, true);
  window.setInterval(() => {
    refreshWallet().catch(() => undefined);
  }, 3000);
  window.setInterval(() => {
    const panel = document.querySelector('[data-tab-panel="onlineMode"]');
    if (panel && panel.classList.contains("is-active") && !onlineModeBusy) {
      refreshOnlineMode().catch(() => undefined);
    }
  }, 15000);
})();
