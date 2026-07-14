import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { fetchOnlineSaveList, loginTo4399, OnlineSaveError, type OnlineSession } from "../platform4399/onlineSave.js";

const UID = "123456789";
const USERNAME = "test-user";
const PASSWORD = "test-password";
const GAME_ID = "100025235";
const VERIFY_PREFIX = "SDALPlsldlnSLWPElsdslSE";
const VERIFY_SUFFIX = "PKslsO";
const SAVE_KEY_SALT = "LPislKLodlLKKOSNlSDOAADLKADJAOADALAklsd";

function md5(value: string): string {
  return createHash("md5").update(value).digest("hex");
}

function tripleMd5(value: string): string {
  return md5(md5(md5(value)));
}

function response(body: string, setCookies: string[] = []): Response {
  const headers = new Headers({ "content-type": "text/html; charset=utf-8" });
  for (const cookie of setCookies) headers.append("set-cookie", cookie);
  return new Response(body, { status: 200, headers });
}

async function testLoginCookieDecoding(): Promise<void> {
  const pauth = encodeURIComponent(encodeURIComponent(`${UID}|session|fields`));
  const nickname = encodeURIComponent("测试昵称");
  const fetchMock: typeof fetch = async () =>
    response("<html>login callback</html>", [
      `Pauth=${pauth}; Path=/; Domain=.4399.com`,
      `Puser=${USERNAME}; Path=/; Domain=.4399.com`,
      `Pnick=${nickname}; Path=/; Domain=.4399.com`,
    ]);

  const session = await loginTo4399({ username: USERNAME, password: PASSWORD }, fetchMock);
  assert.equal(session.uid, UID);
  assert.equal(session.username, USERNAME);
  assert.equal(session.nickname, "测试昵称");
  assert.match(session.cookie, /Pauth=/);
}

async function testInvalidLoginResponse(): Promise<void> {
  const fetchMock: typeof fetch = async () =>
    response("<html>rejected</html>", ["USESSIONID=temporary; Path=/; Domain=ptlogin.4399.com"]);

  await assert.rejects(
    () => loginTo4399({ username: USERNAME, password: "wrong" }, fetchMock),
    (error: unknown) => error instanceof OnlineSaveError && error.result === "login_failed"
  );
}

async function testSaveHandshakeAndSlots(): Promise<void> {
  const gameKey = md5(md5(`${GAME_ID}${SAVE_KEY_SALT}${GAME_ID}`)).slice(4, 20);
  const requests: Array<{ url: URL; params: URLSearchParams; init?: RequestInit }> = [];
  const fetchMock: typeof fetch = async (input, init) => {
    const url = new URL(typeof input === "string" || input instanceof URL ? input : input.url);
    const params = new URLSearchParams(String(init?.body ?? ""));
    requests.push({ url, params, init });

    if (url.pathname === "/auth/openapi.php") return response(`|1000|${UID}|${USERNAME}|`);
    if (url.searchParams.get("ac") === "get_session") return response("session-id");
    if (url.pathname === "/index.php") return response("token-value");
    if (url.searchParams.get("ac") === "get_list") {
      return response(
        JSON.stringify(
          Array.from({ length: 6 }, (_, offset) => ({
            index: String(offset + 1),
            title: `slot-${offset + 1}`,
            datetime: "2026-07-14 12:00:00",
            status: 0,
          }))
        )
      );
    }
    if (url.searchParams.get("ac") === "get") {
      const index = params.get("index") ?? "";
      return response(JSON.stringify({ index, title: `slot-${index}`, status: 0, data: `data-${index}` }));
    }
    throw new Error(`Unexpected upstream request: ${url}`);
  };

  const session: OnlineSession = {
    uid: UID,
    username: USERNAME,
    nickname: USERNAME,
    cookie: `Pauth=${encodeURIComponent(`${UID}|session`)}; Puser=${USERNAME}`,
  };
  const slots = await fetchOnlineSaveList(session, GAME_ID, fetchMock);

  assert.deepEqual(slots.map((slot) => slot.index), [1, 2, 3, 4, 5, 6]);
  assert.deepEqual(slots.map((slot) => slot.data), ["data-1", "data-2", "data-3", "data-4", "data-5", "data-6"]);
  assert.ok(requests.every((request) => request.url.protocol === "https:"));
  assert.ok(requests.every((request) => request.init?.method === "POST"));

  const auth = requests.find((request) => request.url.pathname === "/auth/openapi.php");
  assert.equal(auth?.params.get("username"), USERNAME);

  const sessionRequest = requests.find((request) => request.url.searchParams.get("ac") === "get_session");
  assert.equal(sessionRequest?.params.get("gamekey"), gameKey);
  assert.equal(
    sessionRequest?.params.get("verify"),
    tripleMd5(`${VERIFY_PREFIX}${gameKey}${UID}${GAME_ID}${VERIFY_SUFFIX}`)
  );

  const list = requests.find((request) => request.url.searchParams.get("ac") === "get_list");
  assert.equal(
    list?.params.get("verify"),
    tripleMd5(`${VERIFY_PREFIX}${gameKey}${UID}${GAME_ID}token-value${VERIFY_SUFFIX}`)
  );

  const details = requests.filter((request) => request.url.searchParams.get("ac") === "get");
  assert.deepEqual(details.map((request) => request.params.get("index")), ["1", "2", "3", "4", "5", "6"]);
  for (const detail of details) {
    const index = detail.params.get("index") ?? "";
    assert.equal(detail.params.get("session"), "session-id");
    assert.equal(
      detail.params.get("verify"),
      tripleMd5(`${VERIFY_PREFIX}${index}${gameKey}${UID}${GAME_ID}token-value${VERIFY_SUFFIX}`)
    );
  }
}

await testLoginCookieDecoding();
await testInvalidLoginResponse();
await testSaveHandshakeAndSlots();
console.log("online save flow ok");
