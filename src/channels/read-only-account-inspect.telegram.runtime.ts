import { inspectTelegramAccount as inspectTelegramAccountImpl } from "klawty/plugin-sdk/telegram";

export type { InspectedTelegramAccount } from "klawty/plugin-sdk/telegram";

type InspectTelegramAccount = typeof import("klawty/plugin-sdk/telegram").inspectTelegramAccount;

export function inspectTelegramAccount(
  ...args: Parameters<InspectTelegramAccount>
): ReturnType<InspectTelegramAccount> {
  return inspectTelegramAccountImpl(...args);
}
