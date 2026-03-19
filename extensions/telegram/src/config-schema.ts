import { buildChannelConfigSchema, TelegramConfigSchema } from "klawty/plugin-sdk/telegram-core";

export const TelegramChannelConfigSchema = buildChannelConfigSchema(TelegramConfigSchema);
