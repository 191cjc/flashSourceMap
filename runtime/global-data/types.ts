export type GlobalPlayer = {
  uid: number;
  instanceId: string;
  username: string;
  nickname: string;
  createdAt: string;
  updatedAt: string;
  lastSeenAt: string;
};

export type RegisterGlobalPlayerRequest = {
  instanceId: string;
  sourceUid: string | number;
  username: string;
  nickname: string;
};

export type RemoteSaveSlot = {
  uid: number;
  gameId: string;
  slotIndex: number;
  title: string;
  data: string;
  checksum: string;
  revision: number;
  updatedAt: string;
};

export type PutRemoteSaveRequest = {
  gameId: string;
  title: string;
  data: string;
  checksum: string;
  revision: number;
};
