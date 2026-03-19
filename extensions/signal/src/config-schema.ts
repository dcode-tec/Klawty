import { buildChannelConfigSchema, SignalConfigSchema } from "klawty/plugin-sdk/signal-core";

export const SignalChannelConfigSchema = buildChannelConfigSchema(SignalConfigSchema);
