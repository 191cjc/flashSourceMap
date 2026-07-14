import type { OnlineSaveSlot } from "../types.js";

const LOGIN_URL = "https://ptlogin.4399.com/ptlogin/login.do";
const SAVE_API_BASE = "http://save.api.4399.com/";
const DEFAULT_GAME_ID = "100025235";
export const ONLINE_SAVE_SLOT_COUNT = 6;

const REQUEST_HEADERS = {
  "User-Agent":
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36",
  Referer: "https://www.4399.com/",
} as const;

export type OnlineSession = {
  uid: string;
  username: string;
  nickname: string;
  cookie: string;
};

export type OnlineLoginRequest = {
  username?: string;
  password?: string;
  cookie?: string;
  uid?: string;
};

export class OnlineSaveError extends Error {
  constructor(readonly result: string, message: string, readonly details?: Record<string, unknown>) {
    super(message);
    this.name = "OnlineSaveError";
  }
}

function collectSetCookie(response: Response): string {
  const headerWithGetter = response.headers as Headers & { getSetCookie?: () => string[] };
  const list =
    typeof headerWithGetter.getSetCookie === "function"
      ? headerWithGetter.getSetCookie()
      : (() => {
          const single = response.headers.get("set-cookie");
          return single ? [single] : [];
        })();

  const jar = new Map<string, string>();
  for (const entry of list) {
    const pair = entry.split(";", 1)[0]?.trim();
    if (!pair) continue;
    const eq = pair.indexOf("=");
    if (eq <= 0) continue;
    jar.set(pair.slice(0, eq).trim(), pair.slice(eq + 1).trim());
  }
  return [...jar.entries()].map(([k, v]) => `${k}=${v}`).join("; ");
}

function extractUidFromCookie(cookie: string): string | null {
  const match = /(?:^|;\s*)Puid=([^;]+)/.exec(cookie) ?? /(?:^|;\s*)puid=([^;]+)/i.exec(cookie);
  return match ? decodeURIComponent(match[1]) : null;
}

export async function loginTo4399(request: OnlineLoginRequest): Promise<OnlineSession> {
  if (request.cookie?.trim()) {
    const cookie = request.cookie.trim();
    const uid = request.uid?.trim() || extractUidFromCookie(cookie);
    if (!uid) {
      throw new OnlineSaveError("missing_uid", "使用 cookie 登录时必须提供 uid");
    }
    return { uid, username: request.username ?? `4399_${uid}`, nickname: request.username ?? `4399账号${uid}`, cookie };
  }

  const username = request.username?.trim();
  const password = request.password ?? "";
  if (!username || !password) {
    throw new OnlineSaveError("missing_credentials", "请输入 4399 账号和密码");
  }

  const form = new URLSearchParams({
    username,
    password,
    savePassword: "0",
    remember_me: "0",
    domain: "4399.com",
    layout: "2",
    displayModel: "0",
    from: "web",
  });

  let response: Response;
  try {
    response = await fetch(LOGIN_URL, {
      method: "POST",
      headers: { ...REQUEST_HEADERS, "content-type": "application/x-www-form-urlencoded" },
      body: form.toString(),
      redirect: "manual",
    });
  } catch (error) {
    throw new OnlineSaveError("network_error", `登录请求失败：${error instanceof Error ? error.message : String(error)}`);
  }

  const cookie = collectSetCookie(response);
  const bodyText = await response.text();

  if (!cookie) {
    throw new OnlineSaveError("login_failed", "登录失败：未获取到会话，请检查账号密码或改用 cookie 登录", {
      status: response.status,
      bodyPreview: bodyText.slice(0, 200),
    });
  }

  let parsed: Record<string, unknown> = {};
  try {
    parsed = JSON.parse(bodyText) as Record<string, unknown>;
  } catch {
    // 部分返回是 JSONP 或 HTML，忽略解析错误，靠 cookie 判断。
  }

  const code = parsed.code ?? parsed.errcode;
  if (code != null && String(code) !== "0" && String(code) !== "success") {
    throw new OnlineSaveError("login_rejected", `登录被拒绝：${String(parsed.msg ?? parsed.message ?? code)}`, { code });
  }

  const uid =
    (typeof parsed.uid === "string" || typeof parsed.uid === "number" ? String(parsed.uid) : null) ??
    extractUidFromCookie(cookie);
  if (!uid) {
    throw new OnlineSaveError("missing_uid", "登录成功但无法解析 uid，请改用 cookie + uid 登录", {
      bodyPreview: bodyText.slice(0, 200),
    });
  }

  const nickname =
    typeof parsed.nick === "string" ? parsed.nick : typeof parsed.nickname === "string" ? parsed.nickname : username;
  return { uid, username, nickname, cookie };
}

