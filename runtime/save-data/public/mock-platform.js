(function () {
  const account = {
    uid: "10001",
    username: "local_user",
    nickname: "本地玩家",
    loginType: "local",
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
  let levelRewardBusy = false;
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
      log.lastElementChild?.remove();
    }
  };

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
      window.__saveDataLog?.("已进入游戏，本地充值入口已暂时禁用");
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

  function formatAmount(value) {
    return Number(value ?? 0).toLocaleString("zh-CN");
  }

  async function readJsonResponse(response) {
    const text = await response.text();
    try {
      return JSON.parse(text);
    } catch {
      throw new Error(text || `HTTP ${response.status}`);
    }
  }

  function selectedLevelReward() {
    const select = document.getElementById("levelRewardSelect");
    const key = select?.value;
    if (!key || !levelRewardState?.levels) {
      return null;
    }
    return levelRewardState.levels.find((level) => level.key === key) ?? null;
  }

  function updateLevelRewardHint(level) {
    const hint = document.getElementById("levelRewardHint");
    if (!hint) {
      return;
    }
    hint.classList.toggle("is-warning", gameState === "in_game");
    if (!levelRewardState) {
      hint.textContent = "正在读取关卡奖励配置。";
      return;
    }
    if (!levelRewardState.loaded) {
      hint.textContent = "未找到 dataxmlvav447.swf，启动游戏加载资源后再试。";
      return;
    }
    if (!level) {
      hint.textContent = "请选择一个关卡。";
      return;
    }

    const original = level.original;
    const base = level.hasOverride
      ? `已覆盖，原始 ${formatAmount(original.exp)}/${formatAmount(original.gold)}/${formatAmount(original.achievement)}。`
      : `原始 ${formatAmount(original.exp)}/${formatAmount(original.gold)}/${formatAmount(original.achievement)}。`;
    hint.textContent =
      gameState === "in_game" ? `${base} 修改会保存，但需要重载游戏后生效。` : `${base} 修改后重载游戏生效。`;
  }

  function updateLevelRewardControls() {
    const select = document.getElementById("levelRewardSelect");
    const exp = document.getElementById("levelRewardExp");
    const gold = document.getElementById("levelRewardGold");
    const achievement = document.getElementById("levelRewardAchievement");
    const apply = document.getElementById("applyLevelReward");
    const reset = document.getElementById("resetLevelReward");
    const level = selectedLevelReward();
    const available = Boolean(levelRewardState?.loaded && levelRewardState.levels?.length);

    if (select) {
      select.disabled = levelRewardBusy || !available;
    }
    for (const input of [exp, gold, achievement]) {
      if (input) {
        input.disabled = levelRewardBusy || !available || !level;
      }
    }
    if (apply) {
      apply.disabled = levelRewardBusy || !available || !level;
      apply.textContent = levelRewardBusy ? "保存中" : "应用";
    }
    if (reset) {
      reset.disabled = levelRewardBusy || !available || !level?.hasOverride;
    }
    updateLevelRewardHint(level);
  }

  function updateLevelRewardInputs() {
    const level = selectedLevelReward();
    const exp = document.getElementById("levelRewardExp");
    const gold = document.getElementById("levelRewardGold");
    const achievement = document.getElementById("levelRewardAchievement");
    if (!level) {
      for (const input of [exp, gold, achievement]) {
        if (input) {
          input.value = "";
        }
      }
      return;
    }

    if (exp) {
      exp.value = String(level.effective.exp);
    }
    if (gold) {
      gold.value = String(level.effective.gold);
    }
    if (achievement) {
      achievement.value = String(level.effective.achievement);
    }
  }

  function renderLevelRewards(previousKey) {
    const select = document.getElementById("levelRewardSelect");
    if (!select) {
      return;
    }
    select.textContent = "";

    if (!levelRewardState?.loaded || !levelRewardState.levels.length) {
      const option = document.createElement("option");
      option.value = "";
      option.textContent = levelRewardState?.loaded ? "无关卡数据" : "未加载资源";
      select.append(option);
      updateLevelRewardInputs();
      updateLevelRewardControls();
      return;
    }

    for (const level of levelRewardState.levels) {
      const option = document.createElement("option");
      option.value = level.key;
      option.textContent = `${level.levelId} ${level.name} / 难度${level.difficulty}${level.hasOverride ? " *" : ""}`;
      select.append(option);
    }

    const nextKey =
      previousKey && levelRewardState.levels.some((level) => level.key === previousKey)
        ? previousKey
        : levelRewardState.levels[0].key;
    select.value = nextKey;
    updateLevelRewardInputs();
    updateLevelRewardControls();
  }

  async function refreshLevelRewards() {
    const select = document.getElementById("levelRewardSelect");
    const previousKey = select?.value;
    const response = await fetch("/api/saveData/level-rewards", { cache: "no-store" });
    const result = await readJsonResponse(response);
    if (!response.ok || result.ok !== true) {
      throw new Error(result.error ?? `读取关卡奖励失败: ${response.status}`);
    }
    levelRewardState = result;
    renderLevelRewards(previousKey);
    return result;
  }

  function readRewardInput(id, label) {
    const input = document.getElementById(id);
    const value = Math.floor(Number(input?.value ?? NaN));
    if (!Number.isSafeInteger(value) || value < 0) {
      throw new Error(`${label}必须是大于等于 0 的整数`);
    }
    return value;
  }

  async function applyLevelReward() {
    const level = selectedLevelReward();
    if (!level) {
      window.__saveDataLog?.("请选择关卡");
      return;
    }

    levelRewardBusy = true;
    updateLevelRewardControls();
    try {
      const payload = {
        levelId: level.levelId,
        difficulty: level.difficulty,
        exp: readRewardInput("levelRewardExp", "经验"),
        gold: readRewardInput("levelRewardGold", "金币"),
        achievement: readRewardInput("levelRewardAchievement", "成就"),
      };
      const response = await fetch("/api/saveData/level-rewards", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify(payload),
      });
      const result = await readJsonResponse(response);
      if (!response.ok || result.ok !== true) {
        throw new Error(result.error ?? `保存关卡奖励失败: ${response.status}`);
      }
      levelRewardState = result;
      renderLevelRewards(level.key);
      window.__saveDataLog?.(
        `已修改 ${level.levelId} ${level.name} 难度${level.difficulty}: ${formatAmount(payload.exp)}/${formatAmount(
          payload.gold
        )}/${formatAmount(payload.achievement)}，重载游戏后生效`
      );
    } catch (error) {
      window.__saveDataLog?.(error instanceof Error ? error.message : String(error));
    } finally {
      levelRewardBusy = false;
      updateLevelRewardControls();
    }
  }

  async function resetLevelReward() {
    const level = selectedLevelReward();
    if (!level) {
      window.__saveDataLog?.("请选择关卡");
      return;
    }

    levelRewardBusy = true;
    updateLevelRewardControls();
    try {
      const response = await fetch("/api/saveData/level-rewards/clear", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ levelId: level.levelId, difficulty: level.difficulty }),
      });
      const result = await readJsonResponse(response);
      if (!response.ok || result.ok !== true) {
        throw new Error(result.error ?? `还原关卡奖励失败: ${response.status}`);
      }
      levelRewardState = result;
      renderLevelRewards(level.key);
      window.__saveDataLog?.(`已还原 ${level.levelId} ${level.name} 难度${level.difficulty}，重载游戏后生效`);
    } catch (error) {
      window.__saveDataLog?.(error instanceof Error ? error.message : String(error));
    } finally {
      levelRewardBusy = false;
      updateLevelRewardControls();
    }
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
    const response = await fetch(`/api/saveData/wallet?uid=${encodeURIComponent(account.uid)}`, { cache: "no-store" });
    if (!response.ok) {
      throw new Error(`读取钱包失败: ${response.status}`);
    }
    const wallet = await response.json();
    renderWallet(wallet);
    return wallet;
  }

  async function rechargeLocally() {
    const input = document.getElementById("rechargeAmount");
    const amount = Math.floor(Number(input?.value ?? 0));

    if (isRechargeBlocked()) {
      window.__saveDataLog?.(rechargeBlockedMessage());
      updateRechargeControls();
      return;
    }

    if (!Number.isSafeInteger(amount) || amount <= 0) {
      window.__saveDataLog?.("充值金额无效");
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
        throw new Error(result.error ?? `HTTP ${response.status}`);
      }

      renderWallet(result.wallet);
      window.__saveDataLog?.(`本地充值 +${formatAmount(result.wallet.amount)}，余额 ${formatAmount(result.wallet.balance)}`);

      const notified = await window.__refreshGamePaymentState?.();
      if (notified) {
        window.__saveDataLog?.("已请求游戏刷新余额");
      } else {
        window.__saveDataLog?.("游戏将在下一次余额查询时读取新值");
      }
    } catch (error) {
      window.__saveDataLog?.(error instanceof Error ? error.message : String(error));
    } finally {
      rechargeBusy = false;
      updateRechargeControls();
    }
  }

  window.__saveDataRefreshWallet = refreshWallet;
  document.getElementById("localRecharge")?.addEventListener("click", () => {
    rechargeLocally();
  });
  document.getElementById("levelRewardSelect")?.addEventListener("change", () => {
    updateLevelRewardInputs();
    updateLevelRewardControls();
  });
  document.getElementById("applyLevelReward")?.addEventListener("click", () => {
    applyLevelReward();
  });
  document.getElementById("resetLevelReward")?.addEventListener("click", () => {
    resetLevelReward();
  });

  updateRechargeControls();
  updateLevelRewardControls();
  refreshWallet().catch((error) => window.__saveDataLog?.(error instanceof Error ? error.message : String(error)));
  refreshLevelRewards().catch((error) => window.__saveDataLog?.(error instanceof Error ? error.message : String(error)));
})();
