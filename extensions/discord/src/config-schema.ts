import { buildChannelConfigSchema, DiscordConfigSchema } from "klawty/plugin-sdk/discord-core";

export const DiscordChannelConfigSchema = buildChannelConfigSchema(DiscordConfigSchema);
