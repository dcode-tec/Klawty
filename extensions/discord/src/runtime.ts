import type { PluginRuntime } from "klawty/plugin-sdk/core";
import { createPluginRuntimeStore } from "klawty/plugin-sdk/runtime-store";

const { setRuntime: setDiscordRuntime, getRuntime: getDiscordRuntime } =
  createPluginRuntimeStore<PluginRuntime>("Discord runtime not initialized");
export { getDiscordRuntime, setDiscordRuntime };
