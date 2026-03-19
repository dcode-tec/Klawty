import { buildChannelConfigSchema, SlackConfigSchema } from "klawty/plugin-sdk/slack-core";

export const SlackChannelConfigSchema = buildChannelConfigSchema(SlackConfigSchema);
