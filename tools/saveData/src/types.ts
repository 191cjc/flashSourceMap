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

export type Wallet = {
  balance: number;
  totalPaid: number;
  totalRecharged: number;
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
