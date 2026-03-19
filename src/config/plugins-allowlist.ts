import type { KlawtyConfig } from "./config.js";

export function ensurePluginAllowlisted(cfg: KlawtyConfig, pluginId: string): KlawtyConfig {
  const allow = cfg.plugins?.allow;
  if (!Array.isArray(allow) || allow.includes(pluginId)) {
    return cfg;
  }
  return {
    ...cfg,
    plugins: {
      ...cfg.plugins,
      allow: [...allow, pluginId],
    },
  };
}
