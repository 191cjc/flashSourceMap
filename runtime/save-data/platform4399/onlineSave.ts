import { createHash } from "node:crypto";
import type { OnlineSaveSlot } from "../types.js";

const LOGIN_URL = "https://ptlogin.4399.com/ptlogin/login.do";
const SAVE_API_BASE = "https://save.api.4399.com/";
const SAVE_AUTH_URL = "https://save.api.4399.com/auth/openapi.php?method=User.Authenticate";
const SAVE_TOKEN_URL = "https://save.api.4399.com/index.php?ac=get_token";
const DEFAULT_GAME_ID = "100025235";
const SAVE_SLOT_FIRST_INDEX = 1;
const SAVE_KEY_SALT = "LPislKLodlLKKOSNlSDOAADLKADJAOADALAklsd";
const VERIFY_PREFIX = "SDALPlsldlnSLWPElsdslSE";
const VERIFY_SUFFIX = "PKslsO";
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

type FetchLike = typeof fetch;

function md5(value: string): string {
  return createHash("md5").update(value).digest("hex");
}

function tripleMd5(value: string): string {
  return md5(md5(md5(value)));
}

function saveGameKey(gameId: string): string {
  return md5(md5(`${gameId}${SAVE_KEY_SALT}${gameId}`)).slice(4, 20);
}

function decodeCookieValue(value: string, passes = 1): string {
  let decoded = value;
  for (let pass = 0; pass < passes; pass += 1) {
    try {
      decoded = decodeURIComponent(decoded);
    } catch {
      break;
    }
  }
  return decoded;
}

function getCookieValue(cookie: string, name: string): string | null {
  const expected = name.toLowerCase();
  for (const part of cookie.split(";")) {
    const pair = part.trim();
    const eq = pair.indexOf("=");
    if (eq <= 0 || pair.slice(0, eq).trim().toLowerCase() !== expected) continue;
    return pair.slice(eq + 1).trim();
  }
  return null;
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
  const pauth = getCookieValue(cookie, "Pauth");
  if (pauth) {
    const uid = decodeCookieValue(pauth, 2).split("|", 1)[0]?.trim();
    if (uid && /^\d+$/.test(uid)) return uid;
  }

  const legacyUid = getCookieValue(cookie, "Puid") ?? getCookieValue(cookie, "uid");
  return legacyUid ? decodeCookieValue(legacyUid).trim() || null : null;
}

function extractUsernameFromCookie(cookie: string): string | null {
  const value = getCookieValue(cookie, "Puser") ?? getCookieValue(cookie, "ck_accname");
  return value ? decodeCookieValue(value).trim() || null : null;
}

function extractNicknameFromCookie(cookie: string): string | null {
  const value = getCookieValue(cookie, "Pnick") ?? getCookieValue(cookie, "Qnick");
  return value ? decodeCookieValue(value).trim() || null : null;
}

