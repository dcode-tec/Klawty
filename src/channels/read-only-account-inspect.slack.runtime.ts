import { inspectSlackAccount as inspectSlackAccountImpl } from "klawty/plugin-sdk/slack";

export type { InspectedSlackAccount } from "klawty/plugin-sdk/slack";

type InspectSlackAccount = typeof import("klawty/plugin-sdk/slack").inspectSlackAccount;

export function inspectSlackAccount(
  ...args: Parameters<InspectSlackAccount>
): ReturnType<InspectSlackAccount> {
  return inspectSlackAccountImpl(...args);
}
