import { emptyPluginConfigSchema } from "../plugins/config-schema.js";
import type {
  KlawtyPluginApi,
  KlawtyPluginCommandDefinition,
  KlawtyPluginConfigSchema,
  KlawtyPluginDefinition,
  PluginInteractiveTelegramHandlerContext,
} from "../plugins/types.js";

export type {
  AnyAgentTool,
  MediaUnderstandingProviderPlugin,
  KlawtyPluginApi,
  KlawtyPluginConfigSchema,
  ProviderDiscoveryContext,
  ProviderCatalogContext,
  ProviderCatalogResult,
  ProviderAugmentModelCatalogContext,
  ProviderBuiltInModelSuppressionContext,
  ProviderBuiltInModelSuppressionResult,
  ProviderBuildMissingAuthMessageContext,
  ProviderCacheTtlEligibilityContext,
  ProviderDefaultThinkingPolicyContext,
  ProviderFetchUsageSnapshotContext,
  ProviderModernModelPolicyContext,
  ProviderPreparedRuntimeAuth,
  ProviderResolvedUsageAuth,
  ProviderPrepareExtraParamsContext,
  ProviderPrepareDynamicModelContext,
  ProviderPrepareRuntimeAuthContext,
  ProviderResolveUsageAuthContext,
  ProviderResolveDynamicModelContext,
  ProviderNormalizeResolvedModelContext,
  ProviderRuntimeModel,
  SpeechProviderPlugin,
  ProviderThinkingPolicyContext,
  ProviderWrapStreamFnContext,
  KlawtyPluginService,
  KlawtyPluginServiceContext,
  ProviderAuthContext,
  ProviderAuthDoctorHintContext,
  ProviderAuthMethodNonInteractiveContext,
  ProviderAuthMethod,
  ProviderAuthResult,
  KlawtyPluginCommandDefinition,
  KlawtyPluginDefinition,
  PluginLogger,
  PluginInteractiveTelegramHandlerContext,
} from "../plugins/types.js";
export type { KlawtyConfig } from "../config/config.js";

export { emptyPluginConfigSchema } from "../plugins/config-schema.js";

type DefinePluginEntryOptions = {
  id: string;
  name: string;
  description: string;
  kind?: KlawtyPluginDefinition["kind"];
  configSchema?: KlawtyPluginConfigSchema | (() => KlawtyPluginConfigSchema);
  register: (api: KlawtyPluginApi) => void;
};

type DefinedPluginEntry = {
  id: string;
  name: string;
  description: string;
  configSchema: KlawtyPluginConfigSchema;
  register: NonNullable<KlawtyPluginDefinition["register"]>;
} & Pick<KlawtyPluginDefinition, "kind">;

function resolvePluginConfigSchema(
  configSchema: DefinePluginEntryOptions["configSchema"] = emptyPluginConfigSchema,
): KlawtyPluginConfigSchema {
  return typeof configSchema === "function" ? configSchema() : configSchema;
}

// Small entry surface for provider and command plugins that do not need channel helpers.
export function definePluginEntry({
  id,
  name,
  description,
  kind,
  configSchema = emptyPluginConfigSchema,
  register,
}: DefinePluginEntryOptions): DefinedPluginEntry {
  return {
    id,
    name,
    description,
    ...(kind ? { kind } : {}),
    configSchema: resolvePluginConfigSchema(configSchema),
    register,
  };
}
