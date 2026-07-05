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
  let gameState = "selecting";
  let rechargeBusy = false;
  let walletRefreshInFlight = false;
  let levelRewardState = null;

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
    const status = document.getElementById("levelRewardStatus");
    if (!hint && !status) {
      return;
    }

    function setStatus(text, className, label) {
      if (!status) {
        return;
      }
      status.textContent = text;
      status.classList.remove("is-pending", "is-ok", "is-error");
      status.classList.add(className);
      status.setAttribute("aria-label", label);
    }

    if (hint) {
      hint.classList.remove("is-warning");
    }
    if (!levelRewardState) {
      setStatus("…", "is-pending", "检测中");
      if (hint) {
        hint.textContent = "正在检测体验优化状态。";
      }
      return;
    }
    if (!levelRewardState.loaded) {
      setStatus("×", "is-error", "未生效");
      if (hint) {
        hint.textContent = "关卡数据还未加载完成。请先成功进入一次游戏，关闭后重新打开；重启后该优化会自动生效。";
        hint.classList.add("is-warning");
      }
      return;
    }

    const value = formatAmount(levelRewardState.achievementBoostValue);
    setStatus("✓", "is-ok", "已生效");
    if (hint) {
      hint.textContent = `关卡成就点奖励优化已生效：通关成就点奖励固定为 ${value}。`;
    }
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