async function fetchSaveEndpoint(session: OnlineSession, params: Record<string, string>): Promise<string> {
  const url = new URL(SAVE_API_BASE);
  for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);

  let response: Response;
  try {
    response = await fetch(url.toString(), {
      method: "GET",
      headers: { ...REQUEST_HEADERS, Cookie: session.cookie },
    });
  } catch (error) {
    throw new OnlineSaveError("network_error", `存档请求失败：${error instanceof Error ? error.message : String(error)}`);
  }
  if (!response.ok) {
    throw new OnlineSaveError("save_api_error", `存档接口返回 ${response.status}`, { status: response.status });
  }
  return response.text();
}

type RawSlot = {
  index?: number | string;
  idx?: number | string;
  title?: string;
  name?: string;
  datetime?: string;
  time?: string;
  status?: number | string;
  data?: string;
};

function normalizeSlot(raw: RawSlot, fallbackIndex: number): OnlineSaveSlot | null {
  const index = Number(raw.index ?? raw.idx ?? fallbackIndex);
  if (!Number.isFinite(index)) return null;
  return {
    index,
    title: raw.title ?? raw.name ?? `存档 ${index}`,
    datetime: raw.datetime ?? raw.time ?? "",
    status: raw.status ?? 0,
    data: typeof raw.data === "string" ? raw.data : "",
  };
}

export async function fetchOnlineSaveList(
  session: OnlineSession,
  gameId: string = DEFAULT_GAME_ID
): Promise<OnlineSaveSlot[]> {
  const listBody = await fetchSaveEndpoint(session, { ac: "get_list", gameid: gameId, uid: session.uid });
  const trimmed = listBody.trim();

  let summaries: OnlineSaveSlot[] = [];
  if (trimmed && trimmed !== "0") {
    try {
      const parsed = JSON.parse(trimmed) as RawSlot[] | { list?: RawSlot[]; data?: RawSlot[] };
      const rawList = Array.isArray(parsed) ? parsed : (parsed.list ?? parsed.data ?? []);
      summaries = rawList
        .map((raw, i) => normalizeSlot(raw, i))
        .filter((s): s is OnlineSaveSlot => s != null);
    } catch (error) {
      throw new OnlineSaveError("list_parse_error", `存档列表解析失败：${error instanceof Error ? error.message : String(error)}`, {
        bodyPreview: trimmed.slice(0, 200),
      });
    }
  }

  const byIndex = new Map(summaries.map((s) => [s.index, s]));
  const slots: OnlineSaveSlot[] = [];

  for (let index = 0; index < ONLINE_SAVE_SLOT_COUNT; index += 1) {
    const summary = byIndex.get(index);
    let data = summary?.data ?? "";

    if (!data && summary) {
      const detail = (await fetchSaveEndpoint(session, { ac: "get", gameid: gameId, uid: session.uid, index: String(index) })).trim();
      if (detail && detail !== "0") {
        try {
          const parsed = JSON.parse(detail) as RawSlot;
          data = typeof parsed.data === "string" ? parsed.data : detail;
        } catch {
          data = detail;
        }
      }
    }

    slots.push({
      index,
      title: summary?.title ?? `存档 ${index}`,
      datetime: summary?.datetime ?? "",
      status: summary?.status ?? 0,
      data,
    });
  }

  return slots;
}
