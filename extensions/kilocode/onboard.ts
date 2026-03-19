import { KILOCODE_BASE_URL, KILOCODE_DEFAULT_MODEL_REF } from "klawty/plugin-sdk/provider-models";
import {
  applyProviderConfigWithModelCatalogPreset,
  type KlawtyConfig,
} from "klawty/plugin-sdk/provider-onboard";
import { buildKilocodeProvider } from "./provider-catalog.js";

export { KILOCODE_BASE_URL, KILOCODE_DEFAULT_MODEL_REF };

export function applyKilocodeProviderConfig(cfg: KlawtyConfig): KlawtyConfig {
  return applyProviderConfigWithModelCatalogPreset(cfg, {
    providerId: "kilocode",
    api: "openai-completions",
    baseUrl: KILOCODE_BASE_URL,
    catalogModels: buildKilocodeProvider().models ?? [],
    aliases: [{ modelRef: KILOCODE_DEFAULT_MODEL_REF, alias: "Kilo Gateway" }],
  });
}

export function applyKilocodeConfig(cfg: KlawtyConfig): KlawtyConfig {
  return applyProviderConfigWithModelCatalogPreset(cfg, {
    providerId: "kilocode",
    api: "openai-completions",
    baseUrl: KILOCODE_BASE_URL,
    catalogModels: buildKilocodeProvider().models ?? [],
    aliases: [{ modelRef: KILOCODE_DEFAULT_MODEL_REF, alias: "Kilo Gateway" }],
    primaryModelRef: KILOCODE_DEFAULT_MODEL_REF,
  });
}
