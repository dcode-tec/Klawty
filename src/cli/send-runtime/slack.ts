import { sendMessageSlack as sendMessageSlackImpl } from "klawty/plugin-sdk/slack";

type RuntimeSend = {
  sendMessage: typeof import("klawty/plugin-sdk/slack").sendMessageSlack;
};

export const runtimeSend = {
  sendMessage: sendMessageSlackImpl,
} satisfies RuntimeSend;