export async function loginTo4399(request: OnlineLoginRequest, fetchImpl: FetchLike = fetch): Promise<OnlineSession> {
  if (request.cookie?.trim()) {
    const cookie = request.cookie.trim();
    const uid = request.uid?.trim() || extractUidFromCookie(cookie);
    if (!uid) {
      throw new OnlineSaveError("missing_uid", "使用 cookie 登录时必须提供 uid");
    }
    const username = request.username?.trim() || extractUsernameFromCookie(cookie) || `4399_${uid}`;
    const nickname = extractNicknameFromCookie(cookie) || username;
    return { uid, username, nickname, cookie };
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
    response = await fetchImpl(LOGIN_URL, {
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
    throw new OnlineSaveError("login_failed", "登录失败：未获取到会话，请检查账号密码", {
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
    throw new OnlineSaveError("login_failed", "登录失败：4399 未返回有效登录会话，请检查账号密码", {
      bodyPreview: bodyText.slice(0, 200),
    });
  }

  const sessionUsername = extractUsernameFromCookie(cookie) || username;
  const nickname =
    typeof parsed.nick === "string"
      ? parsed.nick
      : typeof parsed.nickname === "string"
        ? parsed.nickname
        : extractNicknameFromCookie(cookie) || sessionUsername;
  return { uid, username: sessionUsername, nickname, cookie };
}

async function postSaveForm(
  url: string,
  session: OnlineSession,
  params: Record<string, string>,
  fetchImpl: FetchLike
): Promise<string> {
  let response: Response;
  try {
    response = await fetchImpl(url, {
      method: "POST",
      headers: { ...REQUEST_HEADERS, Cookie: session.cookie, "content-type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams(params).toString(),
      redirect: "manual",
    });
  } catch (error) {
    throw new OnlineSaveError("network_error", `存档请求失败：${error instanceof Error ? error.message : String(error)}`);
  }
  if (!response.ok) {
    throw new OnlineSaveError("save_api_error", `存档接口返回 ${response.status}`, { status: response.status });
  }
  const body = await response.text();
  if (/^\s*Error:/i.test(body)) {
    throw new OnlineSaveError("save_api_error", `存档接口拒绝请求：${body.trim()}`);
  }
  return body;
}

type SaveContext = {
  gameId: string;
  gameKey: string;
  sessionId: string;
};

async function createSaveContext(
  session: OnlineSession,
  gameId: string,
  fetchImpl: FetchLike
): Promise<SaveContext> {
  const username = extractUsernameFromCookie(session.cookie) || session.username;
  const authBody = await postSaveForm(
    SAVE_AUTH_URL,
    session,
    { uid: session.uid, username, gameid: gameId },
    fetchImpl
  );
  const authParts = authBody.trim().split("|");
  if (authParts[1] !== "1000" || !authParts[2] || !authParts[3]) {
    throw new OnlineSaveError("save_auth_failed", "4399 存档账号认证失败");
  }

  const gameKey = saveGameKey(gameId);
  const sessionId = (
    await postSaveForm(
      `${SAVE_API_BASE}?ac=get_session`,
      session,
      {
        gameid: gameId,
        uid: session.uid,
        gamekey: gameKey,
        verify: tripleMd5(`${VERIFY_PREFIX}${gameKey}${session.uid}${gameId}${VERIFY_SUFFIX}`),
        refer: REQUEST_HEADERS.Referer,
      },
      fetchImpl
    )
  ).trim();
  if (!sessionId) {
    throw new OnlineSaveError("save_session_failed", "4399 存档会话创建失败");
  }
  return { gameId, gameKey, sessionId };
}

async function getSaveToken(session: OnlineSession, context: SaveContext, fetchImpl: FetchLike): Promise<string> {
  return (
    await postSaveForm(
      SAVE_TOKEN_URL,
      session,
      { gameid: context.gameId, uid: session.uid },
      fetchImpl
    )
  ).trim();
}

async function fetchSaveListBody(
  session: OnlineSession,
  context: SaveContext,
  fetchImpl: FetchLike
): Promise<string> {
  const token = await getSaveToken(session, context, fetchImpl);
  return postSaveForm(
    `${SAVE_API_BASE}?ac=get_list`,
    session,
    {
      gameid: context.gameId,
      uid: session.uid,
      token,
      gamekey: context.gameKey,
      verify: tripleMd5(
        `${VERIFY_PREFIX}${context.gameKey}${session.uid}${context.gameId}${token}${VERIFY_SUFFIX}`
      ),
    },
    fetchImpl
  );
}

async function fetchSaveDetailBody(
  session: OnlineSession,
  context: SaveContext,
  index: number,
  fetchImpl: FetchLike
): Promise<string> {
  const token = await getSaveToken(session, context, fetchImpl);
  return postSaveForm(
    `${SAVE_API_BASE}?ac=get`,
    session,
    {
      gameid: context.gameId,
      uid: session.uid,
      index: String(index),
      token,
      gamekey: context.gameKey,
      verify: tripleMd5(
        `${VERIFY_PREFIX}${index}${context.gameKey}${session.uid}${context.gameId}${token}${VERIFY_SUFFIX}`
      ),
      session: context.sessionId,
      refer: REQUEST_HEADERS.Referer,
    },
    fetchImpl
  );
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
  gameId: string = DEFAULT_GAME_ID,
  fetchImpl: FetchLike = fetch
): Promise<OnlineSaveSlot[]> {
  const context = await createSaveContext(session, gameId, fetchImpl);
  const listBody = await fetchSaveListBody(session, context, fetchImpl);
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

  for (let index = SAVE_SLOT_FIRST_INDEX; index < SAVE_SLOT_FIRST_INDEX + ONLINE_SAVE_SLOT_COUNT; index += 1) {
    const summary = byIndex.get(index);
    let data = summary?.data ?? "";

    if (!data && summary) {
      const detail = (await fetchSaveDetailBody(session, context, index, fetchImpl)).trim();
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
