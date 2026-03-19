import {
  buildTogetherModelDefinition,
  TOGETHER_BASE_URL,
  TOGETHER_MODEL_CATALOG,
} from "klawty/plugin-sdk/provider-models";
import {
  applyProviderConfigWithModelCatalogPreset,
  type KlawtyConfig,
} from "klawty/plugin-sdk/provider-onboard";

export const TOGETHER_DEFAULT_MODEL_REF = "together/moonshotai/Kimi-K2.5";

function applyTogetherPreset(cfg: KlawtyConfig, primaryModelRef?: string): KlawtyConfig {
  return applyProviderConfigWithModelCatalogPreset(cfg, {
    providerId: "together",
    api: "openai-completions",
    baseUrl: TOGETHER_BASE_URL,
    catalogModels: TOGETHER_MODEL_CATALOG.map(buildTogetherModelDefinition),
    aliases: [{ modelRef: TOGETHER_DEFAULT_MODEL_REF, alias: "Together AI" }],
    primaryModelRef,
  });
}

export function applyTogetherProviderConfig(cfg: KlawtyConfig): KlawtyConfig {
  return applyTogetherPreset(cfg);
}

export function applyTogetherConfig(cfg: KlawtyConfig): KlawtyConfig {
  return applyTogetherPreset(cfg, TOGETHER_DEFAULT_MODEL_REF);
}
