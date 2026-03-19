import { sendMessageTelegram as sendMessageTelegramImpl } from "klawty/plugin-sdk/telegram";

type RuntimeSend = {
  sendMessage: typeof import("klawty/plugin-sdk/telegram").sendMessageTelegram;
};

export const runtimeSend = {
  sendMessage: sendMessageTelegramImpl,
} satisfies RuntimeSend;
