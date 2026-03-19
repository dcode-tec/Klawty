import { resolveChannelGroupRequireMention } from "klawty/plugin-sdk/channel-policy";
import type { KlawtyConfig } from "klawty/plugin-sdk/core";

type GoogleChatGroupContext = {
  cfg: KlawtyConfig;
  accountId?: string | null;
  groupId?: string | null;
};

export function resolveGoogleChatGroupRequireMention(params: GoogleChatGroupContext): boolean {
  return resolveChannelGroupRequireMention({
    cfg: params.cfg,
    channel: "googlechat",
    groupId: params.groupId,
    accountId: params.accountId,
  });
}
