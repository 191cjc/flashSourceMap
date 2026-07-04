(function () {
  const account = {
    uid: "10001",
    username: "local_user",
    nickname: "本地玩家",
    loginType: "local",
  };

  const ITEM_QUEUE_KEY = "__saveDataItemQueue";
  const MAX_ITEM_QUEUE = 12;
  const BAG_LABELS = {
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
  let gameState = "selecting";
  let rechargeBusy = false;
  let walletRefreshInFlight = false;
  let levelRewardState = null;
  let itemCatalog = [];
  let itemQueue = loadItemQueue();

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

  function clampInteger(value, fallback, min, max) {
    const parsed = Number.parseInt(String(value), 10);
    if (!Number.isFinite(parsed)) {
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

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

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
    updateLevelRewardControls();
    if (state === "in_game") {
      window.__saveDataLog && window.__saveDataLog("已进入游戏，本地充值入口已暂时禁用");
    }
  };

  fetch("/api/unilogin/account")
    .then((response) => response.json())
    .then((serverAccount) => {
      Object.assign(account, serverAccount);
    })
    .finally(() => {
      const el = document.getElementById("account");
      if (el) {
        el.textContent = `${account.nickname} (${account.uid})`;
      }
    });

  function updateLevelRewardHint() {
    const hint = document.getElementById("levelRewardHint");
    if (!hint) {
      return;
    }
    hint.classList.remove("is-warning");
    if (!levelRewardState) {
      hint.textContent = "正在读取关卡奖励配置。";
      return;
    }
    if (!levelRewardState.loaded) {
      hint.textContent = "未找到 dataxmlvav447.swf，启动游戏加载资源后再试。";
      return;
    }

    const value = formatAmount(levelRewardState.achievementBoostValue);
    hint.textContent = `通关成就奖励已固定启用为 ${value}，重载游戏后生效。`;
  }

  function updateLevelRewardControls() {
    updateLevelRewardHint();
  }

  async function refreshLevelRewards() {
    const response = await fetch("/api/saveData/level-rewards", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error == null ? `读取关卡奖励失败: ${response.status}` : result.error);
    }
    levelRewardState = result;
    updateLevelRewardControls();
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
  }

  function setupTabs() {
    for (const button of document.querySelectorAll("[data-tab-button]")) {
      button.addEventListener("click", () => activateTab(button.getAttribute("data-tab-button") || "wallet"));
    }
  }

  function bagLabel(value) {
    return BAG_LABELS[value] || `背包 ${value}`;
  }

  function itemById(id) {
    return itemCatalog.find((item) => item.id === Number(id)) || null;
  }

  function itemLabel(entry) {
    const item = itemById(entry?.id);
    const name = item?.name || `ID ${entry?.id || 0}`;
    return `${name} / ID ${entry?.id || 0} x${entry?.count || 1}`;
  }

  function itemMeta(item) {
    const parts = [bagLabel(item.bag), `类型 ${item.type}`, `小类 ${item.smallType}`];
    if (item.stack > 0) {
      parts.push(`叠加 ${item.stack}`);
    }
    if (item.hasMallPrice && item.mallPrice > 0) {
      parts.push(`商城价 ${item.mallPrice}`);
    }
    return parts.join(" / ");
  }

  function normalizeItemQueue(value) {
    return (Array.isArray(value) ? value : [])
      .map((item) => ({
        id: clampInteger(item?.id, 0, 0, 999999),
        count: clampInteger(item?.count, 1, 1, 999),
      }))
      .filter((item) => item.id > 0)
      .slice(0, MAX_ITEM_QUEUE);
  }

  function loadItemQueue() {
    try {
      return normalizeItemQueue(JSON.parse(localStorage.getItem(ITEM_QUEUE_KEY)));
    } catch {
      return [];
    }
  }

  function saveItemQueue() {
    itemQueue = normalizeItemQueue(itemQueue);
    try {
      localStorage.setItem(ITEM_QUEUE_KEY, JSON.stringify(itemQueue));
    } catch {
      // The in-memory queue is still usable.
    }
    renderItemQueue();
  }

  function setItemHint(message, warning) {
    const hint = document.getElementById("itemHint");
    if (!hint) {
      return;
    }
    hint.textContent = message;
    hint.classList.toggle("is-warning", Boolean(warning));
  }

  function populateItemFilters() {
    const bagFilter = document.getElementById("itemBagFilter");
    const typeFilter = document.getElementById("itemTypeFilter");
    if (bagFilter) {
      const bags = [...new Set(itemCatalog.map((item) => item.bag).filter((value) => Number.isFinite(value)))].sort((a, b) => a - b);
      bagFilter.innerHTML = `<option value="-1">全部</option>${bags.map((bag) => `<option value="${bag}">${escapeHtml(bagLabel(bag))} / ${bag}</option>`).join("")}`;
    }
    if (typeFilter) {
      const types = [...new Set(itemCatalog.map((item) => item.type).filter((value) => Number.isFinite(value)))].sort((a, b) => a - b);
      typeFilter.innerHTML = `<option value="-1">全部</option>${types.map((type) => `<option value="${type}">类型 ${type}</option>`).join("")}`;
    }
  }

  function selectedItemFilters() {
    return {
      query: String(document.getElementById("itemSearch")?.value || "").trim().toLowerCase(),
      bag: clampInteger(document.getElementById("itemBagFilter")?.value, -1, -1, 99),
      type: clampInteger(document.getElementById("itemTypeFilter")?.value, -1, -1, 999),
    };
  }

  function renderItemResults() {
    const list = document.getElementById("itemResults");
    if (!list) {
      return;
    }
    const idInput = document.getElementById("itemId");
    const selectedId = Number(idInput?.value || 0);
    const filters = selectedItemFilters();
    const results = itemCatalog
      .filter((item) => {
        if (filters.bag !== -1 && item.bag !== filters.bag) {
          return false;
        }
        if (filters.type !== -1 && item.type !== filters.type) {
          return false;
        }
        if (!filters.query) {
          return true;
        }
        return String(item.id).includes(filters.query)
          || String(item.name || "").toLowerCase().includes(filters.query)
          || String(item.type).includes(filters.query)
          || String(item.smallType).includes(filters.query)
          || String(item.bag).includes(filters.query)
          || bagLabel(item.bag).toLowerCase().includes(filters.query);
      })
      .slice(0, 120);

    if (results.length === 0) {
      list.innerHTML = `<div class="item-queue-label">没有匹配物品，也可以直接填写物品 ID。</div>`;
      return;
    }

    list.innerHTML = results.map((item) => `
      <button class="${item.id === selectedId ? "is-active" : ""}" data-item-select="${item.id}" type="button">
        ${escapeHtml(item.name || "未命名")}
        <span class="item-meta">ID ${item.id} / ${escapeHtml(itemMeta(item))}</span>
      </button>
    `).join("");

    for (const button of list.querySelectorAll("[data-item-select]")) {
      button.addEventListener("click", () => {
        const id = button.getAttribute("data-item-select") || "";
        if (idInput) {
          idInput.value = id;
        }
        renderItemResults();
      });
    }
  }

  function renderItemQueue() {
    const root = document.getElementById("itemQueue");
    if (!root) {
      return;
    }
    if (itemQueue.length === 0) {
      root.innerHTML = `<div class="item-queue-label">队列为空。</div>`;
      return;
    }
    root.innerHTML = itemQueue.map((item, index) => `
      <div class="item-queue-row">
        <div class="item-queue-label">${escapeHtml(`${index + 1}. ${itemLabel(item)}`)}</div>
        <button data-item-remove="${index}" type="button">移除</button>
      </div>
    `).join("");

    for (const button of root.querySelectorAll("[data-item-remove]")) {
      button.addEventListener("click", () => {
        const index = clampInteger(button.getAttribute("data-item-remove"), -1, -1, itemQueue.length - 1);
        if (index >= 0) {
          itemQueue.splice(index, 1);
          saveItemQueue();
        }
      });
    }
  }

  function addSelectedItemToQueue() {
    const id = clampInteger(document.getElementById("itemId")?.value, 0, 0, 999999);
    const count = clampInteger(document.getElementById("itemCount")?.value, 1, 1, 999);
    if (id <= 0) {
      setItemHint("请先选择或输入物品 ID。", true);
      return;
    }
    if (itemQueue.length >= MAX_ITEM_QUEUE) {
      setItemHint(`队列最多 ${MAX_ITEM_QUEUE} 种物品。`, true);
      return;
    }
    itemQueue.push({ id, count });
    saveItemQueue();
    setItemHint(`已加入队列: ${itemLabel({ id, count })}`, false);
  }

  function findFlashCallback(callbackName) {
    const candidates = [];
    if (window[callbackName] && typeof window[callbackName] === "function") {
      candidates.push(window);
    }
    for (const item of document.querySelectorAll("object, embed")) {
      candidates.push(item);
    }
    return candidates.find((item) => item && typeof item[callbackName] === "function") || null;
  }

  function sendItemsToGame() {
    if (itemQueue.length === 0) {
      setItemHint("队列为空，不能发送。", true);
      return;
    }

    const callbackName = "codexSendBagItems";
    const target = findFlashCallback(callbackName);
    if (!target) {
      setItemHint(`未找到 Flash 回调 ${callbackName}，请先进入存档再试。`, true);
      return;
    }

    try {
      target[callbackName]();
      setItemHint(`已触发发送: ${itemQueue.length} 种物品。`, false);
      window.__saveDataLog && window.__saveDataLog(`物品发送已触发: ${itemQueue.map(itemLabel).join("; ")}`);
    } catch (error) {
      setItemHint(error instanceof Error ? error.message : String(error), true);
    }
  }

  async function loadItems() {
    try {
      const response = await fetch("/api/saveData/items", { cache: "no-store" });
      const result = await readJsonResponse(response);
      if (!response.ok || result.ok !== true) {
        throw new Error(result.error == null ? `HTTP ${response.status}` : result.error);
      }
      itemCatalog = Array.isArray(result.items) ? result.items : [];
      populateItemFilters();
      renderItemResults();
      renderItemQueue();
      setItemHint(result.loaded ? `已加载 ${itemCatalog.length} 个物品。` : "物品资源尚未加载，可直接输入 ID。", !result.loaded);
    } catch (error) {
      renderItemQueue();
      setItemHint(error instanceof Error ? error.message : String(error), true);
    }
  }

  function setupItemTools() {
    document.getElementById("itemSearch")?.addEventListener("input", renderItemResults);
    document.getElementById("itemBagFilter")?.addEventListener("change", renderItemResults);
    document.getElementById("itemTypeFilter")?.addEventListener("change", renderItemResults);
    document.getElementById("itemId")?.addEventListener("input", renderItemResults);
    document.getElementById("addItemToQueue")?.addEventListener("click", addSelectedItemToQueue);
    document.getElementById("sendItemsToGame")?.addEventListener("click", sendItemsToGame);
    document.getElementById("clearItemQueue")?.addEventListener("click", () => {
      itemQueue = [];
      saveItemQueue();
      setItemHint("队列已清空。", false);
    });
    renderItemQueue();
    loadItems();
  }

  window.dataIndexYouData = function (kind, payload) {
    if (kind !== "goodsId" && kind !== "goodsNum") {
      return "0";
    }
    const index = clampInteger(payload, 0, 0, MAX_ITEM_QUEUE);
    if (kind === "goodsId" && index >= MAX_ITEM_QUEUE) {
      return window.codexBagMockDone();
    }
    return window.codexBagMockValue(kind, index);
  };

  window.codexBagMockValue = function (kind, index) {
    const item = itemQueue[clampInteger(index, 0, 0, MAX_ITEM_QUEUE - 1)];
    if (!item) {
      return "0";
    }
    return String(kind === "goodsNum" ? item.count : item.id);
  };

  window.codexBagMockDone = function () {
    if (itemQueue.length === 0) {
      return "0";
    }
    window.__saveDataLog && window.__saveDataLog(`Flash 已读取物品队列: ${itemQueue.map(itemLabel).join("; ")}`);
    return "1";
  };

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
  setupItemTools();

  const localRechargeButton = document.getElementById("localRecharge");
  if (localRechargeButton) {
    localRechargeButton.addEventListener("click", () => {
      rechargeLocally();
    });
  }

  updateRechargeControls();
  updateLevelRewardControls();
  refreshWallet().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));
  refreshLevelRewards().catch((error) => window.__saveDataLog && window.__saveDataLog(error instanceof Error ? error.message : String(error)));
  window.setInterval(() => {
    refreshWallet().catch(() => undefined);
  }, 3000);
})();
