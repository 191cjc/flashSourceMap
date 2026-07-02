export type AccountSeed = {
  uid: string;
  username: string;
  nickname: string;
};

export type Account = AccountSeed & {
  id: number;
};

export type SaveSlot = {
  index: number;
  title: string;
  datetime: string;
  data?: unknown;
  status: string;
};

export type SavePayload = {
  uid: string;
  gameid: string;
  index: number;
  title: string;
  data: string;
};

export type SavePrimitive = string | number | boolean | null;

export type SaveValue = SavePrimitive | SaveValue[] | SaveObject;

export type SaveObject = {
  [key: string]: SaveValue | undefined;
};

export type GameSaveRole = {
  job: number;
  lv: number;
  sn: number;
  ec: number;
  g: number;
  d: number;
};

export type GameSaveLevelProgress = {
  id: number;
  ach: number;
  ov: number;
};

export type GameSaveSkillLevels = {
  bs: number[];
  wid: number[];
  wlv: number[];
};

export type GameSaveFlags = {
  guisp: number;
  guist: number;
  guiwq: number;
};

export type GameSaveCardTimer = {
  pd: number;
  pm: number;
  pn: number;
};

export type GameSaveCheckFlags = {
  co: number;
  fa: SaveObject[];
  dm: SaveObject[];
  idai: number;
};

export type GameSavePetManager = {
  onum: number;
  fp: number;
  parr: Record<string, SaveObject>;
  earr: Record<string, SaveObject>;
};

export type GameSaveDailyRefresh = {
  kd: number;
  km: number;
};

export type GameSaveZodiacData = {
  un: number;
  dgn: number;
  sxd: number;
  sxm: number;
  sxv: number;
};

export type GameSaveChallengeTower = {
  en: number;
  enb: number;
  ml: number;
};

export type GameSaveNewLevel = {
  mal: number;
};

export type GameSaveJieshaData = {
  pgd: number;
  pgdb: number;
  pg: number;
  pn: number;
  pgb: number;
  pnb: number;
};

export type GameSaveSurvivalData = {
  bom: number;
  smn: number;
};

export type GameSaveSummerRecord = {
  db: number;
  da: number[];
};

export type GameSavePkEnemyList = SaveObject & {
  fn?: number;
  gup?: number[];
  sxm?: number;
  ea?: SaveObject[];
  wa?: number[];
  gaw?: number;
  un?: number;
  sxd?: number;
  npfbx?: number;
  pkfb?: number;
};

export type GameSavePkData = SaveObject & {
  kd?: number;
  gs?: number;
  awr?: number[];
  km?: number;
  hid?: number;
  sxb?: number;
  sx?: number;
};

export type GameSaveExtendedData = {
  ndf: GameSaveDailyRefresh;
  sxd: GameSaveZodiacData;
  sxlv: SaveObject;
  pm: GameSavePetManager;
  gv: number;
  pkl: GameSavePkEnemyList;
  pks: GameSavePkData;
  tr: GameSaveChallengeTower;
  cm: GameSaveCheckFlags;
  nlel: GameSaveNewLevel;
  jsha?: GameSaveJieshaData;
  sum?: GameSaveSurvivalData;
  summr?: GameSaveSummerRecord;
};

export type GameSaveDataList = {
  un: SaveObject;
  uvp: SaveObject;
  hd: SaveObject;
  us: SaveObject;
  ol: SaveObject;
  pb: SaveObject;
  cb: SaveObject;
  th: SaveObject;
  ev: SaveObject;
  sg: SaveObject;
  dl?: SaveObject;
};

export type GameSaveFlowData = {
  addEq: SaveObject;
  jxbag: SaveObject;
  jxtask: SaveObject;
  jxshop: SaveObject;
  jxfengj: SaveObject;
  jxware: SaveObject;
  gene: SaveObject;
  gift: SaveObject;
  vp: SaveObject;
  fb: SaveObject;
  fmv: SaveObject;
  zp: SaveObject;
  tim: number;
  ship: SaveObject;
  pgj: SaveObject;
  dl: GameSaveDataList;
};

export type LegacyActivityData = {
  pn: number;
  pgb: number;
  pm: number;
  pnb: number;
  pd: number;
  pg: number;
};

export type GameSaveData = {
  jxv: number;
  jxid: number;
  sidx: number;
  newnn: string;
  idn: string;
  jxsflag: GameSaveFlags;
  jxrole: GameSaveRole;
  jxguanka: Record<string, GameSaveLevelProgress>;
  jxjinenglv: GameSaveSkillLevels;
  jxkaizhong: GameSaveFlowData;
  kpji: GameSaveCardTimer;
  asaved: GameSaveExtendedData;
  lactd?: LegacyActivityData;
};

export type OnlineSaveSlot = {
  index: number;
  title: string;
  datetime: string;
  status?: number | string;
  data: string;
};

export type DecodedSaveSlot = Omit<OnlineSaveSlot, "data"> & {
  data: GameSaveData;
};

export type Wallet = {
  balance: number;
  totalPaid: number;
  totalRecharged: number;
};

export type RechargeWalletRequest = {
  uid: string;
  amount: number;
};

export type RechargeWalletResult = Wallet & {
  amount: number;
};

export type BuyPropRequest = {
  uid: string;
  propId: number;
  count: number;
  price: number;
  tag: number;
};

export type BuyPropResult = {
  propId: number;
  count: number;
  tag: number;
  balance: number;
};

export type SaveDataLogEvent = {
  ts: string;
  event: string;
  method?: string;
  pathname?: string;
  ac?: string;
  uid?: string;
  gameid?: string;
  slotIndex?: number;
  title?: string;
  status?: number;
  result?: string;
  dataLength?: number;
  dataSha256?: string;
  dataPreview?: string;
  details?: Record<string, unknown>;
};
