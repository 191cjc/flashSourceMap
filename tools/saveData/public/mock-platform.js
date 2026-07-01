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

  window.__saveDataLog = function (message) {
    const log = document.getElementById("log");
    if (!log) {
      return;
    }
    const li = document.createElement("li");
    li.textContent = message;
    log.prepend(li);
  };
})();
