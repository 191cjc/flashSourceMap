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

export type StaffPlayerOverview = GlobalPlayer & {
  saveCount: number;
  latestSaveAt: string | null;
  unionMembershipCount: number;
  rankEntryCount: number;
};

export type StaffUnionMember = {
  uid: string;
  username: string;
  nickname: string;
  slotIndex: number;
  contribution: number;
  roleId: string;
  roleName: string;
  activeTime: string;
  createdAt: string;
  updatedAt: string;
};

export type StaffUnionApplication = {
  uid: string;
  username: string;
  nickname: string;
  slotIndex: number;
  createdAt: string;
  updatedAt: string;
};

export type StaffUnionOverview = {
  id: number;
  gameId: string;
  title: string;
  ownerUid: string;
  ownerUsername: string;
  ownerNickname: string;
  level: number;
  experience: number;
  contribution: number;
  createdAt: string;
  updatedAt: string;
  members: StaffUnionMember[];
  applications: StaffUnionApplication[];
};

export type StaffRankOverview = {
  rankListId: number;
  entryCount: number;
  topScore: number;
  updatedAt: string;
};

export type StaffOverview = {
  generatedAt: string;
  summary: {
    playerCount: number;
    saveSlotCount: number;
    unionCount: number;
    unionMemberCount: number;
    unionApplicationCount: number;
    rankEntryCount: number;
  };
  players: StaffPlayerOverview[];
  unions: StaffUnionOverview[];
  ranks: StaffRankOverview[];
};
