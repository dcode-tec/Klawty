// Narrow plugin-sdk surface for the bundled diffs plugin.
// Keep this list additive and scoped to symbols used under extensions/diffs.

export { definePluginEntry } from "./core.js";
export type { KlawtyConfig } from "../config/config.js";
export { resolvePreferredKlawtyTmpDir } from "../infra/tmp-klawty-dir.js";
export type {
  AnyAgentTool,
  KlawtyPluginApi,
  KlawtyPluginConfigSchema,
  KlawtyPluginToolContext,
  PluginLogger,
} from "../plugins/types.js";
