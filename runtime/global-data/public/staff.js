(() => {
  "use strict";

  const state = { overview: null, season: null, view: "players", search: "", loading: false, settling: false };
  const elements = {
    summary: document.getElementById("summaryCards"),
    players: document.getElementById("playersView"),
    unions: document.getElementById("unionsView"),
    ranks: document.getElementById("ranksView"),
    searchBox: document.getElementById("searchBox"),
    search: document.getElementById("playerSearch"),
    refresh: document.getElementById("refreshButton"),
    serviceState: document.getElementById("serviceState"),
    lastUpdated: document.getElementById("lastUpdated"),
    notice: document.getElementById("notice"),
  };

  const summaryItems = [
    ["playerCount", "联机玩家", "#36d9d0"],
    ["saveSlotCount", "服务器存档", "#5ea7ff"],
    ["unionCount", "军团", "#f0bf68"],
    ["unionMemberCount", "军团成员", "#57d38c"],
    ["unionApplicationCount", "待审申请", "#b992ff"],
    ["rankEntryCount", "排行记录", "#ff7785"],
  ];

  function escapeHtml(value) {
    return String(value ?? "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  function parseServerDate(value) {
    if (!value) return null;
    const normalized = /Z$|[+-]\d\d:\d\d$/.test(value) ? value : `${value.replace(" ", "T")}Z`;
    const date = new Date(normalized);
    return Number.isNaN(date.getTime()) ? null : date;
  }

  function formatTime(value) {
    const date = parseServerDate(value);
    return date ? date.toLocaleString("zh-CN", { hour12: false }) : "—";
  }

  function relativeTime(value) {
    const date = parseServerDate(value);
    if (!date) return "未知";
    const seconds = Math.max(0, Math.floor((Date.now() - date.getTime()) / 1000));
    if (seconds < 60) return `${seconds} 秒前`;
    if (seconds < 3600) return `${Math.floor(seconds / 60)} 分钟前`;
    if (seconds < 86400) return `${Math.floor(seconds / 3600)} 小时前`;
    return `${Math.floor(seconds / 86400)} 天前`;
  }

  function isRecent(value) {
    const date = parseServerDate(value);
    return Boolean(date && Date.now() - date.getTime() < 5 * 60 * 1000);
  }

  function renderSummary() {
    const summary = state.overview?.summary ?? {};
    elements.summary.innerHTML = summaryItems.map(([key, label, color]) => `
      <article class="summary-card" style="--accent:${color}">
        <span class="summary-label">${label}</span>
        <strong class="summary-value">${Number(summary[key] ?? 0).toLocaleString("zh-CN")}</strong>
      </article>
    `).join("");
  }

  function renderPlayers() {
    const query = state.search.trim().toLowerCase();
    const players = (state.overview?.players ?? []).filter((player) => {
      if (!query) return true;
      return [player.uid, player.username, player.nickname, player.instanceId]
        .some((value) => String(value).toLowerCase().includes(query));
    });
    if (!players.length) {
      elements.players.innerHTML = `<div class="empty">${query ? "没有符合条件的玩家" : "尚无玩家接入联机模式"}</div>`;
      return;
    }
    elements.players.innerHTML = `<div class="table-wrap"><table>
      <thead><tr><th>UID / 玩家</th><th>Windows 实例</th><th>最近活动</th><th>存档</th><th>军团身份</th><th>排行记录</th><th>接入时间</th></tr></thead>
      <tbody>${players.map((player) => `
        <tr>
          <td class="identity"><strong>${escapeHtml(player.username)}</strong><small><span class="uid">${player.uid}</span> · ${escapeHtml(player.nickname)}</small></td>
          <td><span class="subtle" title="${escapeHtml(player.instanceId)}">${escapeHtml(player.instanceId)}</span></td>
          <td title="${escapeHtml(formatTime(player.lastSeenAt))}"><span class="activity${isRecent(player.lastSeenAt) ? " is-recent" : ""}">${relativeTime(player.lastSeenAt)}</span></td>
          <td>${player.saveCount}<br><small class="subtle">${player.latestSaveAt ? relativeTime(player.latestSaveAt) : "无服务器存档"}</small></td>
          <td>${player.unionMembershipCount}</td>
          <td>${player.rankEntryCount}</td>
          <td>${formatTime(player.createdAt)}</td>
        </tr>
      `).join("")}</tbody>
    </table></div>`;
  }

  function memberCard(member) {
    return `<article class="member-card">
      <strong>${escapeHtml(member.username)} ${member.roleName === "团长" ? '<span class="tag is-owner">团长</span>' : `<span class="tag">${escapeHtml(member.roleName)}</span>`}</strong>
      <div class="member-meta"><span><span class="uid">${escapeHtml(member.uid)}</span> · 存档位 ${String(member.slotIndex + 1).padStart(2, "0")}</span><span>贡献 ${member.contribution}</span></div>
    </article>`;
  }

  function applicationCard(application) {
    return `<article class="member-card">
      <strong>${escapeHtml(application.username)} <span class="tag is-pending">待审核</span></strong>
      <div class="member-meta"><span><span class="uid">${escapeHtml(application.uid)}</span> · 存档位 ${String(application.slotIndex + 1).padStart(2, "0")}</span><span>${relativeTime(application.createdAt)}</span></div>
    </article>`;
  }

  function renderUnions() {
    const unions = state.overview?.unions ?? [];
    if (!unions.length) {
      elements.unions.innerHTML = '<div class="empty">当前还没有军团</div>';
      return;
    }
    elements.unions.innerHTML = `<div class="union-list">${unions.map((union, index) => `
      <details class="union-card"${index === 0 ? " open" : ""}>
        <summary class="union-head">
          <div class="union-title"><h2>${escapeHtml(union.title)}</h2><span class="tag">Lv.${union.level}</span><span class="tag">ID ${union.id}</span></div>
          <div class="union-metrics"><span>团长 ${escapeHtml(union.ownerUsername)} · <span class="uid">${escapeHtml(union.ownerUid)}</span></span><span>成员 ${union.members.length}</span><span>申请 ${union.applications.length}</span><span>经验 ${union.experience}</span></div>
        </summary>
        <div class="union-body">
          <p class="section-title">成员</p>
          <div class="member-grid">${union.members.length ? union.members.map(memberCard).join("") : '<span class="subtle">暂无成员</span>'}</div>
          <p class="section-title">待处理申请</p>
          <div class="member-grid">${union.applications.length ? union.applications.map(applicationCard).join("") : '<span class="subtle">暂无申请</span>'}</div>
        </div>
      </details>
    `).join("")}</div>`;
  }

  function renderRanks() {
    const ranks = state.overview?.ranks ?? [];
    const season = state.season;
    const currentRank = ranks.find((rank) => Number(rank.rankListId) === 1093);
    const seasonCard = season ? `
      <article class="season-card">
        <div>
          <span class="section-kicker">竞技场赛季</span>
          <h2>第 ${Number(season.currentSeason).toLocaleString("zh-CN")} 赛季</h2>
          <p>上次结算：${season.lastSettledSeason > 0 ? `第 ${season.lastSettledSeason} 赛季 · ${formatTime(season.lastSettledAt)}` : "尚未结算"}</p>
        </div>
        <div class="season-actions">
          <span>${currentRank ? `${currentRank.entryCount} 名参赛者，最高 ${Number(currentRank.topScore).toLocaleString("zh-CN")} 分` : "当前榜单为空"}</span>
          <button class="danger-button" id="settleSeasonButton" type="button"${state.settling || !currentRank?.entryCount ? " disabled" : ""}>
            ${state.settling ? "正在结算…" : `结算第 ${season.currentSeason} 赛季`}
          </button>
        </div>
      </article>` : "";
    const rankCards = ranks.length ? `<div class="rank-grid">${ranks.map((rank) => `
      <article class="rank-card">
        <h2>排行榜 ${rank.rankListId}</h2>
        <div class="rank-score">${Number(rank.topScore).toLocaleString("zh-CN")}</div>
        <div class="subtle">当前最高分</div>
        <div class="rank-meta"><span>${rank.entryCount} 条记录</span><span>${relativeTime(rank.updatedAt)}更新</span></div>
      </article>
    `).join("")}</div>` : '<div class="empty">当前还没有排行榜数据</div>';
    elements.ranks.innerHTML = `${seasonCard}${rankCards}`;
  }

  function render() {
    renderSummary();
    renderPlayers();
    renderUnions();
    renderRanks();
    elements.players.hidden = state.view !== "players";
    elements.unions.hidden = state.view !== "unions";
    elements.ranks.hidden = state.view !== "ranks";
    elements.searchBox.hidden = state.view !== "players";
  }

  function setConnectionState(kind, text) {
    elements.serviceState.className = `status-pill is-${kind}`;
    elements.serviceState.innerHTML = `<span></span>${escapeHtml(text)}`;
  }

  async function refresh() {
    if (state.loading) return;
    state.loading = true;
    elements.refresh.disabled = true;
    elements.notice.hidden = true;
    setConnectionState("loading", "正在刷新");
    try {
      const [overviewResponse, seasonResponse] = await Promise.all([
        fetch("/api/staff/overview", { cache: "no-store" }),
        fetch("/api/global/arena/season", { cache: "no-store" }),
      ]);
      const [overview, season] = await Promise.all([overviewResponse.json(), seasonResponse.json()]);
      if (!overviewResponse.ok || !overview.ok) throw new Error(overview.message || overview.error || `HTTP ${overviewResponse.status}`);
      if (!seasonResponse.ok || !season.ok) throw new Error(season.message || season.error || `HTTP ${seasonResponse.status}`);
      state.overview = overview;
      state.season = season;
      render();
      setConnectionState("online", "服务正常");
      elements.lastUpdated.textContent = `数据生成于 ${formatTime(overview.generatedAt)}`;
    } catch (error) {
      setConnectionState("error", "连接失败");
      elements.notice.textContent = `无法读取 Staff 数据：${error instanceof Error ? error.message : String(error)}`;
      elements.notice.hidden = false;
    } finally {
      state.loading = false;
      elements.refresh.disabled = false;
    }
  }

  async function settleSeason() {
    if (state.settling || !state.season) return;
    const expectedSeason = Number(state.season.currentSeason);
    const currentRank = (state.overview?.ranks ?? []).find((rank) => Number(rank.rankListId) === 1093);
    if (!currentRank?.entryCount) return;
    const confirmed = window.confirm(
      `确认结算第 ${expectedSeason} 赛季？\n\n当前 ${currentRank.entryCount} 名参赛者将写入上赛季榜单 975，当前榜单 1093 会重置为 1 分。此操作不可直接撤销。`
    );
    if (!confirmed) return;

    state.settling = true;
    renderRanks();
    elements.notice.hidden = true;
    try {
      const response = await fetch("/api/staff/arena/settle", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ expectedSeason, confirmation: `SETTLE_SEASON_${expectedSeason}` }),
      });
      const result = await response.json();
      if (!response.ok || !result.ok) throw new Error(result.message || result.error || `HTTP ${response.status}`);
      await refresh();
      elements.notice.className = "notice is-success";
      elements.notice.textContent = `第 ${result.settledSeason} 赛季结算完成：${result.entryCount} 名玩家，最高 ${Number(result.topScore).toLocaleString("zh-CN")} 分；当前已进入第 ${result.currentSeason} 赛季。`;
      elements.notice.hidden = false;
    } catch (error) {
      elements.notice.className = "notice";
      elements.notice.textContent = `赛季结算失败：${error instanceof Error ? error.message : String(error)}`;
      elements.notice.hidden = false;
    } finally {
      state.settling = false;
      renderRanks();
    }
  }

  document.querySelectorAll(".tab").forEach((tab) => {
    tab.addEventListener("click", () => {
      state.view = tab.dataset.view;
      document.querySelectorAll(".tab").forEach((item) => item.classList.toggle("is-active", item === tab));
      render();
    });
  });
  elements.search.addEventListener("input", () => { state.search = elements.search.value; renderPlayers(); });
  elements.refresh.addEventListener("click", refresh);
  elements.ranks.addEventListener("click", (event) => {
    if (event.target.closest("#settleSeasonButton")) settleSeason();
  });

  render();
  refresh();
  window.setInterval(refresh, 15000);
})();
