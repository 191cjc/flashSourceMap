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
    const button = document.getElementById("localRecharge");
    const amount = Math.floor(Number(input?.value ?? 0));

    if (!Number.isSafeInteger(amount) || amount <= 0) {
      window.__saveDataLog?.("充值金额无效");
      return;
    }

    if (button) {
      button.disabled = true;
    }

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
      if (button) {
        button.disabled = false;
      }
    }
  }

  window.__saveDataRefreshWallet = refreshWallet;
  document.getElementById("localRecharge")?.addEventListener("click", () => {
    rechargeLocally();
  });

  refreshWallet().catch((error) => window.__saveDataLog?.(error instanceof Error ? error.message : String(error)));
})();
