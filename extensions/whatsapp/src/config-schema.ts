import { buildChannelConfigSchema, WhatsAppConfigSchema } from "klawty/plugin-sdk/whatsapp-core";

export const WhatsAppChannelConfigSchema = buildChannelConfigSchema(WhatsAppConfigSchema);
