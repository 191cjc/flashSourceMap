import type {
  Account,
  AccountSeed,
  BuyPropRequest,
  BuyPropResult,
  RechargeWalletRequest,
  RechargeWalletResult,
  SavePayload,
  SaveSlot,
  Wallet,
} from "../types.js";

export type SaveDataStore = {
  close(): void;
  getOrCreateAccount(seed: AccountSeed): Account;
  getAccountByUid(uid: string): Account | null;
  getCurrentAccount(): Account | null;
  ensureAccount(uid: string): Account;
  saveSlot(payload: SavePayload): boolean;
  getSlot(uid: string, gameId: string, slotIndex: number): SaveSlot | null;
  listSlots(uid: string, gameId: string): SaveSlot[];
  listSlotsWithData(uid: string, gameId: string): SaveSlot[];
  getWallet(uid: string): Wallet;
  rechargeWallet(request: RechargeWalletRequest): RechargeWalletResult;
  buyProp(request: BuyPropRequest): BuyPropResult;
};
