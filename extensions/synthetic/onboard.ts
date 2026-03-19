import {
  buildSyntheticModelDefinition,
  SYNTHETIC_BASE_URL,
  SYNTHETIC_DEFAULT_MODEL_REF,
  SYNTHETIC_MODEL_CATALOG,
} from "klawty/plugin-sdk/provider-models";
import {
  applyProviderConfigWithModelCatalogPreset,
  type KlawtyConfig,
} from "klawty/plugin-sdk/provider-onboard";

export { SYNTHETIC_DEFAULT_MODEL_REF };

function applySyntheticPreset(cfg: KlawtyConfig, primaryModelRef?: string): KlawtyConfig {
  return applyProviderConfigWithModelCatalogPreset(cfg, {
    providerId: "synthetic",
    api: "anthropic-messages",
    baseUrl: SYNTHETIC_BASE_URL,
    catalogModels: SYNTHETIC_MODEL_CATALOG.map(buildSyntheticModelDefinition),
    aliases: [{ modelRef: SYNTHETIC_DEFAULT_MODEL_REF, alias: "MiniMax M2.5" }],
    primaryModelRef,
  });
}

export function applySyntheticProviderConfig(cfg: KlawtyConfig): KlawtyConfig {
  return applySyntheticPreset(cfg);
}

export function applySyntheticConfig(cfg: KlawtyConfig): KlawtyConfig {
  return applySyntheticPreset(cfg, SYNTHETIC_DEFAULT_MODEL_REF);
}
