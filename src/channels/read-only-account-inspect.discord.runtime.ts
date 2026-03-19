import { inspectDiscordAccount as inspectDiscordAccountImpl } from "klawty/plugin-sdk/discord";

export type { InspectedDiscordAccount } from "klawty/plugin-sdk/discord";

type InspectDiscordAccount = typeof import("klawty/plugin-sdk/discord").inspectDiscordAccount;

export function inspectDiscordAccount(
  ...args: Parameters<InspectDiscordAccount>
): ReturnType<InspectDiscordAccount> {
  return inspectDiscordAccountImpl(...args);
}
