import {
  buildVeniceModelDefinition,
  VENICE_BASE_URL,
  VENICE_DEFAULT_MODEL_REF,
  VENICE_MODEL_CATALOG,
} from "klawty/plugin-sdk/provider-models";
import {
  applyProviderConfigWithModelCatalogPreset,
  type KlawtyConfig,
} from "klawty/plugin-sdk/provider-onboard";

export { VENICE_DEFAULT_MODEL_REF };

function applyVenicePreset(cfg: KlawtyConfig, primaryModelRef?: string): KlawtyConfig {
  return applyProviderConfigWithModelCatalogPreset(cfg, {
    providerId: "venice",
    api: "openai-completions",
    baseUrl: VENICE_BASE_URL,
    catalogModels: VENICE_MODEL_CATALOG.map(buildVeniceModelDefinition),
    aliases: [{ modelRef: VENICE_DEFAULT_MODEL_REF, alias: "Kimi K2.5" }],
    primaryModelRef,
  });
}

export function applyVeniceProviderConfig(cfg: KlawtyConfig): KlawtyConfig {
  return applyVenicePreset(cfg);
}

export function applyVeniceConfig(cfg: KlawtyConfig): KlawtyConfig {
  return applyVenicePreset(cfg, VENICE_DEFAULT_MODEL_REF);
}
