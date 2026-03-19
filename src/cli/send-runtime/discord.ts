import { sendMessageDiscord as sendMessageDiscordImpl } from "klawty/plugin-sdk/discord";

type RuntimeSend = {
  sendMessage: typeof import("klawty/plugin-sdk/discord").sendMessageDiscord;
};

export const runtimeSend = {
  sendMessage: sendMessageDiscordImpl,
} satisfies RuntimeSend;
